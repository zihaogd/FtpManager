unit UFrameDriver;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Buttons, RzTabs, Vcl.Menus, ShellAPI, Vcl.ImgList, IOUtils, IniFiles,
  ActiveX, Vcl.StdCtrls, dirnotify, Generics.Collections;

type
  TFrameDriver = class(TFrame)
    Splitter1: TSplitter;
    plRight: TPanel;
    vstLocal: TVirtualStringTree;
    vstNetwork: TVirtualStringTree;
    plLeft: TPanel;
    plLocalBottom: TPanel;
    plLocalComputer: TPanel;
    ilMyComputer: TImage;
    sbMyComputer: TSpeedButton;
    plLocalStatus: TPanel;
    plNetworkBottom: TPanel;
    plNetworkStatus: TPanel;
    plNetworkDriver: TPanel;
    ilNetworkDriver: TImage;
    sbNetwork: TSpeedButton;
    plCopy: TPanel;
    plCopyBottom: TPanel;
    plSplit: TPanel;
    tmrLeftEnter: TTimer;
    tmrRightEnter: TTimer;
    pmLocalFolder: TPopupMenu;
    miLocalRefresh: TMenuItem;
    miLocalNewFolder: TMenuItem;
    miLocalExplorer: TMenuItem;
    pmNetworkFolder: TPopupMenu;
    miNetworkNewFolder: TMenuItem;
    miNetworkRefresh: TMenuItem;
    miNetworkExplorer: TMenuItem;
    pmLocalFile: TPopupMenu;
    miLocalZip: TMenuItem;
    miLocalRename: TMenuItem;
    miLocalDelete: TMenuItem;
    pmNeworkFile: TPopupMenu;
    miNetworkZip: TMenuItem;
    miNetworkRename: TMenuItem;
    miNetworkDelete: TMenuItem;
    il16: TImageList;
    PcCopyUtil: TRzPageControl;
    tsCopy: TRzTabSheet;
    tsCopyAfter: TRzTabSheet;
    PcCopy: TRzPageControl;
    tsCopyLeft: TRzTabSheet;
    plCopyLeft: TPanel;
    sbCopyLeft: TSpeedButton;
    ilCopyLeft: TImage;
    tsCopyRight: TRzTabSheet;
    plRightCopy: TPanel;
    sbCopyRight: TSpeedButton;
    ilCopyRight: TImage;
    tsCopyLeftDisable: TRzTabSheet;
    ilCopyLeftDisable: TImage;
    tsCopyRightDisable: TRzTabSheet;
    ilCopyRightDisable: TImage;
    PcCopyAfter: TRzPageControl;
    tsCopyLeftAfter: TRzTabSheet;
    tsCopyRightAfter: TRzTabSheet;
    ilCopyLeftAfter: TImage;
    ilCopyRightAfter: TImage;
    plBottom: TPanel;
    vstFileJob: TVirtualStringTree;
    edtLocalSearch: TButtonedEdit;
    tmrLocalSearch: TTimer;
    edtNetworkSearch: TButtonedEdit;
    tmrNetworkSearch: TTimer;
    sbLocalStatus: TSpeedButton;
    sbNetworkStatus: TSpeedButton;
    plNetworkStatusCopy: TPanel;
    plLoading: TPanel;
    PcNetworkStatus: TRzPageControl;
    tsNetworkStatus: TRzTabSheet;
    tsNetworkLoading: TRzTabSheet;
    Image1: TImage;
    plLocal: TPanel;
    slLocalHistory: TSplitter;
    vstLocalHistory: TVirtualStringTree;
    pmLocalHistory: TPopupMenu;
    miHistoryRemove: TMenuItem;
    procedure vstLocalGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstLocalGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstNetworkGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstNetworkGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstLocalDblClick(Sender: TObject);
    procedure vstNetworkDblClick(Sender: TObject);
    procedure ilMyComputerMouseEnter(Sender: TObject);
    procedure sbMyComputerMouseLeave(Sender: TObject);
    procedure sbNetworkMouseLeave(Sender: TObject);
    procedure ilNetworkDriverMouseEnter(Sender: TObject);
    procedure sbNetworkClick(Sender: TObject);
    procedure ilCopyLeftMouseEnter(Sender: TObject);
    procedure sbCopyLeftMouseLeave(Sender: TObject);
    procedure ilCopyRightMouseEnter(Sender: TObject);
    procedure sbCopyRightMouseLeave(Sender: TObject);
    procedure vstLocalChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstNetworkChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure tmrLeftEnterTimer(Sender: TObject);
    procedure ilCopyLeftMouseLeave(Sender: TObject);
    procedure tmrRightEnterTimer(Sender: TObject);
    procedure ilCopyRightMouseLeave(Sender: TObject);
    procedure miLocalRefreshClick(Sender: TObject);
    procedure miNetworkRefreshClick(Sender: TObject);
    procedure sbCopyLeftClick(Sender: TObject);
    procedure sbCopyRightClick(Sender: TObject);
    procedure miLocalExplorerClick(Sender: TObject);
    procedure miNetworkExplorerClick(Sender: TObject);
    procedure miLocalNewFolderClick(Sender: TObject);
    procedure miNetworkNewFolderClick(Sender: TObject);
    procedure vstLocalMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure vstNetworkMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miNetworkDeleteClick(Sender: TObject);
    procedure miLocalDeleteClick(Sender: TObject);
    procedure miLocalRenameClick(Sender: TObject);
    procedure miNetworkRenameClick(Sender: TObject);
    procedure miLocalZipClick(Sender: TObject);
    procedure ilCopyLeftAfterMouseLeave(Sender: TObject);
    procedure ilCopyRightAfterMouseLeave(Sender: TObject);
    procedure vstLocalKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure vstNetworkKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure vstFileJobGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstFileJobGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure sbMyComputerClick(Sender: TObject);
    procedure vstLocalCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstLocalHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure vstNetworkHeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure vstNetworkCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstLocalDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure vstNetworkDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure vstLocalDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure vstNetworkDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure edtLocalSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtLocalSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tmrLocalSearchTimer(Sender: TObject);
    procedure edtNetworkSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtNetworkSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tmrNetworkSearchTimer(Sender: TObject);
    procedure edtLocalSearchRightButtonClick(Sender: TObject);
    procedure edtNetworkSearchRightButtonClick(Sender: TObject);
    procedure sbLocalStatusMouseLeave(Sender: TObject);
    procedure plLocalStatusMouseEnter(Sender: TObject);
    procedure sbLocalStatusClick(Sender: TObject);
    procedure plNetworkStatusMouseEnter(Sender: TObject);
    procedure sbNetworkStatusMouseLeave(Sender: TObject);
    procedure sbNetworkStatusClick(Sender: TObject);
    procedure plNetworkStatusCopyMouseLeave(Sender: TObject);
    procedure vstLocalHistoryGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure vstLocalHistoryGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstLocalHistoryDblClick(Sender: TObject);
    procedure miHistoryRemoveClick(Sender: TObject);
    procedure vstLocalHistoryKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    ControlPath : string;
    LocalPath, NetworkPath : string;
  public
    procedure IniFrame;
    procedure SetControlPath( _ControlPath : string );
    procedure SetLocalPath( _LocalPath : string );
    procedure SetNetworkPath( _NetworkPath : string );
  end;

{$Region ' ���� ���� ' }

    // ��������
  TVstLocalData = record
  public
    FilePath : WideString;
    IsFile : Boolean;
    FileSize : Int64;
    FileTime : TDateTime;
  public
    ShowName, ShowSize, ShowTime : WideString;
    ShowIcon : Integer;
  public
    IsLocked : Boolean;
  end;
  PVstLocalData = ^TVstLocalData;

    // ��������
  TVstNetworkData = record
  public
    FilePath : WideString;
    IsFile : Boolean;
    FileSize : Int64;
    FileTime : TDateTime;
  public
    ShowName, ShowSize, ShowTime : WideString;
    ShowIcon : Integer;
  public
    IsLocked : Boolean;
  end;
  PVstNetworkData = ^TVstNetworkData;

    // �ļ���������
  TVstFileJobData = record
  public
    FilePath, ActionType : WideString;
  public
    ShowName, ActionName : WideString;
    ShowIcon, ActionIcon : Integer;
  public
    ActionID : WideString;
  end;
  PVstFileJobData = ^TVstFileJobData;

    // ������ʷ����
  TVstLocalHistoryData = record
  public
    FolderPath : WideString;
  public
    ShowName, ShowDir : WideString;
    ShowIcon : Integer;
  end;
  PVstLocalHistoryData = ^TVstLocalHistoryData;

{$EndRegion}

{$Region ' ���� ���� ' }

    // Frame Api
  TFaceFrameDriverApi = class
  public
    FrameDriver : TFrameDriver;
  public
    procedure Activate( _FrameDriver : TFrameDriver );
  public
    procedure SetLocalPath( LocalPath : string );
    procedure SetNetworkPath( NetworkPath : string );
  public
    function ReadLocalPath : string;
    function ReadNetworkPath : string;
  public
    procedure UnvisibleLocalSearch;
    procedure UnvisibleNetworkSearch;
    function ReadLocalSerach : string;
    function ReadNetworkSerach : string;
  end;

    // ��Ӳ���
  TFileAddParams = record
  public
    FilePath : string;
    IsFile : Boolean;
    FileSize : Int64;
    FileTime : TDateTime;
  end;

    // �����ļ�
  TFaceLocalDriverApi = class
  public
    vstLocal : TVirtualStringTree;
  public
    procedure Activate( _vstLocal : TVirtualStringTree );
  public
    procedure Clear;
    function ReadIsExist( FilePath : string ): Boolean;
    procedure Add( Params : TFileAddParams );
    procedure AddDriver( Params : TFileAddParams );
    procedure AddParentFolder( ParentPath : string );
    procedure Insert( Params : TFileAddParams );
    procedure Select( FilePath : string );
    procedure CancelSelect;
    procedure Search( FileName : string );
    procedure Remove( FilePath : string );
  public
    function ReadSelectList : TStringList;
    function ReadPathList : TStringList;
    function ReadFocusePath : string;
  private
    function ReadNode( FilePath : string ): PVirtualNode;
    function CreateInsertNode : PVirtualNode;
  end;

    // �����ļ�
  TFaceNetworkDriverApi = class
  public
    vstNetwork : TVirtualStringTree;
  public
    procedure Activate( _vstNetwork : TVirtualStringTree );
  public
    procedure Clear;
    function ReadIsExist( FilePath : string ): Boolean;
    procedure Add( Params : TFileAddParams );
    procedure AddParentFolder( ParentPath : string );
    procedure Insert( Params : TFileAddParams );
    procedure Select( FilePath : string );
    procedure CancelSelect;
    procedure Search( FileName : string );
    procedure Remove( FilePath : string );
  public
    function ReadIsFile( FilePath : string ): Boolean;
    function ReadFileSize( FilePath : string ): Int64;
    function ReadFileTime( FilePath : string ): TDateTime;
  public
    function ReadSelectList : TStringList;
    function ReadPathList : TStringList;
    function ReadFocusePath : string;
  private
    function ReadNode( FilePath : string ): PVirtualNode;
    function CreateInsertNode : PVirtualNode;
  end;

    // ���ش���״̬
  TFaceLocalStatusApi = class
  public
    plLocalStatus : TPanel;
    sbLocalStatus : TSpeedButton;
  public
    procedure Activate( _plLocalStatus : TPanel; _sbLocalStatus : TSpeedButton );
  public
    procedure ShowPath( FolderPath : string );
  end;

    // �������״̬
  TFaceNetworkStatusApi = class
  public
    plNetworkStatus : TPanel;
    sbNetworkStatus : TSpeedButton;
  public
    PcNetworkStatus : TRzPageControl;
    tsNetworkStatus, tsNetworkLoading : TRzTabSheet;
  public
    procedure Activate( FrameDriver : TFrameDriver );
  public
    procedure ShowPath( FolderPath : string );
  public
    procedure ShowIsLoading;
    procedure HideIsLoading;
  end;

    // �ļ������б�
  TFaceFileJobApi = class
  public
    vstFileJob : TVirtualStringTree;
    PlFileJob : TPanel;
  public
    procedure Activate( _vstFileJob : TVirtualStringTree; _PlFileJob : TPanel );
  public
    function AddFileJob( FilePath, ActionType : string ): string;
    procedure RemoveFileJob( ActionID : string );
  private
    function ReadNode( ActionID : string ): PVirtualNode;
  end;

    // ���ط�����ʷ
  TFaceLocalHistoryApi = class
  public
    vstLocalHistory : TVirtualStringTree;
    slLocalHistory : TSplitter;
  public
    procedure Activate( _vstLocalHistory : TVirtualStringTree; _slLocalHistory : TSplitter );
  public
    function ReadIsExist( FolderPath : string ): Boolean;
    procedure Add( FolderPath : string );
    procedure Remove( FolderPath : string );
  public
    function ReadHistoryCount : Integer;
    procedure MoveToTop( FolderPath : string );
    procedure RemoveLastNode;
    function ReadList : TStringList;
    function ReadSelectList : TStringList;
    procedure SetVisible( Isvisible : Boolean );
  private
    function ReadNode( FolderPath : string ): PVirtualNode;
  end;

