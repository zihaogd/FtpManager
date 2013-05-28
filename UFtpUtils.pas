unit UFtpUtils;

interface

uses IdFTP, classes, Generics.Collections, SyncObjs, SysUtils, IdFTPList, IniFiles, IdComponent,
     IdAllFTPListParsers;

type

    // Ftp 文件信息
  TFtpFileInfo = class
  public
    FileName : string;
    IsFile : Boolean;
    FileSize : Int64;
    FileTime : TDateTime;
  public
    constructor Create( _FileName : string; _IsFile : Boolean );
    procedure SetFileInfo( _FileSize : Int64; _FileTime : TDateTime );
  end;
  TFtpFileList = class( TObjectList<TFtpFileInfo> )end;

    // 插入 Ftp 文件信息
  TFtpFileInsert = class
  private
    FtpFileList : TFtpFileList;
  public
    constructor Create( _FtpFileList : TFtpFileList );
    procedure Add( FtpFileInfo : TFtpFileInfo );
  private
    procedure AddFile( FtpFileInfo : TFtpFileInfo );
    procedure AddFolder( FtpFileInfo : TFtpFileInfo );
  end;

    // Ftp 连接
  TFtpConnection = class
  public
    Host, Port : string;
    UserName, Password : string;
    CurrentPath : string;
    FtpConn : TIdFTP;
  public
    constructor Create( _Host, _Port : string );
    procedure SetUserInfo( _UserName, _Password : string );
    function ConfirmConnect( Path : string ): Boolean;
    procedure StopTransfer;
    destructor Destroy; override;
  end;
  TFtpConnectionList = class( TObjectList<TFtpConnection> )end;

    // Ftp 连接管理
  TMyFtpHandler = class
  private
    ConnectionLock : TCriticalSection;
    FtpConnectionList : TFtpConnectionList;
  private
    IsRun : Boolean;
  public
    constructor Create;
    procedure Stop;
    destructor Destroy; override;
  public
    procedure SaveIni( IniFile : TIniFile );
    procedure LoadIni( IniFile : TIniFile );
  public
    function NewConn( Host, Port, UserName, Password : string ): Boolean;  // 创建一个连接
    procedure AddConn( Host, Port, UserName, Password : string ); // 添加
    procedure RemoveConn( Host : string ); // 移除
  public
    function ReadFileList( Host, Path : string ) : TFtpFileList;  // 读取文件列表
    function Download( Host, RemotePath, LocalPath : string ): Boolean;  // 下载
    function Upload( Host, LocalPath, RemotePath : string ): Boolean;  // 上传
    function NewFolder( Host, RemotePath : string ): Boolean; // 新建目录
    function RemoveFolder( Host, RemotePath : string ): Boolean; // 删除目录
    function DeleteFile( Host, RemotePath : string ): Boolean; // 删除文件
    function Rename( Host, RemotePath, NewName : string ): Boolean; // 改名
    procedure StopTransfer( Host : string ); // 停止文件传输
  public
    procedure BingWordBegin( Host : string; WorkBeginEvent : TWorkBeginEvent );
    procedure BingWord( Host : string; WorkEvent : TWorkEvent );
  private
    function ReadConnection( Host : string ) : TFtpConnection; // 获取连接
  end;

const
  Ini_FtpConn = 'FtpConn';
  Ini_FtpCount = 'FtpCount';
  Ini_FtpConn_Host = 'Host';
  Ini_FtpConn_Port = 'Port';
  Ini_FtpConn_UserName = 'UserName';
  Ini_FtpConn_Password = 'Password';

const
  Path_FtpRoot = '/';

var
  MyFtpFileHandler : TMyFtpHandler; // Ftp 文件管理
  MyFtpFaceHandler : TMyFtpHandler; // Ftp 界面管理

implementation

uses UMyUtils;

{ TFtpConnection }

function TFtpConnection.ConfirmConnect( Path : string ): Boolean;
begin
  Result := True;
  if FtpConn.Connected then  // 已连接
  begin
    try
    if CurrentPath <> Path then  // 路径不同
      FtpConn.ChangeDir( Path );
    except
      Result := False;
    end;
    Exit;
  end;

  FtpConn.Host := Host;
  FtpConn.Port := StrToIntDef( Port, 21 );
  FtpConn.Username := UserName;
  FtpConn.Password := Password;
  try
    FtpConn.Connect;
  except
  end;
  try
    Result := FtpConn.Connected;
    if Result then
      FtpConn.ChangeDir( Path );
  except
  end;
end;

constructor TFtpConnection.Create( _Host, _Port : string );
begin
  Host := _Host;
  Port := _Port;
  CurrentPath := '';
  FtpConn := TIdFTP.Create(nil);
end;

