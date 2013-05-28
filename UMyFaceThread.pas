unit UMyFaceThread;

interface

uses UThreadUtil, classes, StrUtils, UFileSearch, IOUtils, Types, SysUtils, IniFiles;

type

{$Region ' ������ ' }

    // ˢ����������
  TNetworkComputerRefresh = class( TThreadJob )
  private
    NetworkPcList : TStringList;
  public
    constructor Create;
    procedure Update;override;
    destructor Destroy; override;
  private
    procedure FindNetworkPcList;
    procedure ShowNetworkPcList;
  end;

    // ˢ�¼��������Ŀ¼
  TNetowrkFolderRefresh = class( TThreadJob )
  private
    ComputerName : string;
    NetworkFolderList : TStringList;
  public
    constructor Create( _ComputerName : string );
    procedure Update;override;
    destructor Destroy; override;
  private
    procedure ClearOldFolderList;
    procedure FindNetworkFolderList;
    procedure ShowNetworkFolderList;
  end;

{$EndRegion}

{$Region ' �ļ����� ' }

    // �����ļ�ϵͳ
  TLocalDriverRefresh = class( TThreadJob )
  private
    ControlPath : string;
  private
    FolderPath : string;
    FileList : TFileList;
  public
    constructor Create( _FolderPath : string );
    procedure SetControlPath( _ControlPath : string );
    procedure Update;override;
    destructor Destroy; override;
  private
    procedure FindDriverList;
    procedure FindFileList;
    procedure ReadHistoryList;
    procedure ShowFileList;
  private
    function ReadIsMyComputer : Boolean;
    procedure MoveFile( FileName : string );
  end;

    // �����ļ�ϵͳ
  TNetworkDriverRefresh = class( TThreadJob )
  private
    ControlPath : string;
  private
    FolderPath : string;
    FileList : TFileList;
  public
    constructor Create( _FolderPath : string );
    procedure SetControlPath( _ControlPath : string );
    procedure Update;override;
    destructor Destroy; override;
  private
    procedure FindFileList;
    procedure ReadHistoryList;
    procedure ShowFileList;
  private
    procedure MoveFile( FileName : string );
  end;

    // ��¼ �ļ��б��ѡ��
  TFileListMarkSelectJob = class( TThreadJob )
  private
    FolderPath, SelectName : string;
  public
    constructor Create( _FolderPath, _SelectName : string );
    procedure Update;override;
  end;

    // ѡ���ļ�
  TFileListSelectJob = class( TThreadJob )
  private
    ControlPath, FilePath : string;
    IsLocal : Boolean;
  public
    constructor Create( _ControlPath, _FilePath : string );
    procedure SetIsLocal( _IsLocal : Boolean );
    procedure Update;override;
  private
    procedure SelectPath;
  end;

    // Ŀ¼�仯 Job
  TFolderChangeNofityJob = class( TThreadJob )
  private
    FolderPath : string;
    OldFileList, NewFileList : TStringList;
    FileName : string;
  private
    ControlPath : string;
  public
    constructor Create( _FolderPath : string );
    procedure SetControlPath( _ControlPath : string );
    procedure Update;override;
    destructor Destroy; override;
  private
    procedure ReadOldFileList;
    procedure ReadNewFileList;
  private
    procedure AddFile;
    procedure RemoveFile;
  end;

{$EndRegion}

    // ������� Job
  TMyFaceJobHandler = class( TMyJobHandler )
  public
    procedure RefreshNetworkPc; // ˢ�������ھ�
    procedure RefreshNetworkFolder( PcName : string ); // ˢ�¹���Ŀ¼
  public
    procedure RefreshLocalDriver( FolderPath, ControlPath : string );  // ����Ŀ¼
    procedure RefreshNetworkDriver( FolderPath, ControlPath : string );  // ����Ŀ¼
    procedure FileListMarkSelect( FolderPath, SelectName : string );  // ��¼ѡ��λ��
    procedure FileListSelect( ControlPath, FilePath : string; IsLocal : Boolean );  // ѡ��λ��
    procedure FileChange( ControlPath, FolderPath : string; IsLocal : Boolean ); // �ļ��仯���
  end;

var
  MyFaceJobHandler : TMyFaceJobHandler;

implementation

uses UFormSelectShare, UMainForm, UFrameDriver, UMyUtils, UFtpUtils;

{ TNetworkComputerRefresh }

constructor TNetworkComputerRefresh.Create;
begin
  NetworkPcList := TStringList.Create;
end;

