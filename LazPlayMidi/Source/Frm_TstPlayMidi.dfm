object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Test: Play midi'
  ClientHeight = 160
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 96
    Top = 88
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 96
    Top = 104
    Width = 31
    Height = 13
    Caption = 'Label2'
  end
  object Button1: TButton
    Left = 8
    Top = 16
    Width = 81
    Height = 25
    Caption = 'Techno'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 47
    Width = 81
    Height = 25
    Caption = 'Root-Beer-Rag'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 78
    Width = 82
    Height = 25
    Caption = 'Born to be alive'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 325
    Top = 127
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 3
    OnClick = Button4Click
  end
  object TrackBar1: TTrackBar
    Left = 89
    Top = 47
    Width = 311
    Height = 39
    Enabled = False
    TabOrder = 4
    ThumbLength = 15
  end
  object Button5: TButton
    Left = 368
    Top = 78
    Width = 32
    Height = 25
    Caption = 'Stop'
    TabOrder = 5
    OnMouseDown = Button5MouseDown
    OnMouseUp = Button5MouseUp
  end
  object Button6: TButton
    Left = 152
    Top = 127
    Width = 75
    Height = 25
    Caption = 'Button6'
    TabOrder = 6
    OnClick = Button6Click
  end
end
