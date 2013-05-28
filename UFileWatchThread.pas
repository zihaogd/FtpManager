unit UFileWatchThread;

interface

uses classes, dirnotify, ExtCtrls;

type
    // 文件监听对象
  TMyFileWatch = class
  public
    ControlPath, LocalPath : string;
    IsStop : Boolean;
  public
    LocalDirNotify : TDirNotify;  // 目录监听器
    Timer : TTimer;
  public
    constructor Create;
    procedure Stop;
  public
    procedure SetPath( _ControlPath, _LocalPath : string );
    procedure SetLocalPath( _LocalPath : string );
  private
    procedure LocalFolderChange(Sender: TObject);
    procedure OnTime( Sender: TObject );
  end;

var
  MyFileWatch : TMyFileWatch;

implementation

uses UMyUtils, SysUtils, UMyFaceThread;

{ TMyFileWatch }

constructor TMyFileWatch.Create;
begin
  LocalDirNotify := TDirNotify.Create( nil );
  LocalDirNotify.OnChange := LocalFolderChange;
  Timer := TTimer.Create( nil );
  Timer.Enabled := False;
  Timer.Interval := 1000;
  Timer.OnTimer := OnTime;
  IsStop := False;
end;

procedure TMyFileWatch.LocalFolderChange(Sender: TObject);
begin
  Timer.Enabled := False;
  Timer.Enabled := True;
end;

procedure TMyFileWatch.OnTime(Sender: TObject);
begin
  if LocalPath <> '' then
    MyFaceJobHandler.FileChange( ControlPath, LocalPath, True );
end;

procedure TMyFileWatch.SetLocalPath(_LocalPath: string);
begin
  if IsStop then
    Exit;

  LocalPath := _LocalPath;

TThread.CreateAnonymousThread(
procedure
begin
  if ( LocalPath <> '' ) and MyFilePath.getIsFixedDriver( ExtractFileDrive( LocalPath ) ) then
  begin
    LocalDirNotify.Path := LocalPath;
    LocalDirNotify.Enabled := True;
  end
  else
    LocalDirNotify.Enabled := False
end).Start;
end;

procedure TMyFileWatch.SetPath(_ControlPath, _LocalPath : string);
begin
  if IsStop then
    Exit;
  ControlPath := _ControlPath;
  SetLocalPath( _LocalPath );
end;

procedure TMyFileWatch.Stop;
begin
  IsStop := True;
  Timer.Enabled := False;
  LocalDirNotify.Free;
  Timer.Free;
end;

end.
