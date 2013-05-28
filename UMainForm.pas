unit UMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ImgList, Vcl.ExtCtrls,
  Vcl.Buttons, RzTabs, UFrameDriverBtn, IniFiles, Vcl.Menus, auHTTP, shellapi,
  auAutoUpgrader, idhttp;

const
  hfck_Index = wm_user + $1000;
  hfck_Name = 'FtpManager';

type
  TfrmMain = class(TForm)
    ilFile16: TImageList;
    plMain: TPanel;
    plToolBar: TPanel;
    sbAddDriver: TSpeedButton;
    PcMain: TRzPageControl;
    plCenter: TPanel;
    Panel1: TPanel;
    ilDriver: TImage;
    tiApp: TTrayIcon;
    pmTrayIcon: TPopupMenu;
    Exit1: TMenuItem;
    About1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    miCloseHide: TMenuItem;
    miCloseExit: TMenuItem;
    ilMainForm: TImageList;
    auMain: TauAutoUpgrader;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbAddDriverClick(Sender: TObject);
    procedure miCloseExitClick(Sender: TObject);
    procedure miCloseHideClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tiAppClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    procedure WMQueryEndSession(var Message: TMessage);message WM_QUERYENDSESSION;
    procedure createparams(var params: tcreateparams); override;
    procedure restorerequest(var Msg: TMessage); message hfck_Index;
    procedure DropFiles(var Msg: TMessage); message WM_DROPFILES;
  private
    IsAppExit, IsHideApp : Boolean;
    procedure ShowMainForm;
    procedure HideMainForm;
  private
    procedure LoadIni;
    procedure SaveIni;
  private
    procedure MainFormIni;
    procedure MainFormUnini;
    procedure CreateAppDataDir;
    procedure SavePicture;
  public
    procedure AppStart;
  end;

{$Region ' ��������ʱ ' }

    // ��¼������Ϣ ���� ������԰�
  TAppRunMarkHandle = class
  public
    procedure Update;
  private
    procedure AppRunMark;
  end;

    // PcID
  MyComputerID = class
  public
    class function get : string;
  private
    class function getNewPcID : string;
    class function Read : string;
    class procedure Save( PcID : string );
  end;

{$EndRegion}

