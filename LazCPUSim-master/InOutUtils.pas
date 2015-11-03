unit InOutUtils;

{$MODE Delphi}

interface

uses
  math, SysUtils, LCLIntf, LCLType, LMessages, Messages, Forms, strutils;

  procedure Delay(msecs: Longint);
  procedure NanoSleep(dur: Integer);
  function BinToInt(Value: string): Integer;
  function GetUgDif(ug1: Integer; ug2: Integer): Integer;
  
var
  busInUse: Boolean;

implementation

function BinToInt(Value: string): Integer;
var
  i, iValueSize: Integer;
begin
  Result := 0;
  iValueSize := Length(Value);
  for i := iValueSize downto 1 do
    if Value[i] = '1' then Result := Result + (1 shl (iValueSize - i));
end;

procedure NanoSleep(dur: Integer);
var
  i: Integer;
begin
  if dur>0 then
    Delay(dur)
  else
    if dur = 0 then
      for i:=1 to 1000 do
      begin
        application.ProcessMessages;
      end;
end;

procedure Delay(msecs: Longint);
var
  targettime: Longint;
  Msg: TMsg;
begin
  targettime := GetTickCount + msecs;
  while targettime > GetTickCount do
    application.ProcessMessages;
end;

function GetUgDif(ug1: Integer; ug2: Integer): Integer;
var
  tmpUg, smn: Integer;
begin
  smn := -1;
  if ug1 < ug2 then
  begin
    tmpUg := ug1;
    ug1 := ug2;
    ug2 := tmpUg;
    smn := 1;
  end;

  if (abs(ug1 - ug2) > 180) then
  begin
    tmpUg := abs((360 - ug1) + ug2)*-1;
  end
  else
  begin
    tmpUg := abs(ug1 - ug2);
  end;

  result := tmpUg * smn;
end;//function GetUgDif(ug1: Integer; ug2: Integer): integer;

end.