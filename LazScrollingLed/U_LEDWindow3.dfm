object LEDForm: TLEDForm
  Left = 184
  Height = 442
  Top = 39
  Width = 680
  BorderIcons = []
  ClientHeight = 442
  ClientWidth = 680
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  Position = poScreenCenter
  LCLVersion = '1.6.0.4'
  object Image2: TImage
    Left = 0
    Height = 442
    Top = 0
    Width = 680
    Align = alClient
    OnClick = Image2Click
  end
end