destructor TNetworkComputerRefresh.Destroy;
begin
  NetworkPcList.Free;
  inherited;
end;

procedure TNetworkComputerRefresh.FindNetworkPcList;
var
  GroupList, ComputerList, InputList : TStringList;
  i, j: Integer;
begin
    // �������ھ�
  GroupList := NetworkDriverUtil.ReadGroupList;
  for i := 0 to GroupList.Count - 1 do
  begin
    ComputerList := NetworkDriverUtil.ReadGroupPcList( GroupList[i] );
    for j := 0 to ComputerList.Count - 1 do
      NetworkPcList.Add( ComputerList[j] );
    ComputerList.Free;
  end;
  GroupList.Free;

    // �ֹ������ Pc
  InputList := frmSelectShare.ReadInputList;
  for i := 0 to InputList.Count - 1 do
    NetworkPcList.Add( InputList[i] );
end;

procedure TNetworkComputerRefresh.ShowNetworkPcList;
var
  i: Integer;
begin
    // ��� ��Pc
  FaceNetworkPcApi.ClearComputer;

    // ��� �¼����
  FaceNetworkPcApi.AddNewComputer;

    // ��������ļ����
  for i := 0 to NetworkPcList.Count - 1 do
    FaceNetworkPcApi.AddComputer( NetworkPcList[i] );
end;

procedure TNetworkComputerRefresh.Update;
begin
    // Ѱ�� Pc
  FindNetworkPcList;

    // ��ʾ Pc
  FaceUpdate( ShowNetworkPcList );
end;

{ TMyFaceJobHandler }

procedure TMyFaceJobHandler.FileChange(ControlPath, FolderPath: string;
  IsLocal: Boolean);
var
  FolderChangeNofityJob : TFolderChangeNofityJob;
begin
  FolderChangeNofityJob := TFolderChangeNofityJob.Create( FolderPath );
  FolderChangeNofityJob.SetControlPath( ControlPath );
  AddJob( FolderChangeNofityJob );
end;


procedure TMyFaceJobHandler.FileListMarkSelect(FolderPath, SelectName: string);
var
  FileListMarkSelectJob : TFileListMarkSelectJob;
begin
  FileListMarkSelectJob := TFileListMarkSelectJob.Create( FolderPath, SelectName );
  AddJob( FileListMarkSelectJob );
end;

procedure TMyFaceJobHandler.FileListSelect(ControlPath, FilePath: string;
  IsLocal : Boolean);
var
  FileListSelectJob : TFileListSelectJob;
begin
  FileListSelectJob := TFileListSelectJob.Create( ControlPath, FilePath );
  FileListSelectJob.SetIsLocal( IsLocal );
  AddJob( FileListSelectJob );
end;

procedure TMyFaceJobHandler.RefreshLocalDriver(FolderPath, ControlPath: string);
var
  LocalDriverRefresh : TLocalDriverRefresh;
begin
  LocalDriverRefresh := TLocalDriverRefresh.Create( FolderPath );
  LocalDriverRefresh.SetControlPath( ControlPath );
  AddJob( LocalDriverRefresh );
end;

procedure TMyFaceJobHandler.RefreshNetworkDriver(FolderPath,
  ControlPath: string);
var
  NetworkDriverRefresh : TNetworkDriverRefresh;
begin
  NetworkDriverRefresh := TNetworkDriverRefresh.Create( FolderPath );
  NetworkDriverRefresh.SetControlPath( ControlPath );
  AddJob( NetworkDriverRefresh );
end;

procedure TMyFaceJobHandler.RefreshNetworkFolder(PcName: string);
var
  NetowrkFolderRefresh : TNetowrkFolderRefresh;
begin
  NetowrkFolderRefresh := TNetowrkFolderRefresh.Create( PcName );
  AddJob( NetowrkFolderRefresh );
end;

procedure TMyFaceJobHandler.RefreshNetworkPc;
var
  NetworkComputerRefresh : TNetworkComputerRefresh;
begin
  NetworkComputerRefresh := TNetworkComputerRefresh.Create;
  AddJob( NetworkComputerRefresh );
end;

{ TNetowrkFolderRefresh }

procedure TNetowrkFolderRefresh.ClearOldFolderList;
begin
    // ��վ���Ϣ
  FaceNetworkFolderApi.Clear;
end;

constructor TNetowrkFolderRefresh.Create(_ComputerName: string);
begin
  ComputerName := _ComputerName;
  NetworkFolderList := TStringList.Create;
end;

destructor TNetowrkFolderRefresh.Destroy;
begin
  NetworkFolderList.Free;
  inherited;
