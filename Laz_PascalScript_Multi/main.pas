unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, LclIntf, Messages,LMessages, LclType, LResources,
  SysUtils, FileUtil, uPSComponent, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls,

  uPSRuntime,uPSCompiler

  ;

const
  WM_SET_CAPTION = WM_USER + $01;

type
    Tlbl_msg_rec = record
      lbl_cmp,              // for finding the component instead of tlabel
      lbl_cap : String;
    end;
  Plbl_msg_rec=^Tlbl_msg_rec;


type

  { TScriptThread }

  TScriptThread = class (TThread)
    fScript:TPSScript;
    procedure PSScriptExecute(Sender: TPSScript);
    procedure PSScriptCompImport(Sender: TObject; x: TPSPascalCompiler);
    procedure PSScriptExecImport(Sender: TObject;
                                 se: TPSExec; x: TPSRuntimeClassImporter);
    procedure PSScriptCompile(Sender: TPSScript);

    procedure AppProcMes;
    procedure ScrSleep(const ms: Integer);

  protected
    procedure Execute; override;
  public
    constructor Create(aText:String);overload;
    destructor Destroy; override;
  end;

type
  { TForm1 }

  TForm1 = class(TForm)
    Button4: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblCallBack: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    procedure Button4Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure MyCallBack;

    procedure LabelSetAsync(lbl: PtrInt);
  protected
     procedure WMSetCaption(var Message: TLMessage); message WM_SET_CAPTION;
  end;

var
  Form1: TForm1;
  thr1,thr2,thr3 : TScriptThread;
  Cnt:Integer;
  Busy:Boolean=False;

implementation
uses
      uPSR_std,
      uPSC_std,
      uPSR_stdctrls,
      uPSC_stdctrls,
      uPSR_forms,
      uPSC_forms,
      uPSC_graphics,
      uPSC_controls,
      uPSC_classes,
      uPSR_graphics,
      uPSR_controls,
      uPSR_classes;


{$R *.lfm}

{ TForm1 }

procedure TScriptThread.ScrSleep(const ms:Integer);
begin
  Sleep(ms);
end;


procedure SetLabelCaption(const aName, aCaption:string);
var
  buf: PChar;
  len: integer;
  cmp : TComponent;
begin
  if (aName='') or (aCaption='') then
    Exit;

  if Busy then
    Exit;

  Busy:=True;

  len := (Length(aCaption) + 1) * SizeOf(Char);
  GetMem(buf, len);
  Move(aCaption[1], buf^, len);
  cmp := Form1.FindComponent(aName);
  if Assigned(cmp) then
    LclIntf.SendMessage(Form1.Handle,
                        WM_SET_CAPTION,
                        Integer(cmp),
                        Integer(buf));
end;



constructor TScriptThread.Create(aText:String);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  fScript:=TPSScript.Create(nil);
  fScript.Script.Text := aText;
  fScript.OnCompile := @PSScriptCompile;
  fScript.OnExecute := @PSScriptExecute;
  fScript.OnCompImport := @PSScriptCompImport;
  fScript.OnExecImport := @PSScriptExecImport;
  // Execute;
end;

destructor TScriptThread.Destroy;
begin
  FreeAndNil(fScript);
  inherited;
end;

procedure TScriptThread.Execute;
begin
  if fScript.Compile then
    fScript.Execute;
end;

procedure TScriptThread.PSScriptCompImport(Sender: TObject;
  x: TPSPascalCompiler);
begin
  SIRegister_Std(x);
  SIRegister_Classes(x, true);
  SIRegister_Graphics(x, true);
  SIRegister_Controls(x);
  SIRegister_stdctrls(x);
  SIRegister_Forms(x);
end;

procedure TScriptThread.PSScriptExecImport(Sender: TObject; se: TPSExec;
  x: TPSRuntimeClassImporter);
begin
  RIRegister_Std(x);
  RIRegister_Classes(x, True);
  RIRegister_Graphics(x, True);
  RIRegister_Controls(x);
  RIRegister_stdctrls(x);
  RIRegister_Forms(x);
end;

procedure TScriptThread.PSScriptExecute(Sender: TPSScript);
begin
  Sender.SetVarToInstance('Application', Application);
  Sender.SetVarToInstance('Form1', Self);
end;

procedure TScriptThread.PSScriptCompile(Sender: TPSScript);
begin
  Sender.AddRegisteredVariable('Application', 'TApplication');
  Sender.AddRegisteredVariable('Form1', 'TForm');
  Sender.AddFunction(@TScriptThread.ScrSleep,
                   'procedure ScrSleep(const ms:Integer);');
  Sender.AddFunction(@SetLabelCaption,
                   'procedure SetLabelCaption(const aName, aCaption:string);');
  Sender.AddFunction(@TScriptThread.AppProcMes,
                    'procedure AppProcMes;');
end;

procedure TScriptThread.AppProcMes;
begin
  Synchronize(@Form1.MyCallBack);
  Synchronize(@Application.ProcessMessages);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Cnt:=0;

  thr1:=TScriptThread.Create(Memo1.Text);
  thr1.Start;

  thr2:=TScriptThread.Create(Memo2.Text);
  thr2.Start;

  thr3:=TScriptThread.Create(Memo3.Text);
  thr3.Start;

end;

procedure TForm1.MyCallBack;
begin
  Cnt+=1;
  lblCallBack.Caption:=IntToStr(Cnt);
end;

//avra's method
procedure TForm1.LabelSetAsync(lbl: PtrInt);
var
  rcv_lbl: Tlbl_msg_rec;
begin
  rcv_lbl:=Plbl_msg_rec(lbl)^;
  TLabel(FindComponent(rcv_lbl.lbl_cmp)).Caption:=rcv_lbl.lbl_cap;
  Dispose(Plbl_msg_rec(lbl));
end;

procedure TForm1.WMSetCaption(var Message: TLMessage);
var
  buf: PChar;
  lblcap : Plbl_msg_rec;
begin
  if (Message.lParam <> 0) and (Message.WParam<>0) then
    try
      buf := PChar(Message.lParam);

      // will be destroy in LabelSetAsync
      New(lblcap);
      lblcap^.lbl_cmp:=TComponent(Message.wParam).Name;
      lblcap^.lbl_cap:=buf;
      Application.QueueAsyncCall(@Form1.LabelSetAsync,PtrInt(lblcap));

      //TLabel(Message.wParam).Caption := buf;  // in windows working correct
    finally
      FreeMem(buf);
      Busy:=False;
    end;
end;

end.


