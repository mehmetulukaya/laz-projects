object Form1: TForm1
  Left = 191
  Height = 414
  Top = 94
  Width = 485
  Caption = 'Form1'
  ClientHeight = 414
  ClientWidth = 485
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnCreate = FormCreate
  Position = poScreenCenter
  LCLVersion = '1.8.0.1'
  object Lot: TImage
    Left = 40
    Height = 257
    Top = 24
    Width = 393
    OnClick = LotClick
  end
  object Label1: TLabel
    Left = 48
    Height = 19
    Top = 312
    Width = 290
    Caption = 'Click slots or cars to assign/unassign'
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    ParentColor = False
    ParentFont = False
  end
end