end;

procedure TNetowrkFolderRefresh.FindNetworkFolderList;
var
  ShareList : TStringList;
  i: Integer;
begin
    // �����ھ�·������
  if LeftStr( ComputerName, 2 ) <> '\\' then
    ComputerName := '\\' + ComputerName;

    // ����
  ShareList := NetworkDriverUtil.ReadPcShareList( ComputerName );
  for i := 0 to ShareList.Count - 1 do
    NetworkFolderList.Add( ShareList[i] );
  ShareList.Free;
end;

procedure TNetowrkFolderRefresh.ShowNetworkFolderList;
var
  i: Integer;
begin
    // �������Ϣ
  for i := 0 to NetworkFolderList.Count - 1 do
    FaceNetworkFolderApi.Add( NetworkFolderList[i] );
end;

procedure TNetowrkFolderRefresh.Update;
begin
    // ��վ���Ϣ
  FaceUpdate( ClearOldFolderList );

    // Ѱ�ҹ���Ŀ¼
  FindNetworkFolderList;

    // ��ʾ����Ŀ¼
  FaceUpdate( ShowNetworkFolderList );
end;

{ TLocalDriverRefresh }

constructor TLocalDriverRefresh.Create(_FolderPath: string);
begin
  FolderPath := _FolderPath;
  FileList := TFileList.Create;
end;

destructor TLocalDriverRefresh.Destroy;
begin
  FileList.Free;
  inherited;
end;

procedure TLocalDriverRefresh.FindDriverList;
var
  StrArray : TStringDynArray;
  i: Integer;
  FileInfo : TFileInfo;
begin
  StrArray := TDirectory.GetLogicalDrives;
  for i := 0 to Length( StrArray ) - 1 do
  begin
    if not MyFilePath.getDriverExist( StrArray[i] ) then
      Continue;
    FileInfo := TFileInfo.Create( StrArray[i], False );
    FileList.Add( FileInfo );
  end;
end;

procedure TLocalDriverRefresh.FindFileList;
var
  FolderExplorer : TFolderExplorer;
begin
  FolderExplorer := TFolderExplorer.Create( FolderPath );
  FolderExplorer.SetFileList( FileList );
  FolderExplorer.Update;
  FolderExplorer.Free;

  ReadHistoryList;
end;

procedure TLocalDriverRefresh.MoveFile(FileName: string);
var
  FilePos : Integer;
  i: Integer;
begin
  FilePos := -1;
  for i := 0 to FileList.Count - 1 do
  begin
    if FileList[i].IsFile and ( FilePos = -1 ) then // ��һ���ļ���λ��
      FilePos := i;
    if FileList[i].FileName = FileName then  // �ҵ���·��
    begin
      if not FileList[i].IsFile then
        FileList.Move( i, 0 )
      else
      if FilePos >= 0 then
        FileList.Move( i, FilePos );
      Break;
    end;
  end;
end;

procedure TLocalDriverRefresh.ReadHistoryList;
var
  HistorySelectList : TStringList;
  IniFile : TIniFile;
  i: Integer;
begin
    // ��ȡ��ʷѡ��
  HistorySelectList := TStringList.Create;
  IniFile := TIniFile.Create( MyAppData.getExplorerHistoryPath );
  try
    IniFile.ReadSection( FolderPath, HistorySelectList );
  except
  end;
  IniFile.Free;

    // �ƶ��ļ�
  for i := 0 to HistorySelectList.Count - 1 do
    MoveFile( HistorySelectList[i] );
  HistorySelectList.Free;
end;

function TLocalDriverRefresh.ReadIsMyComputer: Boolean;
begin
  Result := FolderPath = '';
end;

procedure TLocalDriverRefresh.SetControlPath(_ControlPath: string);
begin
  ControlPath := _ControlPath;
end;

procedure TLocalDriverRefresh.ShowFileList;
var
  Params : TFileAddParams;
  i: Integer;
  ParentPath, UpPath : string;
begin
    // ����ҳ��
  if not FacePageDriverApi.ControlPage( ControlPath ) then
    Exit;

    // ��վ���Ϣ
  FaceLocalDriverApi.Clear;

    // ���ظ�Ŀ¼
  if FolderPath <> '' then
  begin
    UpPath := ExtractFileDir( FolderPath );
    if UpPath = FolderPath then
      UpPath := '';
    FaceLocalDriverApi.AddParentFolder( UpPath );
  end;

    // ���
  ParentPath := MyFilePath.getPath( FolderPath );
  for i := 0 to FileList.Count - 1 do
  begin
    Params.FilePath := ParentPath + FileList[i].FileName;
    Params.IsFile := FileList[i].IsFile;
    Params.FileSize := FileList[i].FileSize;
    Params.FileTime := FileList[i].FileTime;
    if ReadIsMyComputer then
      FaceLocalDriverApi.AddDriver( Params )
    else
      FaceLocalDriverApi.Add( Params );
  end;
