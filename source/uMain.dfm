object Main: TMain
  Left = 482
  Top = 214
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = 'WebPlayer9'#30005#24433#25209#37327#28155#21152#24037#20855'---Powered by xieyunc 2013-05-30'
  ClientHeight = 575
  ClientWidth = 777
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object RzPageControl1: TRzPageControl
    Left = 0
    Top = 95
    Width = 777
    Height = 396
    ActivePage = rztbshtTabSheet4
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    FixedDimension = 20
    object rztbshtTabSheet4: TRzTabSheet
      Caption = #30005#24433#31867#21035
      object DBGridEh1: TDBGridEh
        Left = 0
        Top = 0
        Width = 773
        Height = 372
        Align = alClient
        Ctl3D = False
        DataGrouping.GroupLevels = <>
        DataSource = ds_class
        EditActions = [geaCutEh, geaCopyEh, geaPasteEh, geaDeleteEh, geaSelectAllEh]
        Flat = False
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -12
        FooterFont.Name = 'Tahoma'
        FooterFont.Style = []
        FooterRowCount = 1
        IndicatorTitle.ShowDropDownSign = True
        IndicatorTitle.TitleButton = True
        OddRowColor = clMenuBar
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove, dghHotTrack]
        ParentCtl3D = False
        ParentShowHint = False
        PopupMenu = pm1
        ReadOnly = True
        RowDetailPanel.Color = clBtnFace
        RowHeight = 22
        ShowHint = True
        SortLocal = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        TitleHeight = 20
        VertScrollBar.VisibleMode = sbNeverShowEh
        Columns = <
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = 'class_id'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = 'ID'
            Title.TitleButton = True
            Width = 46
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = 'class_name'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #30005#24433#20998#31867
            Title.TitleButton = True
            Width = 87
          end
          item
            Alignment = taCenter
            ButtonStyle = cbsEllipsis
            EditButtons = <>
            FieldName = 'class_localdir'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #26412#22320#30446#24405
            Title.TitleButton = True
            Width = 102
            OnEditButtonClick = DBGridEh1Columns2EditButtonClick
          end
          item
            EditButtons = <
              item
                Hint = #21019#24314#34394#25311#30446#24405
                Style = ebsPlusEh
                OnClick = DBGridEh1Columns2EditButtons0Click
              end>
            EndEllipsis = True
            FieldName = 'class_dir'
            Footers = <>
            Title.Caption = #34394#25311#30446#24405
            Title.TitleButton = True
            Width = 113
            OnUpdateData = DBGridEh1Columns2UpdateData
          end
          item
            AlwaysShowEditButton = True
            EditButtons = <>
            FieldName = 'class_url'
            Footers = <>
            Title.Caption = #30005#24433#20998#31867'URL'
            Title.TitleButton = True
            Width = 379
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
    object TabSheet2: TRzTabSheet
      Caption = #31243#24207#35828#26126
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object mmo2: TMemo
        Left = 0
        Top = 0
        Width = 773
        Height = 372
        Align = alClient
        Lines.Strings = (
          #12288#12288#36825#26159#19968#20010#19987#20026'WebPlayer9'#30005#24433#25972#31449#31995#32479#32780#35774#35745#30340#30005#24433#25209#37327#28155#21152#31243#24207#65281#30456#23545#20110'WebPlayer9'#33258
          #24102#30340#25209#37327#28155#21152#31243#24207#22686#21152#20102#22914#19979#21151#33021#65306
          ''
          '1'#12289#33258#21160#22788#29702#25152#26377#30340#30005#24433#20998#31867#21517#31216#21644#25991#20214#22841#21517#31216#30456#21516#30340#24433#29255#12290
          '2'#12289#33258#21160#22788#29702#24433#29255#25991#20214#22841#20013#30340#22270#29255#25991#20214#21644'Txt'#25991#20214#20316#20026#24433#29255#30340#39044#35272#22270#21644#31616#20171#12290
          '3'#12289#20462#27491#20102#21407'WebPlayer9'#33258#24102#30340#24037#20855#20250#37325#22797#28155#21152#30005#24433#30340'BUG'#12290
          ''
          '   '
          #27880#65306#35831#25226#26412#24037#20855#25918#22312'WebPlayer'#25972#31449#31995#32479#30340#23433#35013#30446#24405#20013#65292#21363#19982'MyWeb'#20026#24179#34892#30446#24405#65281#32780#19988#35831#30830#35748
          'MyWeb'#30446#24405#20013#26377'Uploadfile\MoviePic'#23376#30446#24405#65292#22914#26524#27809#26377#35831#33258#34892#24314#31435#12290
          ''
          '   '#24433#29255#30340#30446#24405#32467#26500#24212#19982#20320'WebPlayer'#25972#31449#31995#32479#20013#30340#24433#29255#20998#31867#19968#33268#65281#22914#19979#22270#65306
          'F:\vod'#23545#24212#20320#30340#28857#25773#26381#21153#20013#30340#34394#25311#30446#24405'Movie1'#65292#30005#24433#39057#36947#12289#30005#35270#21095#22330#20026#30005#24433#22823#31867#65292#26538#25112#29255#12289#21095
          #24773#29255#31561#20026#22823#31867#19979#30340#24433#29255#20998#31867#12290
          ''
          'F:\vod\'#30005#24433#39057#36947'\'#26538#25112#29255'\'#26080#38388#36947'\'#26080#38388#36947'CD1.rmvb'
          '                              '#26080#38388#36947'CD2.rmvb'
          '                              '#31616#20171'.txt('#25991#20214#21517#26080#20851#32039#35201#65292#20851#38190#24517#39035#26159'txt'#25110'csv'#26684#24335')'
          
            '                              '#26080#38388#36947'.jpg('#25991#20214#21517#26080#20851#32039#35201#65292#20851#38190#24517#39035#26159'jpg,gif,bmp'#25110'p' +
            'ng'#26684#24335')'
          '.....'
          ''
          'F:\vod\'#30005#35270#21095#22330'\'#21095#24773#29255'\'#24515#33457#25918'\'#24515#33457#25918'1.rmvb'
          '                              '#24515#33457#25918'2.rmvb'
          '                              '#24515#33457#25918'2.rmvb'
          '                              '#24515#33457#25918'2.rmvb'
          '                              '#24515#33457#25918'2.rmvb'
          '                              ....'
          '                              '#31616#20171'.txt('#25991#20214#21517#26080#20851#32039#35201#65292#20851#38190#24517#39035#26159'txt'#25110'csv'#26684#24335')'
          
            '                              '#24515#33457#25918'.jpg('#25991#20214#21517#26080#20851#32039#35201#65292#20851#38190#24517#39035#26159'jpg,gif,bmp'#25110'p' +
            'ng'#26684#24335')'
          '.....'
          '                               '
          ''
          '  '#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288'---Powered by xieyunc 2008-11-10 @NanChang'
          '  '#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288#12288'http://xieyunc.jxstnu.edu.cn/'
          '   ')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 491
    Width = 777
    Height = 65
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object bvl2: TBevel
      Left = 0
      Top = 59
      Width = 777
      Height = 6
      Align = alBottom
      Shape = bsBottomLine
      ExplicitLeft = 24
      ExplicitTop = 35
      ExplicitWidth = 719
    end
    object lbl_Srv: TLabel
      Left = 16
      Top = 9
      Width = 72
      Height = 14
      Caption = #24433#29255#26381#21153#22120#65306
    end
    object lbl_Image: TLabel
      Left = 16
      Top = 39
      Width = 60
      Height = 14
      Caption = #40664#35748#22270#29255#65306
    end
    object lbl_SrvUrl: TLabel
      Left = 202
      Top = 9
      Width = 72
      Height = 14
      Caption = #26381#21153#22120#22495#21517#65306
    end
    object cbb_Srv: TComboBox
      Left = 90
      Top = 6
      Width = 89
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 0
    end
    object edt_Image: TEdit
      Left = 90
      Top = 37
      Width = 392
      Height = 22
      TabOrder = 1
      Text = 'http://vod.jxstnu.edu.cn/Upload/MoviePic/default.gif'
      OnChange = edt_ImageChange
    end
    object edt_SrvUrl: TEdit
      Left = 272
      Top = 6
      Width = 210
      Height = 22
      TabOrder = 2
      Text = 'http://vod.jxstnu.edu.cn/'
      OnChange = edt_SrvUrlChange
      OnExit = edt_SrvUrlExit
    end
    object btn_UpdateSrvUrl: TBitBtn
      Left = 488
      Top = 5
      Width = 68
      Height = 25
      Caption = #26356#25913#22495#21517
      Enabled = False
      TabOrder = 3
      OnClick = btn_UpdateSrvUrlClick
    end
    object chk_Delete: TCheckBox
      Left = 627
      Top = 6
      Width = 130
      Height = 21
      Caption = #26356#26032#26102#21024#38500#26080#25928#24433#29255
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
  end
  object RzStatusBar1: TRzStatusBar
    Left = 0
    Top = 556
    Width = 777
    Height = 19
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    TabOrder = 2
    object RzStatusPane1: TRzStatusPane
      Left = 0
      Top = 0
      Width = 67
      Height = 19
      Align = alLeft
      Alignment = taCenter
      Caption = #22788#29702#36827#24230#65306
    end
    object ProgressBar1: TRzProgressStatus
      Left = 67
      Top = 0
      Width = 710
      Height = 19
      Align = alClient
      ParentShowHint = False
      PartsComplete = 0
      Percent = 0
      ShowPercent = True
      TotalParts = 0
      ExplicitWidth = 614
    end
  end
  object btn_InitLocalDir: TBitBtn
    Left = 162
    Top = 463
    Width = 104
    Height = 25
    Caption = #21019#24314#25152#26377#26412#22320#30446#24405
    TabOrder = 3
    OnClick = btn_InitLocalDirClick
  end
  object btn_InitUrl: TBitBtn
    Left = 264
    Top = 463
    Width = 116
    Height = 25
    Caption = #21019#24314#25152#26377#34394#25311#30446#24405
    TabOrder = 4
    OnClick = btn_InitUrlClick
  end
  object grp1: TGroupBox
    Left = 0
    Top = 0
    Width = 777
    Height = 95
    Align = alTop
    Caption = #25968#25454#24211#36830#25509#65306
    TabOrder = 5
    object lbl2: TLabel
      Left = 22
      Top = 29
      Width = 59
      Height = 14
      Caption = #25968#25454#24211'IP'#65306
    end
    object lbl3: TLabel
      Left = 215
      Top = 28
      Width = 48
      Height = 14
      Caption = #30331#24405#21517#65306
    end
    object lbl4: TLabel
      Left = 392
      Top = 28
      Width = 36
      Height = 14
      Caption = #23494#30721#65306
    end
    object lbl_db: TLabel
      Left = 33
      Top = 59
      Width = 48
      Height = 14
      Caption = #25968#25454#24211#65306
    end
    object bvl1: TBevel
      Left = 579
      Top = 18
      Width = 4
      Height = 68
      Shape = bsLeftLine
    end
    object edt1: TEdit
      Left = 83
      Top = 25
      Width = 124
      Height = 22
      TabOrder = 0
      Text = '(local)'
    end
    object edt2: TEdit
      Left = 262
      Top = 25
      Width = 110
      Height = 22
      TabOrder = 1
      Text = 'vod_sa'
    end
    object edt3: TEdit
      Left = 426
      Top = 25
      Width = 124
      Height = 22
      PasswordChar = '*'
      TabOrder = 2
      Text = 'xlinuxx'
    end
    object btn_Test: TBitBtn
      Left = 477
      Top = 53
      Width = 73
      Height = 25
      Caption = #27979#35797#36830#25509
      TabOrder = 3
      OnClick = btn_TestClick
    end
    object chk_Local: TCheckBox
      Left = 218
      Top = 58
      Width = 243
      Height = 18
      Caption = #20351#29992'Windows'#23433#20840#36830#25509'('#25968#25454#24211#20026#26412#26426#26102')'
      TabOrder = 4
      OnClick = chk_LocalClick
    end
    object edt_db: TEdit
      Left = 83
      Top = 56
      Width = 124
      Height = 22
      TabOrder = 5
      Text = 'MovieDB'
    end
    object btn_OK: TBitBtn
      Left = 612
      Top = 23
      Width = 142
      Height = 57
      Caption = #26356#26032#25152#26377#31867#21035#30005#24433#20449#24687
      PopupMenu = pm1
      TabOrder = 6
      OnClick = btn_OKClick
    end
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=xlinuxx;Persist Security Info=True;' +
      'User ID=sa;Initial Catalog=MovieDB;Data Source=.'
    ConnectionTimeout = 3
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 311
    Top = 271
  end
  object qry_Temp: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 345
    Top = 271
  end
  object qry_ProgInfo: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 383
    Top = 271
  end
  object qry_Prog_Server: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 423
    Top = 271
  end
  object pm1: TPopupMenu
    Left = 384
    Top = 312
    object N1: TMenuItem
      Action = EditCopy1
    end
    object N2: TMenuItem
      Action = EditCut1
    end
    object N3: TMenuItem
      Action = EditPaste1
    end
    object N4: TMenuItem
      Caption = '-'
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 1
      ShortCut = 16451
    end
    object mi_UpdateMovie: TMenuItem
      Caption = #26356#26032#24403#21069#20998#31867#24433#29255
      OnClick = mi_UpdateMovieClick
    end
    object mi_DeleteErrorMovie: TMenuItem
      Caption = #21024#38500#26080#25928#30340#24433#29255
      Hint = #21024#38500#38169#35823#21644#19981#23384#22312#30340#24433#29255
      OnClick = mi_DeleteErrorMovieClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object mi_CreateLocalDir: TMenuItem
      Caption = #21019#24314#24403#21069#26412#22320#30446#24405
      OnClick = mi_CreateLocalDirClick
    end
    object mi_CreateVirualDir: TMenuItem
      Caption = #21019#24314#24403#21069#34394#25311#30446#24405
      OnClick = mi_CreateVirualDirClick
    end
    object mi_AllowEdit: TMenuItem
      Caption = #20801#35768#32534#36753#34920#26684#25968#25454
      OnClick = mi_AllowEditClick
    end
  end
  object qry_class: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from adnim_class')
    Left = 311
    Top = 311
  end
  object ds_class: TDataSource
    DataSet = qry_class
    Left = 344
    Top = 312
  end
  object CnIISCtrl1: TCnIISCtrl
    Left = 424
    Top = 312
  end
  object actlst1: TActionList
    Left = 16
    Top = 176
    object EditCopy1: TEditCopy
      Category = 'Edit'
      Caption = #22797#21046
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 1
      ShortCut = 16451
    end
    object EditCut1: TEditCut
      Category = 'Edit'
      Caption = #21098#20999
      Hint = 'Cut|Cuts the selection and puts it on the Clipboard'
      ImageIndex = 0
      ShortCut = 16472
    end
    object EditPaste1: TEditPaste
      Category = 'Edit'
      Caption = #31896#36148
      Hint = 'Paste|Inserts Clipboard contents'
      ImageIndex = 2
      ShortCut = 16470
    end
  end
end
