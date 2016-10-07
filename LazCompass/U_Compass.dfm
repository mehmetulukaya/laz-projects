object Form1: TForm1
  Left = 331
  Height = 484
  Top = 80
  Width = 525
  ActiveControl = Memo1
  AutoSize = True
  Caption = 'Compass Drawing Demo'
  ClientHeight = 484
  ClientWidth = 525
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  OnActivate = FormActivate
  Position = poScreenCenter
  LCLVersion = '1.6.0.4'
  Visible = False
  object StaticText1: TStaticText
    Cursor = crHandPoint
    Left = 0
    Height = 23
    Top = 461
    Width = 525
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2010, Gary Darby,  www.DelphiForFun.org'
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    OnClick = StaticText1Click
    ParentFont = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Height = 461
    Top = 0
    Width = 525
    Align = alClient
    ClientHeight = 461
    ClientWidth = 525
    TabOrder = 1
    object Compass: TPaintBox
      Left = 25
      Height = 300
      Top = 111
      Width = 300
      OnPaint = CompassPaint
    end
    object Label1: TLabel
      Left = 334
      Height = 16
      Top = 7
      Width = 163
      Caption = 'Heading angle in degrees'
      ParentColor = False
    end
    object Memo1: TMemo
      Left = 25
      Height = 68
      Top = 30
      Width = 222
      Color = 14548991
      Font.CharSet = TURKISH_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Pitch = fpVariable
      Font.Quality = fqDraft
      Lines.Strings = (
        'Here''s a sample Compass drawing'
        'demonstration which will show how '
        'to rotate the '
        'dial or the pointer in Delphi code.    '
        'The angle '
        'is specified in the "Heading" '
        'SpinEdit control;'
        ''
        'It uses a TPaintbox, "Compass", to '
        'repaint the '
        'compass when needed.  Compass '
        'is '
        'completely redrawn for each call so '
        'its owner '
        '(Panel1) has its "Doublebuffered" '
        'property set '
        'True to prevent flashing when the '
        'space is '
        'cleared before redrawing.'
        ''
        'It uses the TLogRec data structure '
        'and the'
        'CreateFontIndirect procedure to '
        'draw letters'
        'and numbers at right angles to the '
        'direction'
        'radial..'
        ''
        'The pointer is two back-to-back '
        'triangles drawn'
        'with the Polygon method and filled '
        'with different'
        'Brush property colors of the '
        'Paintbox''s Canvas'
        'property.'
      )
      ParentFont = False
      TabOrder = 0
    end
    object Heading: TSpinEdit
      Left = 431
      Height = 34
      Top = 30
      Width = 65
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      MaxValue = 3600
      MinValue = -3600
      OnChange = ForceRepaint
      ParentFont = False
      TabOrder = 1
      Value = 45
    end
    object TypeGrp: TRadioGroup
      Left = 263
      Height = 65
      Top = 30
      Width = 161
      AutoFill = True
      Caption = 'Compass type'
      ChildSizing.LeftRightSpacing = 6
      ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
      ChildSizing.EnlargeVertical = crsHomogenousChildResize
      ChildSizing.ShrinkHorizontal = crsScaleChilds
      ChildSizing.ShrinkVertical = crsScaleChilds
      ChildSizing.Layout = cclLeftToRightThenTopToBottom
      ChildSizing.ControlsPerLine = 1
      ClientHeight = 48
      ClientWidth = 159
      ItemIndex = 0
      Items.Strings = (
        'Rotate dial'
        'Rotate pointer'
      )
      OnClick = ForceRepaint
      TabOrder = 2
    end
  end
end
