object frmSelectFtp: TfrmSelectFtp
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 1
  Caption = #28155#21152
  ClientHeight = 167
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001000800680500001600000028000000100000002000
    0000010008000000000000010000000000000000000000010000000100000000
    0000744E25005B6420004772290056792E00990600009C0D01008D1E1C00A60F
    0700B40D0100AD150200B0150300BD18100091221B0098301F00B82B1B008F39
    3800A12E2400BF3D2D00A83F3700CA140200D4160600CB231500864A2600A85F
    2B009160270085752800AF682E00C9423500EC473A00C67A3900A9564700A45E
    5700B7575200937B5B00BC704900BA6D5B00B4696000B5776700BB736F00B67F
    6A00A67F7E00D0584700E96B5700C7766200DC736100E77B6700F87E71003497
    03002E941A002A931F0038A61A00329B270037912A000BBF240023A1240028AF
    2F0027B4320026B6340028B7380029BB3B0059B91D00658A3D0051C2030067DD
    10002ABD400033BD46005A9F4E0046B3420053B856005FA566007CA764002DC1
    44002ACB45002ECA4C002FCD4F003BD15B003CD45C0050C15A004BD96D0053DA
    720052DB740053DC750057DC77005DDE7D0077C96E006DD87F00BEB23C00C28F
    33008388530093B17A00A3BC6D00B9BA7100C9815600C6975200DFB54200D4B4
    5F00E0B74100C09B6600EF847000D9B76100C8AA7600C9B77D00F0DB6500F7E8
    6900F8EB7300F9ED760064E2860069E1880068E6890074E4920078E595007BE6
    98007EE79B009D949700B38C8B00BB9B8900BBA39600C7938D00EF978700D8A0
    9300FAAE9D00D1ABA600C1B1AC00CFBEBA00C8BEBC00EEBCAF00F9B2A20098CF
    850084E8A000C3CBB700C2C1BA00DEE6BC00F6FAB900F9F8BC00CAC6C200D1CF
    C600D0D4C600D5D1CB00D7D2CE00D8D5CA00D5DCD900FAD6C800F2DACF00F9D9
    CC00EEDFD500F1DCD300FCE0D400F4E3D900D9F8E900F6EBE100FDF0E8000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000FFFFFF000000
    003C3800000000000000000000000000004D49000000005A8A88830000000000
    4E6C4F3731333F3D8900000000004254706E6B504A3940308200000000003B4D
    546F816E504800008C8D00000000000045507134434672292527000000000000
    044B50031007050F122A877A7D00001F353941020D060B2D2E63730C7600000E
    31445920110A167F79797B2B78001317181B1E2808141D938E907D7F7E000119
    585F612609152F9796948C9290003E1A57686A65242C74211C77929200000036
    6C85866A605D2275000000000000005556958467642347000000000000000000
    805B5C665E62000000000000000000000000000000000000000000000000E7FF
    0000E7870000C01F0000001F000000CF0000C00F0000C0010000800100008001
    0000000100000001000000030000803F0000807F0000C0FF0000FFFF0000}
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object plButtons: TPanel
    Left = 0
    Top = 126
    Width = 308
    Height = 41
    Align = alBottom
    BevelEdges = [beTop]
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 0
    object btnOK: TButton
      Left = 60
      Top = 9
      Width = 75
      Height = 25
      Caption = #30830#23450
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 192
      Top = 9
      Width = 75
      Height = 25
      Caption = #21462#28040
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object plMain: TPanel
    Left = 0
    Top = 0
    Width = 308
    Height = 126
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 9
      Top = 15
      Width = 59
      Height = 13
      Caption = #22320#22336#25110'URL:'
    end
    object Label2: TLabel
      Left = 40
      Top = 41
      Width = 28
      Height = 13
      Caption = #31471#21475':'
    end
    object lbUserName: TLabel
      Left = 28
      Top = 67
      Width = 40
      Height = 13
      Caption = #29992#25143#21517':'
    end
    object lbPassword: TLabel
      Left = 40
      Top = 93
      Width = 28
      Height = 13
      Caption = #23494#30721':'
    end
    object edtHost: TEdit
      Left = 71
      Top = 12
      Width = 228
      Height = 21
      TabOrder = 0
    end
    object edtPort: TEdit
      Left = 74
      Top = 39
      Width = 228
      Height = 21
      NumbersOnly = True
      TabOrder = 1
      Text = '21'
    end
    object edtUserName: TEdit
      Left = 71
      Top = 64
      Width = 178
      Height = 21
      TabOrder = 2
    end
    object edtPassword: TEdit
      Left = 71
      Top = 90
      Width = 228
      Height = 21
      PasswordChar = '*'
      TabOrder = 3
    end
    object chkNoName: TCheckBox
      Left = 254
      Top = 66
      Width = 45
      Height = 17
      Caption = #21311#21517
      TabOrder = 4
      OnClick = chkNoNameClick
    end
  end
end