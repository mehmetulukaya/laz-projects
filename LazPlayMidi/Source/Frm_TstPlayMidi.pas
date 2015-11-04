unit Frm_TstPlayMidi;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
   SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    TrackBar1: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    Button5: TButton;
    Button6: TButton;
    procedure Button5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private-Deklarationen }
    FFlag:boolean;
    Procedure PlayNotify(Sender:Tobject;Position,Length:string;var BreakF:boolean);
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

uses Unt_PlayMidi;

function deci(i,d:integer):string;

begin
  result:='0000000'+inttostr(i);
  result:=copy(result,length(result)-d+1,d);
end;

procedure TForm2.playnotify ;
var p,l:integer;
begin
  if TryStrToInt(Position,p) and TryStrToInt(Length,l)   then
    begin
      TrackBar1.Max := L;
      TrackBar1.Position := p;
      TrackBar1.Frequency := 600;
      label1.Caption := inttostr(P div 600)+':'+deci((P mod 600) div 10,2);
      Label2.Caption := inttostr(l div 600)+':'+deci((l mod 600) div 10,2);
    end
  else
    begin
        label1.Caption := Position;
  Label2.Caption := length;

    end;
  BreakF :=FFlag;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  Midi('mOne',PlayNotify );
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  Midi('mTwo',PlayNotify);
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  Midi('mThree',PlayNotify);
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  close;
end;

procedure TForm2.Button5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FFlag :=true
end;

procedure TForm2.Button5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FFlag := false;
end;

procedure TForm2.Button6Click(Sender: TObject);
begin

end;

(*
  uses
  MMSystem;

// Play Midi
procedure TForm1.Button1Click;
const
  FileName = 'C:\YourFile.mid';
begin
  MCISendString(PChar('play ' + FileName), nil, 0, 0);
end;

// Stop Midi
procedure TForm1.Button1Click;
const
  FileName = 'C:\YourFile.mid';
begin
  MCISendString(PChar('stop ' + FileName), nil, 0, 0);
end;
*)

end.
