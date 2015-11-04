object MainForm: TMainForm
  Left = 31
  Top = 58
  Width = 824
  Height = 628
  Caption = 
    'Cannon  V3 - Cannonball flight constrained by barrel.  What angl' +
    'e which produces maximum range?  '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 64
    Top = 408
    Width = 91
    Height = 13
    Caption = 'Elevation (degrees)'
  end
  object Label2: TLabel
    Left = 83
    Top = 448
    Width = 72
    Height = 13
    Caption = 'Powder charge'
  end
  object Image1: TImage
    Left = 24
    Top = 16
    Width = 753
    Height = 337
  end
  object Label3: TLabel
    Left = 160
    Top = 368
    Width = 72
    Height = 13
    Caption = 'Move target -->'
  end
  object Label4: TLabel
    Left = 74
    Top = 488
    Width = 81
    Height = 13
    Caption = 'Gravity (0 to 200)'
  end
  object Label6: TLabel
    Left = 97
    Top = 528
    Width = 60
    Height = 13
    Caption = 'BarrelLength'
  end
  object PowderLbl: TLabel
    Left = 408
    Top = 449
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Distlbl: TLabel
    Left = 288
    Top = 416
    Width = 45
    Height = 13
    Caption = 'Distance '
  end
  object GLbl: TLabel
    Left = 408
    Top = 488
    Width = 6
    Height = 13
    Caption = '0'
  end
  object BarLenLbl: TLabel
    Left = 408
    Top = 528
    Width = 6
    Height = 13
    Caption = '0'
  end
  object ElevationEdt: TSpinEdit
    Left = 176
    Top = 408
    Width = 41
    Height = 22
    MaxValue = 90
    MinValue = 0
    TabOrder = 0
    Value = 45
    OnChange = ElevationEdtChange
  end
  object PowerBar: TTrackBar
    Left = 162
    Top = 440
    Width = 239
    Height = 33
    Max = 50
    Min = 1
    Orientation = trHorizontal
    PageSize = 1
    Frequency = 1
    Position = 10
    SelEnd = 0
    SelStart = 0
    TabOrder = 1
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = PowerBarChange
  end
  object Button1: TButton
    Left = 463
    Top = 527
    Width = 61
    Height = 26
    Caption = 'Fire!'
    TabOrder = 2
    OnClick = FirebtnClick
  end
  object ReloadBtn: TButton
    Left = 463
    Top = 495
    Width = 60
    Height = 26
    Caption = 'Reload'
    TabOrder = 3
    OnClick = ReloadBtnClick
  end
  object TrackBar1: TTrackBar
    Left = 232
    Top = 360
    Width = 550
    Height = 25
    Max = 753
    Min = 225
    Orientation = trHorizontal
    Frequency = 1
    Position = 637
    SelEnd = 0
    SelStart = 0
    TabOrder = 4
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = TrackBar1Change
  end
  object ViewStatsBtn: TButton
    Left = 623
    Top = 536
    Width = 97
    Height = 25
    Caption = 'View statistics'
    Enabled = False
    TabOrder = 5
    OnClick = ViewStatsBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 577
    Width = 816
    Height = 17
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2006, 2007  Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 6
    OnClick = StaticText1Click
  end
  object Gravitybar: TTrackBar
    Left = 170
    Top = 480
    Width = 239
    Height = 33
    Max = 200
    Orientation = trHorizontal
    PageSize = 1
    Frequency = 5
    Position = 100
    SelEnd = 0
    SelStart = 0
    TabOrder = 7
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = GravitybarChange
  end
  object BLengthBar: TTrackBar
    Left = 162
    Top = 520
    Width = 239
    Height = 33
    Max = 100
    Orientation = trHorizontal
    PageSize = 1
    Frequency = 1
    Position = 87
    SelEnd = 0
    SelStart = 0
    TabOrder = 8
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = BLengthBarChange
  end
  object SymBox: TCheckBox
    Left = 456
    Top = 448
    Width = 201
    Height = 17
    Caption = 'Adjust ground level to barrel height'
    TabOrder = 9
    OnClick = SymBoxClick
  end
  object StatsType: TRadioGroup
    Left = 624
    Top = 472
    Width = 177
    Height = 49
    Caption = 'Statistics'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Summary'
      'Detailed')
    TabOrder = 10
    OnClick = StatsTypeClick
  end
end
