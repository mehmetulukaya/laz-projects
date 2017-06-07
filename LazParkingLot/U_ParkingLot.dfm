object Form1: TForm1
  Left = 192
  Top = 120
  Width = 485
  Height = 414
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Lot: TImage
    Left = 40
    Top = 24
    Width = 393
    Height = 257
    OnClick = LotClick
  end
  object Label1: TLabel
    Left = 48
    Top = 312
    Width = 258
    Height = 20
    Caption = 'Click slots or cars to assign/unassign'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
end