{$EndRegion}

{$Region ' �û� ���� ' }

    // ������Ϣ
  TCopyPathInfo = class
  public
    SourcePath, DesPath : string;
  public
    constructor Create( _SourcePath, _DesPath : string );
  end;
  TCopyPathList = class( TObjectList<TCopyPathInfo> )end;

    // ���ظ��Ƴ�ͻ����
  TLocalFileCopyHandle = class
  public
    ControlPath : string;
  public
    SourceList : TStringList;
    DesFolder : string;
  public
    CopyPathList : TCopyPathList;
  public
    constructor Create( _SourceFileList : TStringList; _DesFolder : string );
    procedure SetControlPath( _ControlPath : string );
    procedure Update;
    destructor Destroy; override;
  private
    function IsExistConflict : Boolean;
    function ConfirmConflict : Boolean;
    procedure CopyHandle;
  end;

    // ���縴�Ƴ�ͻ����
  TNetworkFileCopyHandle = class
  public
    ControlPath : string;
  public
    SourceList : TStringList;
    DesFolder : string;
  public
    CopyPathList : TCopyPathList;
  public
    constructor Create( _SourceFileList : TStringList; _DesFolder : string );
    procedure SetControlPath( _ControlPath : string );
    procedure Update;
    destructor Destroy; override;
  private
    function IsExistConflict : Boolean;
    function ConfirmConflict : Boolean;
    procedure CopyHandle;
  end;


    // �����ļ���
  UserLocalDriverApi = class
  public
    class procedure EnterFolder( FolderPath, ControlPath : string );
    class procedure RefreshFolder( ControlPath : string );
    class procedure CopyFile( ControlPath : string );
    class procedure CopyNow( ControlPath : string; PathList : TStringList );
    class procedure NewFolder( ControlPath : string );
    class procedure DeleteFile( ControlPath : string );
    class procedure RenameFile( ControlPath : string );
    class procedure ZipFile( ControlPath : string );
    class procedure SearchFile( ControlPath : string );
  public
    class procedure AddFile( ControlPath, FilePath : string );
    class procedure RemoveFile( ControlPath, FilePath : string );
    class procedure CancelSelect( ControlPath : string );
    class procedure Select( ControlPath, FilePath : string );
    class function ReadFileList( ControlPath : string ): TStringList;
  private
    class function ControlPage( ControlPath : string ): Boolean;
  end;

    // ��Ӳ���
  TNetworkAddParams = record
  public
    ControlPath, FilePath : string;
    IsFile : Boolean;
    FileSize : Int64;
    FileTime : TDateTime;
  end;

    // �����ļ���
  UserNetworkDriverApi = class
  public
    class procedure EnterFolder( FolderPath, ControlPath : string );
    class procedure RefreshFolder( ControlPath : string );
    class procedure CopyFile( ControlPath : string );
    class procedure NewFolder( ControlPath : string );
    class procedure DeleteFile( ControlPath : string );
    class procedure RenameFile( ControlPath : string );
    class procedure SearchFile( ControlPath : string );
  public
    class procedure AddFile( AddParams : TNetworkAddParams );
    class procedure RemoveFile( ControlPath, FilePath : string );
    class procedure CancelSelect( ControlPath : string );
    class procedure Select( ControlPath, FilePath : string );
    class function ReadFileList( ControlPath : string ): TStringList;
  public
    class function ReadIsExist( ControlPath, FilePath : string ): Boolean;
    class function ReadIsFile( ControlPath, FilePath : string ): Boolean;
    class function ReadFileSize( ControlPath, FilePath : string ): Int64;
    class function ReadFileTime( ControlPath, FilePath : string ): TDateTime;
  private
    class function ControlPage( ControlPath : string ): Boolean;
    class function ReadRenamePath( Path: string; IsFile: Boolean ): string;
  end;

    // Frame Api
  UserFrameDriverApi = class
  public
    class procedure SaveIni( ControlPath : string; IniFile : TIniFile; FrameIndex : Integer );
    class procedure LoadIni( ControlPath : string; IniFile : TIniFile; FrameIndex : Integer );
    class procedure SelectFrame( ControlPath : string );
  private
    class function ControlPage( ControlPath : string ): Boolean;
  end;

    // ������ʷ Api
  UserLocalHistoryApi = class
  public
    class procedure AddHistory( ControlPath, FolderPath : string );
    class procedure RemoveHistory( ControlPath, FolderPath : string );
    class function ReadSelectList( ControlPath : string ) : TStringList;
  private
    class function ControlPage( ControlPath : string ): Boolean;
  end;

{$EndRegion}

var
  FaceFrameDriverApi : TFaceFrameDriverApi;
  FaceLocalDriverApi : TFaceLocalDriverApi;
  FaceNetworkDriverApi : TFaceNetworkDriverApi;
  FaceLocalStatusApi : TFaceLocalStatusApi;
  FaceNetworkStatusApi : TFaceNetworkStatusApi;
  FaceFileJobApi : TFaceFileJobApi;
  FaceLocalHistoryApi : TFaceLocalHistoryApi;

var
  FileJob_ActionID : Int64 = 0;

const
  VstLocal_FileName = 0;
  VstLocal_FileSize = 1;
  VstLocal_FileTime = 2;
const
  VstNetwork_FileName = 0;
  VstNetwork_FileSize = 1;
  VstNetwork_FileTime = 2;

const
  Caption_ParentFolder = '������һ��';
  Caption_MyComputer = '�ҵĵ���';
  Caption_NetworkLoading = '���ڻ�ȡ...';

const
  NewFolder_DefaultName = '�½��ļ���';
  NewFolder_Title : string = '�½��ļ���';
  NewFolder_Name : string = '�����ļ�����';

  Rename_Title : string = '������';
  Rename_Name : string = '�����ļ���';
  Rename_Exist : string = '·���Ѵ���';

  DeleteFile_Comfirm : string = 'ȷ��Ҫɾ����?';

const
  EnterFolder_Title = '���ļ���';
  EnterFolder_Name = '�ļ���·��';
  EnterFolder_NotExist = '·��������';

const
  Compressed_NewName : string = 'ѹ���ļ�';

const
  ActionType_CopyLeft = 'CopyLeft';
  ActionType_CopyRight = 'CopyRight';
  ActionType_Delete = 'Delete';
  ActionType_Zip = 'Zip';
  ActionType_NewFolder = 'NewFolder';
  ActionType_Rename = 'Rename';

  AcionTypeShow_Copy = '�ȴ�����';
  AcionTypeShow_Delete = '�ȴ�ɾ��';
  AcionTypeShow_Zip = '�ȴ�ѹ��';
  AcionTypeShow_NewFolder = '�ȴ�����';
  AcionTypeShow_Rename = '�ȴ�����';

const
  Ini_FrameDriver = 'FrameDriver';
  Ini_LocalFolder = 'LocalFolder';
  Ini_NetworkFolder = 'NetworkFolder';
  Ini_LocalWidth = 'LocalWidth';
  Ini_LocalHistoryCount = 'LocalHistoryCount';
  Ini_LocalHistory = 'LocalHistory';
  Ini_LocalHistoryHeigh = 'LocalHistoryHeigh';

const
  VstHistory_FileName = 0;
  VstHistory_FileDir = 1;


implementation

uses UMyUtils, UMyFaceThread, UMainForm, UFileThread, UFileWatchThread, UFormConflict, Clipbrd;

{$R *.dfm}

{ TFaceLocalDriverApi }

procedure TFaceLocalDriverApi.Activate(_vstLocal: TVirtualStringTree);
begin
  vstLocal := _vstLocal;
end;

procedure TFaceLocalDriverApi.Add(Params: TFileAddParams);
var
  FileNode : PVirtualNode;
  NodeData : PVstLocalData;
begin
  FileNode := vstLocal.AddChild( vstLocal.RootNode );
  NodeData := vstLocal.GetNodeData( FileNode );
  NodeData.FilePath := Params.FilePath;
  NodeData.IsFile := Params.IsFile;
  NodeData.FileSize := Params.FileSize;
  NodeData.FileTime := Params.FileTime;
  NodeData.ShowName := MyFilePath.getName( Params.FilePath );
  NodeData.ShowTime := DateTimeToStr( Params.FileTime );
  if Params.IsFile then
    NodeData.ShowSize := MySizeUtil.getStr( Params.FileSize )
  else
    NodeData.ShowSize := '';
  NodeData.ShowIcon := MyIcon.getPathIcon( Params.FilePath, Params.IsFile );
  NodeData.IsLocked := False;
end;

procedure TFaceLocalDriverApi.AddDriver(Params: TFileAddParams);
var
  FileNode : PVirtualNode;
  NodeData : PVstLocalData;
begin
  FileNode := vstLocal.AddChild( vstLocal.RootNode );
  NodeData := vstLocal.GetNodeData( FileNode );
  NodeData.FilePath := Params.FilePath;
  NodeData.IsFile := Params.IsFile;
  NodeData.FileSize := Params.FileSize;
  NodeData.FileTime := Params.FileTime;
  NodeData.ShowName := MyFilePath.getDriverName( Params.FilePath );
  NodeData.ShowTime := '';
  NodeData.ShowSize := '';
  NodeData.ShowIcon := MyIcon.getPathIcon( Params.FilePath, Params.IsFile );
  NodeData.IsLocked := False;
end;

procedure TFaceLocalDriverApi.AddParentFolder(ParentPath: string);
var
  FileNode : PVirtualNode;
  NodeData : PVstLocalData;
begin
  FileNode := vstLocal.InsertNode( vstLocal.RootNode, amAddChildFirst );
  NodeData := vstLocal.GetNodeData( FileNode );
  NodeData.FilePath := ParentPath;
  NodeData.IsFile := False;
  NodeData.ShowName := Caption_ParentFolder;
  NodeData.ShowSize := '';
  NodeData.ShowTime := '';
  NodeData.ShowIcon := My16IconUtil.getBack;
  NodeData.IsLocked := True;
end;

procedure TFaceLocalDriverApi.CancelSelect;
var
  SelectNode : PVirtualNode;
begin
  SelectNode := vstLocal.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    vstLocal.Selected[ SelectNode ] := False;
    SelectNode := SelectNode.NextSibling;
  end;
end;

procedure TFaceLocalDriverApi.Clear;
begin
  vstLocal.Clear;
end;

function TFaceLocalDriverApi.CreateInsertNode: PVirtualNode;
var
  FirstNode : PVirtualNode;
  NodeData : PVstLocalData;
begin
  FirstNode := vstLocal.RootNode.FirstChild;
  if Assigned( FirstNode ) then
  begin
    NodeData := vstLocal.GetNodeData( FirstNode );
    if NodeData.IsLocked then
      Result := vstLocal.InsertNode( FirstNode, amInsertAfter )
    else
      Result := vstLocal.InsertNode( vstLocal.RootNode, amAddChildFirst );
  end
  else
    Result := vstLocal.InsertNode( vstLocal.RootNode, amAddChildFirst );
end;

procedure TFaceLocalDriverApi.Insert(Params: TFileAddParams);
var
  FileNode : PVirtualNode;
  NodeData : PVstLocalData;
begin
  FileNode := CreateInsertNode;
  NodeData := vstLocal.GetNodeData( FileNode );
  NodeData.FilePath := Params.FilePath;
  NodeData.IsFile := Params.IsFile;
  NodeData.FileSize := Params.FileSize;
  NodeData.FileTime := Params.FileTime;
  NodeData.ShowName := MyFilePath.getName( Params.FilePath );
  NodeData.ShowTime := DateTimeToStr( Params.FileTime );
  if Params.IsFile then
    NodeData.ShowSize := MySizeUtil.getStr( Params.FileSize )
  else
    NodeData.ShowSize := '';
  NodeData.ShowIcon := MyIcon.getPathIcon( Params.FilePath, Params.IsFile );
  NodeData.IsLocked := False;
end;

function TFaceLocalDriverApi.ReadFocusePath: string;
var
  NodeData : PVstLocalData;
begin
  Result := '';
  if not Assigned( vstLocal.FocusedNode ) then
    Exit;
  NodeData := vstLocal.GetNodeData( vstLocal.FocusedNode );
  Result := NodeData.FilePath;
end;

