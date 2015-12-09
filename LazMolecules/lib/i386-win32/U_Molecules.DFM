object Form1: TForm1
  Left = 279
  Height = 446
  Top = 137
  Width = 665
  Caption = 'Molekyl6'
  ClientHeight = 426
  ClientWidth = 665
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Menu = MainMenu1
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  LCLVersion = '1.4.4.0'
  object Image1: TImage
    Left = 0
    Height = 403
    Top = 0
    Width = 665
    Align = alClient
    OnClick = Image1Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Height = 23
    Top = 403
    Width = 665
    Panels = <    
      item
        Alignment = taCenter
        Text = 'Copyright  © 2002, Gary Darby,  www.DelphiForFun.org'
        Width = 50
      end>
    SimplePanel = False
  end
  object MainMenu1: TMainMenu
    left = 80
    top = 40
    object Close1: TMenuItem
      Caption = 'Close'
      OnClick = Close1Click
    end
    object Start1: TMenuItem
      Caption = 'Start'
      OnClick = Start1Click
    end
    object Stop1: TMenuItem
      Caption = 'Stop'
      OnClick = Stop1Click
    end
    object Setup1: TMenuItem
      Caption = 'Setup'
      object Setup11: TMenuItem
        Tag = 1
        Caption = 'Setup1 - Inline equal mass'
        OnClick = SetupClick
      end
      object Setup21: TMenuItem
        Tag = 2
        Caption = 'Setup2- Inline, one heavy'
        OnClick = SetupClick
      end
      object Setup31: TMenuItem
        Tag = 3
        Caption = 'Setup3 - Brownian'
        OnClick = SetupClick
      end
      object Stup41: TMenuItem
        Tag = 4
        Caption = 'Setup4 - Heavy && light, slow'
        OnClick = SetupClick
      end
      object Setup51: TMenuItem
        Tag = 5
        Caption = 'Setup5 - heavy && light , fast'
        OnClick = SetupClick
      end
    end
  end
end
