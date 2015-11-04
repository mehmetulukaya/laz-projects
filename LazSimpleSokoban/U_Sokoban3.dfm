object Form1: TForm1
  Left = 192
  Height = 640
  Top = 52
  Width = 950
  Caption = 'Sokoban Version 3'
  ClientHeight = 640
  ClientWidth = 950
  Color = 8766176
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  KeyPreview = True
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  LCLVersion = '1.4.0.4'
  object StaticText1: TStaticText
    Cursor = crHandPoint
    Left = 0
    Height = 20
    Top = 620
    Width = 950
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2009, Gary Darby,  www.DelphiForFun.org'
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    OnClick = StaticText1Click
    ParentFont = False
    TabOrder = 0
  end
  object PageControl1: TPageControl
    Left = 0
    Height = 620
    Top = 0
    Width = 950
    ActivePage = TabSheet2
    Align = alClient
    TabIndex = 1
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      ClientHeight = 0
      ClientWidth = 0
      object Memo1: TMemo
        Left = 32
        Height = 513
        Top = 16
        Width = 865
        Color = 14548991
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Lines.Strings = (
          ''
          'Here''s a simple Delphi version of "Sokoban", a warehouse puzzle where you use the arrow keys to'
          'control the warehouseman, ( the "Sokoban"), as he completes his task of pushing the yellow "Boxes"'
          'onto the green "Targets".  There is much information  It was developed as possible test bed for '
          'devloping a Delphi version of a Sokoban solver.'
          ''
          'Factors are:'
          '*    Boxes may only be pushed, never pulled. This is the key factor that makes the puzzles '
          '     challenging.'
          '*    The gray squares are immovable walls.'
          '*    You win when all of the targets are covered with boxes.'
          '*    In addition to the 4 arrow keys, you can use "Z", "U", or Backspace keys to undo the latest'
          '     last move made.'
          '*    The R key restarts the puzzle.'
          '*    The Load button allows you to load one of the supplied puzzles. The four sample puzzle files '
          '      included range from simple to very hard (at least for me :>).'
          '*    Solutions are automatically saved and may be retrieved and replayed.'
          '*    View any of the included text  puzzle files to see how you can enter addiional puzzles.  On '
          '     website  http://www.sourcecode.se/sokoban/levels.php you can view and copy the text version of'
          '     thousands of additional puzzles and make new text files which this program can read.  Website'
          '     http://www.joriswit.nl/sokoban/ also contains a downloadable program (Sokoban++) and level files.'
        )
        ParentFont = False
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Puzzles'
      ClientHeight = 591
      ClientWidth = 942
      ImageIndex = 1
      object Label1: TLabel
        Left = 528
        Height = 19
        Top = 239
        Width = 44
        Caption = 'Steps'
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object StepLbl: TLabel
        Left = 584
        Height = 22
        Top = 237
        Width = 22
        Caption = '00'
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object Label2: TLabel
        Left = 752
        Height = 19
        Top = 239
        Width = 112
        Caption = 'Boxes in place'
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object InPlaceLbl: TLabel
        Left = 880
        Height = 22
        Top = 237
        Width = 22
        Caption = '00'
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object Label3: TLabel
        Left = 536
        Height = 18
        Top = 416
        Width = 123
        Caption = 'No saved solution'
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        ParentColor = False
        ParentFont = False
      end
      object LoadBtn: TButton
        Left = 24
        Height = 25
        Top = 16
        Width = 145
        Caption = 'Load puzzle'
        OnClick = LoadBtnClick
        TabOrder = 0
      end
      object BoardGrid: TStringGrid
        Left = 13
        Height = 490
        Top = 55
        Width = 490
        BorderStyle = bsNone
        ColCount = 10
        DefaultColWidth = 47
        DefaultDrawing = False
        DefaultRowHeight = 47
        FixedCols = 0
        FixedRows = 0
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        RowCount = 10
        TabOrder = 1
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = 'Arial'
        TitleFont.Style = [fsBold]
        OnDrawCell = BoardGridDrawCell
      end
      object LoadSolBtn: TButton
        Left = 536
        Height = 25
        Top = 448
        Width = 145
        Caption = 'Load saved moves'
        OnClick = LoadSolBtnClick
        TabOrder = 2
      end
      object Memo2: TMemo
        Left = 528
        Height = 129
        Top = 272
        Width = 385
        Lines.Strings = (
          'Moves display here '
          ''
          'l, r, u, or d for moves of the warehouseman (the Sokoban) one '
          'square in a left, right, up, or down direction.'
          ''
          'Moves are denoted  in capital letters (L, R, U, D) if the move '
          'pushes a box.'
        )
        ScrollBars = ssVertical
        TabOrder = 3
      end
      object ReplayBtn: TButton
        Left = 768
        Height = 25
        Top = 448
        Width = 145
        Caption = 'Replay moves'
        OnClick = ReplayBtnClick
        TabOrder = 4
      end
      object Memo3: TMemo
        Left = 528
        Height = 169
        Top = 56
        Width = 377
        Lines.Strings = (
          'Shortcut keys'
          '     Left, Right, Up, Down arrow keys : Move that direction'
          '     U, Z, Backspace keys: Undo previous move'
          '     R: Restart'
          ''
          'Colors codes'
          '    Gray = wall'
          '    Blue = Floor'
          '    Green = Target'
          '    Yellow = Box'
        )
        TabOrder = 5
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Title = 'Select a case'
    DefaultExt = '.txt'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    left = 888
    top = 536
  end
end