destructor TFtpConnection.Destroy;
begin
  try
    if FtpConn.Connected then  // 连接则断开
    begin
      FtpConn.Abort;
      FtpConn.Quit;
    end;
  except
  end;
  FtpConn.Free;
  inherited;
end;

procedure TFtpConnection.SetUserInfo(_UserName, _Password: string);
begin
  UserName := _UserName;
  Password := _Password;
end;

procedure TFtpConnection.StopTransfer;
begin
  try
    if FtpConn.Connected then
      FtpConn.Abort;
  except
  end;
end;

{ TMyFtpHandler }

procedure TMyFtpHandler.AddConn(Host, Port, UserName, Password: string);
var
  FtpConnection : TFtpConnection;
begin
    // 已结束
  if not IsRun then
    Exit;

  FtpConnection := ReadConnection( Host );
  if Assigned( FtpConnection ) then  // 连接已存在
    Exit;

    // 创建
  FtpConnection := TFtpConnection.Create( Host, Port );
  FtpConnection.SetUserInfo( UserName, Password );

    // 添加
  ConnectionLock.Enter;
  FtpConnectionList.Add( FtpConnection );
  ConnectionLock.Leave;
end;

procedure TMyFtpHandler.BingWord(Host: string; WorkEvent: TWorkEvent);
var
  FtpConnection : TFtpConnection;
begin
    // 已结束
  if not IsRun then
    Exit;

    // 获取连接
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) then
    Exit;

    // 事件绑定
  FtpConnection.FtpConn.OnWork := WorkEvent;
end;

procedure TMyFtpHandler.BingWordBegin(Host: string;
  WorkBeginEvent: TWorkBeginEvent);
var
  FtpConnection : TFtpConnection;
begin
    // 已结束
  if not IsRun then
    Exit;

    // 获取连接
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) then
    Exit;

    // 事件绑定
  FtpConnection.FtpConn.OnWorkBegin := WorkBeginEvent;
end;

constructor TMyFtpHandler.Create;
begin
  ConnectionLock := TCriticalSection.Create;
  FtpConnectionList := TFtpConnectionList.Create;
  IsRun := True;
end;

function TMyFtpHandler.DeleteFile(Host, RemotePath: string): Boolean;
var
  RemoteParent, RemoteName : string;
  FtpConnection : TFtpConnection;
  FtpConn : TIdFTP;
  i: Integer;
  FtpItem : TIdFTPListItem;
begin
  Result := False;

    // 已结束
  if not IsRun then
    Exit;

  RemoteParent := MyFilePath.getFtpDir( RemotePath );
  RemoteName := MyFilePath.getFtpName( RemotePath );
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) or not FtpConnection.ConfirmConnect( RemoteParent ) then  // 连接不存在 或 无法连接
    Exit;
  FtpConn := FtpConnection.FtpConn;
  try
    FtpConn.Delete( RemoteName );
    Result := True;
  except
  end;
end;

destructor TMyFtpHandler.Destroy;
begin
  FtpConnectionList.Free;
  ConnectionLock.Free;
  inherited;
end;

function TMyFtpHandler.Download(Host, RemotePath, LocalPath: string): Boolean;
var
  RemoteParent, RemoteName : string;
  FtpConnection : TFtpConnection;
  FtpConn : TIdFTP;
  i: Integer;
  FtpItem : TIdFTPListItem;
begin
  Result := False;

    // 已结束
  if not IsRun then
    Exit;

  RemoteParent := MyFilePath.getFtpDir( RemotePath );
  RemoteName := MyFilePath.getFtpName( RemotePath );
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) or not FtpConnection.ConfirmConnect( RemoteParent ) then  // 连接不存在 或 无法连接
    Exit;
  FtpConn := FtpConnection.FtpConn;
  try
    if FileExists( LocalPath ) then  // 文件存在则先删除
      MyShellFile.DeleteFile( LocalPath );
    ForceDirectories( ExtractFileDir( LocalPath ) );
    FtpConn.Get( RemoteName, LocalPath );
    Result := True;
  except
  end;
end;

procedure TMyFtpHandler.LoadIni(IniFile: TIniFile);
var
  i, FtpCount: Integer;
  Host, Port, UserName, Password : string;
  FtpConnection : TFtpConnection;
begin
  ConnectionLock.Enter;
  FtpCount := IniFile.ReadInteger( Ini_FtpConn, Ini_FtpCount, 0 );
  for i := 0 to FtpCount - 1 do
  begin
    Host := IniFile.ReadString( Ini_FtpConn, Ini_FtpConn_Host + IntToStr(i), '' );
    Port := IniFile.ReadString( Ini_FtpConn, Ini_FtpConn_Port + IntToStr(i), '' );
    UserName := IniFile.ReadString( Ini_FtpConn, Ini_FtpConn_UserName + IntToStr(i), '' );
    Password := IniFile.ReadString( Ini_FtpConn, Ini_FtpConn_Password + IntToStr(i), '' );
        // 创建
    FtpConnection := TFtpConnection.Create( Host, Port );
    FtpConnection.SetUserInfo( UserName, Password );
    FtpConnectionList.Add( FtpConnection );
  end;
  ConnectionLock.Leave;
