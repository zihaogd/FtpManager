unit UFileThread;

interface

uses UThreadUtil, IOUtils, classes, SysUtils, Math, shellapi, SyncObjs, UFileSearch, IniFiles;

type

{$Region ' 文件 Job 信息 ' }

    // 父类
  TFileJobBase = class( TThreadJob )
  public
    ActionID : string;
    ControlPath : string;
  public
    constructor Create( _ActionID : string );
    procedure SetControlPath( _ControlPath : string );
    procedure Update;override;
  protected
    procedure BeforeAction;
    procedure ActionHandle;virtual;abstract;
    procedure AfterAction;
  private
    procedure RemoveToFace;
  end;

    // 文件父类
  TFileJob = class( TFileJobBase )
  public
    FilePath : string;
  public
    procedure SetFilePath( _FilePath : string );
  end;

    // 复制
  TFileCopyJob = class( TFileJob )
  public
    RemotePath : string;
  public
    procedure SetRemotePath( _RemotePath : string );
  protected
    procedure ActionHandle;override;
  private
    procedure ShowForm;
    procedure HideForm;
  private
    procedure AddToFace;
  end;

    // 删除
  TFileDeleteJob = class( TFileJob )
  protected
    procedure ActionHandle;override;
  private
    procedure AddToFace;
  end;

    // 压缩
  TFileZipJob = class( TFileJobBase )
  public
    FileList : TStringList;
    ZipPath : string;
  public
    procedure SetFileList( _FileList : TStringList );
    procedure SetZipPath( _ZipPath : string );
    destructor Destroy; override;
  protected
    procedure ActionHandle;override;
  private
    procedure ShowForm;
    procedure HideForm;
  private
    procedure AddToFace;
  end;

{$EndRegion}

{$Region ' Ftp 文件 Job ' }

    // 文件父类
  TFtpFileJob = class( TFileJobBase )
  public
    RemotePath : string;
  public
    procedure SetRemotePath( _RemotePath : string );
  end;

   // 新建目录
  TFtpNewFolderJob = class( TFtpFileJob )
  protected
    procedure ActionHandle;override;
  private
    procedure AddToFace;
  end;

    // 文件/目录 改名
  TFtpRenameJob = class( TFtpFileJob )
  private
    NewName : string;
  public
    procedure SetNewName( _NewName : string );
  protected
    procedure ActionHandle;override;
  private
    procedure AddToFace;
  end;

    // 删除Ftp文件
  TFtpDeleteFileJob = class( TFtpFileJob )
  protected
    procedure ActionHandle;override;
  private
    procedure RemoveToFace;
  end;

    // 删除Ftp目录
  TFtpDeleteFolderJob = class( TFtpFileJob )
  protected
    procedure ActionHandle;override;
  private
    procedure ShowForm;
    procedure HideForm;
  private
    procedure RemoveToFace;
  end;

    // Ftp 复制
  TFtpCopyFileJob = class( TFtpFileJob )
  public
    LocalPath : string;
    FileSize : Int64;
    IsFile : Boolean;
  public
    procedure SetLocalPath( _LocalPath : string );
    procedure SetFileSize( _FileSize : Int64 );
    procedure SetIsFile( _IsFile : Boolean );
  protected
    procedure ActionHandle;override;
  private
    procedure ShowForm;
    procedure HideForm;
  private
    procedure AddToFace;
  end;

{$EndRegion}

    // 复制参数
  TFileCopyParams = record
  public
    LocalPath, RemotePath : string;
    ControlPath, ActionID : string;
  end;

    // 压缩参数
  TFileZipParams = record
  public
    LocalPathList : TStringList;
    ZipPath : string;
    ControlPath, ActionID : string;
  end;

    // Ftp 复制参数
  TFtpFileCopyParams = record
  public
    ControlPath, RemotePath : string;
    LocalPath, ActionID : string;
    FileSize : Int64;
    IsFile : Boolean;
  end;

    // 文件任务处理器
  TMyFileJobHandler = class( TMyJobHandler )
  private
    RunningLock : TCriticalSection;
    RunningCount : Integer;
  private
    IsUserStop : Boolean;
  public
    constructor Create;
    destructor Destroy; override;
  public         // 本地文件操作
    procedure FleCopy( Params : TFileCopyParams );
    procedure FleDelete( LocalPath, ControlPath, ActionID : string );
    procedure FileZip( Params : TFileZipParams );
  public         // 网络文件操作
    procedure FtpNewFolder( ControlPath, FilePath, ActionID : string );
    procedure FtpRename( ControlPath, FilePath, NewName, ActionID : string );
    procedure FtpFileDelete( ControlPath, FilePath, ActionID : string );
    procedure FtpFolderDelete( ControlPath, FilePath, ActionID : string );
    procedure FtpCopy( Params : TFtpFileCopyParams );
  public
    procedure AddRuningCount;
    procedure RemoveRuningCount;
    function ReadIsRunning : Boolean;
  end;

