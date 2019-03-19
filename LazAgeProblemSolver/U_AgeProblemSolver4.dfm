object Form1: TForm1
  Left = 0
  Height = 650
  Top = 44
  Width = 1022
  Caption = 'Age Problem Solver Version 4'
  ClientHeight = 650
  ClientWidth = 1022
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  OnCreate = FormCreate
  Position = poScreenCenter
  LCLVersion = '2.0.0.4'
  object Label1: TLabel
    Left = 28
    Height = 19
    Top = 234
    Width = 51
    Caption = 'Names'
    ParentColor = False
  end
  object ProblemLbl: TLabel
    Left = 223
    Height = 18
    Top = 33
    Width = 261
    Caption = 'Current Problem:  None loaded'
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label2: TLabel
    Left = 28
    Height = 105
    Top = 432
    Width = 180
    AutoSize = False
    Caption = 'For debugging: Enable loading and back-testing  a trialt  version of the parsing tables  used to convert text to equations.'
    ParentColor = False
    WordWrap = True
  end
  object Solvebtn: TButton
    Left = 28
    Height = 28
    Top = 90
    Width = 141
    Caption = 'Solve it'
    OnClick = SolvebtnClick
    TabOrder = 0
  end
  object NameDisplay: TMemo
    Left = 28
    Height = 100
    Top = 252
    Width = 143
    Lines.Strings = (
      ''
    )
    TabOrder = 1
  end
  object StaticText1: TStaticText
    Cursor = crHandPoint
    Left = 0
    Height = 20
    Top = 630
    Width = 1022
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2007, Gary Darby,  www.DelphiForFun.org'
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    OnClick = StaticText1Click
    ParentFont = False
    TabOrder = 2
  end
  object LoadIniBtn: TButton
    Left = 28
    Height = 28
    Top = 548
    Width = 181
    Caption = 'Load a tables file'
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    OnClick = LoadIniBtnClick
    ParentFont = False
    TabOrder = 3
  end
  object BacktestBtn: TButton
    Left = 28
    Height = 28
    Top = 585
    Width = 181
    Caption = 'Backtest all cases'
    OnClick = BacktestBtnClick
    TabOrder = 4
  end
  object PageControl1: TPageControl
    Left = 223
    Height = 574
    Top = 57
    Width = 771
    ActivePage = IntroSheet
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    ParentFont = False
    TabIndex = 0
    TabOrder = 5
    object IntroSheet: TTabSheet
      Caption = 'Introduction'
      ClientHeight = 540
      ClientWidth = 761
      object Memo1: TMemo
        Left = 0
        Height = 540
        Top = 0
        Width = 761
        Align = alClient
        Color = 14548991
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Lines.Strings = (
          ' This is an experiment in writing a program to solve "age" type story problems by oaprsing the text into algebraic '
          'equations and then solving them. The "age" problem stories  define relationships between the ages of two people. '
          ' The sample used here appeared in recent editions of our 2007 "Mensa Puzzle-A-Day" calendar.  Here''s an '
          'example:'
          ''
          '"A year ago, Gary was twice as old as Ron is now.  In four more years, Ron will be as old as Gary is now.  Neither '
          'one is yet a teenager. How old are Gary and Ron now?"'
          ''
          'The syntax analysis is not comprehensove but it is adequate to handle the 10 age probems in the 2007 year''s '
          'calendar.  The text were entered verbatim as "AgeTest1.txt" through "Agetest10.txt" files which are included here.  '
          'The '
          'problems are converted in several stages and using a initialization file, "AgeProblemTables.ini, containing several '
          'word '
          'conversion sections.  Briefly, the process is:'
          ''
          '1. Un-needed words and delimiters are removed based on "UnNeededWords" section.'
          ''
          '2. Names of the people are identified.  Common initial captialized words to ignore are in "FirstWord"'
          'section.  Certain other words (e.g. grandfather), which are not capitalized, but should be treated as names, are '
          'treated as names based on the "Capitalized" section.'
          ''
          '3. Numbers are converted to a standard text form using the "Numbers" section; "one" to "1", "twice" to "2*", etc.'
          'Similarly fraction denominator words ("half", "third", "thirds", etc.) are idenified based on the'
          '"Denominators" section.'
          ''
          '4.Sentences are converted to a "canonical" form replacing names with "&V", whole numbers and fraction'
          'numerators with "&N", denominators with "&D".  Patterns in the "OpWords" section are tested against the'
          'canonical  form and matches are replaced with a corresponding text in equation form.'
          ''
          '5.Numeric and name identifers and then replaced with the original values and the results displayed.'
          ''
          'For the restricted text forms represented by the included sample files, the program works quite well.'
          'The resulting 2 equations in 2 unknowns are easily solved algebraically.  Version 3 adds a search for '
          'numeric  solutions to the equations for each equation pair.'
          ''
          ''
          ''
          ''
          ' '
        )
        ParentFont = False
        TabOrder = 0
      end
    end
    object ProblemSheet: TTabSheet
      Caption = 'Problem'
      ClientHeight = 540
      ClientWidth = 761
      ImageIndex = 1
      object problem: TMemo
        Left = 69
        Height = 336
        Top = 59
        Width = 582
        TabOrder = 0
      end
    end
    object ParseSheet: TTabSheet
      Caption = 'Parsed results'
      ClientHeight = 540
      ClientWidth = 761
      ImageIndex = 2
      object SentenceDisplayMemo: TMemo
        Left = 20
        Height = 454
        Top = 20
        Width = 661
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object OpenBtn: TButton
    Left = 28
    Height = 30
    Top = 33
    Width = 144
    Caption = 'Load a problem'
    OnClick = OpenBtnClick
    TabOrder = 6
  end
  object OpenDialog1: TOpenDialog
    Title = 'Select a problem'
    Filter = 'Problems (*.txt)|*.txt|All files (*.*)|*.*'
    left = 680
    top = 16
  end
  object OpenDialog2: TOpenDialog
    Title = 'Select a "Tables" file to load'
    DefaultExt = '.ini'
    Filter = 'Tables files (*.ini*|*.ini|All files (*.*)|*.*'
    left = 720
    top = 16
  end
end
