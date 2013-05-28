unit UFormConflict;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, VirtualTrees, Vcl.StdCtrls;

type
  TfrmConflict = class(TForm)
    vstFileList: TVirtualStringTree;
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure vstFileListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstFileListGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstFileListChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure vstFileListFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
  private
    { Private declarations }
  public
    procedure ClearConflictPaths;
    procedure AddConflictPath( Path : string );
    procedure AddFtpConflictPath( Path : string; IsFile : Boolean );
    function ReadConflict : Boolean;
    function ReadConflictAction( Path : string ): string;
  end;

    // ���ݽṹ
  TVstConflictData = record
  public
    FilePath : WideString;
    IsFolder : Boolean;
  public
    IsAdd : Boolean;
    ActionType : WideString;
  public
    ShowName : WideString;
    ShowIcon : Integer;
  end;
  PVstConflictData = ^TVstConflictData;

var
  ConflictActionShow_Replace : string = '���ƺ��滻���滻Ŀ���ļ��е��ļ�';
  ConflictActionShow_Rename : string = '�����������ڸ��Ƶ��ļ���������';
  ConflictActionShow_Cancel : string = 'ȡ��������������κ��ļ�';

const
  ConflictAction_None = 'None';
  ConflictAction_Replace = 'Replace';
  ConflictAction_Rename = 'Rename';
  ConflictAction_Cancel = 'Cancel';

var
  frmConflict: TfrmConflict;

implementation

uses UMyUtils;

{$R *.dfm}

procedure TfrmConflict.AddConflictPath(Path: string);
var
  NewNode, ChildNode : PVirtualNode;
  NodeData, ChildData : PVstConflictData;
begin
    // �����ļ�
  NewNode := vstFileList.AddChild( vstFileList.RootNode );
  NodeData := vstFileList.GetNodeData( NewNode );
  NodeData.FilePath := Path;
  NodeData.IsFolder := DirectoryExists( Path );
  NodeData.IsAdd := False;
  NodeData.ActionType := ConflictAction_Replace;
  NodeData.ShowName := ExtractFileName( Path );
  NodeData.ShowIcon := MyIcon.getPathIcon( Path, FileExists( Path ) );

    // ��������
  ChildNode := vstFileList.AddChild( NewNode );
  vstFileList.CheckType[ ChildNode ] := ctRadioButton;
  ChildData := vstFileList.GetNodeData( ChildNode );
  ChildData.IsAdd := True;
  ChildData.ActionType := ConflictAction_Replace;
  ChildData.ShowName := ConflictActionShow_Replace;
  ChildData.ShowIcon := My16IconUtil.getReplace;
  vstFileList.CheckState[ ChildNode ] := csCheckedNormal; // Ĭ��ѡ��

    // ��������
  ChildNode := vstFileList.AddChild( NewNode );
  vstFileList.CheckType[ ChildNode ] := ctRadioButton;
  ChildData := vstFileList.GetNodeData( ChildNode );
  ChildData.IsAdd := True;
  ChildData.ActionType := ConflictAction_Rename;
  ChildData.ShowName := ConflictActionShow_Rename;
  ChildData.ShowIcon := My16IconUtil.getRename;

    // ����ȡ��
  ChildNode := vstFileList.AddChild( NewNode );
  vstFileList.CheckType[ ChildNode ] := ctRadioButton;
  ChildData := vstFileList.GetNodeData( ChildNode );
  ChildData.IsAdd := True;
  ChildData.ActionType := ConflictAction_Cancel;
  ChildData.ShowName := ConflictActionShow_Cancel;
  ChildData.ShowIcon := My16IconUtil.getCancel;

    // չ��
  vstFileList.Expanded[ NewNode ] := True; // չ��
end;

procedure TfrmConflict.AddFtpConflictPath(Path: string; IsFile: Boolean);
var
  NewNode, ChildNode : PVirtualNode;
  NodeData, ChildData : PVstConflictData;