end;

function TMyFtpHandler.NewConn(Host, Port, UserName, Password: string): Boolean;
var
  FtpConnection : TFtpConnection;
begin
    // 已结束
  if not IsRun then
    Exit;

  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) then  // 连接不存在，则添加
  begin
    FtpConnection := TFtpConnection.Create( Host, Port );
    FtpConnection.SetUserInfo( UserName, Password );
      // 添加
    ConnectionLock.Enter;
    FtpConnectionList.Add( FtpConnection );
    ConnectionLock.Leave;
  end;
  Result := FtpConnection.ConfirmConnect( '/' );
  if not Result then  // 连接失败，则删除连接
    RemoveConn( Host );
end;

function TMyFtpHandler.NewFolder(Host, RemotePath: string): Boolean;
var
  RemoteParent, RemoteName : string;
  FtpConnection : TFtpConnection;
  FtpConn : TIdFTP;
  i: Integer;
  FtpItem : TIdFTPListItem;
begin
  Result := False;

    // 已结束
  if not IsRun then
    Exit;

  RemoteParent := MyFilePath.getFtpDir( RemotePath );
  RemoteName := MyFilePath.getFtpName( RemotePath );
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) or not FtpConnection.ConfirmConnect( RemoteParent ) then  // 连接不存在 或 无法连接
    Exit;
  FtpConn := FtpConnection.FtpConn;
  try
    FtpConn.MakeDir( RemoteName );
    Result := True;
  except
  end;
end;

function TMyFtpHandler.ReadConnection(Host: string): TFtpConnection;
var
  i: Integer;
begin
  ConnectionLock.Enter;
  Result := nil;
  for i := 0 to FtpConnectionList.Count - 1 do
    if FtpConnectionList[i].Host = Host then
    begin
      Result := FtpConnectionList[i];
      Break;
    end;
  ConnectionLock.Leave;
end;

function TMyFtpHandler.ReadFileList(Host, Path: string): TFtpFileList;
var
  FtpConnection : TFtpConnection;
  FtpConn : TIdFTP;
  FtpFileInsert : TFtpFileInsert;
  i: Integer;
  FtpItem : TIdFTPListItem;
  FtpFileInfo : TFtpFileInfo;
begin
  Result := TFtpFileList.Create;

    // 已结束
  if not IsRun then
    Exit;

  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) or not FtpConnection.ConfirmConnect( Path ) then  // 连接不存在 或 无法连接
    Exit;
  FtpConn := FtpConnection.FtpConn;
  try
    FtpConn.List;
  except
  end;
  FtpFileInsert := TFtpFileInsert.Create( Result );
  try
    for i := 0 to FtpConn.DirectoryListing.Count - 1 do
    begin
      FtpItem := FtpConn.DirectoryListing.Items[i];
      FtpFileInfo := TFtpFileInfo.Create( FtpItem.FileName, FtpItem.ItemType = ditFile);
      FtpFileInfo.SetFileInfo( FtpItem.Size, FtpItem.ModifiedDate );
      FtpFileInsert.Add( FtpFileInfo );
    end;
  except
  end;
  FtpFileInsert.Free;
end;

procedure TMyFtpHandler.RemoveConn(Host: string);
var
  i: Integer;
begin
  ConnectionLock.Enter;
  for i := 0 to FtpConnectionList.Count - 1 do
    if FtpConnectionList[i].Host = Host then
    begin
      FtpConnectionList.Delete( i );
      Break;
    end;
  ConnectionLock.Leave;
end;

function TMyFtpHandler.RemoveFolder(Host, RemotePath: string): Boolean;
var
  RemoteParent, RemoteName : string;
  FtpConnection : TFtpConnection;
  FtpConn : TIdFTP;
  i: Integer;
  FtpItem : TIdFTPListItem;
begin
  Result := False;

    // 已结束
  if not IsRun then
    Exit;

  RemoteParent := MyFilePath.getFtpDir( RemotePath );
  RemoteName := MyFilePath.getFtpName( RemotePath );
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) or not FtpConnection.ConfirmConnect( RemoteParent ) then  // 连接不存在 或 无法连接
    Exit;
  FtpConn := FtpConnection.FtpConn;
  try
    FtpConn.RemoveDir( RemoteName );
    Result := True;
  except
  end;
end;

function TMyFtpHandler.Rename(Host, RemotePath, NewName: string): Boolean;
var
  RemoteParent, RemoteName : string;
  FtpConnection : TFtpConnection;
  FtpConn : TIdFTP;
  i: Integer;
  FtpItem : TIdFTPListItem;
