object Main_Patch: TMain_Patch
  Left = 482
  Top = 214
  ActiveControl = btn_Test
  BorderIcons = [biSystemMenu]
  BorderWidth = 3
  Caption = 'WebPlayer9'#30005#24433#25209#37327#28155#21152#24037#20855'---'#34917#19969'(2010-12-10)'
  ClientHeight = 297
  ClientWidth = 502
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCanResize = FormCanResize
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RzPageControl2: TRzPageControl
    Left = 0
    Top = 0
    Width = 502
    Height = 297
    ActivePage = TabSheet3
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    ExplicitWidth = 476
    ExplicitHeight = 251
    FixedDimension = 19
    object TabSheet3: TRzTabSheet
      Caption = #21442#25968#35774#32622
      ExplicitWidth = 472
      ExplicitHeight = 228
      object Label1: TLabel
        Left = 12
        Top = 19
        Width = 58
        Height = 13
        Caption = #25968#25454#24211'IP'#65306
      end
      object Label2: TLabel
        Left = 22
        Top = 52
        Width = 48
        Height = 13
        Caption = #30331#24405#21517#65306
      end
      object Label3: TLabel
        Left = 261
        Top = 52
        Width = 36
        Height = 13
        Caption = #23494#30721#65306
      end
      object Bevel1: TBevel
        Left = 4
        Top = 124
        Width = 719
        Height = 6
        Shape = bsBottomLine
      end
      object lbl_db: TLabel
        Left = 248
        Top = 18
        Width = 48
        Height = 13
        Caption = #25968#25454#24211#65306
      end
      object Edit1: TEdit
        Left = 73
        Top = 15
        Width = 162
        Height = 21
        TabOrder = 0
        Text = '(local)'
      end
      object Edit2: TEdit
        Left = 73
        Top = 49
        Width = 162
        Height = 21
        TabOrder = 3
        Text = 'vod_sa'
      end
      object Edit3: TEdit
        Left = 299
        Top = 49
        Width = 184
        Height = 21
        PasswordChar = '*'
        TabOrder = 4
        Text = 'xlinuxx'
      end
      object btn_Test: TBitBtn
        Left = 364
        Top = 82
        Width = 109
        Height = 25
        Caption = #25968#25454#24211#36830#25509#27979#35797
        TabOrder = 2
        OnClick = btn_TestClick
      end
      object chk_Local: TCheckBox
        Left = 73
        Top = 86
        Width = 265
        Height = 17
        Caption = #20351#29992'Windows'#23433#20840#36830#25509'('#25968#25454#24211#20026#26412#26426#26102')'
        TabOrder = 1
        OnClick = chk_LocalClick
      end
      object edt_db: TEdit
        Left = 299
        Top = 15
        Width = 184
        Height = 21
        TabOrder = 5
        Text = 'MovieDB'
      end
      object btn_Patch: TBitBtn
        Left = 364
        Top = 197
        Width = 109
        Height = 25
        Caption = #24320#22987#26356#26032#22788#29702
        TabOrder = 6
        OnClick = btn_PatchClick
      end
      object btn_Exit: TBitBtn
        Left = 364
        Top = 237
        Width = 109
        Height = 25
        Caption = #36864#20986'[&X]'
        TabOrder = 7
        OnClick = btn_ExitClick
      end
      object edt_Source: TLabeledEdit
        Left = 73
        Top = 153
        Width = 162
        Height = 21
        EditLabel.Width = 48
        EditLabel.Height = 13
        EditLabel.Caption = #28304#20869#23481#65306
        LabelPosition = lpLeft
        TabOrder = 8
        Text = 'H:/vod2/'
        OnChange = edt_SourceChange
      end
      object edt_Desc: TLabeledEdit
        Left = 299
        Top = 153
        Width = 184
        Height = 21
        EditLabel.Width = 48
        EditLabel.Height = 13
        EditLabel.Caption = #26367#25442#20026#65306
        LabelPosition = lpLeft
        TabOrder = 9
        Text = 'http://vod.jxstnu.cn/movie/'
        OnChange = edt_SourceChange
      end
    end
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=xlinuxx;Persist Security Info=True;' +
      'User ID=sa;Initial Catalog=MovieDB;Data Source=.'
    ConnectionTimeout = 3
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 383
    Top = 71
  end
  object qry_Temp: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 417
    Top = 71
  end
end
