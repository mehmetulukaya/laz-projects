object frmMain: TfrmMain
  Left = 303
  Height = 570
  Top = 114
  Width = 653
  Caption = 'frmMain'
  ClientHeight = 550
  ClientWidth = 653
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Menu = MainMenu1
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  LCLVersion = '1.4.0.4'
  object pnlLeft: TPanel
    Left = 0
    Height = 527
    Top = 0
    Width = 133
    Align = alLeft
    BevelOuter = bvLowered
    ClientHeight = 527
    ClientWidth = 133
    TabOrder = 0
    object Label3: TLabel
      Left = 8
      Height = 13
      Top = 292
      Width = 53
      Caption = 'Block Size:'
      ParentColor = False
    end
    object Label2: TLabel
      Left = 32
      Height = 13
      Top = 132
      Width = 27
      Caption = 'Rows'
      ParentColor = False
    end
    object Label5: TLabel
      Left = 32
      Height = 13
      Top = 148
      Width = 40
      Caption = 'Columns'
      ParentColor = False
    end
    object lblRows: TLabel
      Left = 76
      Height = 13
      Top = 132
      Width = 45
      Caption = 'lblRows'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object lblCols: TLabel
      Left = 76
      Height = 13
      Top = 148
      Width = 38
      Caption = 'lblCols'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Label1: TLabel
      Left = 8
      Height = 45
      Top = 456
      Width = 113
      AutoSize = False
      Caption = 'Left-click on the Maze to set Start, Right-click to set Finish.'
      ParentColor = False
      WordWrap = True
    end
    object Label4: TLabel
      Left = 8
      Height = 13
      Top = 372
      Width = 114
      Caption = 'Colors (click to change):'
      ParentColor = False
    end
    object Label6: TLabel
      Left = 8
      Height = 13
      Top = 316
      Width = 48
      Caption = 'Step Size:'
      ParentColor = False
    end
    object Label7: TLabel
      Left = 8
      Height = 13
      Top = 340
      Width = 50
      Caption = 'Ends Size:'
      ParentColor = False
    end
    object sbCols: TScrollBar
      Left = 22
      Height = 16
      Top = 106
      Width = 105
      LargeChange = 16
      Max = 256
      Min = 2
      PageSize = 0
      Position = 40
      TabOrder = 0
      OnChange = sbColsChange
    end
    object sbRows: TScrollBar
      Left = 4
      Height = 105
      Top = 124
      Width = 16
      Kind = sbVertical
      LargeChange = 16
      Max = 256
      Min = 2
      PageSize = 0
      Position = 40
      TabOrder = 1
      OnChange = sbRowsChange
    end
    object spnRandSeed: TSpinEdit
      Left = 28
      Height = 21
      Top = 256
      Width = 81
      Enabled = False
      MaxValue = 65535
      TabOrder = 2
    end
    object chkRandSeed: TCheckBox
      Left = 10
      Height = 19
      Top = 236
      Width = 96
      Caption = 'Use Rand Seed'
      OnClick = chkRandSeedClick
      TabOrder = 3
    end
    object pnlLine: TPanel
      Left = 80
      Height = 24
      Hint = 'Borders'
      Top = 416
      Width = 24
      BevelOuter = bvLowered
      Color = clBlack
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = pnlStartClick
    end
    object pnlSolution: TPanel
      Left = 52
      Height = 24
      Hint = 'Solution Cells'
      Top = 388
      Width = 24
      BevelOuter = bvLowered
      Color = clSilver
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = pnlStartClick
    end
    object pnlNormal: TPanel
      Left = 24
      Height = 24
      Hint = 'Normal Cell'
      Top = 388
      Width = 24
      BevelOuter = bvLowered
      Color = clWhite
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = pnlStartClick
    end
    object pnlStart: TPanel
      Left = 24
      Height = 24
      Hint = 'Start'
      Top = 416
      Width = 24
      BevelOuter = bvLowered
      Color = clGreen
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = pnlStartClick
    end
    object pnlEnd: TPanel
      Left = 52
      Height = 24
      Hint = 'Finish'
      Top = 416
      Width = 24
      BevelOuter = bvLowered
      Color = clBlue
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnClick = pnlStartClick
    end
    object btnCompute: TBitBtn
      Left = 4
      Height = 25
      Top = 4
      Width = 125
      Caption = '&New Maze'
      NumGlyphs = 2
      OnClick = cmNewMazeClick
      TabOrder = 9
    end
    object btnSolve: TBitBtn
      Left = 4
      Height = 25
      Top = 32
      Width = 125
      Caption = '&Solve'
      NumGlyphs = 2
      OnClick = cmSolveMazeClick
      TabOrder = 10
    end
    object chkAutoSolve: TCheckBox
      Left = 8
      Height = 19
      Top = 64
      Width = 103
      Caption = 'Solve on creation'
      Checked = True
      State = cbChecked
      TabOrder = 11
    end
    object spnTileSize: TSpinEdit
      Left = 64
      Height = 21
      Top = 288
      Width = 61
      MaxValue = 36
      MinValue = 2
      OnChange = spnTileSizeChange
      TabOrder = 12
      Value = 8
    end
    object pnlVisited: TPanel
      Left = 80
      Height = 24
      Hint = 'Visited Cells'
      Top = 388
      Width = 24
      BevelOuter = bvLowered
      Color = 14278859
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 13
      OnClick = pnlStartClick
    end
    object chkShowVisited: TCheckBox
      Left = 8
      Height = 19
      Top = 84
      Width = 106
      Caption = 'Show Visited Cells'
      OnClick = chkShowVisitedClick
      TabOrder = 14
    end
    object spnStepSize: TSpinEdit
      Tag = 1
      Left = 64
      Height = 21
      Top = 312
      Width = 61
      MaxValue = 36
      MinValue = 2
      OnChange = spnTileSizeChange
      TabOrder = 15
      Value = 8
    end
    object spnEndsSize: TSpinEdit
      Tag = 2
      Left = 64
      Height = 21
      Top = 336
      Width = 61
      MaxValue = 36
      MinValue = 2
      OnChange = spnTileSizeChange
      TabOrder = 16
      Value = 5
    end
  end
  object pnlPaintArea: TPanel
    Left = 133
    Height = 527
    Top = 0
    Width = 520
    Align = alClient
    BevelOuter = bvLowered
    ClientHeight = 527
    ClientWidth = 520
    Color = clWhite
    ParentColor = False
    TabOrder = 1
    OnResize = pnlPaintAreaResize
    object pb: TPaintBox
      Left = 1
      Height = 525
      Top = 1
      Width = 518
      Align = alClient
      Color = clWhite
      ParentColor = False
      OnMouseUp = pbMouseUp
      OnPaint = pbPaint
    end
  end
  object sb: TStatusBar
    Left = 0
    Height = 23
    Top = 527
    Width = 653
    Panels = <>
  end
  object MainMenu1: TMainMenu
    left = 141
    top = 8
    object File1: TMenuItem
      Caption = '&File'
      ShortCut = 16460
      object cmNewMaze: TMenuItem
        Caption = '&New Maze'
        ShortCut = 16462
        OnClick = cmNewMazeClick
      end
      object cmSolveMaze: TMenuItem
        Caption = '&Solve Maze'
        OnClick = cmSolveMazeClick
      end
      object cmRefresh: TMenuItem
        Caption = '&Refresh'
        ShortCut = 16466
        OnClick = cmRefreshClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object cmExit: TMenuItem
        Caption = 'E&xit'
        OnClick = cmExitClick
      end
    end
    object cmHelp: TMenuItem
      Caption = 'Help'
      object cmAbout: TMenuItem
        Caption = '&About'
        OnClick = cmAboutClick
      end
    end
  end
  object dlgColor: TColorDialog
    Color = clBlack
    CustomColors.Strings = (
      'ColorA=000000'
      'ColorB=000080'
      'ColorC=008000'
      'ColorD=008080'
      'ColorE=800000'
      'ColorF=800080'
      'ColorG=808000'
      'ColorH=808080'
      'ColorI=C0C0C0'
      'ColorJ=0000FF'
      'ColorK=00FF00'
      'ColorL=00FFFF'
      'ColorM=FF0000'
      'ColorN=FF00FF'
      'ColorO=FFFF00'
      'ColorP=FFFFFF'
      'ColorQ=C0DCC0'
      'ColorR=F0CAA6'
      'ColorS=F0FBFF'
      'ColorT=A4A0A0'
    )
    left = 205
    top = 8
  end
end
