unit UFileSearch;

interface

uses classes, Generics.Collections, SysUtils, Winapi.Windows, IOUtils, Types, DateUtils;

type

    // �ļ���Ϣ
  TFileInfo = class
  public
    FileName : string;
    IsFile : Boolean;
  public
    FileSize : Int64;
    FileTime : TDateTime;
  public
    constructor Create( _FileName : string; _IsFile : Boolean );
    procedure SetFileInfo( _FileSize : Int64; _FileTime : TDateTime );
  end;
  TFileList = class( TObjectList<TFileInfo> )end;

    // ������
  TFolderExplorer = class
  public
    FolderPath : string;
    FileList : TFileList;
  public
    constructor Create( _FolderPath : string );
    procedure SetFileList( _FileList : TFileList );
    procedure Update;
  private
    function getFileTime( sch : TSearchRec ): TDateTime;
    procedure AddFolder( sch : TSearchRec );
    procedure AddFile( sch : TSearchRec );
  end;

    // ������
  FolderSearchUtil = class
  public
    class function ReadList( FolderPath : string ): TFileList;
  end;

implementation

uses UMyUtils;

{ TFileInfo }

constructor TFileInfo.Create(_FileName: string; _IsFile: Boolean);
begin
  FileName := _FileName;
  IsFile := _IsFile;
end;

procedure TFileInfo.SetFileInfo(_FileSize: Int64; _FileTime: TDateTime);
begin
  FileSize := _FileSize;
  FileTime := _FileTime;
end;

{ TFileSearch }

procedure TFolderExplorer.AddFile(sch : TSearchRec);
var
  FileName : string;
  FileTime : TDateTime;
  InsertPos : Integer;
  i: Integer;
  FileInfo : TFileInfo;
begin
    // ��ȡ��Ϣ
  FileName := sch.Name;
  FileTime := getFileTime( sch );

    // Ѱ�����λ��
  InsertPos := FileList.Count;
  for i := FileList.Count - 1 downto 0 do
    if not FileList[i].IsFile or ( CompareText( FileName, FileList[i].FileName ) > 0 ) then
    begin
      InsertPos := i + 1;
      Break;
    end;

    // ���
  FileInfo := TFileInfo.Create( FileName, True );
  FileInfo.SetFileInfo( sch.Size, FileTime );
  FileList.Insert( InsertPos, FileInfo );
end;

procedure TFolderExplorer.AddFolder(sch : TSearchRec);
var
  FolderName : string;
  FolderTime : TDateTime;
  InsertPos : Integer;
  i: Integer;
  FileInfo : TFileInfo;
begin
    // ��ȡ��Ϣ
  FolderName := sch.Name;
  FolderTime := getFileTime( sch );

    // Ѱ�����λ��
  InsertPos := FileList.Count;
  for i := 0 to FileList.Count - 1 do
    if FileList[i].IsFile or ( CompareText( FileList[i].FileName, FolderName ) > 0 ) then
    begin
      InsertPos := i;
      Break;
    end;

    // ���
  FileInfo := TFileInfo.Create( FolderName, False );
  FileInfo.SetFileInfo( sch.Size, FolderTime );
  FileList.Insert( InsertPos, FileInfo );
end;

constructor TFolderExplorer.Create(_FolderPath: string);
begin
  FolderPath := _FolderPath;
end;

function TFolderExplorer.getFileTime(sch: TSearchRec): TDateTime;
var
  LastWriteTimeSystem: TSystemTime;
begin
  FileTimeToSystemTime( sch.FindData.ftLastWriteTime, LastWriteTimeSystem );
  Result := SystemTimeToDateTime( LastWriteTimeSystem );
  Result := TTimeZone.Local.ToLocalTime( Result );
end;

procedure TFolderExplorer.SetFileList(_FileList: TFileList);
begin
  FileList := _FileList;
end;

procedure TFolderExplorer.Update;
begin
  if not DirectoryExists( FolderPath ) then
    Exit;

  try
    TDirectory.GetFileSystemEntries( FolderPath,
      function(const Path: string; const SearchRec: TSearchRec): Boolean
      begin
        if ( SearchRec.Attr and SysUtils.faDirectory ) = 0 then
          AddFile( SearchRec )
        else
          AddFolder( SearchRec );
        Result := False;
      end);
  except
  end;
end;

{ FolderSearchUtil }

class function FolderSearchUtil.ReadList(FolderPath: string): TFileList;
var
  FolderExplorer : TFolderExplorer;
begin
  Result := TFileList.Create;
  FolderExplorer := TFolderExplorer.Create( FolderPath );
  FolderExplorer.SetFileList( Result );
  FolderExplorer.Update;
  FolderExplorer.Free;
end;

end.
