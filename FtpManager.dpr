program FtpManager;

uses
  Vcl.Forms,
  Windows,
  UMainForm in 'UMainForm.pas' {frmMain},
  UMyUtils in 'UMyUtils.pas',
  UFrameDriver in 'UFrameDriver.pas' {FrameDriver: TFrame},
  UThreadUtil in 'UThreadUtil.pas',
  UMyFaceThread in 'UMyFaceThread.pas',
  UFileSearch in 'UFileSearch.pas',
  Vcl.Themes,
  Vcl.Styles,
  UFileThread in 'UFileThread.pas',
  UFormZip in 'UFormZip.pas' {frmZip},
  UFormShareManage in 'UFormShareManage.pas' {frmShareManger},
  dirnotify in 'dirnotify.pas',
  UFileWatchThread in 'UFileWatchThread.pas',
  UFormConflict in 'UFormConflict.pas' {frmConflict},
  UFormAbout in 'UFormAbout.pas' {frmAbout},
  UMyUrl in 'UMyUrl.pas',
  UFormSelectFtp in 'UFormSelectFtp.pas' {frmSelectFtp},
  UFtpUtils in 'UFtpUtils.pas',
  UFormFtpDelete in 'UFormFtpDelete.pas' {frmFtpDelete},
  UFormFtpCopy in 'UFormFtpCopy.pas' {frmFtpCopy};

{$R *.res}

var
  myhandle : Integer;
begin
    // �����ڴ�й©
  ReportMemoryLeaksOnShutdown := DebugHook<>0;

    // ��ֹ�������ͬʱ����
  myhandle := findwindow( hfck_Name, nil );
  if myhandle > 0 then  // ������ͬһ�� �û� ID �Ѿ�����, �ָ�֮ǰ�Ĵ���
  begin
    postmessage( myhandle,hfck_index,0,0 );
    Exit;
  end;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Iceberg Classico');
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmZip, frmZip);
  Application.CreateForm(TfrmShareManger, frmShareManger);
  Application.CreateForm(TfrmConflict, frmConflict);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmSelectFtp, frmSelectFtp);
  Application.CreateForm(TfrmFtpDelete, frmFtpDelete);
  Application.CreateForm(TfrmFtpCopy, frmFtpCopy);
  frmMain.AppStart;
  Application.Run;
end.
