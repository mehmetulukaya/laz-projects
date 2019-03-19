object Form1: TForm1
  Left = 212
  Height = 562
  Top = 0
  Width = 784
  Caption = 'Scrolling LEDs '
  ClientHeight = 562
  ClientWidth = 784
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  LCLVersion = '2.0.0.4'
  object Image1: TImage
    Left = 16
    Height = 209
    Top = 328
    Width = 753
  end
  object Label2: TLabel
    Left = 224
    Height = 15
    Top = 256
    Width = 78
    Caption = 'Scroll Speed '
    ParentColor = False
  end
  object FontLbl: TLabel
    Left = 400
    Height = 15
    Top = 296
    Width = 110
    Caption = 'Current Font: None'
    ParentColor = False
  end
  object Label5: TLabel
    Left = 544
    Height = 33
    Top = 280
    Width = 219
    AutoSize = False
    Caption = '(Use click and drag to adjust  window size and position)'
    ParentColor = False
    WordWrap = True
  end
  object ShowTextBtn: TButton
    Left = 16
    Height = 25
    Top = 260
    Width = 185
    Caption = 'Start display'
    OnClick = ShowTextBtnClick
    TabOrder = 7
  end
  object MessagePages: TPageControl
    Left = 16
    Height = 241
    Hint = 'Use Stop button  to change message '
    Top = 8
    Width = 505
    ActivePage = Textpage
    TabIndex = 0
    TabOrder = 3
    object Textpage: TTabSheet
      Hint = 'Stop message before changing text'
      Caption = 'Message'
      ClientHeight = 212
      ClientWidth = 495
      object Label1: TLabel
        Left = 16
        Height = 15
        Top = 168
        Width = 79
        Caption = 'Message text'
        ParentColor = False
      end
      object TextEdt: TEdit
        Left = 112
        Height = 27
        Top = 168
        Width = 345
        TabOrder = 0
        Text = 'Welcome - today is &dt       '
      end
      object Memo1: TMemo
        Left = 16
        Height = 145
        Top = 8
        Width = 449
        Color = 14548991
        Lines.Strings = (
          'Enter display text in the box below and click the "Start" button.  Embed &dt '
          'in the message to display current date/time in a format defined on the '
          '"Date/Time" page.  Embed &ct in the message to display countdown (or '
          'count-up) time as defined on the count up/down page.  '
          ''
        )
        TabOrder = 1
      end
    end
    object DateTimePage: TTabSheet
      Caption = 'Date/Time'
      ClientHeight = 212
      ClientWidth = 495
      ImageIndex = 1
      object DTFormatGrp: TRadioGroup
        Left = 8
        Height = 161
        Top = 24
        Width = 473
        AutoFill = True
        Caption = 'Select a format'
        ChildSizing.LeftRightSpacing = 6
        ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
        ChildSizing.EnlargeVertical = crsHomogenousChildResize
        ChildSizing.ShrinkHorizontal = crsScaleChilds
        ChildSizing.ShrinkVertical = crsScaleChilds
        ChildSizing.Layout = cclLeftToRightThenTopToBottom
        ChildSizing.ControlsPerLine = 1
        ClientHeight = 143
        ClientWidth = 471
        ItemIndex = 0
        Items.Strings = (
          'Jan 03  11:24'
          'Jan 03, 2005'
          '11:24 PM'
          'Friday, January 03, 2003  11:24 PM'
        )
        TabOrder = 0
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Count Up/Down'
      ClientHeight = 212
      ClientWidth = 495
      ImageIndex = 2
      object Label4: TLabel
        Left = 16
        Height = 15
        Top = 16
        Width = 100
        Caption = 'Target Date/Time'
        ParentColor = False
      end
      object GroupBox1: TGroupBox
        Left = 24
        Height = 57
        Top = 72
        Width = 449
        Caption = 'Display count time units'
        ClientHeight = 39
        ClientWidth = 447
        TabOrder = 0
        object Yearbox: TCheckBox
          Left = 16
          Height = 22
          Top = 6
          Width = 54
          Caption = 'Years'
          TabOrder = 0
        end
        object DayBox: TCheckBox
          Left = 88
          Height = 22
          Top = 6
          Width = 53
          Caption = 'Days'
          TabOrder = 1
        end
        object HourBox: TCheckBox
          Left = 160
          Height = 22
          Top = 6
          Width = 59
          Caption = 'Hours'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object MinuteBox: TCheckBox
          Left = 240
          Height = 22
          Top = 6
          Width = 71
          Caption = 'Minutes'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object SecondBox: TCheckBox
          Left = 336
          Height = 22
          Top = 6
          Width = 75
          Caption = 'Seconds'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
      end
      object FormatGrp: TRadioGroup
        Left = 24
        Height = 64
        Top = 136
        Width = 449
        AutoFill = True
        Caption = 'Format'
        ChildSizing.LeftRightSpacing = 6
        ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
        ChildSizing.EnlargeVertical = crsHomogenousChildResize
        ChildSizing.ShrinkHorizontal = crsScaleChilds
        ChildSizing.ShrinkVertical = crsScaleChilds
        ChildSizing.Layout = cclLeftToRightThenTopToBottom
        ChildSizing.ControlsPerLine = 1
        ClientHeight = 46
        ClientWidth = 447
        ItemIndex = 0
        Items.Strings = (
          'yy:dd:hh:mm:ss'
          'yy years dd days mm minutes ss seconds '
        )
        TabOrder = 1
      end
      object CountTime: TDateTimePicker
        Left = 280
        Height = 21
        Top = 40
        Width = 71
        CenturyFrom = 1941
        MaxDate = 2958465
        MinDate = -53780
        TabOrder = 2
        TrailingSeparator = False
        TextForNullDate = 'NULL'
        LeadingZeros = True
        Kind = dtkTime
        TimeFormat = tf24
        TimeDisplay = tdHMS
        DateMode = dmComboBox
        Date = 38231
        Time = 0.927754629628907
        UseDefaultSeparators = True
        HideDateTimeParts = []
        MonthNames = 'Long'
      end
      object CountDate: TDateTimePicker
        Left = 24
        Height = 21
        Top = 40
        Width = 87
        CenturyFrom = 1941
        MaxDate = 2958465
        MinDate = -53780
        TabOrder = 3
        TrailingSeparator = False
        TextForNullDate = 'NULL'
        LeadingZeros = True
        Kind = dtkDate
        TimeFormat = tf24
        TimeDisplay = tdHMS
        DateMode = dmComboBox
        Date = 38231
        Time = 0.927241770841647
        UseDefaultSeparators = True
        HideDateTimeParts = []
        MonthNames = 'Long'
      end
    end
  end
  object LedGrp: TGroupBox
    Left = 536
    Height = 193
    Top = 8
    Width = 233
    Caption = 'LED'
    ClientHeight = 177
    ClientWidth = 231
    TabOrder = 0
    object Label3: TLabel
      Left = 24
      Height = 15
      Top = 28
      Width = 72
      Caption = 'Size (pixels)'
      ParentColor = False
    end
    object LEDPixelsUD: TUpDown
      Left = 145
      Height = 27
      Top = 28
      Width = 12
      Associate = LEDSizeEdt
      Max = 50
      Min = 5
      Position = 10
      TabOrder = 0
    end
    object LEDSizeEdt: TEdit
      Left = 120
      Height = 27
      Top = 28
      Width = 25
      OnChange = gth
      TabOrder = 1
      Text = '10'
    end
    object LEDColorBtn: TButton
      Left = 22
      Height = 25
      Top = 64
      Width = 75
      Caption = 'On Color'
      OnClick = LEDColorBtnClick
      TabOrder = 2
    end
    object LEDOffColorBtn: TButton
      Left = 24
      Height = 25
      Top = 104
      Width = 73
      Caption = 'Off color'
      OnClick = LEDOffColorBtnClick
      TabOrder = 3
    end
    object ShapeGrp: TRadioGroup
      Left = 120
      Height = 65
      Top = 64
      Width = 89
      AutoFill = True
      Caption = 'Shape'
      ChildSizing.LeftRightSpacing = 6
      ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
      ChildSizing.EnlargeVertical = crsHomogenousChildResize
      ChildSizing.ShrinkHorizontal = crsScaleChilds
      ChildSizing.ShrinkVertical = crsScaleChilds
      ChildSizing.Layout = cclLeftToRightThenTopToBottom
      ChildSizing.ControlsPerLine = 1
      ClientHeight = 49
      ClientWidth = 87
      ItemIndex = 0
      Items.Strings = (
        'Round'
        'Square'
      )
      OnClick = ShapeGrpClick
      TabOrder = 4
    end
    object BoardColorBtn: TButton
      Left = 22
      Height = 33
      Top = 136
      Width = 139
      Caption = 'Background Color'
      OnClick = BoardColorBtnClick
      TabOrder = 5
    end
  end
  object StopBtn: TButton
    Left = 16
    Height = 25
    Top = 288
    Width = 185
    Caption = 'Stop'
    Font.Color = clWindow
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    OnClick = StopBtnClick
    ParentFont = False
    TabOrder = 1
    Visible = False
  end
  object SpeedBar: TTrackBar
    Left = 224
    Height = 41
    Top = 272
    Width = 150
    Max = 50
    OnChange = SpeedBarChange
    Position = 10
    TabOrder = 2
  end
  object LoadFontBtn: TButton
    Left = 400
    Height = 25
    Top = 264
    Width = 75
    Caption = 'Font'
    OnClick = LoadFontBtnClick
    TabOrder = 4
  end
  object NewScreenBox: TCheckBox
    Left = 528
    Height = 23
    Top = 264
    Width = 240
    Caption = 'Display message in separate window'
    OnClick = NewScreenBoxClick
    TabOrder = 5
  end
  object StaticText1: TStaticText
    Cursor = crHandPoint
    Left = 0
    Height = 20
    Top = 542
    Width = 784
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2001-2004, Gary Darby,  www.DelphiForFun.org'
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    OnClick = StaticText1Click
    ParentFont = False
    TabOrder = 6
  end
  object OpenDialog1: TOpenDialog
    Title = 'Select a Font'
    DefaultExt = '.led'
    Filter = 'LED Font (*.LED, *.Font)|*.led;*.font|All files (*.*)|*.*'
    left = 688
    top = 24
  end
  object ColorDialog1: TColorDialog
    Color = clBlack
    CustomColors.Strings = (
      'ColorA=000000'
      'ColorB=000080'
      'ColorC=008000'
      'ColorD=008080'
      'ColorE=800000'
      'ColorF=800080'
      'ColorG=808000'
      'ColorH=808080'
      'ColorI=C0C0C0'
      'ColorJ=0000FF'
      'ColorK=00FF00'
      'ColorL=00FFFF'
      'ColorM=FF0000'
      'ColorN=FF00FF'
      'ColorO=FFFF00'
      'ColorP=FFFFFF'
      'ColorQ=C0DCC0'
      'ColorR=F0CAA6'
      'ColorS=F0FBFF'
      'ColorT=A4A0A0'
    )
    left = 688
    top = 64
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    left = 744
    top = 216
  end
end
