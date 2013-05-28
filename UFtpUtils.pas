unit UFtpUtils;

interface

uses IdFTP, classes, Generics.Collections, SyncObjs, SysUtils, IdFTPList, IniFiles, IdComponent,
     IdAllFTPListParsers;

type

    // Ftp �ļ���Ϣ
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

    // ���� Ftp �ļ���Ϣ
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

    // Ftp ����
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

    // Ftp ���ӹ���
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
    function NewConn( Host, Port, UserName, Password : string ): Boolean;  // ����һ������
    procedure AddConn( Host, Port, UserName, Password : string ); // ���
    procedure RemoveConn( Host : string ); // �Ƴ�
  public
    function ReadFileList( Host, Path : string ) : TFtpFileList;  // ��ȡ�ļ��б�
    function Download( Host, RemotePath, LocalPath : string ): Boolean;  // ����
    function Upload( Host, LocalPath, RemotePath : string ): Boolean;  // �ϴ�
    function NewFolder( Host, RemotePath : string ): Boolean; // �½�Ŀ¼
    function RemoveFolder( Host, RemotePath : string ): Boolean; // ɾ��Ŀ¼
    function DeleteFile( Host, RemotePath : string ): Boolean; // ɾ���ļ�
    function Rename( Host, RemotePath, NewName : string ): Boolean; // ����
    procedure StopTransfer( Host : string ); // ֹͣ�ļ�����
  public
    procedure BingWordBegin( Host : string; WorkBeginEvent : TWorkBeginEvent );
    procedure BingWord( Host : string; WorkEvent : TWorkEvent );
  private
    function ReadConnection( Host : string ) : TFtpConnection; // ��ȡ����
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
  MyFtpFileHandler : TMyFtpHandler; // Ftp �ļ�����
  MyFtpFaceHandler : TMyFtpHandler; // Ftp �������

implementation

uses UMyUtils;

{ TFtpConnection }

function TFtpConnection.ConfirmConnect( Path : string ): Boolean;
begin
  Result := True;
  if FtpConn.Connected then  // ������
  begin
    try
    if CurrentPath <> Path then  // ·����ͬ
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
    if FtpConn.Connected then  // ������Ͽ�
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
    // �ѽ���
  if not IsRun then
    Exit;

  FtpConnection := ReadConnection( Host );
  if Assigned( FtpConnection ) then  // �����Ѵ���
    Exit;

    // ����
  FtpConnection := TFtpConnection.Create( Host, Port );
  FtpConnection.SetUserInfo( UserName, Password );

    // ���
  ConnectionLock.Enter;
  FtpConnectionList.Add( FtpConnection );
  ConnectionLock.Leave;
end;

procedure TMyFtpHandler.BingWord(Host: string; WorkEvent: TWorkEvent);
var
  FtpConnection : TFtpConnection;
begin
    // �ѽ���
  if not IsRun then
    Exit;

    // ��ȡ����
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) then
    Exit;

    // �¼���
  FtpConnection.FtpConn.OnWork := WorkEvent;
end;

procedure TMyFtpHandler.BingWordBegin(Host: string;
  WorkBeginEvent: TWorkBeginEvent);
var
  FtpConnection : TFtpConnection;
begin
    // �ѽ���
  if not IsRun then
    Exit;

    // ��ȡ����
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) then
    Exit;

    // �¼���
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

    // �ѽ���
  if not IsRun then
    Exit;

  RemoteParent := MyFilePath.getFtpDir( RemotePath );
  RemoteName := MyFilePath.getFtpName( RemotePath );
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) or not FtpConnection.ConfirmConnect( RemoteParent ) then  // ���Ӳ����� �� �޷�����
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

    // �ѽ���
  if not IsRun then
    Exit;

  RemoteParent := MyFilePath.getFtpDir( RemotePath );
  RemoteName := MyFilePath.getFtpName( RemotePath );
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) or not FtpConnection.ConfirmConnect( RemoteParent ) then  // ���Ӳ����� �� �޷�����
    Exit;
  FtpConn := FtpConnection.FtpConn;
  try
    if FileExists( LocalPath ) then  // �ļ���������ɾ��
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
        // ����
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
    // �ѽ���
  if not IsRun then
    Exit;

  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) then  // ���Ӳ����ڣ������
  begin
    FtpConnection := TFtpConnection.Create( Host, Port );
    FtpConnection.SetUserInfo( UserName, Password );
      // ���
    ConnectionLock.Enter;
    FtpConnectionList.Add( FtpConnection );
    ConnectionLock.Leave;
  end;
  Result := FtpConnection.ConfirmConnect( '/' );
  if not Result then  // ����ʧ�ܣ���ɾ������
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

    // �ѽ���
  if not IsRun then
    Exit;

  RemoteParent := MyFilePath.getFtpDir( RemotePath );
  RemoteName := MyFilePath.getFtpName( RemotePath );
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) or not FtpConnection.ConfirmConnect( RemoteParent ) then  // ���Ӳ����� �� �޷�����
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

    // �ѽ���
  if not IsRun then
    Exit;

  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) or not FtpConnection.ConfirmConnect( Path ) then  // ���Ӳ����� �� �޷�����
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

    // �ѽ���
  if not IsRun then
    Exit;

  RemoteParent := MyFilePath.getFtpDir( RemotePath );
  RemoteName := MyFilePath.getFtpName( RemotePath );
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) or not FtpConnection.ConfirmConnect( RemoteParent ) then  // ���Ӳ����� �� �޷�����
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

    // �ѽ���
  if not IsRun then
    Exit;

  RemoteParent := MyFilePath.getFtpDir( RemotePath );
  RemoteName := MyFilePath.getFtpName( RemotePath );
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) or not FtpConnection.ConfirmConnect( RemoteParent ) then  // ���Ӳ����� �� �޷�����
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
    // �ѽ���
  if not IsRun then
    Exit;

    // ��ȡ����
  FtpConnection := ReadConnection( Host );
  if Assigned( FtpConnection ) then
    FtpConnection.StopTransfer;  // ֹͣ���ݴ���
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

    // �ѽ���
  if not IsRun then
    Exit;

  RemoteParent := MyFilePath.getFtpDir( RemotePath );
  RemoteName := MyFilePath.getFtpName( RemotePath );
  FtpConnection := ReadConnection( Host );
  if not Assigned( FtpConnection ) or not FtpConnection.ConfirmConnect( RemoteParent ) then  // ���Ӳ����� �� �޷�����
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
    // Ѱ�����λ��
  InsertPos := FtpFileList.Count;
  for i := FtpFileList.Count - 1 downto 0 do
    if not FtpFileList[i].IsFile or ( CompareText( FtpFileInfo.FileName, FtpFileList[i].FileName ) > 0 ) then
    begin
      InsertPos := i + 1;
      Break;
    end;

    // ���
  FtpFileList.Insert( InsertPos, FtpFileInfo );
end;


procedure TFtpFileInsert.AddFolder(FtpFileInfo: TFtpFileInfo);
var
  InsertPos : Integer;
  i: Integer;
begin
    // Ѱ�����λ��
  InsertPos := FtpFileList.Count;
  for i := 0 to FtpFileList.Count - 1 do
    if FtpFileList[i].IsFile or ( CompareText( FtpFileList[i].FileName, FtpFileInfo.FileName ) > 0 ) then
    begin
      InsertPos := i;
      Break;
    end;

    // ���
  FtpFileList.Insert( InsertPos, FtpFileInfo );
end;

constructor TFtpFileInsert.Create(_FtpFileList: TFtpFileList);
begin
  FtpFileList := _FtpFileList;
end;

end.