var
  MyFileJobHandler : TMyFileJobHandler;

implementation

uses UMyUtils, UFrameDriver, UFormZip, UFtpUtils, UFormFtpDelete, UFormFtpCopy, UMainForm;

{ TFileMoveInfo }

procedure TFileJobBase.AfterAction;
begin
    // 正在运行
  MyFileJobHandler.RemoveRuningCount;
end;

procedure TFileJobBase.BeforeAction;
begin
    // 结束 Waiting
  FaceUpdate( RemoveToFace );
end;

constructor TFileJobBase.Create(_ActionID: string);
begin
  ActionID := _ActionID;
end;

procedure TFileJobBase.RemoveToFace;
begin
  FaceFileJobApi.RemoveFileJob( ActionID );
end;

procedure TFileJobBase.SetControlPath(_ControlPath: string);
begin
  ControlPath := _ControlPath;
end;


{ TFileCopyJob }

procedure TFileCopyJob.ActionHandle;
begin
    // 设置复制信息
  frmFtpCopy.SetCopyInfo( ControlPath, RemotePath, FilePath );

    // 显示复制窗口
  FaceUpdate( ShowForm );

    // 上传文件
  if FileExists( FilePath ) then
  begin
    if frmFtpCopy.UploadFile then
      FaceUpdate( AddToFace );
  end
  else  // 上传目录
  if frmFtpCopy.UploadFolder then
    FaceUpdate( AddToFace );

    // 用户取消操作
  if frmFtpCopy.ReadIsStop then
    MyFileJobHandler.IsUserStop := True;

    // 隐藏复制窗口
  FaceUpdate( HideForm );
end;

procedure TFileCopyJob.AddToFace;
var
  Params : TNetworkAddParams;
begin
  Params.ControlPath := ControlPath;
  Params.FilePath := RemotePath;
  Params.IsFile := FileExists( FilePath );
  Params.FileSize := MyFileInfo.getFileSize( FilePath );
  Params.FileTime := MyFileInfo.getFileTime( FilePath );
  UserNetworkDriverApi.AddFile( Params );
end;

procedure TFileCopyJob.HideForm;
begin
  frmFtpCopy.Close;
end;

procedure TFileCopyJob.SetRemotePath(_RemotePath: string);
begin
  RemotePath := _RemotePath;
end;

procedure TFileCopyJob.ShowForm;
begin
  frmFtpCopy.Show;
end;

{ TMyFileJobHandler }

procedure TMyFileJobHandler.FileZip(Params : TFileZipParams);
var
  FileZipJob : TFileZipJob;
begin
  AddRuningCount;

  FileZipJob := TFileZipJob.Create( Params.ActionID );
  FileZipJob.SetControlPath( Params.ControlPath );
  FileZipJob.SetFileList( Params.LocalPathList );
  FileZipJob.SetZipPath( Params.ZipPath );
  AddJob( FileZipJob );
end;

procedure TMyFileJobHandler.FleCopy( Params : TFileCopyParams );
var
  FileCopyJob : TFileCopyJob;
begin
  AddRuningCount;

  FileCopyJob := TFileCopyJob.Create( Params.ActionID );
  FileCopyJob.SetControlPath( Params.ControlPath );
  FileCopyJob.SetFilePath( Params.LocalPath );
  FileCopyJob.SetRemotePath( Params.RemotePath );
  AddJob( FileCopyJob );
end;

procedure TMyFileJobHandler.FleDelete(LocalPath, ControlPath, ActionID : string);
var
  FileDeleteJob : TFileDeleteJob;
begin
  AddRuningCount;

  FileDeleteJob := TFileDeleteJob.Create( ActionID );
  FileDeleteJob.SetControlPath( ControlPath );
  FileDeleteJob.SetFilePath( LocalPath );
  AddJob( FileDeleteJob );
end;

procedure TMyFileJobHandler.FtpCopy( Params : TFtpFileCopyParams );
var
  FtpCopyFileJob : TFtpCopyFileJob;
begin
  AddRuningCount;

  FtpCopyFileJob := TFtpCopyFileJob.Create( Params.ActionID );
  FtpCopyFileJob.SetControlPath( Params.ControlPath );
  FtpCopyFileJob.SetRemotePath( Params.RemotePath );
  FtpCopyFileJob.SetLocalPath( Params.LocalPath );
  FtpCopyFileJob.SetFileSize( Params.FileSize );
  FtpCopyFileJob.SetIsFile( Params.IsFile );
  AddJob( FtpCopyFileJob );
end;