end;

procedure TLocalDriverRefresh.Update;
begin
    // Ѱ���ļ��б�
  if ReadIsMyComputer then
    FindDriverList
  else
    FindFileList;

    // ��ʾ�ļ��б�
  FaceUpdate( ShowFileList );
end;

{ TNetworkDriverRefresh }

constructor TNetworkDriverRefresh.Create(_FolderPath: string);
begin
  FolderPath := _FolderPath;
  FileList := TFileList.Create;
end;

destructor TNetworkDriverRefresh.Destroy;
begin
  FileList.Free;
  inherited;
end;

procedure TNetworkDriverRefresh.FindFileList;
var
  FolderExplorer : TFolderExplorer;
  FtpFileList : TFtpFileList;
  i: Integer;
  FtpInfo : TFtpFileInfo;
  FileInfo : TFileInfo;
begin
  FtpFileList := MyFtpFaceHandler.ReadFileList( ControlPath, FolderPath );
  for i := 0 to FtpFileList.Count - 1 do
  begin
    FtpInfo := FtpFileList[i];
    FileInfo := TFileInfo.Create( FtpInfo.FileName, FtpInfo.IsFile );
    FileInfo.SetFileInfo( FtpInfo.FileSize, FtpInfo.FileTime );
    FileList.Add( FileInfo );
  end;
  FtpFileList.Free;

  ReadHistoryList;
end;

procedure TNetworkDriverRefresh.MoveFile(FileName: string);
var
  FilePos : Integer;
  i: Integer;
begin
  FilePos := -1;
  for i := 0 to FileList.Count - 1 do
  begin
    if FileList[i].IsFile and ( FilePos = -1 ) then // ��һ���ļ���λ��
      FilePos := i;
    if FileList[i].FileName = FileName then  // �ҵ���·��
    begin
      if not FileList[i].IsFile then
        FileList.Move( i, 0 )
      else
      if FilePos >= 0 then
        FileList.Move( i, FilePos );
      Break;
    end;
  end;
end;

procedure TNetworkDriverRefresh.ReadHistoryList;
var
  HistorySelectList : TStringList;
  IniFile : TIniFile;
  i: Integer;
begin
    // ��ȡ��ʷѡ��
  HistorySelectList := TStringList.Create;
  IniFile := TIniFile.Create( MyAppData.getExplorerHistoryPath );
  try
    IniFile.ReadSection( FolderPath, HistorySelectList );
  except
  end;
  IniFile.Free;

    // �ƶ��ļ�
  for i := 0 to HistorySelectList.Count - 1 do
    MoveFile( HistorySelectList[i] );
  HistorySelectList.Free;
end;

procedure TNetworkDriverRefresh.SetControlPath(_ControlPath: string);
begin
  ControlPath := _ControlPath;
end;

procedure TNetworkDriverRefresh.ShowFileList;
var
  Params : TFileAddParams;
  i: Integer;
  ParentPath : string;
begin
    // ����ҳ��
  if not FacePageDriverApi.ControlPage( ControlPath ) then
    Exit;

    // ��վ���Ϣ
  FaceNetworkDriverApi.Clear;

      // ���ظ�Ŀ¼
  if FolderPath <> Path_FtpRoot then
    FaceNetworkDriverApi.AddParentFolder( MyFilePath.getFtpDir( FolderPath ) );

    // ���
  ParentPath := MyFilePath.getFtpPath( FolderPath );
  for i := 0 to FileList.Count - 1 do
  begin
    Params.FilePath := ParentPath + FileList[i].FileName;
    Params.IsFile := FileList[i].IsFile;
    Params.FileSize := FileList[i].FileSize;
    Params.FileTime := FileList[i].FileTime;
    FaceNetworkDriverApi.Add( Params );
  end;

    // �������ڼ���
  FaceNetworkStatusApi.HideIsLoading;
end;

procedure TNetworkDriverRefresh.Update;
begin
    // Ѱ���ļ��б�
  FindFileList;

    // ��ʾ�ļ��б�
  FaceUpdate( ShowFileList );
end;

