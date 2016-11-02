object frmMain: TfrmMain
  Left = 0
  Height = 682
  Top = 8
  Width = 1022
  Caption = 'Dual Trace Oscilloscope Ver 4.2.4'
  ClientHeight = 661
  ClientWidth = 1022
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Menu = MainMenu1
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  Position = poScreenCenter
  LCLVersion = '1.6.0.4'
  object statustext: TPanel
    Left = 0
    Height = 36
    Top = 0
    Width = 1022
    Align = alTop
    BevelInner = bvLowered
    BevelWidth = 2
    Caption = 'Oscilloscope'
    Color = clMaroon
    Font.Color = clRed
    Font.Height = -15
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
  end
  object Panel5: TPanel
    Left = 0
    Height = 463
    Top = 36
    Width = 1022
    Align = alTop
    Caption = 'Panel5'
    ClientHeight = 463
    ClientWidth = 1022
    TabOrder = 1
    object Panel6: TPanel
      Left = 730
      Height = 461
      Top = 1
      Width = 195
      Align = alLeft
      BevelInner = bvLowered
      BevelWidth = 2
      ClientHeight = 461
      ClientWidth = 195
      TabOrder = 0
      object btnRun: TSpeedButton
        Left = 9
        Height = 27
        Hint = 'Run'
        Top = 9
        Width = 44
        AllowAllUp = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FF000000000000000000000000000000000000000000FF
          00FFFF00FFFF00FFFF00FF000000000000000000000000000000000000000000
          000000000000000000000000000000000000FF00FFFF00FFFF00FF0000000000
          00000000000000000000000000000000000000000000000000000000000000FF
          00FFFF00FFFF00FFFF00FF000000000000000000000000000000000000000000
          000000FF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FF000000000000000000000000000000000000FF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000
          000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FF000000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        }
        GroupIndex = 1
        OnClick = btnRunClick
        ShowHint = True
        ParentShowHint = False
      end
      object btnDual: TSpeedButton
        Left = 10
        Height = 27
        Hint = 'Dual input'
        Top = 78
        Width = 104
        AllowAllUp = True
        Caption = 'Dual inp.'
        GroupIndex = 2
        OnClick = btnDualClick
        ShowHint = True
        ParentShowHint = False
      end
      object BtnOneFrame: TSpeedButton
        Left = 54
        Height = 27
        Hint = 'Single frame'
        Top = 9
        Width = 42
        AllowAllUp = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000
          00000000FF00FFFF00FF000000000000000000000000FF00FF00000000000000
          0000000000000000000000000000000000000000000000FF00FF000000000000
          000000000000FF00FF0000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000FF00FF00000000000000
          0000000000000000000000000000000000000000000000FF00FFFF00FF000000
          000000000000FF00FF000000000000000000FF00FFFF00FFFF00FFFF00FF0000
          00000000FF00FFFF00FFFF00FF000000000000000000FF00FF00000000000000
          0000FF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF000000
          000000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF00000000000000000000000000000000000000
          0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          000000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        }
        GroupIndex = 1
        OnClick = BtnOneFrameClick
        ShowHint = True
        ParentShowHint = False
      end
      object Panel3: TPanel
        Left = 99
        Height = 16
        Hint = 'Blinks when running'
        Top = 9
        Width = 14
        BevelInner = bvLowered
        Color = clMaroon
        ParentColor = False
        TabOrder = 0
      end
      object GroupBox1: TGroupBox
        Left = 9
        Height = 252
        Top = 200
        Width = 160
        Caption = 'Trigger'
        ClientHeight = 237
        ClientWidth = 158
        TabOrder = 1
        object btnTriggCh1: TSpeedButton
          Left = 9
          Height = 24
          Hint = 'Trigger on Channel 1'
          Top = 56
          Width = 35
          Caption = 'Ch1'
          Down = True
          GroupIndex = 3
        end
        object btnTriggCh2: TSpeedButton
          Left = 9
          Height = 24
          Hint = 'Trigger on Channel2'
          Top = 81
          Width = 35
          Caption = 'Ch2'
          GroupIndex = 3
        end
        object btnTrigPositiv: TSpeedButton
          Left = 9
          Height = 24
          Hint = 'Trigger on + rising level '
          Top = 107
          Width = 35
          Caption = '+'
          GroupIndex = 4
          OnClick = btnTrigerOnClick
        end
        object btnTrigNegativ: TSpeedButton
          Left = 9
          Height = 24
          Hint = 'Trigger on - falling level'
          Top = 133
          Width = 35
          Caption = '-'
          GroupIndex = 4
          OnClick = trOfsCh1Change
        end
        object Label4: TLabel
          Left = 81
          Height = 14
          Top = 13
          Width = 7
          Caption = '0'
          ParentColor = False
        end
        object Label3: TLabel
          Left = 9
          Height = 17
          Top = 233
          Width = 142
          Caption = 'Level (-128 to +128): '
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Verdana'
          ParentColor = False
          ParentFont = False
        end
        object btnTrigerOn: TSpeedButton
          Left = 9
          Height = 23
          Top = 34
          Width = 35
          AllowAllUp = True
          Caption = 'On'
          GroupIndex = 5
          OnClick = btnTrigerOnClick
        end
        object TrigLevelBar: TTrackBar
          Left = 61
          Height = 200
          Hint = 'Trigger level'
          Top = 26
          Width = 44
          Frequency = 128
          Max = 128
          Min = -128
          OnChange = TrigLevelBarChange
          Orientation = trVertical
          Position = 0
          TickMarks = tmBoth
          TabOrder = 0
        end
      end
      object SpectrumBtn: TBitBtn
        Left = 9
        Height = 27
        Hint = 'Spectrum'
        Top = 43
        Width = 44
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF00000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000FF00FF000000
          FF00FFFF00FF000000FF00FF000000FF00FF000000FF00FF000000FF00FF0000
          00FF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FF000000FF00FF000000FF
          00FF000000FF00FF000000FF00FF000000FF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FF000000FF00FF000000FF00FF000000FF00FF000000FF00FF0000
          00FF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FF000000FF00FF000000FF
          00FF000000FF00FF000000FF00FF000000FF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FF000000FF00FF000000FF00FF000000FF00FF000000FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF000000FF
          00FF000000FF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FFFF00FFFF00FF000000FF00FF000000FF00FF000000FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        }
        OnClick = SpectrumBtnClick
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
      object CalibrateBtn: TBitBtn
        Left = 52
        Height = 27
        Hint = 'Set zero level'
        Top = 43
        Width = 62
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000000000000000000000
          00FF00FFFF00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FF000000FF00FFFF00FF0000000000000000000000000000000000
          00000000FF00FFFF00FFFF00FF000000FF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000000000000000000000
          00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FF
        }
        OnClick = CalibrateBtnClick
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
      end
    end
    object Panel1: TPanel
      Left = 1
      Height = 461
      Top = 1
      Width = 154
      Align = alLeft
      BevelInner = bvLowered
      BevelWidth = 2
      ClientHeight = 461
      ClientWidth = 154
      TabOrder = 1
      object GrpChannel1: TGroupBox
        Left = 9
        Height = 217
        Top = 9
        Width = 136
        Caption = 'Channel 1'
        ClientHeight = 202
        ClientWidth = 134
        TabOrder = 0
        object Label5: TLabel
          Left = 84
          Height = 17
          Top = 17
          Width = 39
          Caption = 'Offset'
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Verdana'
          ParentColor = False
          ParentFont = False
        end
        object Label6: TLabel
          Left = 9
          Height = 21
          Top = 65
          Width = 39
          Caption = 'Gain'
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          ParentColor = False
          ParentFont = False
        end
        object btnCH1Gnd: TSpeedButton
          Left = 14
          Height = 29
          Top = 163
          Width = 48
          AllowAllUp = True
          Caption = 'Gnd'
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          GroupIndex = 7
          OnClick = btnCH1GndClick
          ParentFont = False
        end
        object trOfsCh1: TTrackBar
          Left = 84
          Height = 174
          Top = 35
          Width = 27
          Frequency = 20
          Max = 160
          Min = -160
          OnChange = trOfsCh1Change
          Orientation = trVertical
          Position = 0
          TabOrder = 0
        end
        object upGainCh1: TUpDown
          Left = 41
          Height = 31
          Top = 91
          Width = 21
          Associate = edtGainCh1
          Max = 6
          Min = 0
          Position = 3
          TabOrder = 1
          Wrap = False
        end
        object edtGainCh1: TEdit
          Left = 8
          Height = 31
          Top = 91
          Width = 33
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          OnChange = edtGainCh1Change
          ParentFont = False
          TabOrder = 2
          Text = '3'
        end
        object OnCh1Box: TCheckBox
          Left = 8
          Height = 22
          Top = 24
          Width = 41
          Caption = 'On'
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          OnClick = btnCh1OnClick
          ParentFont = False
          TabOrder = 3
        end
      end
      object grpChannel2: TGroupBox
        Left = 8
        Height = 218
        Top = 234
        Width = 137
        Caption = 'Channel 2'
        ClientHeight = 203
        ClientWidth = 135
        TabOrder = 1
        object Label7: TLabel
          Left = 84
          Height = 17
          Top = 17
          Width = 39
          Caption = 'Offset'
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Verdana'
          ParentColor = False
          ParentFont = False
        end
        object Label8: TLabel
          Left = 9
          Height = 21
          Top = 73
          Width = 39
          Caption = 'Gain'
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          ParentColor = False
          ParentFont = False
        end
        object btnCH2Gnd: TSpeedButton
          Left = 9
          Height = 24
          Top = 175
          Width = 56
          AllowAllUp = True
          Caption = 'Gnd'
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          GroupIndex = 7
          OnClick = btnCH2GndClick
          ParentFont = False
        end
        object trOfsCh2: TTrackBar
          Left = 84
          Height = 174
          Top = 43
          Width = 27
          Frequency = 20
          Max = 160
          Min = -160
          OnChange = trOfsCh2Change
          Orientation = trVertical
          Position = 0
          TabOrder = 0
        end
        object upGainCh2: TUpDown
          Left = 36
          Height = 31
          Top = 99
          Width = 21
          Associate = edtGainCh2
          Max = 6
          Min = 0
          Position = 3
          TabOrder = 1
          Wrap = False
        end
        object edtGainCh2: TEdit
          Left = 8
          Height = 31
          Top = 99
          Width = 28
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          OnChange = edtGainCh2Change
          ParentFont = False
          TabOrder = 2
          Text = '3'
        end
        object OnCh2Box: TCheckBox
          Left = 8
          Height = 22
          Top = 32
          Width = 41
          Caption = 'On'
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          OnClick = btnCh2OnClick
          ParentFont = False
          TabOrder = 3
        end
      end
    end
    object Panel4: TPanel
      Left = 925
      Height = 461
      Top = 1
      Width = 148
      Align = alLeft
      BevelInner = bvLowered
      BevelWidth = 2
      ClientHeight = 461
      ClientWidth = 148
      TabOrder = 2
      object GroupBox2: TGroupBox
        Left = 4
        Height = 349
        Top = 4
        Width = 131
        Caption = 'Time'
        ClientHeight = 334
        ClientWidth = 129
        TabOrder = 0
        object Label2: TLabel
          Left = 9
          Height = 14
          Top = 130
          Width = 96
          AutoSize = False
          Caption = 'Horizontal gain'
          ParentColor = False
          WordWrap = True
        end
        object ScaleLbl: TLabel
          Left = 15
          Height = 14
          Top = 22
          Width = 34
          Caption = 'Scale:'
          ParentColor = False
        end
        object sp11025Sample: TSpeedButton
          Left = 9
          Height = 24
          Top = 43
          Width = 53
          Caption = '11,025'
          Down = True
          GroupIndex = 6
          OnClick = sp11025SampleClick
        end
        object sp22050Sample: TSpeedButton
          Left = 9
          Height = 24
          Top = 69
          Width = 53
          Caption = '22,050'
          GroupIndex = 6
          OnClick = sp22050SampleClick
        end
        object sp44100Sample: TSpeedButton
          Left = 9
          Height = 24
          Top = 95
          Width = 53
          Caption = '44,100'
          GroupIndex = 6
          OnClick = sp44100SampleClick
        end
        object SweepEdt: TEdit
          Left = 9
          Height = 24
          Top = 151
          Width = 31
          OnChange = SweepEdtChange
          TabOrder = 0
          Text = '1'
        end
        object SweepUD: TUpDown
          Left = 40
          Height = 24
          Top = 151
          Width = 17
          Associate = SweepEdt
          Max = 10
          Min = 1
          Position = 1
          TabOrder = 1
          Wrap = False
        end
      end
      object GroupBox3: TGroupBox
        Left = 9
        Height = 162
        Top = 191
        Width = 131
        Caption = 'Capture frame'
        ClientHeight = 147
        ClientWidth = 129
        TabOrder = 1
        object btnExpand1: TSpeedButton
          Left = 9
          Height = 23
          Top = 34
          Width = 25
          Caption = 'X1'
          Down = True
          GroupIndex = 8
          OnClick = btnExpand1Click
        end
        object btnExpand2: TSpeedButton
          Left = 35
          Height = 23
          Top = 33
          Width = 25
          Caption = 'X2'
          GroupIndex = 8
          OnClick = btnExpand2Click
        end
        object btnExpand4: TSpeedButton
          Left = 61
          Height = 23
          Top = 33
          Width = 25
          Caption = 'X4'
          GroupIndex = 8
          OnClick = btnExpand4Click
        end
        object btnExpand8: TSpeedButton
          Left = 87
          Height = 23
          Top = 33
          Width = 25
          Caption = 'X8'
          GroupIndex = 8
          OnClick = btnExpand8Click
        end
        object Label11: TLabel
          Left = 9
          Height = 14
          Top = 17
          Width = 46
          Caption = 'Expand:'
          ParentColor = False
        end
        object Label13: TLabel
          Left = 9
          Height = 14
          Top = 61
          Width = 30
          Caption = 'Gain:'
          ParentColor = False
        end
        object btnGain0: TSpeedButton
          Left = 9
          Height = 24
          Top = 78
          Width = 35
          Caption = '/2'
          GroupIndex = 9
          OnClick = btnGain0Click
        end
        object btnGain1: TSpeedButton
          Left = 43
          Height = 24
          Top = 78
          Width = 36
          Caption = 'X1'
          Down = True
          GroupIndex = 9
          OnClick = btnGain1Click
        end
        object btnGain2: TSpeedButton
          Left = 78
          Height = 24
          Top = 78
          Width = 36
          Caption = 'X2'
          GroupIndex = 9
          OnClick = btnGain2Click
        end
        object Label12: TLabel
          Left = 40
          Height = 14
          Top = 110
          Width = 50
          Caption = '<-- X -->'
          ParentColor = False
          OnDblClick = Label12DblClick
        end
        object trStartPos: TTrackBar
          Left = 4
          Height = 36
          Top = 122
          Width = 123
          Frequency = 40
          Max = 400
          Min = -400
          OnChange = trStartPosChange
          Position = 0
          TabOrder = 0
        end
      end
      object GroupBox4: TGroupBox
        Left = 4
        Height = 97
        Top = 360
        Width = 140
        Align = alBottom
        Caption = 'Intensities'
        ClientHeight = 82
        ClientWidth = 138
        TabOrder = 2
        object Label9: TLabel
          Left = 9
          Height = 14
          Top = 30
          Width = 30
          Caption = 'Scale'
          ParentColor = False
        end
        object Label1: TLabel
          Left = 54
          Height = 14
          Top = 30
          Width = 33
          Caption = 'Beam'
          ParentColor = False
        end
        object Label10: TLabel
          Left = 93
          Height = 14
          Top = 30
          Width = 30
          Caption = 'focus'
          ParentColor = False
        end
        object UpScaleLight: TUpDown
          Left = 17
          Height = 27
          Top = 51
          Width = 19
          Increment = 10
          Max = 200
          Min = 25
          OnChanging = UpScaleLightChanging
          Position = 70
          TabOrder = 0
          Wrap = False
        end
        object upBeamLight: TUpDown
          Left = 61
          Height = 27
          Top = 51
          Width = 18
          Increment = 15
          Max = 150
          Min = -180
          OnClick = upBeamLightClick
          Position = 1
          TabOrder = 1
          Wrap = False
        end
        object upFocus: TUpDown
          Left = 104
          Height = 27
          Top = 51
          Width = 18
          Max = 6
          Min = 1
          OnClick = upFocusClick
          Position = 1
          TabOrder = 2
          Wrap = False
        end
      end
    end
    object PageControl1: TPageControl
      Left = 155
      Height = 461
      Top = 1
      Width = 575
      ActivePage = Runsheet
      Align = alLeft
      TabIndex = 1
      TabOrder = 3
      object IntroSheet: TTabSheet
        Caption = 'Introduction'
        ClientHeight = 429
        ClientWidth = 569
        ImageIndex = 1
        object Memo1: TMemo
          Left = 0
          Height = 435
          Top = 0
          Width = 567
          Align = alClient
          Color = 15400959
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Verdana'
          Lines.Strings = (
            'This simple oscilloscope uses the Windows Wavein API to capture data '
            'from a sound card and display it in the screen area above.   Use the '
            'Windows "Volume Controls - Options - Properties"  dialog and select '
            '"Recording Controls" to select input source(s) to be displayed.    After the '
            'Start button is clicked, any messages describing capture problems will be '
            'displayed here.'
            ''
            'Version  2: A "Trigger" capability has been added.  Each scan is triggered'
            'when the signal rises above (+) or below (-) the preset trigger level.  To'
            'improve the image capture of transient events, there is now a "Capture'
            'Single Frame" button.  Use he "Trigger" feature to control when the frame'
            'will be captured.'
            ''
            'Version 3  Spectrum analysis of Captured frames.  User selectable Sample'
            'rates.  Time scale ref.lines on display.'
            ''
            'Version 4:  Dual trace function added.  Improved visual layout.   Improved'
            'controls.  Input signal selectable via buttons.    Settings saved from run to'
            'run.  Many thanks to "Krille", a very sharp Delphi programmer from '
            'Sweden.  ()March 28, 2014: Version 4.2.3 cleans up a number of '
            'formatting errors and adds some control hints.  Still a work in progress so '
            'bug reports are welcome.)'
          )
          ParentFont = False
          TabOrder = 0
        end
      end
      object Runsheet: TTabSheet
        Caption = 'Oscilloscope'
        ClientHeight = 429
        ClientWidth = 569
        inline frmOscilloscope1: TfrmOscilloscope
          Height = 429
          Width = 569
          Align = alClient
          ClientHeight = 429
          ClientWidth = 569
          inherited Image1: TImage
            Height = 429
            Width = 569
            Stretch = True
          end
          inherited Image2: TImage
            Height = 347
            Width = 483
          end
          inherited ImgScreen: TImage
            Left = 252
          end
        end
      end
    end
  end
  object StaticText1: TStaticText
    Cursor = crHandPoint
    Left = 0
    Height = 20
    Top = 641
    Width = 1022
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2014, Gary Darby,  www.DelphiForFun.org'
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsUnderline]
    OnClick = StaticText1Click
    ParentFont = False
    TabOrder = 2
  end
  object MainMenu1: TMainMenu
    left = 653
    top = 532
    object File1: TMenuItem
      Caption = 'File'
      object menuSaveImage1: TMenuItem
        Caption = 'Save Image'
        OnClick = menuSaveImage1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object menuExit: TMenuItem
        Caption = 'Exit'
        OnClick = menuExitClick
      end
    end
    object Screen1: TMenuItem
      Caption = 'Screen'
      object Color1: TMenuItem
        Caption = 'Color'
        object menuBlack: TMenuItem
          Caption = 'Black'
          OnClick = menuBlackClick
        end
        object MenuGreen: TMenuItem
          Caption = 'Green'
          OnClick = MenuGreenClick
        end
      end
      object Data1: TMenuItem
        Caption = 'Data'
        object MenuData_Time: TMenuItem
          Caption = 'Time'
          OnClick = MenuData_TimeClick
        end
      end
    end
  end
end