procedure TMyFileJobHandler.FtpFileDelete(ControlPath, FilePath,
  ActionID: string);
var
  FtpDeleteFileJob : TFtpDeleteFileJob;
begin
  AddRuningCount;

  FtpDeleteFileJob := TFtpDeleteFileJob.Create( ActionID );
  FtpDeleteFileJob.SetControlPath( ControlPath );
  FtpDeleteFileJob.SetRemotePath( FilePath );
  AddJob( FtpDeleteFileJob );
end;

procedure TMyFileJobHandler.FtpFolderDelete(ControlPath, FilePath,
  ActionID: string);
var
  FtpDeleteFolderJob : TFtpDeleteFolderJob;
begin
  AddRuningCount;

  FtpDeleteFolderJob := TFtpDeleteFolderJob.Create( ActionID );
  FtpDeleteFolderJob.SetControlPath( ControlPath );
  FtpDeleteFolderJob.SetRemotePath( FilePath );
  AddJob( FtpDeleteFolderJob );
end;

procedure TMyFileJobHandler.AddRuningCount;
begin
  RunningLock.Enter;
  Inc( RunningCount );
  RunningLock.Leave;
end;

constructor TMyFileJobHandler.Create;
begin
  inherited;
  RunningLock := TCriticalSection.Create;
  RunningCount := 0;
  IsUserStop := False;
end;

destructor TMyFileJobHandler.Destroy;
begin
  RunningLock.Free;
  inherited;
end;

procedure TMyFileJobHandler.FtpNewFolder(ControlPath, FilePath, ActionID: string);
var
  FolderNewJob : TFtpNewFolderJob;
begin
  AddRuningCount;

  FolderNewJob := TFtpNewFolderJob.Create( ActionID );
  FolderNewJob.SetControlPath( ControlPath );
  FolderNewJob.SetRemotePath( FilePath );
  AddJob( FolderNewJob );
end;

function TMyFileJobHandler.ReadIsRunning: Boolean;
begin
  RunningLock.Enter;
  Result := RunningCount > 0;
  RunningLock.Leave;
end;

procedure TMyFileJobHandler.RemoveRuningCount;
begin
  RunningLock.Enter;
  Dec( RunningCount );
  RunningLock.Leave;

    // Reset
  if RunningCount <= 0 then
    IsUserStop := False;
end;

procedure TMyFileJobHandler.FtpRename(ControlPath, FilePath, NewName,
  ActionID: string);
var
  FileRenameJob : TFtpRenameJob;
begin
  AddRuningCount;

  FileRenameJob := TFtpRenameJob.Create( ActionID );
  FileRenameJob.SetControlPath( ControlPath );
  FileRenameJob.SetRemotePath( FilePath );
  FileRenameJob.SetNewName( NewName );
  AddJob( FileRenameJob );
end;

procedure TFileJobBase.Update;
begin
    // 操作前
  BeforeAction;

  try   // 实际操作
    if not MyFileJobHandler.IsUserStop then
      ActionHandle;
  except
  end;

    // 操作后
  AfterAction;
end;

{ TFileDeleteJob }

procedure TFileDeleteJob.ActionHandle;
begin
  if MyShellFile.DeleteFile( FilePath ) then
    FaceUpdate( AddToFace )
  else
    MyFileJobHandler.IsUserStop := True;
end;

procedure TFileDeleteJob.AddToFace;
begin
  UserLocalDriverApi.RemoveFile( ControlPath, FilePath )
end;

{ TFileJob }

procedure TFileJob.SetFilePath(_FilePath: string);
begin
  FilePath := _FilePath;
end;

{ TFileZipBaseJob }

procedure TFileZipJob.ActionHandle;
begin
  FaceUpdate( ShowForm );

  frmZip.SetFileList( FileList );
  frmZip.SetZipPath( ZipPath );
  if frmZip.FileZip then
    FaceUpdate( AddToFace )
  else  // 压缩失败，删除压缩文件
    MyShellFile.DeleteFile( ZipPath );

  FaceUpdate( HideForm );
end;

procedure TFileZipJob.AddToFace;
begin
  UserLocalDriverApi.CancelSelect( ControlPath );
  UserLocalDriverApi.AddFile( ControlPath, ZipPath );
end;

destructor TFileZipJob.Destroy;
begin
  FileList.Free;
  inherited;
end;

procedure TFileZipJob.HideForm;
begin
  frmZip.Close;
end;

procedure TFileZipJob.SetFileList(_FileList: TStringList);
begin
  FileList := _FileList;
end;

procedure TFileZipJob.SetZipPath(_ZipPath: string);
begin
  ZipPath := _ZipPath;
end;

procedure TFileZipJob.ShowForm;
begin
  frmZip.Show;
end;


