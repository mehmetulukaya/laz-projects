object Form1: TForm1
  Left = 281
  Top = 166
  Width = 773
  Height = 695
  Caption = 'CPU SIM'
  Color = clBtnFace
  Constraints.MinHeight = 612
  Constraints.MinWidth = 738
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    765
    649)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 456
    Top = 616
    Width = 75
    Height = 25
    Hint = 'Step By Step (F7)'
    Anchors = [akLeft, akBottom]
    Caption = 'Step'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 451
    Height = 649
    Caption = 'Visual Sim:'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    object Image1: TImage
      Left = 2
      Top = 15
      Width = 447
      Height = 632
      Align = alClient
      DragKind = dkDock
      IncrementalDisplay = True
      Proportional = True
      Stretch = True
    end
    object Label1: TLabel
      Left = 256
      Top = 136
      Width = 74
      Height = 13
      Caption = 'General register'
      Transparent = True
    end
    object Label2: TLabel
      Left = 128
      Top = 528
      Width = 40
      Height = 13
      Caption = 'Memorie'
      Transparent = True
    end
    object Panel2: TPanel
      Left = 128
      Top = 546
      Width = 225
      Height = 73
      BevelOuter = bvNone
      Caption = 'Memory View'
      Ctl3D = False
      DockSite = True
      ParentCtl3D = False
      TabOrder = 11
    end
    object Panel1: TPanel
      Left = 256
      Top = 154
      Width = 160
      Height = 72
      Caption = 'General registers'
      Ctl3D = False
      DockSite = True
      ParentCtl3D = False
      TabOrder = 10
    end
    object ListView1: TListView
      Left = 256
      Top = 154
      Width = 161
      Height = 73
      Columns = <
        item
          Caption = 'Val'
          Width = 105
        end
        item
          Caption = 'regN'
          Width = 32
        end>
      DragKind = dkDock
      DragMode = dmAutomatic
      FlatScrollBars = True
      GridLines = True
      Items.Data = {
        640200001000000000000000FFFFFFFFFFFFFFFF010000000000000010313030
        313030313031313031303131300352313000000000FFFFFFFFFFFFFFFF010000
        0000000000103130303131313031313130303031313002523100000000FFFFFF
        FFFFFFFFFF010000000000000010313030303130303031313031313030310252
        3200000000FFFFFFFFFFFFFFFF01000000000000001031313030313031313031
        30303130313002523300000000FFFFFFFFFFFFFFFF0000000000000000103031
        303031313130313130303131303100000000FFFFFFFFFFFFFFFF000000000000
        0000103030313130303031313131313030313000000000FFFFFFFFFFFFFFFF00
        00000000000000103131303131313030313130303130313000000000FFFFFFFF
        FFFFFFFF00000000000000000F31313030313031303031303131303100000000
        FFFFFFFFFFFFFFFF00000000000000000F313130303130313030313031313031
        00000000FFFFFFFFFFFFFFFF00000000000000000F3131303031303130303130
        3131303100000000FFFFFFFFFFFFFFFF00000000000000000F31313030313031
        303031303131303100000000FFFFFFFFFFFFFFFF00000000000000000F313130
        30313031303031303131303100000000FFFFFFFFFFFFFFFF0000000000000000
        0F31313030313031303031303131303100000000FFFFFFFFFFFFFFFF00000000
        000000000F31313030313031303031303131303100000000FFFFFFFFFFFFFFFF
        00000000000000000F31313030313031303031303131303100000000FFFFFFFF
        FFFFFFFF00000000000000000F313130303130313030313031313031FFFFFFFF
        FFFFFFFF}
      RowSelect = True
      ShowColumnHeaders = False
      TabOrder = 0
      ViewStyle = vsReport
      OnKeyDown = LabeledEdit1KeyDown
      OnKeyPress = LabeledEdit1KeyPress
    end
    object LabeledEdit1: TLabeledEdit
      Left = 256
      Top = 104
      Width = 105
      Height = 21
      EditLabel.Width = 34
      EditLabel.Height = 13
      EditLabel.BiDiMode = bdLeftToRight
      EditLabel.Caption = 'FLAGS'
      EditLabel.ParentBiDiMode = False
      EditLabel.Transparent = True
      EditLabel.Layout = tlCenter
      LabelPosition = lpAbove
      LabelSpacing = 3
      MaxLength = 16
      TabOrder = 1
      Text = '1000110110111101'
      OnKeyDown = LabeledEdit1KeyDown
      OnKeyPress = LabeledEdit1KeyPress
    end
    object LabeledEdit2: TLabeledEdit
      Left = 256
      Top = 256
      Width = 105
      Height = 21
      EditLabel.Width = 14
      EditLabel.Height = 13
      EditLabel.Caption = 'SP'
      EditLabel.Transparent = True
      LabelPosition = lpAbove
      LabelSpacing = 3
      MaxLength = 16
      TabOrder = 2
      Text = '1000110110111101'
      OnKeyDown = LabeledEdit1KeyDown
      OnKeyPress = LabeledEdit1KeyPress
    end
    object LabeledEdit3: TLabeledEdit
      Left = 256
      Top = 304
      Width = 105
      Height = 21
      EditLabel.Width = 7
      EditLabel.Height = 13
      EditLabel.Caption = 'T'
      EditLabel.Transparent = True
      LabelPosition = lpAbove
      LabelSpacing = 3
      MaxLength = 16
      TabOrder = 3
      Text = '100011011110110101'
      OnKeyDown = LabeledEdit1KeyDown
      OnKeyPress = LabeledEdit1KeyPress
    end
    object LabeledEdit4: TLabeledEdit
      Left = 256
      Top = 352
      Width = 105
      Height = 21
      EditLabel.Width = 14
      EditLabel.Height = 13
      EditLabel.Caption = 'PC'
      EditLabel.Transparent = True
      LabelPosition = lpAbove
      LabelSpacing = 3
      MaxLength = 16
      TabOrder = 4
      Text = '1000110111101101'
      OnKeyDown = LabeledEdit1KeyDown
      OnKeyPress = LabeledEdit1KeyPress
    end
    object LabeledEdit5: TLabeledEdit
      Left = 256
      Top = 400
      Width = 105
      Height = 21
      EditLabel.Width = 18
      EditLabel.Height = 13
      EditLabel.Caption = 'IVR'
      EditLabel.Transparent = True
      LabelPosition = lpAbove
      LabelSpacing = 3
      MaxLength = 16
      TabOrder = 5
      Text = '1000110111101101'
      OnKeyDown = LabeledEdit1KeyDown
      OnKeyPress = LabeledEdit1KeyPress
    end
    object LabeledEdit6: TLabeledEdit
      Left = 256
      Top = 448
      Width = 105
      Height = 21
      EditLabel.Width = 23
      EditLabel.Height = 13
      EditLabel.Caption = 'ADR'
      EditLabel.Transparent = True
      LabelPosition = lpAbove
      LabelSpacing = 3
      MaxLength = 16
      TabOrder = 6
      Text = '1000110110111101'
      OnKeyDown = LabeledEdit1KeyDown
      OnKeyPress = LabeledEdit1KeyPress
    end
    object LabeledEdit7: TLabeledEdit
      Left = 256
      Top = 496
      Width = 105
      Height = 21
      EditLabel.Width = 25
      EditLabel.Height = 13
      EditLabel.Caption = 'MDR'
      EditLabel.Transparent = True
      LabelPosition = lpAbove
      LabelSpacing = 3
      MaxLength = 16
      TabOrder = 7
      Text = '1000110110111101'
      OnKeyDown = LabeledEdit1KeyDown
      OnKeyPress = LabeledEdit1KeyPress
    end
    object ListView2: TListView
      Left = 128
      Top = 546
      Width = 225
      Height = 73
      Columns = <
        item
          Caption = 'Val'
          Width = 105
        end
        item
          Caption = 'HEX'
        end
        item
          Caption = 'adr'
        end>
      ColumnClick = False
      DragKind = dkDock
      DragMode = dmAutomatic
      FlatScrollBars = True
      GridLines = True
      Items.Data = {
        4F0200001000000000000000FFFFFFFFFFFFFFFF000000000000000010313030
        3130303130313130313031313000000000FFFFFFFFFFFFFFFF00000000000000
        00103130303131313031313130303031313000000000FFFFFFFFFFFFFFFF0000
        000000000000103130303031303030313130313130303100000000FFFFFFFFFF
        FFFFFF0000000000000000103131303031303131303130303130313000000000
        FFFFFFFFFFFFFFFF000000000000000010303130303131313031313030313130
        3100000000FFFFFFFFFFFFFFFF00000000000000001030303131303030313131
        31313030313000000000FFFFFFFFFFFFFFFF0000000000000000103131303131
        313030313130303130313000000000FFFFFFFFFFFFFFFF00000000000000000F
        31313030313031303031303131303100000000FFFFFFFFFFFFFFFF0000000000
        0000000F31313030313031303031303131303100000000FFFFFFFFFFFFFFFF00
        000000000000000F31313030313031303031303131303100000000FFFFFFFFFF
        FFFFFF00000000000000000F31313030313031303031303131303100000000FF
        FFFFFFFFFFFFFF00000000000000000F31313030313031303031303131303100
        000000FFFFFFFFFFFFFFFF00000000000000000F313130303130313030313031
        31303100000000FFFFFFFFFFFFFFFF00000000000000000F3131303031303130
        3031303131303100000000FFFFFFFFFFFFFFFF00000000000000000F31313030
        313031303031303131303100000000FFFFFFFFFFFFFFFF00000000000000000F
        313130303130313030313031313031}
      RowSelect = True
      TabOrder = 8
      ViewStyle = vsReport
      OnKeyDown = LabeledEdit1KeyDown
      OnKeyPress = LabeledEdit1KeyPress
    end
    object LabeledEdit8: TLabeledEdit
      Left = 24
      Top = 440
      Width = 105
      Height = 21
      EditLabel.Width = 11
      EditLabel.Height = 13
      EditLabel.Caption = 'IR'
      EditLabel.Transparent = True
      LabelPosition = lpAbove
      LabelSpacing = 3
      MaxLength = 16
      TabOrder = 9
      Text = '1000110110110101'
    end
  end
  object Button2: TButton
    Left = 618
    Top = 616
    Width = 75
    Height = 25
    Hint = 'Reset CPU (F2)'
    Anchors = [akLeft, akBottom]
    Caption = 'Reset CPU'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 538
    Top = 616
    Width = 75
    Height = 25
    Hint = 'Run Program (F9)'
    Anchors = [akLeft, akBottom]
    Caption = 'Run'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = Button3Click
  end
  object CheckBox1: TCheckBox
    Left = 456
    Top = 592
    Width = 65
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'ACLOW'
    TabOrder = 4
  end
  object CheckBox2: TCheckBox
    Left = 528
    Top = 592
    Width = 41
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'CIL'
    TabOrder = 5
  end
  object CheckBox3: TCheckBox
    Left = 576
    Top = 592
    Width = 65
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'INTR'
    TabOrder = 6
  end
  object GroupBox4: TGroupBox
    Left = 456
    Top = 0
    Width = 305
    Height = 585
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Text Sim:'
    TabOrder = 7
    object Splitter1: TSplitter
      Left = 2
      Top = 328
      Width = 301
      Height = 6
      Cursor = crVSplit
      Align = alBottom
      ResizeStyle = rsUpdate
    end
    object GroupBox2: TGroupBox
      Left = 2
      Top = 15
      Width = 301
      Height = 313
      Align = alClient
      Caption = 'Instructiuni:'
      TabOrder = 0
      DesignSize = (
        301
        313)
      object RichEdit1: TRichEdit
        Left = 2
        Top = 15
        Width = 297
        Height = 263
        Anchors = [akLeft, akTop, akRight, akBottom]
        PopupMenu = PopupMenu1
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object Edit2: TEdit
        Left = 8
        Top = 285
        Width = 289
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        ReadOnly = True
        TabOrder = 1
      end
    end
    object GroupBox3: TGroupBox
      Left = 2
      Top = 334
      Width = 301
      Height = 249
      Align = alBottom
      Caption = 'MicroInstructiuni:'
      TabOrder = 1
      DesignSize = (
        301
        249)
      object RichEdit2: TRichEdit
        Left = 2
        Top = 15
        Width = 297
        Height = 197
        Anchors = [akLeft, akTop, akRight, akBottom]
        DragMode = dmAutomatic
        HideSelection = False
        ImeMode = imDisable
        PopupMenu = PopupMenu1
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WantTabs = True
        WordWrap = False
      end
      object Edit1: TEdit
        Left = 8
        Top = 219
        Width = 289
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        ReadOnly = True
        TabOrder = 1
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 72
    Top = 8
    object AddBreakPoint1: TMenuItem
      Caption = 'Add BreakPoint'
    end
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object new1: TMenuItem
        Caption = 'new'
        OnClick = new1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Opent1: TMenuItem
        Caption = 'Load'
        OnClick = Opent1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Settings1: TMenuItem
      Caption = 'Settings'
      object CpuSimSettings1: TMenuItem
        Caption = 'Cpu Sim Settings'
        OnClick = CpuSimSettings1Click
      end
    end
    object About1: TMenuItem
      Caption = 'Help'
      object About2: TMenuItem
        Caption = 'About'
        OnClick = About2Click
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 40
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.asm'
    Filter = '*.asm|*.asm'
    Left = 104
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.asm'
    Filter = '*.asm|*.asm'
    Left = 136
    Top = 8
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 168
    Top = 8
  end
end
