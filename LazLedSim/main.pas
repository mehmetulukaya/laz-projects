unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, LedShape;

type

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    LedShape1: TLedShape;
    LedShape10: TLedShape;
    LedShape11: TLedShape;
    LedShape12: TLedShape;
    LedShape13: TLedShape;
    LedShape14: TLedShape;
    LedShape15: TLedShape;
    LedShape16: TLedShape;
    LedShape17: TLedShape;
    LedShape18: TLedShape;
    LedShape19: TLedShape;
    LedShape2: TLedShape;
    LedShape20: TLedShape;
    LedShape3: TLedShape;
    LedShape4: TLedShape;
    LedShape5: TLedShape;
    LedShape6: TLedShape;
    LedShape7: TLedShape;
    LedShape8: TLedShape;
    LedShape9: TLedShape;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure CheckBox1Change(Sender: TObject);
    procedure LedShape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  led_cnt : integer=0;
  up_down : boolean=true;    //up means left to right, down means right to left
  be_wait_up : tdatetime=0;
  be_wait_dn : tdatetime=0;
implementation

{ TForm1 }

procedure TForm1.Timer1Timer(Sender: TObject);
var
  obj : string;
begin
  if be_wait_up>now then exit;

  if not CheckBox1.Checked then
    Timer1.Enabled:=false;

  if up_down then
    if led_cnt<20 then
      inc(led_cnt);

  obj := 'LedShape'+inttostr(led_cnt);
  if TLedShape(FindComponent(obj))<>nil then
    TLedShape(FindComponent(obj)).StartAnimation := true;

  if led_cnt>=20 then
    begin
      up_down := false;
      be_wait_dn := now + (((1/24)/60)/60)*(2/1);
      be_wait_up := now +1;
      led_cnt := 21;
      exit;
    end;

end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  obj : string;
begin
  if be_wait_dn>now then exit;

  if not CheckBox1.Checked then
    Timer2.Enabled:=false;

  if not up_down then
    if led_cnt>1 then
      dec(led_cnt);

  obj := 'LedShape'+inttostr(led_cnt);
  if TLedShape(FindComponent(obj))<>nil then
    TLedShape(FindComponent(obj)).StartAnimation := true;

  if led_cnt<=1 then
    begin
      up_down := true;
      be_wait_up := now + (((1/24)/60)/60)*(2/1);
      be_wait_dn := now +1;
      led_cnt := 0;
      exit;
    end;

end;

procedure TForm1.CheckBox1Change(Sender: TObject);
var
  obj : string;
  n:integer;
begin
  for n:=1 to 20 do
    begin
      obj := 'LedShape'+inttostr(n);
      if TLedShape(FindComponent(obj))<>nil then
        TLedShape(FindComponent(obj)).Brush.Color := clGreen;
    end;
  if CheckBox1.Checked then
    begin
      Timer1.Enabled:=true;
      Timer2.Enabled:=true;
      led_cnt:=0;
      be_wait_up:=0;
      be_wait_dn:=now+1;
      up_down:= true;
    end;
end;

procedure TForm1.LedShape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  cmp : TLedShape;
begin
  cmp := sender as TLedShape;
  cmp.StartAnimation:= true;
end;




initialization
  {$I main.lrs}

end.