{ TFolderNewJob }

procedure TFtpNewFolderJob.ActionHandle;
begin
  if MyFtpFileHandler.NewFolder( ControlPath, RemotePath ) then
    FaceUpdate( AddToFace );
end;

procedure TFtpNewFolderJob.AddToFace;
var
  Params : TNetworkAddParams;
begin
  Params.ControlPath := ControlPath;
  Params.FilePath := RemotePath;
  Params.IsFile := False;
  Params.FileTime := Now;
  UserNetworkDriverApi.AddFile( Params );
end;

{ TFileRenameJob }

procedure TFtpRenameJob.ActionHandle;
begin
  if MyFtpFileHandler.Rename( ControlPath, RemotePath, NewName ) then
    FaceUpdate( AddToFace );
end;

procedure TFtpRenameJob.AddToFace;
var
  Params : TNetworkAddParams;
begin
  Params.ControlPath := ControlPath;
  Params.FilePath := MyFilePath.getFtpPath( MyFilePath.getFtpDir( RemotePath ) ) + NewName;
  Params.IsFile := UserNetworkDriverApi.ReadIsFile( ControlPath, RemotePath );
  Params.FileSize := UserNetworkDriverApi.ReadFileSize( ControlPath, RemotePath );
  Params.FileTime := UserNetworkDriverApi.ReadFileTime( ControlPath, RemotePath );

  UserNetworkDriverApi.RemoveFile( ControlPath, RemotePath );
  UserNetworkDriverApi.AddFile( Params );
end;

procedure TFtpRenameJob.SetNewName(_NewName: string);
begin
  NewName := _NewName;
end;

{ TFtpDeleteFileJob }

procedure TFtpDeleteFileJob.ActionHandle;
begin
  if MyFtpFileHandler.DeleteFile( ControlPath, RemotePath ) then
    FaceUpdate( RemoveToFace );
end;

procedure TFtpDeleteFileJob.RemoveToFace;
begin
  UserNetworkDriverApi.RemoveFile( ControlPath, RemotePath );
end;

{ TFtpDeleteFolderJob }

procedure TFtpDeleteFolderJob.ActionHandle;
begin
    // 设置删除属性
  frmFtpDelete.SetDeleteInfo( ControlPath, RemotePath );

    // 显示删除窗口
  FaceUpdate( ShowForm );

    // 删除目录
  if frmFtpDelete.FolderDelete then
    FaceUpdate( RemoveToFace );

    // 用户取消操作
  if frmFtpDelete.ReadIsStop then
    MyFileJobHandler.IsUserStop := True;

    // 隐藏删除窗口
  FaceUpdate( HideForm );
end;

procedure TFtpDeleteFolderJob.RemoveToFace;
begin
  UserNetworkDriverApi.RemoveFile( ControlPath, RemotePath );
end;

procedure TFtpDeleteFolderJob.HideForm;
begin
  frmFtpDelete.Close;
end;

procedure TFtpDeleteFolderJob.ShowForm;
begin
  frmFtpDelete.Show;
end;

{ TFtpCopyFileJob }

procedure TFtpCopyFileJob.ActionHandle;
begin
    // 设置复制信息
  frmFtpCopy.SetCopyInfo( ControlPath, RemotePath, LocalPath );
  frmFtpCopy.SetDownloadSize( FileSize );

    // 显示复制窗口
  FaceUpdate( ShowForm );

    // 上传文件
  if IsFile then
  begin
    if frmFtpCopy.DownloadFile then
      FaceUpdate( AddToFace );
  end
  else
  if frmFtpCopy.DownloadFolder then
    FaceUpdate( AddToFace );

    // 用户取消操作
  if frmFtpCopy.ReadIsStop then
    MyFileJobHandler.IsUserStop := True;

    // 隐藏复制窗口
  FaceUpdate( HideForm );
end;

procedure TFtpCopyFileJob.AddToFace;
begin
  UserLocalDriverApi.AddFile( ControlPath, LocalPath );
end;

procedure TFtpCopyFileJob.HideForm;
begin
  frmFtpCopy.Close;
end;

procedure TFtpCopyFileJob.SetFileSize(_FileSize: Int64);
begin
  FileSize := _FileSize;
end;

procedure TFtpCopyFileJob.SetIsFile(_IsFile: Boolean);
begin
  IsFile := _IsFile;
end;

procedure TFtpCopyFileJob.SetLocalPath(_LocalPath: string);
begin
  LocalPath := _LocalPath;
end;

procedure TFtpCopyFileJob.ShowForm;
begin
  frmFtpCopy.Show;
end;

{ TFtpFileJob }

procedure TFtpFileJob.SetRemotePath(_RemotePath: string);
begin
  RemotePath := _RemotePath;
end;

end.