begin
    // �����ļ�
  NewNode := vstFileList.AddChild( vstFileList.RootNode );
  NodeData := vstFileList.GetNodeData( NewNode );
  NodeData.FilePath := Path;
  NodeData.IsFolder := not IsFile;
  NodeData.IsAdd := False;
  NodeData.ActionType := ConflictAction_Replace;
  NodeData.ShowName := MyFilePath.getFtpName( Path );
  NodeData.ShowIcon := MyIcon.getPathIcon( Path, IsFile );

    // ��������
  ChildNode := vstFileList.AddChild( NewNode );
  vstFileList.CheckType[ ChildNode ] := ctRadioButton;
  ChildData := vstFileList.GetNodeData( ChildNode );
  ChildData.IsAdd := True;
  ChildData.ActionType := ConflictAction_Replace;
  ChildData.ShowName := ConflictActionShow_Replace;
  ChildData.ShowIcon := My16IconUtil.getReplace;
  vstFileList.CheckState[ ChildNode ] := csCheckedNormal; // Ĭ��ѡ��

    // ��������
  ChildNode := vstFileList.AddChild( NewNode );
  vstFileList.CheckType[ ChildNode ] := ctRadioButton;
  ChildData := vstFileList.GetNodeData( ChildNode );
  ChildData.IsAdd := True;
  ChildData.ActionType := ConflictAction_Rename;
  ChildData.ShowName := ConflictActionShow_Rename;
  ChildData.ShowIcon := My16IconUtil.getRename;

    // ����ȡ��
  ChildNode := vstFileList.AddChild( NewNode );
  vstFileList.CheckType[ ChildNode ] := ctRadioButton;
  ChildData := vstFileList.GetNodeData( ChildNode );
  ChildData.IsAdd := True;
  ChildData.ActionType := ConflictAction_Cancel;
  ChildData.ShowName := ConflictActionShow_Cancel;
  ChildData.ShowIcon := My16IconUtil.getCancel;

    // չ��
  vstFileList.Expanded[ NewNode ] := True; // չ��
end;

procedure TfrmConflict.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmConflict.btnOKClick(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
end;

procedure TfrmConflict.ClearConflictPaths;
begin
  vstFileList.Clear;
end;

procedure TfrmConflict.FormCreate(Sender: TObject);
begin
  vstFileList.NodeDataSize := SizeOf( TVstConflictData );
  vstFileList.Images := MyIcon.getSysIcon;
end;

function TfrmConflict.ReadConflict: Boolean;
begin
  Result := ShowModal = mrOk;
end;

function TfrmConflict.ReadConflictAction(Path: string): string;
var
  SelectNode : PVirtualNode;
  NodeData : PVstConflictData;
begin
  Result := ConflictAction_None;
  SelectNode := vstFileList.RootNode.FirstChild;
  while Assigned( SelectNode ) do
  begin
    NodeData := vstFileList.GetNodeData( SelectNode );
    if NodeData.FilePath = Path then
    begin
      Result := NodeData.ActionType;
      Break;
    end;
    SelectNode := SelectNode.NextSibling;
  end;
end;

procedure TfrmConflict.vstFileListChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  NodeData, ParentData : PVstConflictData;
begin
  if Assigned( Node ) and Assigned( Node.Parent ) and ( Node.Parent <> Sender.RootNode ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ParentData := Sender.GetNodeData( Node.Parent );
    ParentData.ActionType := NodeData.ActionType;
  end;
end;

procedure TfrmConflict.vstFileListFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  if not Assigned( Node ) then
    Exit;
  if Node.Parent <> Sender.RootNode then
    vstFileList.CheckState[ Node ] := csCheckedNormal;
end;

procedure TfrmConflict.vstFileListGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodeData : PVstConflictData;
begin
  if ( (Kind = ikNormal) or (Kind = ikSelected) ) and ( Column = 0 ) then
  begin
    NodeData := Sender.GetNodeData( Node );
    ImageIndex := NodeData.ShowIcon;
  end
  else
    ImageIndex := -1;
end;

procedure TfrmConflict.vstFileListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeData : PVstConflictData;
begin
  NodeData := Sender.GetNodeData( Node );
  if Column = 0 then
    CellText := NodeData.ShowName
  else
    CellText := '';
end;

end.
