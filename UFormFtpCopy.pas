unit UFormFtpCopy;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, zip, types, IdComponent,
  Vcl.ExtCtrls, UFtpUtils, Vcl.ComCtrls, RzPrgres, UFileSearch;

type
  TfrmFtpCopy = class(TForm)
    lbZiping: TLabel;
    btnCancel: TButton;
    tmrZipFile: TTimer;
    liFileName: TLabel;
    lbSpeed: TLabel;
    pbMain: TProgressBar;
    tmrSpeed: TTimer;
    lbRemainTime: TLabel;
    Panel1: TPanel;
    lbSize: TLabel;
    Panel2: TPanel;
    lbPrecentage: TLabel;
    procedure tmrZipFileTimer(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure tmrSpeedTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FtpHost, RemotePath, LocalPath : string;
    LastSize, NowSize, TotalSize : Int64;
  private
    ShowCopy : string;
    IsStop : Boolean;
    procedure BeforeCopy;
    procedure AfterCopy;
  public
    function ReadIsStop : Boolean;
  public
    procedure SetCopyInfo( _FtpHost, _RemotePath, _LocalPath : string );
    procedure SetDownloadSize( DownloadSize : Int64 );
    function DownloadFile: Boolean;
    function UploadFile: Boolean;
    function DownloadFolder : Boolean;
    function UploadFolder : Boolean;
  private
    procedure FtpWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure FtpWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
  end;

    // 下载目录处理
  TFtpDownloadFolderHandle = class
  public
    FtpHost, RemotePath, LocalPath : string;
    FtpFileList : TFtpFileList;
  public
    constructor Create( _FtpHost, _RemotePath, _LocalPath : string );
    function Update: Boolean;
    destructor Destroy; override;
  private
    function ReadIsNext : Boolean;
    procedure DownloadFile( FilePath : string; FileSize : Int64 );
    procedure DownloadFolder( ChildPath : string );
  end;

    // 上传目录处理
  TFtpUploadFolderHandle = class
  public
    FtpHost, LocalPath, RemotePath : string;
    FileList : TFileList;
  public
    constructor Create( _FtpHost, _LocalPath, _RemotePath : string );
    function Update: Boolean;
    destructor Destroy; override;
  private
    function ReadIsNext : Boolean;
    procedure UploadFile( FilePath : string );
    procedure UploadFolder( ChildPath : string );
  end;

var
  frmFtpCopy: TfrmFtpCopy;

implementation

uses IOUtils, UMyUtils;

{$R *.dfm}

procedure TfrmFtpCopy.AfterCopy;
begin
  tmrZipFile.Enabled := False;
  tmrSpeed.Enabled := False;
end;

procedure TfrmFtpCopy.BeforeCopy;
begin
  IsStop := False;
  tmrZipFile.Enabled := True;
  tmrSpeed.Enabled := True;
  NowSize := 0;
  LastSize := 0;
  if TotalSize <= 0 then
    TotalSize := 1;
end;

procedure TfrmFtpCopy.btnCancelClick(Sender: TObject);
begin
  IsStop := True;
  Close;
  MyFtpFileHandler.StopTransfer( FtpHost );
end;

function TfrmFtpCopy.DownloadFile: Boolean;
begin
  BeforeCopy;

  frmFtpCopy.ShowCopy := RemotePath;
  MyFtpFileHandler.BingWordBegin( FtpHost, FtpWorkBegin );
  MyFtpFileHandler.BingWord( FtpHost, FtpWork );
  Result := MyFtpFileHandler.Download( FtpHost, RemotePath, LocalPath );

    // 手动停止下载，删除中断的文件
  if IsStop then
  begin
    MyShellFile.DeleteFile( LocalPath );
    Result := False;
  end;

  AfterCopy;
end;

function TfrmFtpCopy.DownloadFolder: Boolean;
var
  FtpDownloadFolderHandle : TFtpDownloadFolderHandle;
begin
  BeforeCopy;

  frmFtpCopy.ShowCopy := RemotePath;
  MyFtpFileHandler.BingWordBegin( FtpHost, FtpWorkBegin );
  MyFtpFileHandler.BingWord( FtpHost, FtpWork );

  FtpDownloadFolderHandle := TFtpDownloadFolderHandle.Create( FtpHost, RemotePath, LocalPath );
  Result := FtpDownloadFolderHandle.Update;
  FtpDownloadFolderHandle.Free;

  AfterCopy;
end;

procedure TfrmFtpCopy.FormShow(Sender: TObject);
begin
  liFileName.Caption := MyFilePath.getFtpName( RemotePath );
  pbMain.Position := 0;
end;

procedure TfrmFtpCopy.FtpWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  NowSize := AWorkCount;
end;

procedure TfrmFtpCopy.FtpWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  pbMain.Position := 0;
  if AWorkMode = wmWrite then
    TotalSize := AWorkCountMax;
  LastSize := 0;
end;

function TfrmFtpCopy.ReadIsStop: Boolean;
begin
  Result := IsStop;
end;

procedure TfrmFtpCopy.SetCopyInfo(_FtpHost, _RemotePath, _LocalPath : string);
begin
  FtpHost := _FtpHost;
  RemotePath := _RemotePath;
  LocalPath := _LocalPath;
end;

procedure TfrmFtpCopy.SetDownloadSize(DownloadSize: Int64);
begin
  TotalSize := DownloadSize;
end;

procedure TfrmFtpCopy.tmrSpeedTimer(Sender: TObject);
var
  Speed : Integer;
  RemainSize, RemainSecond : Int64;
begin
  Speed := NowSize - LastSize;
  lbSpeed.Caption := MySpeed.getSpeedStr( Speed );
  LastSize := NowSize;
  lbPrecentage.Caption := MyPercentage.getStr( NowSize, TotalSize );
  lbSize.Caption := MySizeUtil.getStr( NowSize ) + '/' + MySizeUtil.getStr( TotalSize );
  if Speed <= 0 then
    lbRemainTime.Caption := ''
  else
  begin
    RemainSize := TotalSize - NowSize;
    RemainSecond := RemainSize div Speed;
    lbRemainTime.Caption := '剩余' + MyRemainTime.getStr( RemainSecond );
  end;
end;

procedure TfrmFtpCopy.tmrZipFileTimer(Sender: TObject);
begin
  liFileName.Caption := MyFilePath.getFtpName( ShowCopy );
  pbMain.Position := MyPercentage.getInt( NowSize, TotalSize );
end;

function TfrmFtpCopy.UploadFile: Boolean;
begin
  BeforeCopy;

  frmFtpCopy.ShowCopy := LocalPath;
  MyFtpFileHandler.BingWordBegin( FtpHost, FtpWorkBegin );
  MyFtpFileHandler.BingWord( FtpHost, FtpWork );
  Result := MyFtpFileHandler.Upload( FtpHost, LocalPath, RemotePath );

    // 手动停止下载，删除中断的文件
  if IsStop then
  begin
    MyFtpFileHandler.DeleteFile( FtpHost, RemotePath );
    Result := False;
  end;

  AfterCopy;
end;

function TfrmFtpCopy.UploadFolder: Boolean;
var
  FtpUploadFolderHandle : TFtpUploadFolderHandle;
begin
  BeforeCopy;

  frmFtpCopy.ShowCopy := LocalPath;
  MyFtpFileHandler.BingWordBegin( FtpHost, FtpWorkBegin );
  MyFtpFileHandler.BingWord( FtpHost, FtpWork );

  FtpUploadFolderHandle := TFtpUploadFolderHandle.Create( FtpHost, LocalPath, RemotePath );
  Result := FtpUploadFolderHandle.Update;
  FtpUploadFolderHandle.Free;

  AfterCopy;
end;

{ TFtpDownloadFolderHandle }

constructor TFtpDownloadFolderHandle.Create(_FtpHost, _RemotePath,
  _LocalPath: string);
begin
  FtpHost := _FtpHost;
  RemotePath := _RemotePath;
  LocalPath := _LocalPath;
end;

procedure TFtpDownloadFolderHandle.DownloadFile(FilePath: string; FileSize : Int64);
var
  LocalFilePath : string;
begin
  frmFtpCopy.ShowCopy := FilePath;
  frmFtpCopy.SetDownloadSize( FileSize );

  LocalFilePath := MyFilePath.getPath( LocalPath ) + MyFilePath.getFtpName( FilePath );
  MyFtpFileHandler.Download( FtpHost, FilePath, LocalFilePath );

    // 已取消下载
  if not ReadIsNext then
    MyShellFile.DeleteFile( LocalFilePath );
end;

procedure TFtpDownloadFolderHandle.DownloadFolder(ChildPath: string);
var
  LocalChildPath : string;
  FtpDownloadFolderHandle : TFtpDownloadFolderHandle;
begin
  frmFtpCopy.ShowCopy := ChildPath;
  LocalChildPath := MyFilePath.getPath( LocalPath ) + MyFilePath.getFtpName( ChildPath );

  FtpDownloadFolderHandle := TFtpDownloadFolderHandle.Create( FtpHost, ChildPath, LocalChildPath );
  FtpDownloadFolderHandle.Update;
  FtpDownloadFolderHandle.Free;
end;

destructor TFtpDownloadFolderHandle.Destroy;
begin
  FtpFileList.Free;
  inherited;
end;

function TFtpDownloadFolderHandle.ReadIsNext: Boolean;
begin
  Result := not frmFtpCopy.IsStop;
end;

function TFtpDownloadFolderHandle.Update: Boolean;
var
  i: Integer;
  ParentPath, ChildPath : string;
begin
  Result := False;

  FtpFileList := MyFtpFileHandler.ReadFileList( FtpHost, RemotePath );
  ParentPath := MyFilePath.getFtpPath( RemotePath );
  for i := 0 to FtpFileList.Count - 1 do
  begin
    if not ReadIsNext then  // 已停止
      Break;
    ChildPath := ParentPath + FtpFileList[i].FileName;
    if FtpFileList[i].IsFile then
      DownloadFile( ChildPath, FtpFileList[i].FileSize )
    else
      DownloadFolder( ChildPath );
  end;

  Result := ReadIsNext;
end;

{ TFtpUploadFolderHandle }

constructor TFtpUploadFolderHandle.Create(_FtpHost, _LocalPath,
  _RemotePath: string);
begin
  FtpHost := _FtpHost;
  LocalPath := _LocalPath;
  RemotePath := _RemotePath;
end;

destructor TFtpUploadFolderHandle.Destroy;
begin
  FileList.Free;
  inherited;
end;

function TFtpUploadFolderHandle.ReadIsNext: Boolean;
begin
  Result := not frmFtpCopy.IsStop;
end;

function TFtpUploadFolderHandle.Update: Boolean;
var
  ParentPath, ChildPath : string;
  i: Integer;
begin
    // 先创建目录
  MyFtpFileHandler.NewFolder( FtpHost, RemotePath );

  ParentPath := MyFilePath.getPath( LocalPath );

  FileList := FolderSearchUtil.ReadList( LocalPath );
  for i := 0 to FileList.Count - 1 do
  begin
    if not ReadIsNext then
      Break;
    ChildPath := ParentPath + FileList[i].FileName;
    if FileList[i].IsFile then
      UploadFile( ChildPath )
    else
      UploadFolder( ChildPath );
  end;

  Result := ReadIsNext;
end;

procedure TFtpUploadFolderHandle.UploadFile(FilePath: string);
var
  RemoteFilePath : string;
begin
  frmFtpCopy.ShowCopy := FilePath;

  RemoteFilePath := MyFilePath.getFtpPath( RemotePath ) + MyFilePath.getName( FilePath );
  MyFtpFileHandler.Upload( FtpHost, FilePath, RemoteFilePath );

    // 已取消下载
  if not ReadIsNext then
    MyFtpFileHandler.DeleteFile( FtpHost, RemoteFilePath );
end;

procedure TFtpUploadFolderHandle.UploadFolder(ChildPath: string);
var
  RemoteChildPath : string;
  FtpUploadFolderHandle : TFtpUploadFolderHandle;
begin
  frmFtpCopy.ShowCopy := ChildPath;
  RemoteChildPath := MyFilePath.getFtpPath( RemotePath ) + MyFilePath.getName( ChildPath );

  FtpUploadFolderHandle := TFtpUploadFolderHandle.Create( FtpHost, ChildPath, RemoteChildPath );
  FtpUploadFolderHandle.Update;
  FtpUploadFolderHandle.Free;
end;


end.
