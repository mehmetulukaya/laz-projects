object LEDForm: TLEDForm
  Left = 192
  Top = 183
  BorderIcons = []
  ClientHeight = 442
  ClientWidth = 680
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Image2: TImage
    Left = 0
    Top = 0
    Width = 680
    Height = 442
    Align = alClient
    OnClick = Image2Click
    ExplicitHeight = 444
  end
end
