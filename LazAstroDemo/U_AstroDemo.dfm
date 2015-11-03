object Form1: TForm1
  Left = 170
  Height = 694
  Top = 9
  Width = 1102
  Caption = 'Astronomy Unit Demo, Version 2.0'
  ClientHeight = 674
  ClientWidth = 1102
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Menu = MainMenu1
  OnActivate = FormActivate
  OnClick = FormClick
  OnResize = FormResize
  Position = poScreenCenter
  LCLVersion = '1.4.0.4'
  object PBox: TPaintBox
    Left = 608
    Height = 345
    Top = 225
    Width = 346
    OnPaint = PBoxPaint
  end
  object Memo1: TMemo
    Left = 10
    Height = 310
    Top = 200
    Width = 582
    Font.CharSet = TURKISH_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Pitch = fpVariable
    Font.Quality = fqDraft
    Lines.Strings = (
      'Here''s a program to demonstrate some of the capabilities of the'
      'TAstronomy  unit.'
      ''
      'Given a viewer''s location on earth  (Latitude, Longitude, and Elevation'
      'above sea level), and a date/Time reference, options are available to'
      'determine the current position of the Sun, Moon or planets along with'
      'other information.'
      ''
      'Other buttons show information about Solar and Lunar eclipses near the '
      'reference date. and Analemmas  (diagram of the Sun;s position in the '
      'sky at a certain time of day for the entire year. '
      ''
      'One of the most confusing  aspects for astronomy beginners, including '
      'myself, is the multiple time systems (4) and location coordinate '
      'systems (5) in use.   The "Unit Conversions" button allow experimental '
      'conversions among these systems.   Be warned however, you will need '
      'to look up the definitions elsewhere.'
      ''
      'Version 2.0 adds "decimal format" option to the "degrees, minutes, seconds" '
      'format for angles.  Also analemmas can now be animated to show sun position '
      'on by date.  '
    )
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ShowBtn: TButton
    Left = 807
    Height = 31
    Top = 0
    Width = 130
    Caption = 'Sun Info'
    OnClick = ShowBtnClick
    TabOrder = 1
  end
  object AnalemmaBtn: TButton
    Left = 807
    Height = 31
    Top = 125
    Width = 130
    Caption = 'Analemma'
    OnClick = AnalemmaBtnClick
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 10
    Height = 193
    Top = 3
    Width = 779
    ClientHeight = 193
    ClientWidth = 779
    TabOrder = 3
    object Label2: TLabel
      Left = 39
      Height = 16
      Top = 64
      Width = 106
      Caption = 'Longitude (D M S)'
      ParentColor = False
    end
    object Label1: TLabel
      Left = 39
      Height = 16
      Top = 14
      Width = 94
      Caption = 'Latitude (D M S)'
      ParentColor = False
    end
    object Label3: TLabel
      Left = 39
      Height = 16
      Top = 100
      Width = 29
      Caption = 'Date'
      ParentColor = False
    end
    object Label8: TLabel
      Left = 226
      Height = 16
      Top = 100
      Width = 65
      Caption = 'Time Zone'
      ParentColor = False
    end
    object Label4: TLabel
      Left = 512
      Height = 16
      Top = 19
      Width = 141
      Caption = 'Meters above sea level'
      ParentColor = False
    end
    object LongEdt: TEdit
      Left = 167
      Height = 24
      Hint = 'May be entered as decimal degrees  or degrees, minutes, seconds'
      Top = 59
      Width = 120
      OnChange = BaseDataChange
      OnExit = LongEdtExit
      TabOrder = 0
      Text = '77 0 0'
    end
    object EWRGrp: TRadioGroup
      Left = 295
      Height = 41
      Top = 48
      Width = 159
      AutoFill = True
      ChildSizing.LeftRightSpacing = 6
      ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
      ChildSizing.EnlargeVertical = crsHomogenousChildResize
      ChildSizing.ShrinkHorizontal = crsScaleChilds
      ChildSizing.ShrinkVertical = crsScaleChilds
      ChildSizing.Layout = cclLeftToRightThenTopToBottom
      ChildSizing.ControlsPerLine = 2
      ClientHeight = 20
      ClientWidth = 155
      Columns = 2
      ItemIndex = 1
      Items.Strings = (
        'East'
        'West'
      )
      OnClick = BaseDataChange
      TabOrder = 1
    end
    object NSRGrp: TRadioGroup
      Left = 295
      Height = 40
      Top = 0
      Width = 159
      AutoFill = True
      ChildSizing.LeftRightSpacing = 6
      ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
      ChildSizing.EnlargeVertical = crsHomogenousChildResize
      ChildSizing.ShrinkHorizontal = crsScaleChilds
      ChildSizing.ShrinkVertical = crsScaleChilds
      ChildSizing.Layout = cclLeftToRightThenTopToBottom
      ChildSizing.ControlsPerLine = 2
      ClientHeight = 19
      ClientWidth = 155
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'North'
        'South'
      )
      OnClick = BaseDataChange
      TabOrder = 2
    end
    object LatEdt: TEdit
      Left = 167
      Height = 24
      Hint = 'May be entered as decimal degrees  or degrees, minutes, seconds'
      Top = 10
      Width = 120
      OnChange = BaseDataChange
      TabOrder = 3
      Text = '37 0 0 '
    end
    object TZBox: TComboBox
      Left = 305
      Height = 24
      Top = 100
      Width = 100
      ItemHeight = 16
      Items.Strings = (
        '-12'
        '-11'
        '-10'
        '-09'
        '-08  (PST)'
        '-07  (MST)'
        '-06   (CST) '
        '-05  (EST)'
        '-04  '
        '-03  '
        '-02 '
        '-01'
        '00'
        '+01'
        '+02'
        '+03'
        '+04'
        '+05'
        '+06'
        '+07'
        '+08'
        '+09'
        '+10'
        '+11'
      )
      OnChange = BaseDataChange
      TabOrder = 4
      Text = 'TZBox'
    end
    object DLSRGrp: TRadioGroup
      Left = 482
      Height = 46
      Top = 139
      Width = 268
      AutoFill = True
      Caption = 'Daylight Saving Add'
      ChildSizing.LeftRightSpacing = 6
      ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
      ChildSizing.EnlargeVertical = crsHomogenousChildResize
      ChildSizing.ShrinkHorizontal = crsScaleChilds
      ChildSizing.ShrinkVertical = crsScaleChilds
      ChildSizing.Layout = cclLeftToRightThenTopToBottom
      ChildSizing.ControlsPerLine = 3
      ClientHeight = 25
      ClientWidth = 264
      Columns = 3
      ItemIndex = 0
      Items.Strings = (
        '0 hours '
        '1 hour'
        '2 hours'
      )
      OnClick = BaseDataChange
      TabOrder = 5
    end
    object HeightEdt: TEdit
      Left = 660
      Height = 24
      Top = 19
      Width = 70
      OnChange = BaseDataChange
      TabOrder = 6
      Text = '0'
    end
    object HeightUD: TUpDown
      Left = 730
      Height = 24
      Top = 19
      Width = 15
      Associate = HeightEdt
      Max = 10000
      Min = -500
      Position = 0
      TabOrder = 7
      Wrap = False
    end
    object TimeBox: TComboBox
      Left = 601
      Height = 24
      Top = 100
      Width = 149
      ItemHeight = 16
      Items.Strings = (
        'Local Time'
        'Universal Time (UT)'
      )
      OnChange = TimeBoxChange
      TabOrder = 8
      Text = 'Select a time base'
    end
    object Button1: TButton
      Left = 39
      Height = 31
      Top = 139
      Width = 189
      Caption = 'Set date/time to now'
      OnClick = Button1Click
      TabOrder = 9
    end
    object DatePicker: TDateTimePicker
      Left = 83
      Height = 24
      Top = 100
      Width = 87
      CenturyFrom = 1941
      MaxDate = 2958465
      MinDate = -53780
      TabOrder = 10
      TrailingSeparator = False
      TextForNullDate = 'NULL'
      LeadingZeros = True
      Kind = dtkDate
      TimeFormat = tf24
      TimeDisplay = tdHMS
      DateMode = dmComboBox
      Date = 42167
      Time = 0.650695127311337
      UseDefaultSeparators = True
      HideDateTimeParts = []
      MonthNames = 'Long'
    end
    object TimePicker: TDateTimePicker
      Left = 482
      Height = 24
      Top = 100
      Width = 71
      CenturyFrom = 1941
      MaxDate = 2958465
      MinDate = -53780
      TabOrder = 11
      TrailingSeparator = False
      TextForNullDate = 'NULL'
      LeadingZeros = True
      Kind = dtkTime
      TimeFormat = tf24
      TimeDisplay = tdHMS
      DateMode = dmComboBox
      Date = 42167
      Time = 0.650695127311337
      UseDefaultSeparators = True
      HideDateTimeParts = []
      MonthNames = 'Long'
    end
  end
  object TstBtn: TButton
    Left = 807
    Height = 31
    Top = 158
    Width = 130
    Caption = 'Unit conversions'
    OnClick = TstBtnClick
    TabOrder = 4
  end
  object MoonBtn: TButton
    Left = 807
    Height = 31
    Top = 33
    Width = 130
    Caption = 'Moon Info'
    OnClick = MoonBtnClick
    TabOrder = 5
  end
  object EclipseBtn: TButton
    Left = 807
    Height = 31
    Top = 92
    Width = 130
    Caption = 'Eclipse Info'
    OnClick = EclipseBtnClick
    TabOrder = 6
  end
  object PlanetBox: TComboBox
    Left = 807
    Height = 24
    Top = 66
    Width = 130
    ItemHeight = 16
    Items.Strings = (
      'MERCURY'
      'VENUS'
      'MARS'
      'JUPITER'
      'SATURN'
      'URANUS'
      'NEPTUNE'
      'PLUTO'
      ' '
    )
    OnClick = PlanetBoxClick
    TabOrder = 7
    Text = 'Select a planet'
  end
  object StaticText1: TStaticText
    Cursor = crHandPoint
    Left = 0
    Height = 24
    Top = 650
    Width = 1102
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2003, 2015  Gary Darby,  www.DelphiForFun.org'
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    OnClick = StaticText1Click
    ParentFont = False
    TabOrder = 8
  end
  object AnalemmaPanel: TPanel
    Left = 151
    Height = 118
    Top = 522
    Width = 441
    ClientHeight = 118
    ClientWidth = 441
    TabOrder = 9
    Visible = False
    OnExit = AnallemmPanelExit
    object AnDateLbl: TLabel
      Left = 16
      Height = 19
      Top = 46
      Width = 34
      Caption = 'Date'
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      ParentColor = False
      ParentFont = False
    end
    object AzLbl: TLabel
      Left = 16
      Height = 19
      Top = 68
      Width = 40
      Caption = 'AzLbl'
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      ParentColor = False
      ParentFont = False
    end
    object AltLbl: TLabel
      Left = 16
      Height = 19
      Top = 93
      Width = 39
      Caption = 'AltLbl'
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      ParentColor = False
      ParentFont = False
    end
    object AnimateBtn: TButton
      Left = 16
      Height = 25
      Top = 15
      Width = 129
      Caption = 'Animate'
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      OnClick = AnimateBtnClick
      ParentFont = False
      TabOrder = 0
    end
    object AnTypeGrp: TRadioGroup
      Left = 193
      Height = 89
      Top = 15
      Width = 225
      AutoFill = True
      Caption = 'Analemma type'
      ChildSizing.LeftRightSpacing = 6
      ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
      ChildSizing.EnlargeVertical = crsHomogenousChildResize
      ChildSizing.ShrinkHorizontal = crsScaleChilds
      ChildSizing.ShrinkVertical = crsScaleChilds
      ChildSizing.Layout = cclLeftToRightThenTopToBottom
      ChildSizing.ControlsPerLine = 1
      ClientHeight = 68
      ClientWidth = 221
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      ItemIndex = 0
      Items.Strings = (
        'Shadow (Looking South)'
        'Camera (Pointing South)'
      )
      OnClick = AnTypeGrpClick
      ParentFont = False
      TabOrder = 1
    end
  end
  object MainMenu1: TMainMenu
    left = 1017
    top = 43
    object File1: TMenuItem
      Caption = 'File'
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object Calctype1: TMenuItem
        Caption = 'Time system for display...'
        object LocalCiviltime1: TMenuItem
          Caption = 'Local Civil '
          Checked = True
          RadioItem = True
          OnClick = SelectTimeOptClick
        end
        object UniversalTime1: TMenuItem
          Caption = 'Universal '
          RadioItem = True
          OnClick = SelectTimeOptClick
        end
        object GreenwichSiderealTime1: TMenuItem
          Caption = 'Greenwich Sidereal '
          RadioItem = True
          OnClick = SelectTimeOptClick
        end
        object LocalSidereal1: TMenuItem
          Caption = 'Local Sidereal'
          RadioItem = True
          OnClick = SelectTimeOptClick
        end
      end
      object Displaycelestialpositonformat1: TMenuItem
        Caption = 'Celestial positon system for display ...'
        object EclOpt: TMenuItem
          Caption = 'Ecliptic Long/lat'
          RadioItem = True
          OnClick = AngleOptionClick
        end
        object AzAltOpt: TMenuItem
          Caption = 'Azimth/Altitude'
          Checked = True
          RadioItem = True
          OnClick = AngleOptionClick
        end
        object RADeclOpt: TMenuItem
          Caption = 'Right Ascension /Declination'
          RadioItem = True
          OnClick = AngleOptionClick
        end
        object HADeclOpt: TMenuItem
          Caption = 'Hour Angle/Declination'
          RadioItem = True
          OnClick = AngleOptionClick
        end
        object GalOpt: TMenuItem
          Caption = 'Galactic Long/Lat'
          OnClick = AngleOptionClick
        end
      end
      object AngleFormat1: TMenuItem
        Caption = 'Angle Format...'
        object DMSFmt: TMenuItem
          Caption = 'Dgerees Minutes Seconds'
          Checked = True
          OnClick = DMSFmtClick
        end
        object DecimalDegrees1: TMenuItem
          Caption = 'Decimal Degrees'
          OnClick = DecimalDegrees1Click
        end
      end
    end
    object Actions1: TMenuItem
      Caption = 'Actions'
      object SunriseSunset1: TMenuItem
        Caption = 'Sun Info'
        OnClick = ShowBtnClick
      end
      object Moonrisemoonset1: TMenuItem
        Caption = 'Moon Info'
        OnClick = MoonBtnClick
      end
      object Planetpositions1: TMenuItem
        Caption = 'Planets'
        object Mercury1: TMenuItem
          Caption = 'Mercury'
          OnClick = PlanetItemClick
        end
        object Venus1: TMenuItem
          Tag = 1
          Caption = 'Venus'
          OnClick = PlanetItemClick
        end
        object Mars1: TMenuItem
          Tag = 2
          Caption = 'Mars'
          OnClick = PlanetItemClick
        end
        object Jupiter1: TMenuItem
          Tag = 3
          Caption = 'Jupiter'
          OnClick = PlanetItemClick
        end
        object Saturn2: TMenuItem
          Tag = 4
          Caption = 'Saturn'
          OnClick = PlanetItemClick
        end
        object Saturn1: TMenuItem
          Tag = 5
          Caption = 'Uranus'
          OnClick = PlanetItemClick
        end
        object Neptune1: TMenuItem
          Tag = 6
          Caption = 'Neptune'
          OnClick = PlanetItemClick
        end
        object Pluto1: TMenuItem
          Tag = 7
          Caption = 'Pluto'
          OnClick = PlanetItemClick
        end
      end
      object EclipseInfo1: TMenuItem
        Caption = 'Eclipse Info'
        OnClick = EclipseBtnClick
      end
      object Analemma2: TMenuItem
        Caption = 'Analemma'
        OnClick = AnalemmaBtnClick
      end
      object Checkunitconversions1: TMenuItem
        Caption = 'Unit conversions'
        OnClick = TstBtnClick
      end
    end
  end
end
