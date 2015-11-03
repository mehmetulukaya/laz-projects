object TConvertTest: TTConvertTest
  Left = 282
  Height = 600
  Top = 59
  Width = 779
  Caption = 'TAstronomy Conversion Tests'
  ClientHeight = 600
  ClientWidth = 779
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OnClose = FormClose
  Position = poScreenCenter
  LCLVersion = '1.4.0.4'
  object Label1: TLabel
    Left = 16
    Height = 13
    Top = 84
    Width = 94
    Caption = 'Latitude (D M S)'
    ParentColor = False
  end
  object Label2: TLabel
    Left = 16
    Height = 13
    Top = 36
    Width = 104
    Caption = 'Longitude (D M S)'
    ParentColor = False
  end
  object Label3: TLabel
    Left = 360
    Height = 13
    Top = 24
    Width = 28
    Caption = 'Date'
    ParentColor = False
  end
  object Label8: TLabel
    Left = 360
    Height = 13
    Top = 80
    Width = 61
    Caption = 'Time Zone'
    ParentColor = False
  end
  object DatePicker: TDateTimePicker
    Left = 416
    Height = 21
    Top = 20
    Width = 89
    CenturyFrom = 1941
    MaxDate = 2958465
    MinDate = -53780
    TabOrder = 0
    TrailingSeparator = False
    LeadingZeros = True
    Kind = dtkDate
    TimeFormat = tf24
    TimeDisplay = tdHMS
    DateMode = dmComboBox
    Date = 33870
    Time = 0
    UseDefaultSeparators = True
    HideDateTimeParts = []
    MonthNames = 'Long'
  end
  object TZBox: TComboBox
    Left = 432
    Height = 21
    Top = 76
    Width = 81
    ItemHeight = 13
    Items.Strings = (
      '-12'
      '-11'
      '-10'
      '-09'
      '-08  (PST)'
      '-07  (MST)'
      '-06  (CST) '
      '-05  (EST)  '
      '-04  '
      '-03 '
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
    Style = csDropDownList
    TabOrder = 1
  end
  object NSRGrp: TRadioGroup
    Left = 256
    Height = 49
    Top = 62
    Width = 81
    AutoFill = True
    ChildSizing.LeftRightSpacing = 6
    ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
    ChildSizing.EnlargeVertical = crsHomogenousChildResize
    ChildSizing.ShrinkHorizontal = crsScaleChilds
    ChildSizing.ShrinkVertical = crsScaleChilds
    ChildSizing.Layout = cclLeftToRightThenTopToBottom
    ChildSizing.ControlsPerLine = 1
    ClientHeight = 31
    ClientWidth = 77
    ItemIndex = 1
    Items.Strings = (
      'North'
      'South'
    )
    TabOrder = 2
  end
  object EWRGrp: TRadioGroup
    Left = 256
    Height = 49
    Top = 14
    Width = 81
    AutoFill = True
    ChildSizing.LeftRightSpacing = 6
    ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
    ChildSizing.EnlargeVertical = crsHomogenousChildResize
    ChildSizing.ShrinkHorizontal = crsScaleChilds
    ChildSizing.ShrinkVertical = crsScaleChilds
    ChildSizing.Layout = cclLeftToRightThenTopToBottom
    ChildSizing.ControlsPerLine = 1
    ClientHeight = 31
    ClientWidth = 77
    ItemIndex = 0
    Items.Strings = (
      'East'
      'West'
    )
    TabOrder = 3
  end
  object LatEdt: TEdit
    Left = 136
    Height = 21
    Top = 80
    Width = 97
    TabOrder = 4
    Text = '20 0 3.4'
  end
  object LongEdt: TEdit
    Left = 136
    Height = 21
    Top = 32
    Width = 97
    TabOrder = 5
    Text = '62 10 12'
  end
  object DLSRGrp: TRadioGroup
    Left = 552
    Height = 73
    Top = 24
    Width = 177
    AutoFill = True
    Caption = 'Daylight Saving'
    ChildSizing.LeftRightSpacing = 6
    ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
    ChildSizing.EnlargeVertical = crsHomogenousChildResize
    ChildSizing.ShrinkHorizontal = crsScaleChilds
    ChildSizing.ShrinkVertical = crsScaleChilds
    ChildSizing.Layout = cclLeftToRightThenTopToBottom
    ChildSizing.ControlsPerLine = 1
    ClientHeight = 55
    ClientWidth = 173
    ItemIndex = 0
    Items.Strings = (
      'Added 0 hours to local'
      'Added 1 hour to local'
      'Added 2 hours to local'
    )
    OnClick = DLSRGrpClick
    TabOrder = 6
  end
  object BitBtn1: TBitBtn
    Left = 296
    Height = 25
    Top = 184
    Width = 177
    Caption = 'Convert In to Out'
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333333333333333333333333
      3333333333333333333333333333333333333333333FF3333333333333003333
      3333333333773FF3333333333309003333333333337F773FF333333333099900
      33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
      99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
      33333333337F3F77333333333309003333333333337F77333333333333003333
      3333333333773333333333333333333333333333333333333333333333333333
      3333333333333333333333333333333333333333333333333333
    }
    Layout = blGlyphRight
    NumGlyphs = 2
    OnClick = TestBtnClick
    ParentFont = False
    TabOrder = 7
  end
  object GroupBox1: TGroupBox
    Left = 8
    Height = 409
    Top = 120
    Width = 257
    Caption = 'Data In'
    ClientHeight = 391
    ClientWidth = 253
    TabOrder = 8
    object Label6: TLabel
      Left = 24
      Height = 13
      Top = 124
      Width = 75
      Caption = 'Time (H,M,S)'
      ParentColor = False
    end
    object HrDegInLbl: TLabel
      Left = 32
      Height = 13
      Top = 340
      Width = 60
      Caption = 'X  (D,M,S)'
      ParentColor = False
    end
    object Label9: TLabel
      Left = 32
      Height = 13
      Top = 372
      Width = 60
      Caption = 'Y  (D,M,S)'
      ParentColor = False
    end
    object TimeInRGrp: TRadioGroup
      Left = 24
      Height = 89
      Top = 24
      Width = 185
      AutoFill = True
      Caption = 'Time base '
      ChildSizing.LeftRightSpacing = 6
      ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
      ChildSizing.EnlargeVertical = crsHomogenousChildResize
      ChildSizing.ShrinkHorizontal = crsScaleChilds
      ChildSizing.ShrinkVertical = crsScaleChilds
      ChildSizing.Layout = cclLeftToRightThenTopToBottom
      ChildSizing.ControlsPerLine = 1
      ClientHeight = 71
      ClientWidth = 181
      ItemIndex = 0
      Items.Strings = (
        'Local '
        'Universal '
        'Greewich sidereal'
        'Local sidereal'
      )
      TabOrder = 0
    end
    object CoordInRGrp: TRadioGroup
      Left = 24
      Height = 169
      Top = 152
      Width = 185
      AutoFill = True
      Caption = 'Coordinate system'
      ChildSizing.LeftRightSpacing = 6
      ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
      ChildSizing.EnlargeVertical = crsHomogenousChildResize
      ChildSizing.ShrinkHorizontal = crsScaleChilds
      ChildSizing.ShrinkVertical = crsScaleChilds
      ChildSizing.Layout = cclLeftToRightThenTopToBottom
      ChildSizing.ControlsPerLine = 1
      ClientHeight = 151
      ClientWidth = 181
      ItemIndex = 2
      Items.Strings = (
        'Horizon (Azimuth,Altitude)'
        'Ecliptic (Long,Lat)'
        'Equatorial (HA,Decl)'
        'Equatorial (RA,Decl)'
        'Galactic (Long,Lat)'
        'Sun Position for this time'
        'Sunrise'
        'Sunset'
      )
      OnClick = CoordInRGrpClick
      TabOrder = 1
    end
    object XInEdt: TEdit
      Left = 104
      Height = 21
      Top = 336
      Width = 105
      TabOrder = 2
      Text = '12 16 0'
    end
    object YInEdt: TEdit
      Left = 104
      Height = 21
      Top = 368
      Width = 105
      TabOrder = 3
      Text = '14 34 0'
    end
    object TimeIn: TDateTimePicker
      Left = 104
      Height = 21
      Top = 120
      Width = 73
      CenturyFrom = 1941
      MaxDate = 2958465
      MinDate = -53780
      TabOrder = 4
      TrailingSeparator = False
      LeadingZeros = True
      Kind = dtkTime
      TimeFormat = tf24
      TimeDisplay = tdHMS
      DateMode = dmComboBox
      Date = 36526
      Time = 0.939192129597359
      UseDefaultSeparators = True
      HideDateTimeParts = []
      MonthNames = 'Long'
    end
  end
  object GroupBox2: TGroupBox
    Left = 496
    Height = 393
    Top = 136
    Width = 257
    Caption = 'Data Out'
    ClientHeight = 375
    ClientWidth = 253
    TabOrder = 9
    object Label14: TLabel
      Left = 24
      Height = 13
      Top = 124
      Width = 75
      Caption = 'Time (H,M,S)'
      ParentColor = False
    end
    object HrDegOutLbl: TLabel
      Left = 32
      Height = 13
      Top = 300
      Width = 60
      Caption = 'X  (D,M,S)'
      ParentColor = False
    end
    object Label16: TLabel
      Left = 32
      Height = 13
      Top = 332
      Width = 60
      Caption = 'Y  (D,M,S)'
      ParentColor = False
    end
    object TimeOutRGrp: TRadioGroup
      Left = 24
      Height = 89
      Top = 24
      Width = 185
      AutoFill = True
      Caption = 'Time base'
      ChildSizing.LeftRightSpacing = 6
      ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
      ChildSizing.EnlargeVertical = crsHomogenousChildResize
      ChildSizing.ShrinkHorizontal = crsScaleChilds
      ChildSizing.ShrinkVertical = crsScaleChilds
      ChildSizing.Layout = cclLeftToRightThenTopToBottom
      ChildSizing.ControlsPerLine = 1
      ClientHeight = 71
      ClientWidth = 181
      ItemIndex = 1
      Items.Strings = (
        'Local '
        'Universal '
        'Greewich sidereal'
        'Local sidereal'
      )
      OnClick = TestBtnClick
      TabOrder = 0
    end
    object TimeOut: TDateTimePicker
      Left = 104
      Height = 21
      Top = 120
      Width = 73
      CenturyFrom = 1941
      MaxDate = 2958465
      MinDate = -53780
      TabOrder = 1
      TrailingSeparator = False
      LeadingZeros = True
      Kind = dtkTime
      TimeFormat = tf24
      TimeDisplay = tdHMS
      DateMode = dmComboBox
      Date = 36526
      Time = 0.939192129597359
      UseDefaultSeparators = True
      HideDateTimeParts = []
      MonthNames = 'Long'
    end
    object CoordOutRGrp: TRadioGroup
      Left = 24
      Height = 121
      Top = 160
      Width = 185
      AutoFill = True
      Caption = 'Coordinate system'
      ChildSizing.LeftRightSpacing = 6
      ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
      ChildSizing.EnlargeVertical = crsHomogenousChildResize
      ChildSizing.ShrinkHorizontal = crsScaleChilds
      ChildSizing.ShrinkVertical = crsScaleChilds
      ChildSizing.Layout = cclLeftToRightThenTopToBottom
      ChildSizing.ControlsPerLine = 1
      ClientHeight = 103
      ClientWidth = 181
      ItemIndex = 0
      Items.Strings = (
        'Horizon (Azimuth,Altitude)'
        'Ecliptic (Long,Lat)'
        'Equatorial (HA,Decl)'
        'Equatorial (RA,Decl)'
        'Galactic (Long,Lat)'
      )
      OnClick = CoordOutRGrpClick
      TabOrder = 2
    end
    object XoutEdt: TEdit
      Left = 120
      Height = 21
      Top = 296
      Width = 105
      TabOrder = 3
      Text = '12 16 0'
    end
    object YOutEdt: TEdit
      Left = 120
      Height = 21
      Top = 328
      Width = 105
      TabOrder = 4
      Text = '14 34 0'
    end
  end
  object Panel1: TPanel
    Left = 288
    Height = 225
    Top = 304
    Width = 185
    ClientHeight = 225
    ClientWidth = 185
    TabOrder = 10
    Visible = False
    object Label4: TLabel
      Left = 48
      Height = 13
      Top = 32
      Width = 47
      Caption = 'Sunrise '
      ParentColor = False
    end
    object Label5: TLabel
      Left = 37
      Height = 13
      Top = 63
      Width = 57
      Caption = '   Azimuth'
      ParentColor = False
    end
    object Label10: TLabel
      Left = 51
      Height = 13
      Top = 93
      Width = 44
      Caption = 'Sunset '
      ParentColor = False
    end
    object Label11: TLabel
      Left = 37
      Height = 13
      Top = 124
      Width = 57
      Caption = '   Azimuth'
      ParentColor = False
    end
    object Label7: TLabel
      Left = 16
      Height = 13
      Top = 152
      Width = 151
      Caption = 'LST = Local Sideeal Time)'
      ParentColor = False
    end
    object SRAz: TEdit
      Left = 104
      Height = 21
      Top = 59
      Width = 73
      ReadOnly = True
      TabOrder = 0
      Text = '0:0:0'
    end
    object SSAz: TEdit
      Left = 104
      Height = 21
      Top = 120
      Width = 73
      ReadOnly = True
      TabOrder = 1
      Text = '0:0:0'
    end
    object SRmsg: TEdit
      Left = 16
      Height = 21
      Top = 176
      Width = 153
      ReadOnly = True
      TabOrder = 2
    end
    object SSTime: TEdit
      Left = 104
      Height = 21
      Top = 91
      Width = 73
      ReadOnly = True
      TabOrder = 3
      Text = '0:0:0'
    end
    object SRTime: TEdit
      Left = 104
      Height = 21
      Top = 27
      Width = 73
      ReadOnly = True
      TabOrder = 4
      Text = '0:0:0'
    end
  end
  object StaticText1: TStaticText
    Cursor = crHandPoint
    Left = 0
    Height = 20
    Top = 580
    Width = 779
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2003, Gary Darby,  www.DelphiForFun.org'
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    OnClick = StaticText1Click
    ParentFont = False
    TabOrder = 11
  end
  object Memo1: TMemo
    Left = 280
    Height = 257
    Top = 272
    Width = 201
    Lines.Strings = (
      'Initial values are copied from '
      'Astronomy Demo main form.  Make '
      'any changes desired, select the '
      'output time and coordinate '
      'systems desired and click the '
      '"Convert" button to view '
      'conversion results.'
      ''
      'If you select one of the bottom '
      'three radio buttons from the box '
      'at left (Sun Position, Sunrise, '
      'Sunset), the Time Base is set to '
      '"Local", the coordinates '
      'option is set to to "Horizon" '
      'and Azimuth and Altitude are '
      'displayed.  For "Sunrise" and '
      '"Sunset", the Time field  is also '
      'changed to that time.'
    )
    TabOrder = 12
  end
end