begin
  Result := False;

    // 已结束
  if not IsRun then
    Exit;

  RemoteParent := MyFilePath.getFtpDir( RemotePath );
  RemoteName := MyFilePath.getFtpName( RemotePath );
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) or not FtpConnection.ConfirmConnect( RemoteParent ) then  // 连接不存在 或 无法连接
    Exit;
  FtpConn := FtpConnection.FtpConn;
  try
    FtpConn.Rename( RemoteName, NewName );
    Result := True;
  except
  end;
end;

procedure TMyFtpHandler.SaveIni(IniFile: TIniFile);
var
  i: Integer;
begin
  ConnectionLock.Enter;
  IniFile.WriteInteger( Ini_FtpConn, Ini_FtpCount, FtpConnectionList.Count );
  for i := 0 to FtpConnectionList.Count - 1 do
  begin
    IniFile.WriteString( Ini_FtpConn, Ini_FtpConn_Host + IntToStr(i), FtpConnectionList[i].Host );
    IniFile.WriteString( Ini_FtpConn, Ini_FtpConn_Port + IntToStr(i), FtpConnectionList[i].Port );
    IniFile.WriteString( Ini_FtpConn, Ini_FtpConn_UserName + IntToStr(i), FtpConnectionList[i].UserName );
    IniFile.WriteString( Ini_FtpConn, Ini_FtpConn_Password + IntToStr(i), FtpConnectionList[i].Password );
  end;
  ConnectionLock.Leave;
end;

procedure TMyFtpHandler.Stop;
begin
  IsRun := False;

  ConnectionLock.Enter;
  FtpConnectionList.Clear;
  ConnectionLock.Leave;
end;

procedure TMyFtpHandler.StopTransfer(Host: string);
var
  FtpConnection : TFtpConnection;
begin
    // 已结束
  if not IsRun then
    Exit;

    // 获取连接
  FtpConnection := ReadConnection( Host );
  if Assigned( FtpConnection ) then
    FtpConnection.StopTransfer;  // 停止数据传输
end;

function TMyFtpHandler.Upload(Host, LocalPath, RemotePath: string): Boolean;
var
  RemoteParent, RemoteName : string;
  FtpConnection : TFtpConnection;
  FtpConn : TIdFTP;
  i: Integer;
  FtpItem : TIdFTPListItem;
begin
  Result := False;

    // 已结束
  if not IsRun then
    Exit;

  RemoteParent := MyFilePath.getFtpDir( RemotePath );
  RemoteName := MyFilePath.getFtpName( RemotePath );
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) or not FtpConnection.ConfirmConnect( RemoteParent ) then  // 连接不存在 或 无法连接
    Exit;
  FtpConn := FtpConnection.FtpConn;
  try
    FtpConn.Put( LocalPath, RemoteName );
    Result := True;
  except
  end;
end;

{ TFtpFileInfo }

constructor TFtpFileInfo.Create(_FileName: string; _IsFile: Boolean);
begin
  FileName := _FileName;
  IsFile := _IsFile;
end;

procedure TFtpFileInfo.SetFileInfo(_FileSize: Int64; _FileTime: TDateTime);
begin
  FileSize := _FileSize;
  FileTime := _FileTime;
end;

{ TFtpFileInsert }

procedure TFtpFileInsert.Add(FtpFileInfo: TFtpFileInfo);
begin
  if FtpFileInfo.IsFile then
    AddFile( FtpFileInfo )
  else
    AddFolder( FtpFileInfo );
end;

procedure TFtpFileInsert.AddFile(FtpFileInfo: TFtpFileInfo);
var
  InsertPos : Integer;
  i: Integer;
begin
    // 寻找添加位置
  InsertPos := FtpFileList.Count;
  for i := FtpFileList.Count - 1 downto 0 do
    if not FtpFileList[i].IsFile or ( CompareText( FtpFileInfo.FileName, FtpFileList[i].FileName ) > 0 ) then
    begin
      InsertPos := i + 1;
      Break;
    end;

    // 添加
  FtpFileList.Insert( InsertPos, FtpFileInfo );
end;


procedure TFtpFileInsert.AddFolder(FtpFileInfo: TFtpFileInfo);
var
  InsertPos : Integer;
  i: Integer;
begin
    // 寻找添加位置
  InsertPos := FtpFileList.Count;
  for i := 0 to FtpFileList.Count - 1 do
    if FtpFileList[i].IsFile or ( CompareText( FtpFileList[i].FileName, FtpFileInfo.FileName ) > 0 ) then
    begin
      InsertPos := i;
      Break;
    end;

    // 添加
  FtpFileList.Insert( InsertPos, FtpFileInfo );
end;

constructor TFtpFileInsert.Create(_FtpFileList: TFtpFileList);
begin
  FtpFileList := _FtpFileList;
end;

end.