function TFaceLocalDriverApi.ReadIsExist(FilePath: string): Boolean;
begin
  Result := Assigned( ReadNode( FilePath ) );
end;

function TFaceLocalDriverApi.ReadNode(FilePath: string): PVirtualNode;
var
  SelectNode : PVirtualNode;
  NodeData : PVstLocalData;
begin
  Result := nil;

  SelectNode := vstLocal.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstLocal.GetNodeData( SelectNode );
    if NodeData.FilePath = FilePath then
    begin
      Result := SelectNode;
      Break;
    end;
    SelectNode := SelectNode.NextSibling;
  end;
end;

function TFaceLocalDriverApi.ReadPathList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstLocalData;
begin
  Result := TStringList.Create;
  SelectNode := vstLocal.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstLocal.GetNodeData( SelectNode );
    if not NodeData.IsLocked then
      Result.Add( NodeData.FilePath );
    SelectNode := SelectNode.NextSibling;
  end;
end;

function TFaceLocalDriverApi.ReadSelectList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstLocalData;
begin
  Result := TStringList.Create;
  SelectNode := vstLocal.GetFirstSelected;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstLocal.GetNodeData( SelectNode );
    if not NodeData.IsLocked then
      Result.Add( NodeData.FilePath );
    SelectNode := vstLocal.GetNextSelected( SelectNode );
  end;
end;

procedure TFaceLocalDriverApi.Remove(FilePath: string);
var
  SelectNode : PVirtualNode;
begin
  SelectNode := ReadNode( FilePath );
  if not Assigned( SelectNode ) then
    Exit;
  vstLocal.DeleteNode( SelectNode );
end;

procedure TFaceLocalDriverApi.Search(FileName: string);
var
  SelectNode : PVirtualNode;
  NodeData : PVstLocalData;
  IsVisible, IsSearchAll : Boolean;
begin
  FileName := LowerCase( FileName );
  IsSearchAll := FileName = '';

    // ����
  SelectNode := vstLocal.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstLocal.GetNodeData( SelectNode );
    IsVisible := IsSearchAll or NodeData.IsLocked or
                 ( Pos( FileName, LowerCase( string( NodeData.ShowName ) ) ) > 0 );
    vstLocal.IsVisible[ SelectNode ] := IsVisible;
    vstLocal.Selected[ SelectNode ] := False;
    SelectNode := SelectNode.NextSibling;
  end;

    // ȫѡ
  if IsSearchAll then
    Exit;

    // Ĭ��ѡ���һ��
  SelectNode := vstLocal.GetFirstVisible;
  if not Assigned( SelectNode ) then
    Exit;
  NodeData := vstLocal.GetNodeData( SelectNode );
  if NodeData.IsLocked then
  begin
    SelectNode := vstLocal.GetNextVisible( SelectNode );
    if not Assigned( SelectNode ) then
      Exit;
  end;
  vstLocal.Selected[ SelectNode ] := True;
  vstLocal.FocusedNode := SelectNode;
end;

procedure TFaceLocalDriverApi.Select(FilePath: string);
var
  SelectNode : PVirtualNode;
begin
  SelectNode := ReadNode( FilePath );
  if not Assigned( SelectNode ) then
    Exit;
  vstLocal.Selected[ SelectNode ] := True;
  vstLocal.FocusedNode := SelectNode;
end;

{ TFrameDriver }

procedure TFrameDriver.edtLocalSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    // �س�
  if Key = VK_RETURN then
  begin
    if Assigned( vstLocal.FocusedNode ) and vstLocal.IsVisible[ vstLocal.FocusedNode ] then
    begin
      vstLocalDblClick( Sender );
      vstLocal.SetFocus;
    end;
    Exit;
  end;

    // ����/����
  if ( Key = VK_UP ) or ( Key = VK_DOWN ) then
  begin
    vstLocal.SetFocus;
    Exit;
  end;

    // ������ʱ��
  if not tmrLocalSearch.Enabled then
    tmrLocalSearch.Enabled := True;
end;

procedure TFrameDriver.edtLocalSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      // ����������ʾ�رհ�ť
  edtLocalSearch.RightButton.Visible := edtLocalSearch.Text <> '';
end;

procedure TFrameDriver.edtLocalSearchRightButtonClick(Sender: TObject);
begin
  edtLocalSearch.Text := '';
  tmrLocalSearch.Enabled := True;
  edtLocalSearch.RightButton.Visible := False;
end;

procedure TFrameDriver.edtNetworkSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  FirstVisibleNode : PVirtualNode;
begin
    // �س�
  if Key = VK_RETURN then
  begin
    if Assigned( vstNetwork.FocusedNode ) and vstNetwork.IsVisible[ vstNetwork.FocusedNode ] then
    begin
      vstNetworkDblClick( Sender );
      vstNetwork.SetFocus;
    end;
    Exit;
  end;

    // ����/����
  if ( Key = VK_UP ) or ( Key = VK_DOWN ) then
  begin
    vstNetwork.SetFocus;
    Exit;
  end;

    // ������ʱ��
  if not tmrNetworkSearch.Enabled then
    tmrNetworkSearch.Enabled := True;
end;

procedure TFrameDriver.edtNetworkSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
        // ����������ʾ�رհ�ť
  edtNetworkSearch.RightButton.Visible := edtNetworkSearch.Text <> '';
end;

procedure TFrameDriver.edtNetworkSearchRightButtonClick(Sender: TObject);
begin
  edtNetworkSearch.Text := '';
  tmrNetworkSearch.Enabled := True;
  edtNetworkSearch.RightButton.Visible := False;
end;

procedure TFrameDriver.ilCopyLeftAfterMouseLeave(Sender: TObject);
begin
  PcCopyUtil.ActivePage := tsCopy;
end;

procedure TFrameDriver.ilCopyLeftMouseEnter(Sender: TObject);
begin
  tmrLeftEnter.Enabled := True;
end;

procedure TFrameDriver.ilCopyLeftMouseLeave(Sender: TObject);
begin
  tmrLeftEnter.Enabled := False;
end;

procedure TFrameDriver.ilCopyRightAfterMouseLeave(Sender: TObject);
begin
  PcCopyUtil.ActivePage := tsCopy;
end;

procedure TFrameDriver.ilCopyRightMouseEnter(Sender: TObject);
begin
  tmrRightEnter.Enabled := True;
end;

procedure TFrameDriver.ilCopyRightMouseLeave(Sender: TObject);
begin
  tmrRightEnter.Enabled := False;
end;

procedure TFrameDriver.ilMyComputerMouseEnter(Sender: TObject);
begin
  ilMyComputer.Visible := False;
  sbMyComputer.Visible := True;
end;

procedure TFrameDriver.ilNetworkDriverMouseEnter(Sender: TObject);
begin
  ilNetworkDriver.Visible := False;
  sbNetwork.Visible := True;
end;

procedure TFrameDriver.IniFrame;
begin
  vstLocal.NodeDataSize := SizeOf( TVstLocalData );
  vstLocal.Images := MyIcon.getSysIcon;

  vstNetwork.NodeDataSize := SizeOf( TVstNetworkData );
  vstNetwork.Images := MyIcon.getSysIcon;

  vstFileJob.NodeDataSize := SizeOf( TVstFileJobData );
  vstFileJob.Images := MyIcon.getSysIcon;

  vstLocalHistory.NodeDataSize := SizeOf( TVstLocalHistoryData );
  vstLocalHistory.Images := MyIcon.getSysIcon;

  PcCopyUtil.ActivePage := tsCopy;
  PcCopy.ActivePage := tsCopyRight;

  plRight.Width := ( frmMain.Width - plCopy.Width ) div 2;

  PcNetworkStatus.ActivePage := tsNetworkStatus;
end;

procedure TFrameDriver.miHistoryRemoveClick(Sender: TObject);
var
  SelectList : TStringList;
  i: Integer;
begin
  SelectList := UserLocalHistoryApi.ReadSelectList( ControlPath );
  for i := 0 to SelectList.Count - 1 do
    UserLocalHistoryApi.RemoveHistory( ControlPath, SelectList[i] );
  SelectList.Free;
end;

procedure TFrameDriver.miLocalDeleteClick(Sender: TObject);
begin
  UserLocalDriverApi.DeleteFile( ControlPath );
end;

procedure TFrameDriver.miLocalExplorerClick(Sender: TObject);
begin
  MyExplorer.ShowFolder( LocalPath );
end;

procedure TFrameDriver.miLocalNewFolderClick(Sender: TObject);
begin
  UserLocalDriverApi.NewFolder( ControlPath );
end;

procedure TFrameDriver.miLocalRefreshClick(Sender: TObject);
begin
  UserLocalDriverApi.RefreshFolder( ControlPath );
end;

procedure TFrameDriver.miLocalRenameClick(Sender: TObject);
begin
  UserLocalDriverApi.RenameFile( ControlPath );
end;

procedure TFrameDriver.miLocalZipClick(Sender: TObject);
begin
  UserLocalDriverApi.ZipFile( ControlPath );
end;

procedure TFrameDriver.miNetworkDeleteClick(Sender: TObject);
begin
  UserNetworkDriverApi.DeleteFile( ControlPath );
end;

procedure TFrameDriver.miNetworkExplorerClick(Sender: TObject);
begin
  MyExplorer.ShowFolder( NetworkPath );
end;

procedure TFrameDriver.miNetworkNewFolderClick(Sender: TObject);
begin
  UserNetworkDriverApi.NewFolder( ControlPath );
end;

procedure TFrameDriver.miNetworkRefreshClick(Sender: TObject);
begin
  UserNetworkDriverApi.RefreshFolder( ControlPath );
end;

procedure TFrameDriver.miNetworkRenameClick(Sender: TObject);
begin
  UserNetworkDriverApi.RenameFile( ControlPath );
end;

procedure TFrameDriver.plLocalStatusMouseEnter(Sender: TObject);
begin
  sbLocalStatus.Visible := True;
end;

procedure TFrameDriver.plNetworkStatusCopyMouseLeave(Sender: TObject);
begin
  plNetworkStatusCopy.Visible := False;
  plNetworkStatus.Caption := sbNetworkStatus.Caption;
end;

procedure TFrameDriver.plNetworkStatusMouseEnter(Sender: TObject);
begin
  sbNetworkStatus.Visible := True;
end;

procedure TFrameDriver.sbCopyLeftClick(Sender: TObject);
begin
    // ��ʼ����
  UserLocalDriverApi.CopyFile( ControlPath );

    // �л� Disable
  PcCopyUtil.ActivePage := tsCopyAfter;
  PcCopyAfter.ActivePage := tsCopyLeftAfter;
end;

procedure TFrameDriver.sbCopyLeftMouseLeave(Sender: TObject);
begin
  sbCopyLeft.Visible := False;
  ilCopyLeft.Visible := True;
end;

procedure TFrameDriver.sbCopyRightClick(Sender: TObject);
begin
    // ��ʼ�����ļ�
  UserNetworkDriverApi.CopyFile( ControlPath );

    // �л� Disable
  PcCopyUtil.ActivePage := tsCopyAfter;
  PcCopyAfter.ActivePage := tsCopyRightAfter;
end;

procedure TFrameDriver.sbCopyRightMouseLeave(Sender: TObject);
begin
  sbCopyRight.Visible := False;
  ilCopyRight.Visible := True;
end;

procedure TFrameDriver.sbLocalStatusClick(Sender: TObject);
var
  InputStr, OldInputStr : string;
begin
  InputStr := sbLocalStatus.Caption;
  OldInputStr := InputStr;
  if not InputQuery( EnterFolder_Title, EnterFolder_Name, InputStr ) then
    Exit;
  if FileExists( InputStr ) then
    InputStr := ExtractFileDir( InputStr );
  if not DirectoryExists( InputStr ) then
    MyMessageForm.ShowWarnning( EnterFolder_NotExist )
  else
  if InputStr <> OldInputStr then
    UserLocalDriverApi.EnterFolder( InputStr, ControlPath );
end;

procedure TFrameDriver.sbLocalStatusMouseLeave(Sender: TObject);
begin
  sbLocalStatus.Visible := False;
end;

procedure TFrameDriver.sbMyComputerClick(Sender: TObject);
begin
  UserLocalDriverApi.EnterFolder( '', ControlPath );
end;

procedure TFrameDriver.sbMyComputerMouseLeave(Sender: TObject);
begin
  sbMyComputer.Visible := False;
  ilMyComputer.Visible := True;
end;

procedure TFrameDriver.sbNetworkClick(Sender: TObject);
begin
  UserNetworkDriverApi.EnterFolder( '/', ControlPath );
end;

procedure TFrameDriver.sbNetworkMouseLeave(Sender: TObject);
begin
  sbNetwork.Visible := False;
  ilNetworkDriver.Visible := True;
