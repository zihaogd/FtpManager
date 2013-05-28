unit UFormSelectFtp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.ValEdit;

type

  TfrmSelectFtp = class(TForm)
    plButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    plMain: TPanel;
    Label1: TLabel;
    edtHost: TEdit;
    Label2: TLabel;
    edtPort: TEdit;
    lbUserName: TLabel;
    edtUserName: TEdit;
    lbPassword: TLabel;
    edtPassword: TEdit;
    chkNoName: TCheckBox;
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure chkNoNameClick(Sender: TObject);
  private
    { Private declarations }
  public
    function NewFtp : Boolean;
    function ReadFtpHost : string;
  end;

var
  frmSelectFtp: TfrmSelectFtp;

implementation

uses UFtpUtils, UMyUtils;

{$R *.dfm}

procedure TfrmSelectFtp.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSelectFtp.btnOKClick(Sender: TObject);
var
  Host, Port, UserName, Password : string;
begin
  Host := edtHost.Text;
  Port := edtPort.Text;
  if chkNoName.Checked or ( edtUserName.Text = '' ) then  // 匿名登录
  begin
    UserName := 'anonymous';
    Password := '';
  end
  else
  begin
    UserName := edtUserName.Text;
    Password := edtPassword.Text;
  end;
  if not MyFtpFileHandler.NewConn( Host, Port, UserName, Password ) then
  begin
    MyMessageForm.ShowError( '无法连接' );
    Exit;
  end;
  MyFtpFaceHandler.AddConn( Host, Port, UserName, Password );
  Close;
  ModalResult := mrOk;
end;

procedure TfrmSelectFtp.chkNoNameClick(Sender: TObject);
var
  IsNoName : Boolean;
begin
  IsNoName := chkNoName.Checked;
  lbUserName.Enabled := not IsNoName;
  edtUserName.Enabled := not IsNoName;
  lbPassword.Enabled := not IsNoName;
  edtPassword.Enabled := not IsNoName;
end;

procedure TfrmSelectFtp.FormShow(Sender: TObject);
begin
  ModalResult := mrCancel;
  edtHost.Text := '';
  edtPort.Text := '21';
  edtUserName.Text := '';
  edtPassword.Text := '';
  chkNoName.Checked := False;
  chkNoNameClick( nil );
end;

function TfrmSelectFtp.NewFtp: Boolean;
begin
  Result := ShowModal = mrOk;
end;

function TfrmSelectFtp.ReadFtpHost: string;
begin
  Result := edtHost.Text;
end;

end.
