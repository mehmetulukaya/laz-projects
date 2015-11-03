unit main;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, ExtCtrls, SynEdit, SynCompletion,
  SynHighlighterAny, Cpu, InOutUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    ListView1: TListView;
    ListView2: TListView;
    PopupMenu1: TPopupMenu;
    AddBreakPoint1: TMenuItem;
    Button1: TButton;
    GroupBox1: TGroupBox;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    LabeledEdit8: TLabeledEdit;
    Button2: TButton;
    Button3: TButton;
    ASMCodeEditor1: TSynEdit;
    SynAnySyn1: TSynAnySyn;
    SynAnySyn2: TSynAnySyn;
    SynCompletion1: TSynCompletion;
    MicrocodeEdit1: TSynEdit;
    Timer1: TTimer;
    Save1: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Opent1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    new1: TMenuItem;
    N2: TMenuItem;
    About1: TMenuItem;
    About2: TMenuItem;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ApplicationEvents1: TApplicationProperties;
    Settings1: TMenuItem;
    CpuSimSettings1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox4: TGroupBox;
    Splitter1: TSplitter;
    GroupBox2: TGroupBox;
    Edit2: TEdit;
    GroupBox3: TGroupBox;
    Edit1: TEdit;
    procedure ApplicationEvents1Activate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Opent1Click(Sender: TObject);
    procedure new1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure About2Click(Sender: TObject);
    procedure CpuSimSettings1Click(Sender: TObject);
    procedure LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    procedure SetCrMInstr(crPoz: String);
    procedure RefreshCpuStat;
    procedure visualSwap;
//    Procedure WNDPROC(var msg:TMessage);override;
  end;

var
  Form1: TForm1;
  cmpCpu: TCPU;
  codPos: Integer = 0;
  keys: array[0..255] of boolean;

implementation

uses about, Settings;

{$R *.lfm}

{Procedure Tform1.WNDPROC(var msg:TMessage);
begin
  INHERITED;
  case msg.Msg of
  WM_VKEYTOITEM:
    begin
      ShowMessage('OK');
    end;
  end;
end;}

procedure TForm1.visualSwap;
begin

end;

procedure TForm1.RefreshCpuStat;
var
  tmpAcLow, tmpCIL, tmpINTR: Boolean;
begin
  cmpCPU.getCpuIntr( tmpCil, tmpACLOw, tmpINTR);
  CheckBox2.Checked := tmpCil;
  CheckBox1.Checked := tmpACLOW;
  CheckBox3.Checked := tmpINTR;
end;//procedure TForm1.RefreshCpuStat;

procedure TForm1.SetCrMInstr(crPoz: String);

  procedure SelText(crText: String);
  var
    mInst, mCod, tmp: String;
    tmpint: Integer;
  begin
    crText := UpperCase(crText);
    mInst := copy(crText, 1, pos(':', crText));
    mCod := copy(crText, pos(':', crText)+1, length(crText));

    //MicrocodeEdit1.SelStart := pos(mInst, UpperCase(MicrocodeEdit1.Text))-1;
    //MicrocodeEdit1.SelLength := Length(mInst);

    tmp := copy(MicrocodeEdit1.Text, pos(mInst, UpperCase(MicrocodeEdit1.Text)), Length(MicrocodeEdit1.Text));
    tmpint := pos(mCod, UpperCase(tmp));
    //RichEdit2.SelStart := tmpint + pos(mInst, UpperCase(RichEdit2.Text))-2;
    //RichEdit2.SelLength := Length(mCod);
  end;

begin
  edit2.Text := copy(crPoz, 1, pos(':', crPoz)-1);

  delete(crPoz, 1, pos(':', crPoz));

  MicrocodeEdit1.Lines.BeginUpdate;

  SelText(crPoz);

  MicrocodeEdit1.Lines.EndUpdate;

  Edit1.Text := crPoz;
end;

procedure TForm1.Button1Click(Sender: TObject);