end;

procedure TFrameDriver.sbNetworkStatusClick(Sender: TObject);
begin
  Clipboard.AsText := sbNetworkStatus.Caption;
  plNetworkStatus.Caption := '';
  plNetworkStatusCopy.Visible := True;
  sbNetworkStatus.Visible := False;
end;

procedure TFrameDriver.sbNetworkStatusMouseLeave(Sender: TObject);
begin
  sbNetworkStatus.Visible := False;
end;

procedure TFrameDriver.SetControlPath(_ControlPath: string);
begin
  ControlPath := _ControlPath;
end;

procedure TFrameDriver.SetLocalPath(_LocalPath: string);
begin
  LocalPath := _LocalPath;
end;

procedure TFrameDriver.SetNetworkPath(_NetworkPath: string);
begin
  NetworkPath := _NetworkPath;
end;

procedure TFrameDriver.tmrLeftEnterTimer(Sender: TObject);
begin
  tmrLeftEnter.Enabled := False;
  ilCopyLeft.Visible := False;
  sbCopyLeft.Visible := True;
end;

procedure TFrameDriver.tmrLocalSearchTimer(Sender: TObject);
begin
  tmrLocalSearch.Enabled := False;
  UserLocalDriverApi.SearchFile( ControlPath );
end;

procedure TFrameDriver.tmrNetworkSearchTimer(Sender: TObject);
begin
  tmrNetworkSearch.Enabled := False;
  UserNetworkDriverApi.SearchFile( ControlPath );
end;

procedure TFrameDriver.tmrRightEnterTimer(Sender: TObject);
begin
  tmrRightEnter.Enabled := False;
  ilCopyRight.Visible := False;
  sbCopyRight.Visible := True;
end;

procedure TFrameDriver.vstFileJobGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstFileJobData;
begin
  if (Kind = ikNormal) or (Kind = ikSelected) then
  begin
    NodeData := Sender.GetNodeData( Node );
    if Column = 0 then
      ImageIndex := NodeData.ShowIcon
    else
    if Column = 1 then
      ImageIndex := NodeData.ActionIcon
    else
      ImageIndex := -1;
  end
  else
    ImageIndex := -1;
end;

procedure TFrameDriver.vstFileJobGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstFileJobData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.ShowName
  else
  if Column = 1 then
    CellText := NodeData.ActionName
  else
    CellText := '';
end;

procedure TFrameDriver.vstLocalChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  if ( Sender.SelectedCount > 0 ) and ( LocalPath <> '' ) then
    PcCopy.ActivePage := tsCopyLeft
  else
    PcCopy.ActivePage := tsCopyLeftDisable;
end;

procedure TFrameDriver.vstLocalCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  NodeData1, NodeData2 : PVstLocalData;
begin
  NodeData1 := Sender.GetNodeData( Node1 );
  NodeData2 := Sender.GetNodeData( Node2 );
  if NodeData1.IsLocked then
    Result := 0
  else
  if NodeData2.IsLocked then
    Result := 0
  else
  if NodeData1.IsFile <>  NodeData2.IsFile then
    Result := 0
  else
  if Column = VstLocal_FileName then
    Result := CompareText( NodeData1.ShowName, NodeData2.ShowName )
  else
  if Column = VstLocal_FileSize then
    Result := NodeData1.FileSize - NodeData2.FileSize
  else
  if Column = VstLocal_FileTime then
  begin
    if NodeData1.FileTime > NodeData2.FileTime then
      Result := 1
    else
    if NodeData1.FileTime < NodeData2.FileTime then
      Result := -1
    else
      Result := 0;
  end
  else
    Result := 0;
end;

procedure TFrameDriver.vstLocalDblClick(Sender: TObject);
var
  NodeData : PVstLocalData;
  MarkPath, MarkName : string;
  IsLocked : Boolean;
  RootCount : Integer;
begin
  if not Assigned( vstLocal.FocusedNode ) then
    Exit;
  NodeData := vstLocal.GetNodeData( vstLocal.FocusedNode );

    // ��¼��Ϣ
  RootCount := vstLocal.RootNode.ChildCount;
  MarkPath := LocalPath;
  MarkName := MyFilePath.getName( NodeData.FilePath );
  IsLocked := NodeData.IsLocked;

    // �ļ�/Ŀ¼
  if NodeData.IsFile then
    MyExplorer.RunFile( NodeData.FilePath )
  else
    UserLocalDriverApi.EnterFolder( NodeData.FilePath, ControlPath );

    // ������һ��
  if IsLocked then
    MyFaceJobHandler.FileListSelect( ControlPath, MarkPath, True );

    // ��¼ѡ��
  if ( RootCount > 10 ) and not IsLocked then
    MyFaceJobHandler.FileListMarkSelect( MarkPath, MarkName );
end;

procedure TFrameDriver.vstLocalDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
begin
  if Source = vstNetwork then
    sbCopyRight.Click;
end;

procedure TFrameDriver.vstLocalDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
  Accept := ( Source = vstNetwork ) and ( LocalPath <> '' );
end;

procedure TFrameDriver.vstLocalGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstLocalData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.ShowIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TFrameDriver.vstLocalGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstLocalData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = VstLocal_FileName then
    CellText := NodeData.ShowName
  else
  if Column = VstLocal_FileSize then
    CellText := NodeData.ShowSize
  else
  if Column = VstLocal_FileTime then
    CellText := NodeData.ShowTime;
end;

procedure TFrameDriver.vstLocalHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  if vstLocal.Header.SortDirection = sdAscending then
  begin
    vstLocal.Header.SortDirection := sdDescending;
    vstLocal.SortTree( HitInfo.Column, sdDescending )
  end
  else
  begin
    vstLocal.Header.SortDirection := sdAscending;
    vstLocal.SortTree( HitInfo.Column, sdAscending );
  end;
end;

procedure TFrameDriver.vstLocalHistoryDblClick(Sender: TObject);
var
  SelectNode : PVirtualNode;
  NodeData : PVstLocalHistoryData;
begin
  SelectNode := vstLocalHistory.FocusedNode;
  if not Assigned( SelectNode ) then
    Exit;
  NodeData := vstLocalHistory.GetNodeData( SelectNode );
  UserLocalDriverApi.EnterFolder( NodeData.FolderPath, ControlPath );
end;

procedure TFrameDriver.vstLocalHistoryGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstLocalHistoryData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.ShowIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TFrameDriver.vstLocalHistoryGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstLocalHistoryData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = VstHistory_FileName then
    CellText := NodeData.ShowName
  else
  if Column = VstHistory_FileDir then
    CellText := NodeData.ShowDir
  else
    CellText := '';
end;

procedure TFrameDriver.vstLocalHistoryKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    miHistoryRemove.Click
  else
  if Key = VK_RETURN then
    vstLocalHistoryDblClick( Sender );
end;

procedure TFrameDriver.vstLocalKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    // �ļ�����
  if ( Key > 47 ) and ( Key < 91 ) and ( not ( ssCtrl in Shift ) ) then
  begin
    edtLocalSearch.Visible := True;
    edtLocalSearch.Text := LowerCase( Char( Key ) );
    edtLocalSearch.SetFocus;
    edtLocalSearch.SelStart := 1;
  end
  else
  if Key = VK_F5 then
    UserLocalDriverApi.RefreshFolder( ControlPath )
  else  // �ļ��˵�
  if vstLocal.SelectedCount > 0 then
  begin
    if Key = VK_DELETE then
      UserLocalDriverApi.DeleteFile( ControlPath )
    else
    if Key = VK_F2 then
      UserLocalDriverApi.RenameFile( ControlPath )
    else
    if Key = VK_RETURN then
      vstLocalDblClick( Sender );
  end;
end;

procedure TFrameDriver.vstLocalMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  SelectNode : PVirtualNode;
  NodeData : PVstLocalData;
  IsSelectNode : Boolean;
begin
  if Button <> mbRight then
    Exit;

  SelectNode := vstLocal.GetNodeAt( x, y );
  IsSelectNode := False;
  if Assigned( SelectNode ) then
    IsSelectNode := vstLocal.Selected[ SelectNode ];

  if LocalPath = '' then
    vstLocal.PopupMenu := nil
  else
  if IsSelectNode then
    vstLocal.PopupMenu := pmLocalFile
  else
  begin
    vstLocal.PopupMenu := pmLocalFolder;
    SelectNode := vstLocal.GetFirstSelected;
    while Assigned( SelectNode ) do
    begin
      vstLocal.Selected[ SelectNode ] := False;
      SelectNode := vstLocal.GetNextSelected( SelectNode );
    end;
  end;
end;

procedure TFrameDriver.vstNetworkChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  if ( Sender.SelectedCount > 0 ) and ( LocalPath <> '' ) then
    PcCopy.ActivePage := tsCopyRight
  else
    PcCopy.ActivePage := tsCopyRightDisable;
end;

procedure TFrameDriver.vstNetworkCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  NodeData1, NodeData2 : PVstNetworkData;
begin
  NodeData1 := Sender.GetNodeData( Node1 );
  NodeData2 := Sender.GetNodeData( Node2 );
  if NodeData1.IsLocked then
    Result := 0
  else
  if NodeData2.IsLocked then
    Result := 0
  else
  if NodeData1.IsFile <>  NodeData2.IsFile then
    Result := 0
  else
  if Column = VstNetwork_FileName then
    Result := CompareText( NodeData1.ShowName, NodeData2.ShowName )
  else
  if Column = VstNetwork_FileSize then
    Result := NodeData1.FileSize - NodeData2.FileSize
  else
  if Column = VstNetwork_FileTime then
  begin
    if NodeData1.FileTime > NodeData2.FileTime then
      Result := 1
    else
    if NodeData1.FileTime < NodeData2.FileTime then
      Result := -1
    else
      Result := 0;
  end
  else
    Result := 0;
end;

procedure TFrameDriver.vstNetworkDblClick(Sender: TObject);
var
  NodeData : PVstNetworkData;
  MarkPath, MarkName : string;
  IsLocked : Boolean;
  RootCount : Integer;
begin
  if not Assigned( vstNetwork.FocusedNode ) then
    Exit;
  NodeData := vstNetwork.GetNodeData( vstNetwork.FocusedNode );

    // ��¼��Ϣ
  RootCount := vstNetwork.RootNode.ChildCount;
  MarkPath := NetworkPath;
  MarkName := MyFilePath.getFtpName( NodeData.FilePath );
  IsLocked := NodeData.IsLocked;

    // Ŀ¼
  if not NodeData.IsFile then
    UserNetworkDriverApi.EnterFolder( NodeData.FilePath, ControlPath );

    // ������һ��
  if IsLocked then
    MyFaceJobHandler.FileListSelect( ControlPath, MarkPath, False );

    // ��¼ѡ��
  if ( RootCount > 10 ) and not IsLocked then
    MyFaceJobHandler.FileListMarkSelect( MarkPath, MarkName );
end;

procedure TFrameDriver.vstNetworkDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
begin
  if Source = vstLocal then
    sbCopyLeft.Click;
end;

procedure TFrameDriver.vstNetworkDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
  Accept := Source = vstLocal;
end;

procedure TFrameDriver.vstNetworkGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstNetworkData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.ShowIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TFrameDriver.vstNetworkGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstNetworkData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = VstNetwork_FileName then
    CellText := NodeData.ShowName
  else
  if Column = VstNetwork_FileSize then
    CellText := NodeData.ShowSize
  else
  if Column = VstNetwork_FileTime then
    CellText := NodeData.ShowTime;
end;

procedure TFrameDriver.vstNetworkHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  if vstNetwork.Header.SortDirection = sdAscending then
  begin
    vstNetwork.Header.SortDirection := sdDescending;
    vstNetwork.SortTree( HitInfo.Column, sdDescending )
  end
  else
  begin
    vstNetwork.Header.SortDirection := sdAscending;
    vstNetwork.SortTree( HitInfo.Column, sdAscending );
  end;
end;

procedure TFrameDriver.vstNetworkKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    // �ļ�����
  if ( Key > 47 ) and ( Key < 91 ) and ( not ( ssCtrl in Shift ) ) then
  begin
    edtNetworkSearch.Visible := True;
    edtNetworkSearch.Text := LowerCase( Char( Key ) );
    edtNetworkSearch.SetFocus;
    edtNetworkSearch.SelStart := 1;
  end
  else
  if Key = VK_F5 then
    UserNetworkDriverApi.RefreshFolder( ControlPath )
  else  // �ļ��˵�
  if vstNetwork.SelectedCount > 0 then
  begin
    if Key = VK_DELETE then
      UserNetworkDriverApi.DeleteFile( ControlPath )
    else
    if Key = VK_F2 then
      UserNetworkDriverApi.RenameFile( ControlPath )
    else
    if Key = VK_RETURN then
      vstNetworkDblClick( Sender );
  end;