{$Region ' ���� �ӿ� ' }

    // ���� ToolBar
  TFacePageButtonApi = class
  public
    plToolBar : TPanel;
  public
    constructor Create;
  public
    function ReadIsExist( DriverPath : string ): Boolean;
    procedure Add( DriverPath : string );
    procedure Enter( DriverPath : string );
    procedure Remove( DriverPath : string );
  public
    function ReadDriverList : TStringList;
    function ReadSelectDriver : string;
  private
    function ReadButton( DriverPath : string ): TSpeedButton;
    procedure SbButtonClick( Sender : TObject );
    procedure SbButtonRightMouse(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
  end;

    // ����ҳ��
  TFacePageDriverApi = class
  private
    PcMain : TRzPageControl;
  private
    LastControlPath : string;
  public
    constructor Create;
  public
    function ReadIsExist( DriverPath : string ): Boolean;
    procedure Add( DriverPath : string );
    function Enter( DriverPath : string ): Boolean;  // �����Ƿ���Ҫ��ʼ��
    procedure Remove( DriverPath : string );
  public
    function ControlPage( DriverPath : string ): Boolean;
  private
    function ReadPage( DriverPath : string ): TRzTabSheet;
  end;

{$EndRegion}

{$Region ' �û� ���� ' }

    // ������ť
  UserPageButtonApi = class
  public
    class procedure AddDriver( DriverPath : string );
    class procedure SelectDriver( DriverPath : string );
    class procedure RemoveDriver( DriverPath : string );
  end;

    // ����ҳ��
  UserPageDriverApi = class
  public
    class procedure AddDriver( DriverPath : string );
    class procedure SelectDriver( DriverPath : string );
    class procedure RemoveDriver( DriverPath : string );
  public
    class procedure RefreshDriver( DriverPath : string );
  end;

{$EndRegion}

{$Region ' �ļ��϶� ' }

    // �϶��ļ�
  TDropFilesHandle = class
  public
    Msg: TMessage;
    FileList : TStringList;
  public
    constructor Create( _Msg: TMessage );
    procedure Update;
    destructor Destroy; override;
  end;

{$EndRegion}

{$Region ' �رճ��� ' }

    // ǿ�йرճ���
  TStopAppThread = class( TThread )
  public
    constructor Create;
    destructor Destroy; override;
  protected
    procedure Execute; override;
  end;

{$EndRegion}


const
  Ini_MainForm = 'MainForm';
  Ini_ShareCount = 'ShareCount';
  Ini_SharePath = 'SharePath';
  Ini_MainFormWidth = 'MainFormWidth';
  Ini_MainFormHeigh = 'MainFormHeigh';
  Ini_MainFormHide = 'MainFormHide';
  Ini_SelectPath = 'SelectPath';

  Ini_App = 'App';
  Ini_AppPcID = 'AppPcID';

const
  MarkApp_PcID = 'PcID';
  MarkApp_Edition = 'Edition';

var
  FacePageButtonApi : TFacePageButtonApi;
  FacePageDriverApi : TFacePageDriverApi;

var
  frmMain: TfrmMain;

implementation

uses UFormSelectShare, UMyUtils, UFrameDriver, UMyFaceThread, UFileThread, UFormShareManage,
     UFileWatchThread, UFormAbout, UMyUrl, UFormSelectFtp, UFtpUtils;

{$R *.dfm}

procedure TfrmMain.About1Click(Sender: TObject);
begin
  frmAbout.Show;
end;

procedure TfrmMain.AppStart;
var
  i: Integer;
  AppRunMarkHandle : TAppRunMarkHandle;
begin
try
    // �л�����ͼ��λ��
  for i := 0 to plToolBar.ControlCount - 1 do
    plToolBar.Controls[i].Left := 10000 - ( i * 100 );

    // ��¼������Ϣ
  AppRunMarkHandle := TAppRunMarkHandle.Create;
  AppRunMarkHandle.Update;
  AppRunMarkHandle.Free;
except
end;
end;

procedure TfrmMain.CreateAppDataDir;
begin
  try
    ForceDirectories( MyAppData.getLoginPath );
    ForceDirectories( MyAppData.getIconFolderPath );
    ForceDirectories( MyAppData.getIconPicturePath );
  except
  end;
end;

procedure TfrmMain.createparams(var params: tcreateparams);
begin
  try
    inherited createparams(params);
    params.WinClassName := hfck_Name;
  except
  end;
end;

procedure TfrmMain.DropFiles(var Msg: TMessage);
var
  DropFilesHandle : TDropFilesHandle;
begin
  DropFilesHandle := TDropFilesHandle.Create( Msg );
  DropFilesHandle.Update;
  DropFilesHandle.Free;
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  IsAppExit := True;
  Close;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := IsAppExit or not IsHideApp;
  if not CanClose then
    HideMainForm;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  MainFormIni;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  MainFormUnini;
end;

procedure TfrmMain.HideMainForm;
begin
  ShowWindow(Self.Handle, SW_HIDE);
end;

procedure TfrmMain.LoadIni;
var
  IniFile : TIniFile;
  ShareCount, i: Integer;
  SharePath : string;
begin
  IniFile := TIniFile.Create( MyAppData.getConfigPath );

  try
    // ��ȡ Ftp ����
  MyFtpFileHandler.LoadIni( IniFile );
  MyFtpFaceHandler.LoadIni( IniFile );

    // ��ȡ���й���Ŀ¼
  ShareCount := IniFile.ReadInteger( Ini_MainForm, Ini_ShareCount, 0 );
  for i := 0 to ShareCount - 1 do
  begin
    SharePath := IniFile.ReadString( Ini_MainForm, Ini_SharePath + IntToStr(i), '' );
    if SharePath = '' then
      Continue;
    UserPageButtonApi.AddDriver( SharePath );
    UserFrameDriverApi.LoadIni( SharePath, IniFile, i );
  end;

    // ��ȡ����·��
  SharePath := IniFile.ReadString( Ini_MainForm, Ini_SelectPath, '' );
  if SharePath <> '' then
    UserPageButtonApi.SelectDriver( SharePath );

    // ��ȡ������Ϣ
  Self.Width := IniFile.ReadInteger( Ini_MainForm, Ini_MainFormWidth, Self.Width );
  Self.Height := IniFile.ReadInteger( Ini_MainForm, Ini_MainFormHeigh, Self.Height );

    // �Ƿ����ش���
  IsHideApp := IniFile.ReadBool( Ini_MainForm, Ini_MainFormHide, False );
  miCloseHide.Checked := IsHideApp;
  miCloseExit.Checked := not IsHideApp;
  except
  end;

  IniFile.Free;
end;

procedure TfrmMain.MainFormIni;
begin
  CreateAppDataDir;
  SavePicture;

  MyIcon := TMyIcon.Create;
  My16IconUtil.Set16IconName( ilFile16 );

  FacePageButtonApi := TFacePageButtonApi.Create;
  FacePageDriverApi := TFacePageDriverApi.Create;
  FaceFrameDriverApi := TFaceFrameDriverApi.Create;
  FaceLocalDriverApi := TFaceLocalDriverApi.Create;
  FaceNetworkDriverApi := TFaceNetworkDriverApi.Create;
  FaceLocalStatusApi := TFaceLocalStatusApi.Create;
  FaceNetworkStatusApi := TFaceNetworkStatusApi.Create;
  FaceFileJobApi := TFaceFileJobApi.Create;
  FaceLocalHistoryApi := TFaceLocalHistoryApi.Create;

  MyFaceJobHandler := TMyFaceJobHandler.Create;
  MyFileJobHandler := TMyFileJobHandler.Create;
  MyFileWatch := TMyFileWatch.Create;
  MyFtpFileHandler := TMyFtpHandler.Create;
  MyFtpFaceHandler := TMyFtpHandler.Create;

    // �Ϸ��ļ���Ϣ
  DragAcceptFiles(Handle, True);

  LoadIni;

  IsAppExit := False;
end;

procedure TfrmMain.MainFormUnini;
var
  StopAppThread : TStopAppThread;
begin
try
  StopAppThread := TStopAppThread.Create;
  StopAppThread.Resume;

  SaveIni;

  MyFileWatch.Stop;
  MyFaceJobHandler.Stop;
  MyFileJobHandler.Stop;
  MyFtpFileHandler.Stop;
  MyFtpFaceHandler.Stop;

  FaceLocalHistoryApi.Free;
  FaceFileJobApi.Free;
  FaceNetworkStatusApi.Free;
  FaceLocalStatusApi.Free;
  FaceLocalDriverApi.Free;
  FaceNetworkDriverApi.Free;
  FaceFrameDriverApi.Free;
  FacePageDriverApi.Free;
  FacePageButtonApi.Free;
  MyIcon.Free;

  MyFileWatch.Free;
  MyFileJobHandler.Free;
  MyFaceJobHandler.Free;
  MyFtpFileHandler.Free;
  MyFtpFaceHandler.Free;

  StopAppThread.Free;
except
end;
end;

procedure TfrmMain.miCloseExitClick(Sender: TObject);
begin
  IsHideApp := False;
  miCloseHide.Checked := False;
  miCloseExit.Checked := True;
end;


procedure TfrmMain.miCloseHideClick(Sender: TObject);
begin
  IsHideApp := True;
  miCloseExit.Checked := False;
  miCloseHide.Checked := True;
end;

procedure TfrmMain.N1Click(Sender: TObject);
begin
  auMain.CheckUpdate;
end;

procedure TfrmMain.restorerequest(var Msg: TMessage);
begin
  try
    if not IsAppExit then
      ShowMainForm;
  except
  end;
end;

procedure TfrmMain.SaveIni;
var
  IniFile : TIniFile;
  i : Integer;
  DriverList : TStringList;
  SharePath : string;
begin
  IniFile := TIniFile.Create( MyAppData.getConfigPath );

  try
    // ���� Ftp ����
  MyFtpFileHandler.SaveIni( IniFile );

    // �����������б�
  DriverList := FacePageButtonApi.ReadDriverList;
  IniFile.WriteInteger( Ini_MainForm, Ini_ShareCount, DriverList.Count );
  for i := 0 to DriverList.Count - 1 do
  begin
    SharePath := DriverList[i];
    IniFile.WriteString( Ini_MainForm, Ini_SharePath + IntToStr(i), SharePath );
    UserFrameDriverApi.SaveIni( SharePath, IniFile, i );
  end;
  DriverList.Free;

    // ��ǰѡ���·��
  IniFile.WriteString( Ini_MainForm, Ini_SelectPath, FacePageButtonApi.ReadSelectDriver );

    // ������Ϣ
  IniFile.WriteInteger( Ini_MainForm, Ini_MainFormWidth, Self.Width );
  IniFile.WriteInteger( Ini_MainForm, Ini_MainFormHeigh, Self.Height );
  IniFile.WriteBool( Ini_MainForm, Ini_MainFormHide, Self.IsHideApp );
  except
  end;

  IniFile.Free;
end;


procedure TfrmMain.SavePicture;
var
  FilePath : string;
begin
  FilePath := MyAppData.getNetworkDriver;
  if FileExists( FilePath ) then
    Exit;
  ilDriver.Picture.SaveToFile( FilePath );
end;

procedure TfrmMain.sbAddDriverClick(Sender: TObject);
var
  FtpHost : string;
begin
  if not frmSelectFtp.NewFtp then
    Exit;
  FtpHost := frmSelectFtp.ReadFtpHost;
  UserPageButtonApi.AddDriver( FtpHost );
  UserPageButtonApi.SelectDriver( FtpHost );
end;


procedure TfrmMain.ShowMainForm;
begin
  if not Self.Visible then
    Self.Visible := True;
  ShowWindow(Self.Handle, SW_RESTORE);
  SetForegroundWindow(Self.Handle);
end;

procedure TfrmMain.tiAppClick(Sender: TObject);
begin
  if not IsAppExit then
    ShowMainForm;
end;

procedure TfrmMain.WMQueryEndSession(var Message: TMessage);
begin
  try
    SaveIni;
    Message.Result := 1;
  except
  end;
end;

{ TFacePageDriverApi }

procedure TFacePageDriverApi.Add(DriverPath: string);
var
  NewPage : TRzTabSheet;
  FrameDriver : TFrameDriver;
begin
  NewPage := TRzTabSheet.Create( PcMain );
  NewPage.Parent := PcMain;
  NewPage.PageControl := PcMain;
  NewPage.Hint := DriverPath;
  NewPage.TabVisible := False;
  NewPage.Tag := 0;

  FrameDriver := TFrameDriver.Create( NewPage );
  FrameDriver.Parent := NewPage;
  FrameDriver.IniFrame;
  FrameDriver.SetControlPath( DriverPath );
  FrameDriver.SetLocalPath( '' );
  FrameDriver.SetNetworkPath( Path_FtpRoot );
end;

function TFacePageDriverApi.ControlPage(DriverPath: string): Boolean;
var
  Page : TRzTabSheet;
  i : Integer;
  c : TControl;
  f : TFrameDriver;
begin
    // ��ѡ��
  if DriverPath = LastControlPath then
  begin
    Result := True;
    Exit;
  end;

    // ����
  Result := False;
  Page := ReadPage( DriverPath );
  if not Assigned( Page ) then
    Exit;
  for i := 0 to Page.ControlCount - 1 do
  begin
    c := Page.Controls[i];
    if c is TFrameDriver then
    begin
      f := c as TFrameDriver;
      FaceFrameDriverApi.Activate( f );
      LastControlPath := DriverPath;
      Result := True;
    end;
  end;
end;

constructor TFacePageDriverApi.Create;
begin
  PcMain := frmMain.PcMain;
  LastControlPath := '';
end;

function TFacePageDriverApi.Enter(DriverPath: string): Boolean;
var
  Page : TRzTabSheet;
begin
  Result := False;
  Page := ReadPage( DriverPath );
  if Assigned( Page ) then
  begin
    PcMain.ActivePage := Page;
    if Page.Tag <> 0 then // �Ѿ���ʼ��
      Exit;
    Page.Tag := 1;
    Result := True;
  end;
end;

function TFacePageDriverApi.ReadIsExist(DriverPath: string): Boolean;
begin
  Result := Assigned( ReadPage( DriverPath ) );
end;

function TFacePageDriverApi.ReadPage(DriverPath: string): TRzTabSheet;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to PcMain.PageCount - 1 do
    if PcMain.Pages[i].Hint = DriverPath then
    begin
      Result := PcMain.Pages[i];
      Break;
    end;
end;

procedure TFacePageDriverApi.Remove(DriverPath: string);
var
  PageIndex : Integer;
  Page : TRzTabSheet;
begin
    // ɾ����ҳ���ǿ���ҳ��
  if LastControlPath = DriverPath then
    LastControlPath := '';

    // ��ȡҳ��
  Page := ReadPage( DriverPath );
  if not Assigned( Page ) then
    Exit;
  if ( PcMain.ActivePage = Page ) and ( PcMain.PageCount > 1 ) then  // ɾ��ҳ���л�
  begin
    if PcMain.ActivePageIndex = ( PcMain.PageCount - 1 ) then
      PageIndex := PcMain.ActivePageIndex - 1
    else
      PageIndex := PcMain.ActivePageIndex + 1;
    if ( PageIndex >= 0 ) and ( PageIndex < PcMain.PageCount ) then
      UserPageButtonApi.SelectDriver( PcMain.Pages[ PageIndex ].Hint ); // ҳ����ת
  end;
  Page.Free;
end;

{ TFacePageButtonApi }

procedure TFacePageButtonApi.Add(DriverPath: string);
var
  sbDriver : TSpeedButton;
  FileName : string;
begin
  FileName := ExtractFileName( DriverPath );
  if Length( FileName ) > 12 then
    FileName := copy( FileName, 1, 10 ) + '...';

  sbDriver := TSpeedButton.Create( plToolBar );
  sbDriver.Parent := plToolBar;
  sbDriver.Align := alLeft;
  sbDriver.Width := 85;
  sbDriver.Layout := blGlyphTop;
  sbDriver.Caption := FileName;
  sbDriver.Hint := DriverPath;
  sbDriver.ShowHint := True;
  sbDriver.GroupIndex := 1;
  sbDriver.Glyph.LoadFromFile( MyAppData.getNetworkDriver );
  sbDriver.OnClick := SbButtonClick;
  sbDriver.OnMouseDown := SbButtonRightMouse;
end;

constructor TFacePageButtonApi.Create;
begin
  plToolBar := frmMain.plToolBar;
end;

procedure TFacePageButtonApi.Enter(DriverPath: string);
var
  sbDriver : TSpeedButton;
begin
  sbDriver := ReadButton( DriverPath );
  if Assigned( sbDriver ) then
    sbDriver.Down := True;
end;

function TFacePageButtonApi.ReadButton(DriverPath: string): TSpeedButton;
var
  i: Integer;
  c : TControl;
  sbDriver : TSpeedButton;
begin
  Result := nil;
  for i := 0 to plToolBar.ControlCount - 1 do
  begin
    c := plToolBar.Controls[i];
    if not ( c is TSpeedButton ) then
      Continue;
    sbDriver := c as TSpeedButton;
    if sbDriver.Hint = DriverPath then
    begin
      Result := sbDriver;
      Break;
    end;
  end;
end;

function TFacePageButtonApi.ReadDriverList: TStringList;
var
  i: Integer;
  c : TControl;
  sbDriver : TSpeedButton;
begin
  Result := TStringList.Create;
  for i := 0 to plToolBar.ControlCount - 1 do
  begin
    c := plToolBar.Controls[i];
    if not ( c is TSpeedButton ) then
      Continue;
    sbDriver := c as TSpeedButton;
    if sbDriver.Tag = 1 then  // ��Ӱ�ť
      Continue;
    Result.Add( sbDriver.Hint );
  end;
end;

function TFacePageButtonApi.ReadIsExist(DriverPath: string): Boolean;
begin
  Result := Assigned( ReadButton( DriverPath ) );
end;

function TFacePageButtonApi.ReadSelectDriver: string;
var
  i: Integer;
  c : TControl;
  sbDriver : TSpeedButton;
begin
  Result := '';
  for i := 0 to plToolBar.ControlCount - 1 do
  begin
    c := plToolBar.Controls[i];
    if not ( c is TSpeedButton ) then
      Continue;
    sbDriver := c as TSpeedButton;
    if sbDriver.Down then
    begin
      Result := sbDriver.Hint;
      Break;
    end;
  end;
end;

procedure TFacePageButtonApi.Remove(DriverPath: string);
var
  sbDriver : TSpeedButton;
begin
  sbDriver := ReadButton( DriverPath );
  if Assigned( sbDriver ) then
    sbDriver.Free;
end;


procedure TFacePageButtonApi.SbButtonClick(Sender: TObject);
var
  sbDriver : TSpeedButton;
begin
  if not ( Sender is TSpeedButton ) then
    Exit;
  sbDriver := Sender as TSpeedButton;
  UserPageButtonApi.SelectDriver( sbDriver.Hint );
end;

procedure TFacePageButtonApi.SbButtonRightMouse(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  DriverList : TStringList;
  i: Integer;
begin
  if Button <> mbRight then
    Exit;

    // ��վ���Ϣ
  frmShareManger.ClearFolders;

    // ��ӵ�ǰ��Ϣ
  DriverList := FacePageButtonApi.ReadDriverList;
  for i := 0 to DriverList.Count - 1 do
    frmShareManger.AddFolder( DriverList[i] );
  DriverList.Free;

    // ȷ��ɾ��
  if not frmShareManger.ReadDelete then
    Exit;

    // ɾ���б�
  DriverList := frmShareManger.ReadPathList;
  for i := 0 to DriverList.Count - 1 do
    UserPageButtonApi.RemoveDriver( DriverList[i] );
  DriverList.Free;
end;

{ UserPageButtonApi }

class procedure UserPageButtonApi.AddDriver(DriverPath: string);
begin
    // ��� ToolButton
  if not FacePageButtonApi.ReadIsExist( DriverPath ) then
    FacePageButtonApi.Add( DriverPath );

    // ���ҳ��
  UserPageDriverApi.AddDriver( DriverPath );
end;

class procedure UserPageButtonApi.RemoveDriver(DriverPath: string);
begin
    // ɾ����ť
  FacePageButtonApi.Remove( DriverPath );

    // ɾ��ҳ��
  UserPageDriverApi.RemoveDriver( DriverPath );
end;

class procedure UserPageButtonApi.SelectDriver(DriverPath: string);
begin
    // ѡ�� ToolButton
  FacePageButtonApi.Enter( DriverPath );

    // ѡ��ҳ��
  UserPageDriverApi.SelectDriver( DriverPath );
end;

{ UserPageDriverApi }

class procedure UserPageDriverApi.AddDriver(DriverPath: string);
begin
    // ҳ���Ѵ���
  if not FacePageDriverApi.ReadIsExist( DriverPath ) then
    FacePageDriverApi.Add( DriverPath );
end;

class procedure UserPageDriverApi.RefreshDriver(DriverPath: string);
begin
    // ����ҳ��
  UserLocalDriverApi.RefreshFolder( DriverPath );
  UserNetworkDriverApi.RefreshFolder( DriverPath );
end;

class procedure UserPageDriverApi.RemoveDriver(DriverPath: string);
begin
  FacePageDriverApi.Remove( DriverPath );
end;

class procedure UserPageDriverApi.SelectDriver(DriverPath: string);
var
  IsRefresh : Boolean;
begin
    // ����ҳ��
  IsRefresh := FacePageDriverApi.Enter( DriverPath );

    // ˢ��ҳ��
  UserFrameDriverApi.SelectFrame( DriverPath );

    // ˢ�±���Ŀ¼��Ϣ
  UserLocalDriverApi.RefreshFolder( DriverPath );

    // ������Ҫ��ʼ��Ftp�ļ���Ϣ
  if IsRefresh then
    UserNetworkDriverApi.RefreshFolder( DriverPath );
end;

{ MyComputerID }

class function MyComputerID.get: string;
begin
    // ��ȡ PcID
  Result := Read;

    // ��ȡ �ɹ�
  if Result <> '' then
    Exit;

    // �½�һ�� PcID
  Result := getNewPcID;

    // ���� PcID
  Save( Result );
end;

class function MyComputerID.getNewPcID: string;
var
  PcID, s : string;
  i : Integer;
  n : Integer;
  c : Char;
begin
  PcID := '';
  Randomize;
  for i := 1 to 8 do
  begin
    n := Random( 36 );
    if n < 10 then
      s := IntToStr( n )
    else
    begin
      n := n - 10 + 65;
      c := Char(n);
      s := c;
    end;
    PcID := PcID + s;
  end;
  Result := PcID;
end;

class function MyComputerID.Read: string;
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create( MyAppData.getConfigPath );
  try
    Result := IniFile.ReadString( Ini_App, Ini_AppPcID, '' );
  except
  end;
  IniFile.Free;
end;

class procedure MyComputerID.Save(PcID: string);
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create( MyAppData.getConfigPath );
  try
    IniFile.WriteString( Ini_App, Ini_AppPcID, PcID );
  except
  end;
  IniFile.Free;
end;

{ TAppLanguageEditionCheck }

procedure TAppRunMarkHandle.AppRunMark;
var
  PcID, EditionStr : string;
  HttpMark : TIdHTTP;
  Params : TStringList;
begin
  PcID := MyComputerID.get;
  EditionStr := 'FtpManager';
  Params := TStringList.Create;
  Params.Add( MarkApp_PcID + '=' + PcID );
  Params.Add( MarkApp_Edition + '=' + EditionStr );
  HttpMark := TIdHTTP.Create( nil );
  HttpMark.HandleRedirects := True;
  HttpMark.ConnectTimeout := 60000;
  HttpMark.ReadTimeout := 60000;
  try
    HttpMark.Post( Url_MarkApp, Params );
  except
  end;
  HttpMark.Free;
  Params.Free;
end;

procedure TAppRunMarkHandle.Update;
begin
MyThreadUtil.Run(
procedure
begin
    // ��¼����������Ϣ
  AppRunMark;
end);
end;

{ TDropFilesHandle }

constructor TDropFilesHandle.Create(_Msg: TMessage);
var
  FilesCount: Integer; // �ļ�����
  i: Integer;
  FileName: array [0 .. 255] of Char;
  FilePath: string;
begin
  Msg := _Msg;
  FileList := TStringList.Create;

  // ��ȡ�ļ�����
  FilesCount := DragQueryFile(Msg.WParam, $FFFFFFFF, nil, 0);
  try
    // ��ȡ�ļ���
    for i := 0 to FilesCount - 1 do
    begin
      DragQueryFile(Msg.WParam, i, FileName, 256);
      FilePath := FileName;
      FileList.Add(FilePath);
    end;
  except
  end;
  DragFinish(Msg.WParam); // �ͷ�
end;

destructor TDropFilesHandle.Destroy;
begin
  FileList.Free;
  inherited;
end;

procedure TDropFilesHandle.Update;
begin
  UserLocalDriverApi.CopyNow( FacePageButtonApi.ReadSelectDriver, FileList );
end;

{ TStopAppThread }

constructor TStopAppThread.Create;
begin
  inherited Create;
end;

destructor TStopAppThread.Destroy;
begin
  Terminate;
  Resume;
  WaitFor;

  inherited;
end;

procedure TStopAppThread.Execute;
var
  SleepCount : Integer;
begin
  SleepCount := 0;
  while not Terminated and ( SleepCount < 100 ) do
  begin
    Sleep( 100 );
    Inc( SleepCount );
  end;

    // 10 ���Ӷ�û�н���������ǿ�н���
  if not Terminated then
  begin
    try
      ExitProcess(0);
      Application.Terminate;
    except
    end;
  end;

  inherited;
end;

end.