{ TFileListMarkSelectJob }

constructor TFileListMarkSelectJob.Create(_FolderPath, _SelectName: string);
begin
  FolderPath := _FolderPath;
  SelectName := _SelectName;
end;

procedure TFileListMarkSelectJob.Update;
var
  IniFile : TIniFile;
  HistoryList : TStringList;
begin
  IniFile := TIniFile.Create( MyAppData.getExplorerHistoryPath );
  try
      // ɾ���ɵ�λ��
    IniFile.DeleteKey( FolderPath, SelectName );

      // ���Ʊ�����ʷ��
    HistoryList := TStringList.Create;
    IniFile.ReadSection( FolderPath, HistoryList );
    if HistoryList.Count >= 7 then
      IniFile.DeleteKey( FolderPath, HistoryList[0] );
    HistoryList.Free;

      // ��ӵ��µ�λ��
    IniFile.WriteString( FolderPath, SelectName, SelectName );

      // ��ʷ·������
    HistoryList := TStringList.Create;
    IniFile.ReadSections( HistoryList );
    try
      if HistoryList.Count > 100 then
        IniFile.EraseSection( HistoryList[0] );
    except
    end;
    HistoryList.Free
  except
  end;
  IniFile.Free;
end;

{ TFileListSelectJob }

constructor TFileListSelectJob.Create(_ControlPath, _FilePath: string);
begin
  ControlPath := _ControlPath;
  FilePath := _FilePath;
end;

procedure TFileListSelectJob.SelectPath;
begin
  if IsLocal then
    UserLocalDriverApi.Select( ControlPath, FilePath )
  else
    UserNetworkDriverApi.Select( ControlPath, FilePath );
end;

procedure TFileListSelectJob.SetIsLocal(_IsLocal: Boolean);
begin
  IsLocal := _IsLocal;
end;

procedure TFileListSelectJob.Update;
begin
  FaceUpdate( SelectPath );
end;

{ TFolderChangeNofityJob }

procedure TFolderChangeNofityJob.AddFile;
var
  FilePath : string;
begin
  FilePath := MyFilePath.getPath( FolderPath ) + FileName;
  UserLocalDriverApi.AddFile( ControlPath, FilePath )
end;

constructor TFolderChangeNofityJob.Create(_FolderPath: string);
begin
  FolderPath := _FolderPath;
  NewFileList := TStringList.Create;
  OldFileList := TStringList.Create;
end;

destructor TFolderChangeNofityJob.Destroy;
begin
  OldFileList.Free;
  NewFileList.Free;
  inherited;
end;

procedure TFolderChangeNofityJob.ReadNewFileList;
begin
  if not DirectoryExists( FolderPath ) then
    Exit;

try
  TDirectory.GetFileSystemEntries( FolderPath,
    function(const Path: string; const SearchRec: TSearchRec): Boolean
    begin
      NewFileList.Add( SearchRec.Name );
      Result := False;
    end);
except
end;
end;

procedure TFolderChangeNofityJob.ReadOldFileList;
var
  PathList : TStringList;
  i: Integer;
begin
  PathList := UserLocalDriverApi.ReadFileList( ControlPath );
  for i := 0 to PathList.Count - 1 do
    OldFileList.Add( ExtractFileName( PathList[i] ) );
  PathList.Free;
end;

procedure TFolderChangeNofityJob.RemoveFile;
var
  FilePath : string;
begin
  FilePath := MyFilePath.getPath( FolderPath ) + FileName;
  UserLocalDriverApi.RemoveFile( ControlPath, FilePath );
end;

procedure TFolderChangeNofityJob.SetControlPath(_ControlPath: string);
begin
  ControlPath := _ControlPath;
end;

procedure TFolderChangeNofityJob.Update;
var
  i, FileIndex: Integer;
begin
    // ��ȡ��ǰ�����ļ�
  FaceUpdate( ReadOldFileList );

    // ��ȡ��ǰӲ���ļ�
  ReadNewFileList;

    // �Ƿ�����������ļ�
  for i := 0 to NewFileList.Count - 1 do
  begin
    FileName := NewFileList[i];
    FileIndex := OldFileList.IndexOf( FileName );
    if FileIndex >= 0 then
      OldFileList.Delete( FileIndex )
    else
      FaceUpdate( AddFile );
  end;

    // �Ƿ�����Ѿ�ɾ�����ļ�
  for i := 0 to OldFileList.Count - 1 do
  begin
    FileName := OldFileList[i];
    FaceUpdate( RemoveFile );
  end;
end;

end.