end;

procedure TFrameDriver.vstNetworkMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  SelectNode : PVirtualNode;
  NodeData : PVstNetworkData;
  IsSelectNode : Boolean;
begin
  if Button <> mbRight then
    Exit;

  SelectNode := vstNetwork.GetNodeAt( x, y );
  IsSelectNode := False;
  if Assigned( SelectNode ) then
    IsSelectNode := vstNetwork.Selected[ SelectNode ];

  if IsSelectNode then
    vstNetwork.PopupMenu := pmNeworkFile
  else
  begin
    vstNetwork.PopupMenu := pmNetworkFolder;
    SelectNode := vstNetwork.GetFirstSelected;
    while Assigned( SelectNode ) do
    begin
      vstNetwork.Selected[ SelectNode ] := False;
      SelectNode := vstNetwork.GetNextSelected( SelectNode );
    end;
  end;
end;

{ TFaceNetworkDriverApi }

procedure TFaceNetworkDriverApi.Activate(_vstNetwork: TVirtualStringTree);
begin
  vstNetwork := _vstNetwork;
end;

procedure TFaceNetworkDriverApi.Add(Params: TFileAddParams);
var
  FileNode : PVirtualNode;
  NodeData : PVstNetworkData;
begin
  FileNode := vstNetwork.AddChild( vstNetwork.RootNode );
  NodeData := vstNetwork.GetNodeData( FileNode );
  NodeData.FilePath := Params.FilePath;
  NodeData.IsFile := Params.IsFile;
  NodeData.FileSize := Params.FileSize;
  NodeData.FileTime := Params.FileTime;
  NodeData.ShowName := MyFilePath.getFtpName( Params.FilePath );
  NodeData.ShowTime := DateTimeToStr( Params.FileTime );
  if Params.IsFile then
    NodeData.ShowSize := MySizeUtil.getStr( Params.FileSize )
  else
    NodeData.ShowSize := '';
  NodeData.ShowIcon := MyIcon.getPathIcon( Params.FilePath, Params.IsFile );
  NodeData.IsLocked := False;
end;

procedure TFaceNetworkDriverApi.AddParentFolder(ParentPath: string);
var
  FileNode : PVirtualNode;
  NodeData : PVstNetworkData;
begin
  FileNode := vstNetwork.InsertNode( vstNetwork.RootNode, amAddChildFirst );
  NodeData := vstNetwork.GetNodeData( FileNode );
  NodeData.FilePath := ParentPath;
  NodeData.IsFile := False;
  NodeData.ShowName := Caption_ParentFolder;
  NodeData.ShowSize := '';
  NodeData.ShowTime := '';
  NodeData.ShowIcon := My16IconUtil.getBack;
  NodeData.IsLocked := True;
end;

procedure TFaceNetworkDriverApi.CancelSelect;
var
  SelectNode : PVirtualNode;
begin
  SelectNode := vstNetwork.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    vstNetwork.Selected[ SelectNode ] := False;
    SelectNode := SelectNode.NextSibling;
  end;
end;

procedure TFaceNetworkDriverApi.Clear;
begin
  vstNetwork.Clear;
end;

function TFaceNetworkDriverApi.CreateInsertNode: PVirtualNode;
var
  FirstNode : PVirtualNode;
  NodeData : PVstNetworkData;
begin
  FirstNode := vstNetwork.RootNode.FirstChild;
  if Assigned( FirstNode ) then
  begin
    NodeData := vstNetwork.GetNodeData( FirstNode );
    if NodeData.IsLocked then
      Result := vstNetwork.InsertNode( FirstNode, amInsertAfter )
    else
      Result := vstNetwork.InsertNode( vstNetwork.RootNode, amAddChildFirst );
  end
  else
    Result := vstNetwork.InsertNode( vstNetwork.RootNode, amAddChildFirst );
end;

procedure TFaceNetworkDriverApi.Insert(Params: TFileAddParams);
var
  FileNode : PVirtualNode;
  NodeData : PVstNetworkData;
begin
  FileNode := CreateInsertNode;
  NodeData := vstNetwork.GetNodeData( FileNode );
  NodeData.FilePath := Params.FilePath;
  NodeData.IsFile := Params.IsFile;
  NodeData.FileSize := Params.FileSize;
  NodeData.FileTime := Params.FileTime;
  NodeData.ShowName := MyFilePath.getFtpName( Params.FilePath );
  NodeData.ShowTime := DateTimeToStr( Params.FileTime );
  if Params.IsFile then
    NodeData.ShowSize := MySizeUtil.getStr( Params.FileSize )
  else
    NodeData.ShowSize := '';
  NodeData.ShowIcon := MyIcon.getPathIcon( Params.FilePath, Params.IsFile );
  NodeData.IsLocked := False;
end;

function TFaceNetworkDriverApi.ReadFileSize(FilePath: string): Int64;
var
  SelectNode : PVirtualNode;
  NodeData : PVstNetworkData;
begin
  SelectNode := ReadNode( FilePath );
  if not Assigned( SelectNode ) then
    Exit;
  NodeData := vstNetwork.GetNodeData( SelectNode );
  Result := NodeData.FileSize;
end;

function TFaceNetworkDriverApi.ReadFileTime(FilePath: string): TDateTime;
var
  SelectNode : PVirtualNode;
  NodeData : PVstNetworkData;
begin
  SelectNode := ReadNode( FilePath );
  if not Assigned( SelectNode ) then
    Exit;
  NodeData := vstNetwork.GetNodeData( SelectNode );
  Result := NodeData.FileTime;
end;

function TFaceNetworkDriverApi.ReadFocusePath: string;
var
  NodeData : PVstNetworkData;
begin
  Result := '';
  if not Assigned( vstNetwork.FocusedNode ) then
    Exit;
  NodeData := vstNetwork.GetNodeData( vstNetwork.FocusedNode );
  Result := NodeData.FilePath;
end;

function TFaceNetworkDriverApi.ReadIsExist(FilePath: string): Boolean;
begin
  Result := Assigned( ReadNode( FilePath ) );
end;

function TFaceNetworkDriverApi.ReadIsFile(FilePath: string): Boolean;
var
  SelectNode : PVirtualNode;
  NodeData : PVstNetworkData;
begin
  SelectNode := ReadNode( FilePath );
  if not Assigned( SelectNode ) then
    Exit;
  NodeData := vstNetwork.GetNodeData( SelectNode );
  Result := NodeData.IsFile;
end;

function TFaceNetworkDriverApi.ReadNode(FilePath: string): PVirtualNode;
var
  SelectNode : PVirtualNode;
  NodeData : PVstNetworkData;
begin
  Result := nil;

  SelectNode := vstNetwork.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstNetwork.GetNodeData( SelectNode );
    if NodeData.FilePath = FilePath then
    begin
      Result := SelectNode;
      Break;
    end;
    SelectNode := SelectNode.NextSibling;
  end;
end;

function TFaceNetworkDriverApi.ReadPathList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstNetworkData;
begin
  Result := TStringList.Create;
  SelectNode := vstNetwork.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstNetwork.GetNodeData( SelectNode );
    if not NodeData.IsLocked then
      Result.Add( NodeData.FilePath );
    SelectNode := SelectNode.NextSibling;
  end;
end;

function TFaceNetworkDriverApi.ReadSelectList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstNetworkData;
begin
  Result := TStringList.Create;
  SelectNode := vstNetwork.GetFirstSelected;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstNetwork.GetNodeData( SelectNode );
    if not NodeData.IsLocked then
      Result.Add( NodeData.FilePath );
    SelectNode := vstNetwork.GetNextSelected( SelectNode );
  end;
end;

procedure TFaceNetworkDriverApi.Remove(FilePath: string);
var
  SelectNode : PVirtualNode;
begin
  SelectNode := ReadNode( FilePath );
  if not Assigned( SelectNode ) then
    Exit;
  vstNetwork.DeleteNode( SelectNode );
end;

procedure TFaceNetworkDriverApi.Search(FileName: string);
var
  SelectNode : PVirtualNode;
  NodeData : PVstLocalData;
  IsVisible, IsSearchAll : Boolean;
begin
  FileName := LowerCase( FileName );
  IsSearchAll := FileName = '';

  SelectNode := vstNetwork.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstNetwork.GetNodeData( SelectNode );
    IsVisible := IsSearchAll or NodeData.IsLocked or
                 ( Pos( FileName, LowerCase( string( NodeData.ShowName ) ) ) > 0 );
    vstNetwork.IsVisible[ SelectNode ] := IsVisible;
    SelectNode := SelectNode.NextSibling;
  end;

    // ȫѡ
  if IsSearchAll then
    Exit;

    // Ĭ��ѡ���һ��
  SelectNode := vstNetwork.GetFirstVisible;
  if not Assigned( SelectNode ) then
    Exit;
  NodeData := vstNetwork.GetNodeData( SelectNode );
  if NodeData.IsLocked then
  begin
    SelectNode := vstNetwork.GetNextVisible( SelectNode );
    if not Assigned( SelectNode ) then
      Exit;
  end;
  vstNetwork.Selected[ SelectNode ] := True;
  vstNetwork.FocusedNode := SelectNode;
end;

procedure TFaceNetworkDriverApi.Select(FilePath: string);
var
  SelectNode : PVirtualNode;
begin
  SelectNode := ReadNode( FilePath );
  if not Assigned( SelectNode ) then
    Exit;
  vstNetwork.Selected[ SelectNode ] := True;
  vstNetwork.FocusedNode := SelectNode;
end;

{ TFaceFrameDriverApi }

procedure TFaceFrameDriverApi.Activate(_FrameDriver: TFrameDriver);
begin
  FrameDriver := _FrameDriver;
  FaceLocalDriverApi.Activate( FrameDriver.vstLocal );
  FaceNetworkDriverApi.Activate( FrameDriver.vstNetwork );
  FaceLocalStatusApi.Activate( FrameDriver.plLocalStatus, FrameDriver.sbLocalStatus );
  FaceNetworkStatusApi.Activate( FrameDriver );
  FaceFileJobApi.Activate( FrameDriver.vstFileJob, FrameDriver.plBottom );
  FaceLocalHistoryApi.Activate( FrameDriver.vstLocalHistory, FrameDriver.slLocalHistory );
end;

function TFaceFrameDriverApi.ReadLocalPath: string;
begin
  Result := FrameDriver.LocalPath;
end;

function TFaceFrameDriverApi.ReadLocalSerach: string;
begin
  Result := FrameDriver.edtLocalSearch.Text;
end;

function TFaceFrameDriverApi.ReadNetworkPath: string;
begin
  Result := FrameDriver.NetworkPath;
end;

function TFaceFrameDriverApi.ReadNetworkSerach: string;
begin
  Result := FrameDriver.edtNetworkSearch.Text;
end;

procedure TFaceFrameDriverApi.SetLocalPath(LocalPath: string);
begin
  FrameDriver.SetLocalPath( LocalPath );
end;

procedure TFaceFrameDriverApi.SetNetworkPath(NetworkPath: string);
begin
  FrameDriver.SetNetworkPath( NetworkPath );
end;

procedure TFaceFrameDriverApi.UnvisibleLocalSearch;
begin
  FrameDriver.edtLocalSearch.Visible := False;
end;

procedure TFaceFrameDriverApi.UnvisibleNetworkSearch;
begin
  FrameDriver.edtNetworkSearch.Visible := False;
end;

{ UserLocalDriverApi }

class procedure UserLocalDriverApi.AddFile(ControlPath, FilePath: string);
var
  Params : TFileAddParams;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ҳ���ѱ仯
  if FaceFrameDriverApi.ReadLocalPath <> ExtractFileDir( FilePath ) then
    Exit;

    // �Ѵ��ڣ�����ɾ��
  if FaceLocalDriverApi.ReadIsExist( FilePath ) then
    FaceLocalDriverApi.Remove( FilePath );

    // �����ļ�
  Params.FilePath := FilePath;
  Params.IsFile := FileExists( FilePath );
  if Params.IsFile then
  begin
    Params.FileSize := MyFileInfo.getFileSize( FilePath );
    Params.FileTime := MyFileInfo.getFileTime( FilePath );
  end;
  FaceLocalDriverApi.Insert( Params );

    // ѡ���ļ�
  FaceLocalDriverApi.Select( FilePath );
end;

class procedure UserLocalDriverApi.CancelSelect(ControlPath: string);
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ȡ��ѡ��
  FaceLocalDriverApi.CancelSelect;
end;

class function UserLocalDriverApi.ControlPage(ControlPath: string): Boolean;
begin
  Result := FacePageDriverApi.ControlPage( ControlPath );
end;