begin
  if cmpCPU.GetCPUStatus then
  begin
    cmpCPU.setCpuIntr(CheckBox2.Checked, CheckBox1.Checked, CheckBox3.Checked);
    SetCrMInstr(cmpCpu.step);
    RefreshCpuStat;
  end
  else
  begin
    cmpCPU.LoadCode(ASMCodeEditor1.Lines);
    cmpCPU.setCpuIntr(CheckBox2.Checked, CheckBox1.Checked, CheckBox3.Checked);
    SetCrMInstr(cmpCpu.step);
    RefreshCpuStat;
  end;

  visualSwap;
end;

procedure TForm1.ApplicationEvents1Activate(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  cmpCpu := TCPU.Create(Image1);
  cmpCPU.RegAssign(LabeledEdit1, ListView1, LabeledEdit2, LabeledEdit3, LabeledEdit4, LabeledEdit5, LabeledEdit6, LabeledEdit7, ListView2, LabeledEdit8);
  cmpCPU.readMicroCod(ExtractFilePath(Application.ExeName)+'microcod.dat');
  cmpCPU.cpuInit;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if key<256 then Keys[key]:=true;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key<256 then Keys[key]:=false;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if cmpCPU.GetCPUStatus then
  begin
    cmpCPU.setCpuIntr(CheckBox2.Checked, CheckBox1.Checked, CheckBox3.Checked);
    SetCrMInstr(cmpCpu.step);
    RefreshCpuStat;
  end
  else
  begin
    Button3Click(Sender);
  end;

  visualSwap;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if Button3.Caption = 'Run' then
  begin
    if not cmpCPU.GetCPUStatus then
    begin
      cmpCPU.setCpuIntr(CheckBox2.Checked, CheckBox1.Checked, CheckBox3.Checked);
      cmpCPU.LoadCode(ASMCodeEditor1.Lines);
    end;
      timer1.Enabled := true;
      Button3.Caption := 'Stop';
  end
  else
  begin
    timer1.Enabled := false;
    Button3.Caption := 'Run';
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  MicrocodeEdit1.Lines.LoadFromFile(ExtractFilePath(Application.ExeName)+'microcod.dat');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  SetCrMInstr(' ');
  cmpCPU.cpuInit;
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    ASMCodeEditor1.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TForm1.Opent1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    ASMCodeEditor1.Lines.LoadFromFile(OpenDialog1.FileName);
    Button2Click(Sender);
  end;
end;

procedure TForm1.new1Click(Sender: TObject);
begin
  ASMCodeEditor1.Lines.Clear;
  Button2Click(Sender);
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
const
  slp:integer= 50;
begin
  if (getActiveWindow() = Form1.Handle)and(GroupBox1.Enabled) then
  begin
    done := true;

    if keys[118] then
    begin
      Button1Click(sender);
      delay(slp);
    end;

    if keys[120] then
    begin
      Button3Click(sender);
      Delay(slp);
    end;

    if keys[113] then
    begin
      Button2Click(sender);
      Delay(slp);
    end;

    application.ProcessMessages;
  end;
end;

procedure TForm1.About2Click(Sender: TObject);
var
  i: Integer;
begin
  Form2.Show;
  for i:=1 to 255 do
  begin
    Form2.AlphaBlendValue := i;
    application.ProcessMessages;
  end;
end;

procedure TForm1.CpuSimSettings1Click(Sender: TObject);
begin
  form3.Show;
end;

procedure TForm1.LabeledEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key <> ord('1')) and (key <> ord('0')) and (key <> 37) and (key <> 38) and (key <> 39) and (key <> 40) and (key <> 8) and (key <> 46) and (key <> 13) and (key <> 35) and (key <> 36) then
  begin
    Key := 0;
  end;
end;

procedure TForm1.LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if (key <> '1') and (key <> '0') and (key <> #37) and (key <> #38) and (key <> #39) and (key <> #40) and (key <> #8) and (key <> #46) and (key <> #13) and (key <> #35) and (key <> #36) then
  begin
    Key := #0;
  end;
end;

end.
