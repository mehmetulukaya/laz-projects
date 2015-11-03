object frmMain: TfrmMain
  Left = 261
  Height = 547
  Top = 106
  Width = 611
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'box2D PingPong'
  ClientHeight = 547
  ClientWidth = 611
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  KeyPreview = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  Position = poDesktopCenter
  LCLVersion = '1.4.0.4'
  object imgDisplay: TImage
    Left = 6
    Height = 500
    Top = 6
    Width = 600
    OnMouseDown = imgDisplayMouseDown
  end
  object Bevel1: TBevel
    Left = -4
    Height = 2
    Top = 512
    Width = 619
  end
  object btnNewGame: TButton
    Left = 6
    Height = 25
    Top = 517
    Width = 75
    Anchors = [akLeft, akBottom]
    Caption = 'New Game'
    OnClick = btnNewGameClick
    TabOrder = 0
  end
  object clrBlockColor: TColorBox
    Left = 364
    Height = 22
    Top = 519
    Width = 73
    Style = [cbStandardColors, cbExtendedColors, cbPrettyNames, cbCustomColors]
    Anchors = [akLeft, akBottom]
    ItemHeight = 16
    OnChange = clrBlockColorChange
    TabOrder = 1
  end
  object cboBlockType: TComboBox
    Left = 441
    Height = 21
    Top = 519
    Width = 88
    Anchors = [akLeft, akBottom]
    AutoDropDown = True
    ItemHeight = 13
    Items.Strings = (
      'Unbreakable'
      'Hit Once'
      'Hit Twice'
      'Hit Thrice'
    )
    OnChange = cboBlockTypeChange
    Style = csDropDownList
    TabOrder = 2
  end
  object btnPauseResume: TButton
    Left = 83
    Height = 25
    Top = 517
    Width = 75
    Anchors = [akLeft, akBottom]
    Caption = 'Pause'
    OnClick = btnPauseResumeClick
    TabOrder = 3
  end
  object btnLoadMap: TButton
    Left = 160
    Height = 25
    Top = 517
    Width = 75
    Anchors = [akLeft, akBottom]
    Caption = 'Load Map'
    OnClick = btnLoadMapClick
    TabOrder = 4
  end
  object btnSaveMap: TButton
    Left = 532
    Height = 25
    Top = 517
    Width = 75
    Anchors = [akLeft, akBottom]
    Caption = 'Save Map'
    OnClick = btnSaveMapClick
    TabOrder = 5
  end
  object chkEditMode: TCheckBox
    Left = 280
    Height = 19
    Top = 520
    Width = 81
    Anchors = [akLeft, akBottom]
    Caption = 'Editing Mode'
    OnClick = chkEditModeClick
    TabOrder = 6
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '.*.map'
    Filter = 'Map File(*.map)|*.map'
    Options = [ofHideReadOnly, ofNoChangeDir, ofFileMustExist, ofEnableSizing]
    left = 360
    top = 256
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.*.map'
    Filter = 'Map File(*.map)|*.map'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    left = 416
    top = 256
  end
end