class procedure UserLocalDriverApi.CopyFile(ControlPath: string);
var
  PathList : TStringList;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // �����ļ�
  PathList := FaceLocalDriverApi.ReadSelectList;
  CopyNow( ControlPath, PathList );
  PathList.Free;
end;

class procedure UserLocalDriverApi.CopyNow(ControlPath: string;
  PathList : TStringList);
var
  DesFolder, LocalFolder : string;
  FileCopyHandle : TLocalFileCopyHandle;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ȡ��Ŀ��ѡ��
  FaceNetworkDriverApi.CancelSelect;

    // ����Ŀ¼·��
  DesFolder := FaceFrameDriverApi.ReadNetworkPath;

    // �����ļ�
  FileCopyHandle := TLocalFileCopyHandle.Create( PathList, DesFolder );
  FileCopyHandle.SetControlPath( ControlPath );
  FileCopyHandle.Update;
  FileCopyHandle.Free;

    // ��¼��ʷ��Ϣ
  if PathList.Count > 0 then
    LocalFolder := ExtractFileDir( PathList[0] )
  else
    LocalFolder := FaceFrameDriverApi.ReadLocalPath;
  if not MyFilePath.getIsRoot( LocalFolder ) and DirectoryExists( LocalFolder ) then
    UserLocalHistoryApi.AddHistory( ControlPath, LocalFolder );
end;

class procedure UserLocalDriverApi.DeleteFile(ControlPath: string);
var
  PathList : TStringList;
  i: Integer;
  FilePath, ActionID : string;
begin
    // ɾ��ȷ��
  if MessageDlg( DeleteFile_Comfirm, mtConfirmation, [mbYes, mbNo], 0 ) <> mrYes then
    Exit;

    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // �����ļ�
  PathList := FaceLocalDriverApi.ReadSelectList;
  for i := 0 to PathList.Count - 1 do
  begin
    FilePath := PathList[i];
    ActionID := FaceFileJobApi.AddFileJob( FilePath, ActionType_Delete );
    MyFileJobHandler.FleDelete( FilePath, ControlPath, ActionID );
  end;
  PathList.Free;
end;

class procedure UserLocalDriverApi.EnterFolder(FolderPath, ControlPath: string);
var
  IsHistoryShow : Boolean;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ���ñ���·��
  FaceFrameDriverApi.SetLocalPath( FolderPath );

    // ��ʾ״̬·��
  FaceLocalStatusApi.ShowPath( FolderPath );

    // �����ļ�
  MyFaceJobHandler.RefreshLocalDriver( FolderPath, ControlPath );

    // ���ر�������
  FaceFrameDriverApi.UnvisibleLocalSearch;

    // ����
  MyFileWatch.SetLocalPath( FolderPath );

    // ������ʷ�Ƿ���ӻ�
  IsHistoryShow := ( FolderPath = '' ) and ( FaceLocalHistoryApi.ReadHistoryCount > 0 );
  FaceLocalHistoryApi.SetVisible( IsHistoryShow );
end;

class procedure UserLocalDriverApi.NewFolder(ControlPath: string);
var
  LocalFolder, FolderName, NewFolderPath : string;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

  LocalFolder := FaceFrameDriverApi.ReadLocalPath;
  FolderName := NewFolder_DefaultName;
  FolderName := MyFilePath.getRenamePath( MyFilePath.getPath( LocalFolder ) + FolderName, False );
  FolderName := ExtractFileName( FolderName );

    // ����������
  if not InputQuery( NewFolder_Title, NewFolder_Name, FolderName ) then
    Exit;

    // ��·��
  NewFolderPath := MyFilePath.getPath( LocalFolder ) + FolderName;

    // �Ѵ�����ȡ��
  if MyFilePath.getIsExist( NewFolderPath, False ) then
  begin
    MyMessageForm.ShowWarnning( Rename_Exist );
    NewFolder( ControlPath );
    Exit;
  end;

    // �����ļ���
  ForceDirectories( NewFolderPath );
  FaceLocalDriverApi.CancelSelect;
  AddFile( ControlPath, NewFolderPath );
end;

class function UserLocalDriverApi.ReadFileList(
  ControlPath: string): TStringList;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
  begin
    Result := TStringList.Create;
    Exit;
  end;

  Result := FaceLocalDriverApi.ReadPathList;
end;

class procedure UserLocalDriverApi.RefreshFolder(ControlPath: string);
var
  LocalFolder : string;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ˢ�µ�ǰĿ¼
  LocalFolder := FaceFrameDriverApi.ReadLocalPath;
  EnterFolder( LocalFolder, ControlPath );
end;

class procedure UserLocalDriverApi.RemoveFile(ControlPath, FilePath: string);
var
  Params : TFileAddParams;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ҳ���ѱ仯
  if FaceFrameDriverApi.ReadLocalPath <> ExtractFileDir( FilePath ) then
    Exit;

    // ���ڣ���ɾ��
  if FaceLocalDriverApi.ReadIsExist( FilePath ) then
    FaceLocalDriverApi.Remove( FilePath );
end;

