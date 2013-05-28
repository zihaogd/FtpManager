unit UFormFtpDelete;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, zip, types,
  Vcl.ExtCtrls, UFtpUtils;

type
  TfrmFtpDelete = class(TForm)
    lbZiping: TLabel;
    btnCancel: TButton;
    tmrZipFile: TTimer;
    liFileName: TLabel;
    procedure tmrZipFileTimer(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FtpHost, FolderPath : string;
  private
    ShowDelete : string;
    IsStop : Boolean;
    procedure BeforeDelete;
    procedure AfterDelete;
  public
    function ReadIsStop : Boolean;
  public
    procedure SetDeleteInfo( _FtpHost, _FolderPath : string );
    function FolderDelete : Boolean;
  end;

    // É¾³ý Ftp Ä¿Â¼
  TFtpFolderDeleteHandle = class
  public
    FtpHost, FolderPath : string;
    FtpFileList : TFtpFileList;
  public
    constructor Create( _FtpHost, _FolderPath : string );
    function Update: Boolean;
    destructor Destroy; override;
  private
    function ReadIsNext : Boolean;
    procedure DeleteFile( FilePath : string );
    procedure DeleteFolder( ChildPath : string );
  end;

var
  frmFtpDelete: TfrmFtpDelete;

implementation

uses IOUtils, UMyUtils;

{$R *.dfm}

procedure TfrmFtpDelete.AfterDelete;
begin
  tmrZipFile.Enabled := False;
end;

procedure TfrmFtpDelete.BeforeDelete;
begin
  IsStop := False;
  liFileName.Caption := MyFilePath.getFtpName( FolderPath );
  tmrZipFile.Enabled := True;
end;

procedure TfrmFtpDelete.btnCancelClick(Sender: TObject);
begin
  IsStop := True;
  Close;
end;

function TfrmFtpDelete.FolderDelete: Boolean;
var
  FtpFolderDeleteHandle : TFtpFolderDeleteHandle;
begin
  BeforeDelete;

  FtpFolderDeleteHandle := TFtpFolderDeleteHandle.Create( FtpHost, FolderPath );
  Result := FtpFolderDeleteHandle.Update;
  FtpFolderDeleteHandle.Free;

  AfterDelete;
end;

function TfrmFtpDelete.ReadIsStop: Boolean;
begin
  Result := IsStop;
end;

procedure TfrmFtpDelete.SetDeleteInfo(_FtpHost, _FolderPath: string);
begin
  FtpHost := _FtpHost;
  FolderPath := _FolderPath;
end;

procedure TfrmFtpDelete.tmrZipFileTimer(Sender: TObject);
begin
  liFileName.Caption := MyFilePath.getFtpName( ShowDelete );
end;

{ TFtpFolderDeleteHandle }

constructor TFtpFolderDeleteHandle.Create(_FtpHost, _FolderPath: string);
begin
  FtpHost := _FtpHost;
  FolderPath := _FolderPath;
end;

procedure TFtpFolderDeleteHandle.DeleteFile(FilePath: string);
begin
  frmFtpDelete.ShowDelete := FilePath;
  MyFtpFileHandler.DeleteFile( FtpHost, FilePath );
end;

procedure TFtpFolderDeleteHandle.DeleteFolder(ChildPath: string);
var
  FtpFolderDeleteHandle : TFtpFolderDeleteHandle;
begin
  frmFtpDelete.ShowDelete := ChildPath;
  FtpFolderDeleteHandle := TFtpFolderDeleteHandle.Create( FtpHost, ChildPath );
  FtpFolderDeleteHandle.Update;
  FtpFolderDeleteHandle.Free;
end;

destructor TFtpFolderDeleteHandle.Destroy;
begin
  FtpFileList.Free;
  inherited;
end;

function TFtpFolderDeleteHandle.ReadIsNext: Boolean;
begin
  Result := not frmFtpDelete.IsStop;
end;

function TFtpFolderDeleteHandle.Update: Boolean;
var
  i: Integer;
  ParentPath, ChildPath : string;
begin
  Result := False;

  FtpFileList := MyFtpFileHandler.ReadFileList( FtpHost, FolderPath );
  ParentPath := MyFilePath.getFtpPath( FolderPath );
  for i := 0 to FtpFileList.Count - 1 do
  begin
    if not ReadIsNext then  // ÒÑÍ£Ö¹
      Break;
    ChildPath := ParentPath + FtpFileList[i].FileName;
    if FtpFileList[i].IsFile then
      DeleteFile( ChildPath )
    else
      DeleteFolder( ChildPath );
  end;

    // É¾³ý¿ÕÄ¿Â¼
  if ReadIsNext then
    Result := MyFtpFileHandler.RemoveFolder( FtpHost, FolderPath );
end;

end.
