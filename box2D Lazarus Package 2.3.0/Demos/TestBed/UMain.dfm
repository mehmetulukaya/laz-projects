object frmMain: TfrmMain
  Left = 252
  Height = 633
  Top = 47
  Width = 800
  Caption = 'TestBed'
  ClientHeight = 633
  ClientWidth = 800
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 800
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  KeyPreview = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnShow = FormShow
  LCLVersion = '1.4.0.4'
  WindowState = wsMaximized
  object Panel1: TPanel
    Left = 637
    Height = 633
    Top = 0
    Width = 163
    Align = alRight
    ClientHeight = 633
    ClientWidth = 163
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Height = 13
      Top = 5
      Width = 26
      Caption = 'Tests'
      ParentColor = False
    end
    object Label2: TLabel
      Left = 8
      Height = 13
      Top = 253
      Width = 37
      Anchors = [akLeft, akBottom]
      Caption = 'Visibility'
      ParentColor = False
    end
    object Bevel1: TBevel
      Left = 5
      Height = 2
      Top = 183
      Width = 154
      Anchors = [akLeft, akBottom]
    end
    object chkWarmStarting: TCheckBox
      Left = 8
      Height = 19
      Top = 200
      Width = 89
      Anchors = [akLeft, akBottom]
      Caption = 'Warm Starting'
      Checked = True
      OnClick = SimulationOptionsChanged
      State = cbChecked
      TabOrder = 0
    end
    object chkTimeOfImpact: TCheckBox
      Left = 8
      Height = 19
      Top = 215
      Width = 91
      Anchors = [akLeft, akBottom]
      Caption = 'Time of Impact'
      Checked = True
      OnClick = SimulationOptionsChanged
      State = cbChecked
      TabOrder = 1
    end
    object chklstVisibility: TCheckListBox
      Left = 8
      Height = 119
      Top = 268
      Width = 148
      Anchors = [akLeft, akBottom]
      Items.Strings = (
        'Shapes'
        'Joints'
        'AABBs'
        'Pairs'
        'Contact Points'
        'Contact Normals'
        'Contact Impulse'
        'Friction Impulse'
        'Center of Masses'
        'Statistics'
        'Key Information'
      )
      ItemHeight = 17
      OnClickCheck = chklstVisibilityClickCheck
      TabOrder = 2
      Data = {
        0B0000000000000000000000000000
      }
    end
    object btnPause: TButton
      Left = 7
      Height = 25
      Top = 555
      Width = 75
      Anchors = [akLeft, akBottom]
      Caption = 'Pause'
      OnClick = btnPauseClick
      TabOrder = 3
    end
    object btnSingleStep: TButton
      Left = 82
      Height = 25
      Top = 555
      Width = 75
      Anchors = [akLeft, akBottom]
      Caption = 'Single Step'
      OnClick = btnSingleStepClick
      TabOrder = 4
    end
    object GroupBox1: TGroupBox
      Left = 9
      Height = 65
      Top = 388
      Width = 148
      Anchors = [akLeft, akBottom]
      Caption = 'Gravity'
      ClientHeight = 47
      ClientWidth = 144
      TabOrder = 5
      object Label3: TLabel
        Left = 11
        Height = 13
        Top = 3
        Width = 6
        Caption = 'X'
        ParentColor = False
      end
      object Label4: TLabel
        Left = 11
        Height = 13
        Top = 27
        Width = 6
        Caption = 'Y'
        ParentColor = False
      end
      object editGravityX: TEdit
        Left = 20
        Height = 21
        Top = -1
        Width = 51
        TabOrder = 0
      end
      object editGravityY: TEdit
        Left = 20
        Height = 21
        Top = 23
        Width = 51
        TabOrder = 1
      end
      object btnConfirmGravity: TButton
        Left = 80
        Height = 25
        Top = 10
        Width = 63
        Caption = 'Confirm'
        OnClick = btnConfirmGravityClick
        TabOrder = 2
      end
    end
    object btnReset: TButton
      Left = 7
      Height = 25
      Top = 580
      Width = 75
      Anchors = [akLeft, akBottom]
      Caption = 'Reset'
      OnClick = btnResetClick
      TabOrder = 6
    end
    object GroupBox2: TGroupBox
      Left = 8
      Height = 57
      Top = 454
      Width = 148
      Anchors = [akLeft, akBottom]
      Caption = 'Mode'
      ClientHeight = 39
      ClientWidth = 144
      TabOrder = 7
      object rdoRealTime: TRadioButton
        Left = 8
        Height = 19
        Top = -2
        Width = 66
        Caption = 'Real Time'
        Checked = True
        OnClick = rdoRealTimeClick
        TabOrder = 0
        TabStop = True
      end
      object rdoFixedStep: TRadioButton
        Left = 8
        Height = 19
        Top = 16
        Width = 106
        Caption = 'Fixed Step(1/60s)'
        OnClick = rdoFixedStepClick
        TabOrder = 1
      end
    end
    object chkAntialiasing: TCheckBox
      Left = 8
      Height = 19
      Top = 609
      Width = 74
      Anchors = [akLeft, akBottom]
      Caption = 'Antialiasing'
      Checked = True
      OnClick = chkAntialiasingClick
      State = cbChecked
      TabOrder = 8
    end
    object chkSubStepping: TCheckBox
      Left = 8
      Height = 19
      Top = 230
      Width = 84
      Anchors = [akLeft, akBottom]
      Caption = 'Sub-Stepping'
      OnClick = SimulationOptionsChanged
      TabOrder = 9
    end
    object btnDumpWorld: TButton
      Left = 82
      Height = 25
      Top = 580
      Width = 75
      Anchors = [akLeft, akBottom]
      Caption = 'Dump World'
      OnClick = btnDumpWorldClick
      TabOrder = 10
    end
    object listTestEntries: TListBox
      Left = 8
      Height = 143
      Top = 20
      Width = 148
      Anchors = [akTop, akLeft, akBottom]
      ItemHeight = 0
      OnKeyDown = listTestEntriesKeyDown
      OnKeyUp = listTestEntriesKeyUp
      OnMouseDown = listTestEntriesMouseDown
      TabOrder = 11
    end
    object chkEnableSleep: TCheckBox
      Left = 8
      Height = 19
      Top = 185
      Width = 81
      Anchors = [akLeft, akBottom]
      Caption = 'Enable Sleep'
      Checked = True
      OnClick = SimulationOptionsChanged
      State = cbChecked
      TabOrder = 12
    end
  end
end