class procedure UserLocalDriverApi.RenameFile(ControlPath: string);
var
  OldPath, NewName, NewPath : string;
  fo: TSHFILEOPSTRUCT;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ��ȡѡ���·��
  OldPath := FaceLocalDriverApi.ReadFocusePath;
  NewName := ExtractFileName( OldPath );

    // ����������
  if not InputQuery( Rename_Title, Rename_Name, NewName ) then
    Exit;

    // û�к�׺
  if ExtractFileExt( NewName ) = '' then
    NewName := NewName + ExtractFileExt( OldPath );

    // ��·��
  NewPath := ExtractFilePath( OldPath ) + NewName;

    // �Ѵ�����ȡ��
  if MyFilePath.getIsExist( NewPath, FileExists( OldPath ) ) then
  begin
    if NewPath <> OldPath then
    begin
      MyMessageForm.ShowWarnning( Rename_Exist );
      RenameFile( ControlPath );
    end;
    Exit;
  end;

    // ������
  FillChar(fo, SizeOf(fo), 0);
  with fo do
  begin
    Wnd := 0;
    wFunc := FO_RENAME;
    pFrom := PChar( OldPath + #0);
    pTo := PChar( NewPath + #0);
    fFlags := FOF_NOCONFIRMATION + FOF_NOCONFIRMMKDIR;
  end;
  if SHFileOperation(fo)=0 then
  begin
    RemoveFile( ControlPath, OldPath );
    AddFile( ControlPath, NewPath );
  end;
end;

class procedure UserLocalDriverApi.SearchFile(ControlPath: string);
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ����
  FaceLocalDriverApi.Search( FaceFrameDriverApi.ReadLocalSerach );
end;

class procedure UserLocalDriverApi.Select(ControlPath, FilePath: string);
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

  FaceLocalDriverApi.Select( FilePath );
end;

class procedure UserLocalDriverApi.ZipFile(ControlPath: string);
var
  SelectPathList : TStringList;
  LocalFolder, ZipPath : string;
  Params : TFileZipParams;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ��ȡѡ����ļ�·��
  SelectPathList := FaceLocalDriverApi.ReadSelectList;

    // Ŀ¼·��
  LocalFolder := FaceFrameDriverApi.ReadLocalPath;

    // ѹ����Ŀ��·��
  if SelectPathList.Count = 1 then
  begin
    ZipPath := SelectPathList[0];
    if FileExists( ZipPath ) then
      ZipPath := MyFilePath.getPath( LocalFolder ) + TPath.GetFileNameWithoutExtension( ZipPath );
  end
  else
    ZipPath := MyFilePath.getPath( LocalFolder ) + Compressed_NewName;
  ZipPath := ZipPath + '.zip';
  ZipPath := MyFilePath.getRenamePath( ZipPath, True );

    // ѹ������
  Params.LocalPathList := SelectPathList;
  Params.ZipPath := ZipPath;
  Params.ControlPath := ControlPath;
  if SelectPathList.Count > 0 then
    Params.ActionID := FaceFileJobApi.AddFileJob( SelectPathList[0], ActionType_Zip );

    // ����ѹ��
  MyFileJobHandler.FileZip( Params );
end;

{ UserNeworkDriverApi }

class procedure UserNetworkDriverApi.AddFile( AddParams : TNetworkAddParams );
var
  Params : TFileAddParams;
begin
    // ҳ�治����
  if not ControlPage( AddParams.ControlPath ) then
    Exit;

    // ҳ���ѱ仯
  if FaceFrameDriverApi.ReadNetworkPath <> MyFilePath.getFtpDir( AddParams.FilePath ) then
    Exit;

    // �Ѵ��ڣ�����ɾ��
  if FaceNetworkDriverApi.ReadIsExist( AddParams.FilePath ) then
    FaceNetworkDriverApi.Remove( AddParams.FilePath );

    // �����ļ�
  Params.FilePath := AddParams.FilePath;
  Params.IsFile := AddParams.IsFile;
  Params.FileTime := AddParams.FileTime;
  if Params.IsFile then
    Params.FileSize := AddParams.FileSize;
  FaceNetworkDriverApi.Insert( Params );

    // ѡ���ļ�
  FaceNetworkDriverApi.Select( AddParams.FilePath );
end;

class procedure UserNetworkDriverApi.CancelSelect(ControlPath: string);
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ȡ��ѡ��
  FaceNetworkDriverApi.CancelSelect;
end;

class function UserNetworkDriverApi.ControlPage(ControlPath: string): Boolean;
begin
  Result := FacePageDriverApi.ControlPage( ControlPath );
end;

class procedure UserNetworkDriverApi.CopyFile(ControlPath: string);
var
  PathList : TStringList;
  i: Integer;
  DesFolder : string;
  FileCopyHandle : TNetworkFileCopyHandle;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ȡ��Ŀ��ѡ��
  FaceLocalDriverApi.CancelSelect;

    // ����Ŀ¼·��
  DesFolder := FaceFrameDriverApi.ReadLocalPath;

    // �����ļ�
  PathList := FaceNetworkDriverApi.ReadSelectList;
  FileCopyHandle := TNetworkFileCopyHandle.Create( PathList, DesFolder );
  FileCopyHandle.SetControlPath( ControlPath );
  FileCopyHandle.Update;
  FileCopyHandle.Free;
  PathList.Free;

    // ��ӵ���ʷ
  if DirectoryExists( DesFolder ) then
    UserLocalHistoryApi.AddHistory( ControlPath, DesFolder );
end;

class procedure UserNetworkDriverApi.DeleteFile(ControlPath: string);
var
  PathList : TStringList;
  i: Integer;
  FilePath, ActionID : string;
begin
    // ɾ��ȷ��
  if MessageDlg( DeleteFile_Comfirm, mtConfirmation, [mbYes, mbNo], 0 ) <> mrYes then
    Exit;

    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ɾ���ļ�
  PathList := FaceNetworkDriverApi.ReadSelectList;
  for i := 0 to PathList.Count - 1 do
  begin
    FilePath := PathList[i];
    ActionID := FaceFileJobApi.AddFileJob( FilePath, ActionType_Delete );
    if FaceNetworkDriverApi.ReadIsFile( FilePath ) then
      MyFileJobHandler.FtpFileDelete( ControlPath, FilePath, ActionID )
    else
      MyFileJobHandler.FtpFolderDelete( ControlPath, FilePath, ActionID );
  end;
  PathList.Free;
end;

class procedure UserNetworkDriverApi.EnterFolder(FolderPath,
  ControlPath: string);
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ��������·��
  FaceFrameDriverApi.SetNetworkPath( FolderPath );

    // ��ʾ���ڼ���
  FaceNetworkStatusApi.ShowIsLoading;

    // ��ʾ״̬
  FaceNetworkStatusApi.ShowPath( FolderPath );

    // �����ļ�
  MyFaceJobHandler.RefreshNetworkDriver( FolderPath, ControlPath );

    // ������������
  FaceFrameDriverApi.UnvisibleNetworkSearch;
end;

class procedure UserNetworkDriverApi.NewFolder(ControlPath: string);
var
  NetworkFolder, FolderName, NewFolderPath : string;
  ActionID : string;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

  NetworkFolder := FaceFrameDriverApi.ReadNetworkPath;
  FolderName := NewFolder_DefaultName;
  FolderName := ReadRenamePath( MyFilePath.getFtpPath( NetworkFolder ) + FolderName, False );
  FolderName := MyFilePath.getFtpName( FolderName );

    // ����������
  if not InputQuery( NewFolder_Title, NewFolder_Name, FolderName ) then
    Exit;

    // ��·��
  NewFolderPath := MyFilePath.getFtpPath( NetworkFolder ) + FolderName;

    // �Ѵ�����ȡ��
  if FaceNetworkDriverApi.ReadIsExist( NewFolderPath ) then
  begin
    MyMessageForm.ShowWarnning( Rename_Exist );
    NewFolder( ControlPath );
    Exit;
  end;

    // �����ļ���
  ActionID := FaceFileJobApi.AddFileJob( NewFolderPath, ActionType_NewFolder );
  MyFileJobHandler.FtpNewFolder( ControlPath, NewFolderPath, ActionID );
end;

class function UserNetworkDriverApi.ReadFileList(
  ControlPath: string): TStringList;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
  begin
    Result := TStringList.Create;
    Exit;
  end;

  Result := FaceNetworkDriverApi.ReadPathList;
end;

class function UserNetworkDriverApi.ReadIsExist(ControlPath,
  FilePath: string): Boolean;
begin
  Result := False;

    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

  Result := FaceNetworkDriverApi.ReadIsExist( FilePath );
end;

class function UserNetworkDriverApi.ReadIsFile(ControlPath,
  FilePath: string): Boolean;
begin
  Result := False;

    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

  Result := FaceNetworkDriverApi.ReadIsFile( FilePath );
end;

class function UserNetworkDriverApi.ReadFileSize(ControlPath,
  FilePath: string): Int64;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

  Result := FaceNetworkDriverApi.ReadFileSize( FilePath );
end;

class function UserNetworkDriverApi.ReadFileTime(ControlPath,
  FilePath: string): TDateTime;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

  Result := FaceNetworkDriverApi.ReadFileTime( FilePath );
end;

class function UserNetworkDriverApi.ReadRenamePath(Path: string;IsFile: Boolean): string;
var
  FileNum : Integer;
begin
  FileNum := 1;
  Result := Path;
  if IsFile then
  begin
    while True do
    begin
      if not FaceNetworkDriverApi.ReadIsExist( Result ) then
        Break;
      Result := MyFilePath.getFtpPath( MyFilePath.getFtpDir( Path ) ) +  TPath.GetFileNameWithoutExtension( Path ) + '('+ IntToStr(FileNum) + ')' + ExtractFileExt( Path );
      Inc( FileNum );
    end;
  end
  else
  begin
    while True do
    begin
      if not FaceNetworkDriverApi.ReadIsExist( Result ) then
        Break;
      Result := Path + '('+ IntToStr(FileNum) + ')';
      Inc( FileNum );
    end;
  end;
end;

class procedure UserNetworkDriverApi.RefreshFolder(ControlPath: string);
var
  NetworkFolder : string;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ˢ�µ�ǰĿ¼
  NetworkFolder := FaceFrameDriverApi.ReadNetworkPath;
  EnterFolder( NetworkFolder, ControlPath );
end;

class procedure UserNetworkDriverApi.RemoveFile(ControlPath, FilePath: string);
var
  Params : TFileAddParams;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ҳ���ѱ仯
  if FaceFrameDriverApi.ReadNetworkPath <> MyFilePath.getFtpDir( FilePath ) then
    Exit;

    // ���ڣ���ɾ��
  if FaceNetworkDriverApi.ReadIsExist( FilePath ) then
    FaceNetworkDriverApi.Remove( FilePath );
end;

class procedure UserNetworkDriverApi.RenameFile(ControlPath: string);
var
  OldPath, NewName, NewPath, ActionID : string;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ��ȡѡ���·��
  OldPath := FaceNetworkDriverApi.ReadFocusePath;
  NewName := MyFilePath.getFtpName( OldPath );

    // ����������
  if not InputQuery( Rename_Title, Rename_Name, NewName ) then
    Exit;

    // û�к�׺
  if ExtractFileExt( NewName ) = '' then
    NewName := NewName + ExtractFileExt( OldPath );

    // ��·��
  NewPath := MyFilePath.getFtpDir( OldPath ) + NewName;

    // �Ѵ�����ȡ��
  if FaceNetworkDriverApi.ReadIsExist( NewPath ) then
  begin
    if NewPath <> OldPath then
    begin
      MyMessageForm.ShowWarnning( Rename_Exist );
      RenameFile( ControlPath );
    end;
    Exit;
  end;

    // ������
  ActionID := FaceFileJobApi.AddFileJob( OldPath, ActionType_Rename );
  MyFileJobHandler.FtpRename( ControlPath, OldPath, NewName, ActionID );
end;

class procedure UserNetworkDriverApi.SearchFile(ControlPath: string);
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

  FaceNetworkDriverApi.Search( FaceFrameDriverApi.ReadNetworkSerach );
end;

class procedure UserNetworkDriverApi.Select(ControlPath, FilePath: string);
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

  FaceNetworkDriverApi.Select( FilePath );
end;

{ TFaceLocalStatusApi }

procedure TFaceLocalStatusApi.Activate(_plLocalStatus : TPanel;
  _sbLocalStatus : TSpeedButton);
begin
  plLocalStatus := _plLocalStatus;
  sbLocalStatus := _sbLocalStatus;
end;

procedure TFaceLocalStatusApi.ShowPath(FolderPath: string);
var
  ShowStr : string;
begin
  if FolderPath = '' then
    ShowStr := Caption_MyComputer
  else
    ShowStr := FolderPath;
  plLocalStatus.Caption := ShowStr;
  sbLocalStatus.Caption := ShowStr;
end;

{ TFaceNetworkStatusApi }

procedure TFaceNetworkStatusApi.Activate( FrameDriver : TFrameDriver );
begin
  plNetworkStatus := FrameDriver.plNetworkStatus;
  sbNetworkStatus := FrameDriver.sbNetworkStatus;

  PcNetworkStatus := FrameDriver.PcNetworkStatus;
  tsNetworkStatus := FrameDriver.tsNetworkStatus;
  tsNetworkLoading := FrameDriver.tsNetworkLoading;
end;

procedure TFaceNetworkStatusApi.HideIsLoading;
begin
  PcNetworkStatus.ActivePage := tsNetworkStatus;
end;

procedure TFaceNetworkStatusApi.ShowIsLoading;
begin
  PcNetworkStatus.ActivePage := tsNetworkLoading;
end;

procedure TFaceNetworkStatusApi.ShowPath(FolderPath: string);
begin
  plNetworkStatus.Caption := FolderPath;
  sbNetworkStatus.Caption := FolderPath;
end;

{ TFaceFileJobApi }

procedure TFaceFileJobApi.Activate(_vstFileJob: TVirtualStringTree;
  _PlFileJob : TPanel);
begin
  vstFileJob := _vstFileJob;
  PlFileJob := _PlFileJob;
end;

function TFaceFileJobApi.AddFileJob(FilePath, ActionType: string): string;
var
  FileJobNode : PVirtualNode;
  NodeData : PVstFileJobData;
  ActionName : string;
  ActionIcon : Integer;
begin
  Result := '';
  if not MyFileJobHandler.ReadIsRunning then
    Exit;

    // �ڵ�����
  if ActionType = ActionType_CopyLeft then
  begin
    ActionName := AcionTypeShow_Copy;
    ActionIcon := My16IconUtil.getLeft;
  end
  else
  if ActionType = ActionType_CopyRight then
  begin
    ActionName := AcionTypeShow_Copy;
    ActionIcon := My16IconUtil.getRight;
  end
  else
  if ActionType = ActionType_Delete then
  begin
    ActionName := AcionTypeShow_Delete;
    ActionIcon := My16IconUtil.getDelete;
  end
  else
  if ActionType = ActionType_Zip then
  begin
    ActionName := AcionTypeShow_Zip;
    ActionIcon := My16IconUtil.getZip;
  end
  else
  if ActionType = ActionType_Rename then
  begin
    ActionName :=  AcionTypeShow_Rename;
    ActionIcon := My16IconUtil.getRename;
  end
  else
  if ActionType = ActionType_NewFolder then
  begin
    ActionName :=  AcionTypeShow_NewFolder;
    ActionIcon := My16IconUtil.getNewFolder;
  end;

    // ��ӽڵ�
  FileJobNode := vstFileJob.AddChild( vstFileJob.RootNode );
  NodeData := vstFileJob.GetNodeData( FileJobNode );
  NodeData.FilePath := FilePath;
  NodeData.ActionType := ActionType;
  NodeData.ShowName := MyFilePath.getFtpName( FilePath );
  NodeData.ShowIcon := MyIcon.getPathIcon( FilePath );
  NodeData.ActionName := ActionName;
  NodeData.ActionIcon := ActionIcon;
  NodeData.ActionID := IntToStr( FileJob_ActionID );

    // ActionID
  Result := NodeData.ActionID;
  Inc( FileJob_ActionID );

    // ��ʾ
  PlFileJob.Visible := True;
end;

function TFaceFileJobApi.ReadNode(ActionID: string): PVirtualNode;
var
  SelectNode : PVirtualNode;
  NodeData : PVstFileJobData;
begin
  Result := nil;

  SelectNode := vstFileJob.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFileJob.GetNodeData( SelectNode );
    if NodeData.ActionID = ActionID then
    begin
      Result := SelectNode;
      Break;
    end;
    SelectNode := SelectNode.NextSibling;
  end;
end;

procedure TFaceFileJobApi.RemoveFileJob(ActionID: string);
var
  SelectNode : PVirtualNode;
begin
  SelectNode := ReadNode( ActionID );
  if not Assigned( SelectNode ) then
    Exit;
  vstFileJob.DeleteNode( SelectNode );

  if vstFileJob.RootNode.ChildCount = 0 then
    PlFileJob.Visible := False;
end;

{ UserFrameDriverApi }

class function UserFrameDriverApi.ControlPage(ControlPath: string): Boolean;
begin
  Result := FacePageDriverApi.ControlPage( ControlPath );
end;

class procedure UserFrameDriverApi.LoadIni(ControlPath: string;
  IniFile : TIniFile; FrameIndex : Integer);
var
  FrameCaption : string;
  LocalFolder, NetworkFolder : string;
  HistoryCount : Integer;
  i: Integer;
  LocalHistory : string;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ��ȡ
  FrameCaption := Ini_FrameDriver + IntToStr( FrameIndex );
  LocalFolder := IniFile.ReadString( FrameCaption, Ini_LocalFolder, FaceFrameDriverApi.ReadLocalPath );
  NetworkFolder := IniFile.ReadString( FrameCaption, Ini_NetworkFolder, FaceFrameDriverApi.ReadNetworkPath );
  FaceFrameDriverApi.FrameDriver.plRight.Width := IniFile.ReadInteger( FrameCaption, Ini_LocalWidth, FaceFrameDriverApi.FrameDriver.plRight.Width );
  FaceLocalHistoryApi.vstLocalHistory.Height := IniFile.ReadInteger( FrameCaption, Ini_LocalHistoryHeigh, FaceLocalHistoryApi.vstLocalHistory.Height );

    // ����
  FaceFrameDriverApi.SetLocalPath( LocalFolder );
  FaceFrameDriverApi.SetNetworkPath( NetworkFolder );

    // ��ȡ������ʷ
  HistoryCount := IniFile.ReadInteger( FrameCaption, Ini_LocalHistoryCount, 0 );
  for i := HistoryCount - 1 downto 0 do
  begin
    LocalHistory := IniFile.ReadString( FrameCaption, Ini_LocalHistory + IntToStr( i ), '' );
    if LocalHistory <> '' then
      FaceLocalHistoryApi.Add( LocalHistory );
  end;
end;

class procedure UserFrameDriverApi.SaveIni(ControlPath: string;
  IniFile : TIniFile; FrameIndex : Integer);
var
  FrameCaption : string;
  HistoryList : TStringList;
  i: Integer;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ���洰����Ϣ
  FrameCaption := Ini_FrameDriver + IntToStr( FrameIndex );
  IniFile.WriteString( FrameCaption, Ini_LocalFolder, FaceFrameDriverApi.ReadLocalPath );
  IniFile.WriteString( FrameCaption, Ini_NetworkFolder, FaceFrameDriverApi.ReadNetworkPath );
  IniFile.WriteInteger( FrameCaption, Ini_LocalWidth, FaceFrameDriverApi.FrameDriver.plRight.Width );
  IniFile.WriteInteger( FrameCaption, Ini_LocalHistoryHeigh, FaceLocalHistoryApi.vstLocalHistory.Height );

    // ���汾����ʷ
  HistoryList := FaceLocalHistoryApi.ReadList;
  IniFile.WriteInteger( FrameCaption, Ini_LocalHistoryCount, HistoryList.Count );
  for i := 0 to HistoryList.Count - 1 do
    IniFile.WriteString( FrameCaption, Ini_LocalHistory + IntToStr( i ), HistoryList[i] );
  HistoryList.Free;
end;

class procedure UserFrameDriverApi.SelectFrame(ControlPath: string);
var
  LocalPath : string;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ����·��
  LocalPath := FaceFrameDriverApi.ReadLocalPath;
  MyFileWatch.SetPath( ControlPath, LocalPath );
end;

{ TFileCopyHandle }

function TLocalFileCopyHandle.ConfirmConflict: Boolean;
var
  i : Integer;
  TargetFolder : string;
  SourcePath, TargetPath : string;
  ActionType, DesPath : string;
begin
    // �����ͻ·��
  frmConflict.ClearConflictPaths;
  TargetFolder := MyFilePath.getFtpPath( DesFolder );
  for i := 0 to SourceList.Count - 1 do
  begin
    SourcePath := SourceList[i];
    TargetPath := TargetFolder + ExtractFileName( SourcePath );
    if UserNetworkDriverApi.ReadIsExist( ControlPath, TargetPath ) then
      frmConflict.AddConflictPath( SourcePath );
  end;
  Result := frmConflict.ReadConflict;

    // ȡ������
  if not Result then
    Exit;

    // ����Ŀ��·��
  CopyPathList.Clear;
  for i := 0 to SourceList.Count - 1 do
  begin
    SourcePath := SourceList[i];
    ActionType := frmConflict.ReadConflictAction( SourcePath );
    if ( ActionType = ConflictAction_None ) or ( ActionType = ConflictAction_Replace ) then
      DesPath := TargetFolder + ExtractFileName( SourcePath )
    else
    if ActionType = ConflictAction_Rename then
    begin
      DesPath := TargetFolder + ExtractFileName( SourcePath );
      DesPath := UserNetworkDriverApi.ReadRenamePath( DesPath, FaceNetworkDriverApi.ReadIsFile( DesPath ) );
    end
    else
    if ActionType = ConflictAction_Cancel then
      Continue;
    CopyPathList.Add( TCopyPathInfo.Create( SourcePath, DesPath ) );
  end;
end;

procedure TLocalFileCopyHandle.CopyHandle;
var
  i: Integer;
  Params : TFileCopyParams;
begin
  Params.ControlPath := ControlPath;
  for i := 0 to CopyPathList.Count - 1 do
  begin
    Params.LocalPath := CopyPathList[i].SourcePath;
    Params.RemotePath := CopyPathList[i].DesPath;
    Params.ActionID := FaceFileJobApi.AddFileJob( Params.LocalPath, ActionType_CopyLeft );
    MyFileJobHandler.FleCopy( Params );
  end;
end;

constructor TLocalFileCopyHandle.Create(_SourceFileList : TStringList; _DesFolder : string);
begin
  SourceList := _SourceFileList;
  DesFolder := _DesFolder;
  CopyPathList := TCopyPathList.Create;
end;

destructor TLocalFileCopyHandle.Destroy;
begin
  CopyPathList.Free;
  inherited;
end;

function TLocalFileCopyHandle.IsExistConflict: Boolean;
var
  i : Integer;
  TargetFolder : string;
  SourcePath, TargetPath : string;
begin
  Result := False;
  TargetFolder := MyFilePath.getFtpPath( DesFolder );
  for i := 0 to SourceList.Count - 1 do
  begin
    SourcePath := SourceList[i];
    TargetPath := TargetFolder + ExtractFileName( SourcePath );
    if UserNetworkDriverApi.ReadIsExist( ControlPath, TargetPath ) then
    begin
      Result := True;
      Break;
    end;
    CopyPathList.Add( TCopyPathInfo.Create( SourcePath, TargetPath ) );
  end;
end;

procedure TLocalFileCopyHandle.SetControlPath(_ControlPath: string);
begin
  ControlPath := _ControlPath;
end;

procedure TLocalFileCopyHandle.Update;
begin
    // ���ͻȡ������
  if IsExistConflict and not ConfirmConflict then
    Exit;

    // �ļ�����
  CopyHandle;
end;

{ TCopyPathInfo }

constructor TCopyPathInfo.Create(_SourcePath, _DesPath: string);
begin
  SourcePath := _SourcePath;
  DesPath := _DesPath;
end;

{ TFileCopyHandle }

function TNetworkFileCopyHandle.ConfirmConflict: Boolean;
var
  i : Integer;
  TargetFolder : string;
  SourcePath, TargetPath : string;
  ActionType, DesPath : string;
  IsFile : Boolean;
begin
    // �����ͻ·��
  frmConflict.ClearConflictPaths;
  TargetFolder := MyFilePath.getPath( DesFolder );
  for i := 0 to SourceList.Count - 1 do
  begin
    SourcePath := SourceList[i];
    TargetPath := TargetFolder + MyFilePath.getFtpName( SourcePath );
    if FileExists( TargetPath ) or DirectoryExists( TargetPath ) then
    begin
      IsFile := UserNetworkDriverApi.ReadIsFile( ControlPath, SourcePath );
      frmConflict.AddFtpConflictPath( SourcePath, IsFile );
    end;
  end;
  Result := frmConflict.ReadConflict;

    // ȡ������
  if not Result then
    Exit;

    // ����Ŀ��·��
  CopyPathList.Clear;
  for i := 0 to SourceList.Count - 1 do
  begin
    SourcePath := SourceList[i];
    ActionType := frmConflict.ReadConflictAction( SourcePath );
    if ( ActionType = ConflictAction_None ) or ( ActionType = ConflictAction_Replace ) then
      DesPath := TargetFolder + MyFilePath.getFtpName( SourcePath )
    else
    if ActionType = ConflictAction_Rename then
    begin
      DesPath := TargetFolder + MyFilePath.getFtpName( SourcePath );
      DesPath := MyFilePath.getRenamePath( DesPath, FileExists( DesPath ) );
    end
    else
    if ActionType = ConflictAction_Cancel then
      Continue;
    CopyPathList.Add( TCopyPathInfo.Create( SourcePath, DesPath ) );
  end;
end;

procedure TNetworkFileCopyHandle.CopyHandle;
var
  i: Integer;
  Params : TFtpFileCopyParams;
begin
  Params.ControlPath := ControlPath;
  for i := 0 to CopyPathList.Count - 1 do
  begin
    Params.RemotePath := CopyPathList[i].SourcePath;
    Params.LocalPath := CopyPathList[i].DesPath;
    Params.ActionID := FaceFileJobApi.AddFileJob( CopyPathList[i].SourcePath, ActionType_CopyRight );
    Params.FileSize := UserNetworkDriverApi.ReadFileSize( ControlPath, CopyPathList[i].SourcePath );
    Params.IsFile := UserNetworkDriverApi.ReadIsFile( ControlPath, CopyPathList[i].SourcePath );
    MyFileJobHandler.FtpCopy( Params );
  end;
end;

constructor TNetworkFileCopyHandle.Create(_SourceFileList : TStringList; _DesFolder : string);
begin
  SourceList := _SourceFileList;
  DesFolder := _DesFolder;
  CopyPathList := TCopyPathList.Create;
end;

destructor TNetworkFileCopyHandle.Destroy;
begin
  CopyPathList.Free;
  inherited;
end;

function TNetworkFileCopyHandle.IsExistConflict: Boolean;
var
  i : Integer;
  TargetFolder : string;
  SourcePath, TargetPath : string;
begin
  Result := False;
  TargetFolder := MyFilePath.getPath( DesFolder );
  for i := 0 to SourceList.Count - 1 do
  begin
    SourcePath := SourceList[i];
    TargetPath := TargetFolder + MyFilePath.getFtpName( SourcePath );
    if FileExists( TargetPath ) or DirectoryExists( TargetPath ) then
    begin
      Result := True;
      Break;
    end;
    CopyPathList.Add( TCopyPathInfo.Create( SourcePath, TargetPath ) );
  end;
end;

procedure TNetworkFileCopyHandle.SetControlPath(_ControlPath: string);
begin
  ControlPath := _ControlPath;
end;

procedure TNetworkFileCopyHandle.Update;
begin
    // ���ͻȡ������
  if IsExistConflict and not ConfirmConflict then
    Exit;

    // �ļ�����
  CopyHandle;
end;

{ TFaceLocalHistoryApi }

procedure TFaceLocalHistoryApi.Activate(_vstLocalHistory: TVirtualStringTree;
  _slLocalHistory : TSplitter);
begin
  vstLocalHistory := _vstLocalHistory;
  slLocalHistory := _slLocalHistory;
end;

procedure TFaceLocalHistoryApi.Add(FolderPath: string);
var
  NewNode : PVirtualNode;
  NodeData : PVstLocalHistoryData;
begin
  NewNode := vstLocalHistory.InsertNode( vstLocalHistory.RootNode, amAddChildFirst );
  NodeData := vstLocalHistory.GetNodeData( NewNode );
  NodeData.FolderPath := FolderPath;
  NodeData.ShowName := ExtractFileName( FolderPath );
  NodeData.ShowDir := ExtractFileDir( FolderPath );
  NodeData.ShowIcon := MyIcon.getFolderIcon( FolderPath );
end;

procedure TFaceLocalHistoryApi.MoveToTop(FolderPath: string);
var
  SelectNode : PVirtualNode;
begin
  SelectNode := ReadNode( FolderPath );
  if not Assigned( SelectNode ) then
    Exit;

  vstLocalHistory.MoveTo( SelectNode, vstLocalHistory.RootNode, amAddChildFirst, False );
end;

function TFaceLocalHistoryApi.ReadHistoryCount: Integer;
begin
  Result := vstLocalHistory.RootNodeCount;
end;

function TFaceLocalHistoryApi.ReadIsExist(FolderPath: string): Boolean;
begin
  Result := Assigned( ReadNode( FolderPath ) );
end;

function TFaceLocalHistoryApi.ReadList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstLocalHistoryData;
begin
  Result := TStringList.Create;
  SelectNode := vstLocalHistory.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstLocalHistory.GetNodeData( SelectNode );
    Result.Add( NodeData.FolderPath );
    SelectNode := SelectNode.NextSibling;
  end;
end;

function TFaceLocalHistoryApi.ReadNode(FolderPath: string): PVirtualNode;
var
  SelectNode : PVirtualNode;
  NodeData : PVstLocalHistoryData;
begin
  Result := nil;

  SelectNode := vstLocalHistory.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstLocalHistory.GetNodeData( SelectNode );
    if NodeData.FolderPath = FolderPath then
    begin
      Result := SelectNode;
      Break;
    end;
    SelectNode := SelectNode.NextSibling;
  end;
end;


function TFaceLocalHistoryApi.ReadSelectList: TStringList;
var
  SelectNode : PVirtualNode;
  NodeData : PVstLocalHistoryData;
begin
  Result := TStringList.Create;
  SelectNode := vstLocalHistory.GetFirstSelected;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstLocalHistory.GetNodeData( SelectNode );
    Result.Add( NodeData.FolderPath );
    SelectNode := vstLocalHistory.GetNextSelected( SelectNode );
  end;
end;

procedure TFaceLocalHistoryApi.Remove(FolderPath: string);
var
  SelectNode : PVirtualNode;
begin
  SelectNode := ReadNode( FolderPath );
  if not Assigned( SelectNode ) then
    Exit;

  vstLocalHistory.DeleteNode( SelectNode );
end;

procedure TFaceLocalHistoryApi.RemoveLastNode;
var
  SelectNode : PVirtualNode;
begin
  SelectNode := vstLocalHistory.RootNode.LastChild;
  if not Assigned( SelectNode ) then
    Exit;
  vstLocalHistory.DeleteNode( SelectNode );
end;

procedure TFaceLocalHistoryApi.SetVisible(Isvisible: Boolean);
begin
  vstLocalHistory.Visible := Isvisible;
  slLocalHistory.Visible := Isvisible;
end;

{ UserLocalHistoryApi }

class procedure UserLocalHistoryApi.AddHistory(ControlPath, FolderPath: string);
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // �Ѵ��ڣ����ö�
  if FaceLocalHistoryApi.ReadIsExist( FolderPath ) then
  begin
    FaceLocalHistoryApi.MoveToTop( FolderPath );
    Exit;
  end;

    // �������ޣ���ɾ��
  if FaceLocalHistoryApi.ReadHistoryCount > 15 then
    FaceLocalHistoryApi.RemoveLastNode;

    // ���
  FaceLocalHistoryApi.Add( FolderPath );
end;

class function UserLocalHistoryApi.ControlPage(ControlPath: string): Boolean;
begin
  Result := FacePageDriverApi.ControlPage( ControlPath );
end;

class function UserLocalHistoryApi.ReadSelectList(
  ControlPath: string): TStringList;
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
  begin
    Result := TStringList.Create;
    Exit;
  end;

  Result := FaceLocalHistoryApi.ReadSelectList;
end;

class procedure UserLocalHistoryApi.RemoveHistory(ControlPath,
  FolderPath: string);
begin
    // ҳ�治����
  if not ControlPage( ControlPath ) then
    Exit;

    // ɾ��
  FaceLocalHistoryApi.Remove( FolderPath );
end;

end.

