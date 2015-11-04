object Stats: TStats
  Left = 154
  Height = 566
  Top = 102
  Width = 792
  BorderStyle = bsDialog
  Caption = 'Cannon firing statistics'
  ClientHeight = 566
  ClientWidth = 792
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Position = poScreenCenter
  LCLVersion = '1.4.0.4'
  object Label1: TLabel
    Left = 168
    Height = 16
    Top = 360
    Width = 136
    Caption = 'Theoretical Results'
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Button1: TButton
    Left = 356
    Height = 25
    Top = 522
    Width = 75
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object StringGrid1: TStringGrid
    Left = 0
    Height = 345
    Top = 0
    Width = 792
    Align = alTop
    ColCount = 10
    ScrollBars = ssVertical
    TabOrder = 1
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
  end
  object Memo1: TMemo
    Left = 168
    Height = 137
    Top = 376
    Width = 465
    Lines.Strings = (
      'Memo1'
    )
    TabOrder = 2
  end
end
