object MainForm: TMainForm
  Left = 29
  Height = 628
  Top = 0
  Width = 824
  Caption = 'Cannon  V3 - Cannonball flight constrained by barrel.  What angle which produces maximum range?  '
  ClientHeight = 628
  ClientWidth = 824
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnActivate = FormActivate
  Position = poScreenCenter
  LCLVersion = '1.4.2.0'
  object Label1: TLabel
    Left = 64
    Height = 14
    Top = 408
    Width = 110
    Caption = 'Elevation (degrees)'
    ParentColor = False
  end
  object Label2: TLabel
    Left = 83
    Height = 14
    Top = 448
    Width = 85
    Caption = 'Powder charge'
    ParentColor = False
  end
  object Image1: TImage
    Left = 24
    Height = 337
    Top = 16
    Width = 753
  end
  object Label3: TLabel
    Left = 160
    Height = 14
    Top = 368
    Width = 89
    Caption = 'Move target -->'
    ParentColor = False
  end
  object Label4: TLabel
    Left = 74
    Height = 14
    Top = 488
    Width = 101
    Caption = 'Gravity (0 to 200)'
    ParentColor = False
  end
  object Label6: TLabel
    Left = 97
    Height = 14
    Top = 528
    Width = 73
    Caption = 'BarrelLength'
    ParentColor = False
  end
  object PowderLbl: TLabel
    Left = 408
    Height = 14
    Top = 449
    Width = 7
    Caption = '0'
    ParentColor = False
  end
  object Distlbl: TLabel
    Left = 288
    Height = 14
    Top = 416
    Width = 52
    Caption = 'Distance '
    ParentColor = False
  end
  object GLbl: TLabel
    Left = 408
    Height = 14
    Top = 488
    Width = 7
    Caption = '0'
    ParentColor = False
  end
  object BarLenLbl: TLabel
    Left = 408
    Height = 14
    Top = 528
    Width = 7
    Caption = '0'
    ParentColor = False
  end
  object ElevationEdt: TSpinEdit
    Left = 176
    Height = 26
    Top = 408
    Width = 41
    MaxValue = 90
    OnChange = ElevationEdtChange
    TabOrder = 0
    Value = 45
  end
  object PowerBar: TTrackBar
    Left = 162
    Height = 38
    Top = 440
    Width = 239
    Max = 50
    Min = 1
    OnChange = PowerBarChange
    PageSize = 1
    Position = 10
    TabOrder = 1
  end
  object Button1: TButton
    Left = 463
    Height = 26
    Top = 527
    Width = 61
    Caption = 'Fire!'
    OnClick = FirebtnClick
    TabOrder = 2
  end
  object ReloadBtn: TButton
    Left = 463
    Height = 26
    Top = 495
    Width = 60
    Caption = 'Reload'
    OnClick = ReloadBtnClick
    TabOrder = 3
  end
  object TrackBar1: TTrackBar
    Left = 232
    Height = 38
    Top = 360
    Width = 550
    Max = 753
    Min = 225
    OnChange = TrackBar1Change
    Position = 637
    TabOrder = 4
  end
  object ViewStatsBtn: TButton
    Left = 623
    Height = 25
    Top = 536
    Width = 97
    Caption = 'View statistics'
    Enabled = False
    OnClick = ViewStatsBtnClick
    TabOrder = 5
  end
  object StaticText1: TStaticText
    Cursor = crHandPoint
    Left = 0
    Height = 17
    Top = 611
    Width = 824
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2006, 2007  Gary Darby,  www.DelphiForFun.org'
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    OnClick = StaticText1Click
    ParentFont = False
    TabOrder = 6
  end
  object Gravitybar: TTrackBar
    Left = 170
    Height = 38
    Top = 480
    Width = 239
    Frequency = 5
    Max = 200
    OnChange = GravitybarChange
    PageSize = 1
    Position = 100
    TabOrder = 7
  end
  object BLengthBar: TTrackBar
    Left = 162
    Height = 38
    Top = 520
    Width = 239
    Max = 100
    OnChange = BLengthBarChange
    PageSize = 1
    Position = 87
    TabOrder = 8
  end
  object SymBox: TCheckBox
    Left = 456
    Height = 23
    Top = 448
    Width = 241
    Caption = 'Adjust ground level to barrel height'
    OnClick = SymBoxClick
    TabOrder = 9
  end
  object StatsType: TRadioGroup
    Left = 624
    Height = 49
    Top = 472
    Width = 177
    AutoFill = True
    Caption = 'Statistics'
    ChildSizing.LeftRightSpacing = 6
    ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
    ChildSizing.EnlargeVertical = crsHomogenousChildResize
    ChildSizing.ShrinkHorizontal = crsScaleChilds
    ChildSizing.ShrinkVertical = crsScaleChilds
    ChildSizing.Layout = cclLeftToRightThenTopToBottom
    ChildSizing.ControlsPerLine = 2
    ClientHeight = 34
    ClientWidth = 175
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Summary'
      'Detailed'
    )
    OnClick = StatsTypeClick
    TabOrder = 10
  end
end
