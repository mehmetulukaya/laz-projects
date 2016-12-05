unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, LclIntf, Messages,LMessages, LclType, LResources,
  SysUtils, FileUtil, uPSComponent, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls,

  uPSComponent_Default,
  uPSComponent_Forms,
  uPSComponent_Controls,
  uPSComponent_StdCtrls,
  uPSRuntime,uPSCompiler

  ;

const
  WM_SET_CAPTION = WM_USER + $01;
type

  { TForm1 }

  TForm1 = class(TForm)
    Button4: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    procedure Button4Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  protected
     procedure WMSetCaption(var Message: TLMessage); message WM_SET_CAPTION;
  end;

var
  Form1: TForm1;

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


procedure AppProcMes;
begin
  Application.ProcessMessages;
  Sleep(1);
end;

procedure SetLabelCaption(const aName, aCaption:string);
var
  C:TComponent;
  buf: pWideChar;
  len: integer;
begin
  len := (Length(aCaption) + 1) * SizeOf(Char);
  GetMem(buf, len);
  Move(aCaption[1], buf^, len);
  LclIntf.SendMessage(Form1.Handle,
                      WM_SET_CAPTION,
                      Integer(Form1.FindComponent(aName)),
                      Integer(buf));
end;

type
  TScriptThread = class (TThread)
    fScript:TPSScript;
    procedure PSScriptExecute(Sender: TPSScript);
    procedure PSScriptCompImport(Sender: TObject; x: TPSPascalCompiler);
    procedure PSScriptExecImport(Sender: TObject; se: TPSExec; x: TPSRuntimeClassImporter);
    procedure PSScriptCompile(Sender: TPSScript);
  public
    constructor Create(aText:String);overload;
    destructor Destroy; override;
    procedure Execute; override;
  end;

constructor TScriptThread.Create(aText:String);
begin
  //inherited Create(True);
  FreeOnTerminate := True;
  fScript:=TPSScript.Create(nil);
  fScript.Script.Text := aText;
  fScript.OnCompile := @PSScriptCompile;
  fScript.OnExecute := @PSScriptExecute;
  fScript.OnCompImport := @PSScriptCompImport;
  fScript.OnExecImport := @PSScriptExecImport;
  inherited Create(True);
  Execute;
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
  Sender.AddFunction(@SetLabelCaption, 'procedure SetLabelCaption(const aName, aCaption:string);');
  Sender.AddFunction(@AppProcMes, 'procedure AppProcMes;');
end;


procedure TForm1.Button4Click(Sender: TObject);
begin
  TScriptThread.Create(Memo1.Text);
  TScriptThread.Create(Memo2.Text);
  TScriptThread.Create(Memo3.Text);
end;

procedure TForm1.WMSetCaption(var Message: TMessage);
var
  buf: pChar;
begin
  if Message.lParam <> 0 then begin
    buf := pChar(Message.lParam);
    TLabel(Message.wParam).Caption := buf;
    FreeMem(buf);
  end;
end;



end.
uses Classes;

