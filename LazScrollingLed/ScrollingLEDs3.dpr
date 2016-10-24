program ScrollingLEDs3;
 {Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Scrolling LEDs program simulates those scrolling signs frequently used for
 advertising messages}

uses
  Forms, Interfaces,
  U_ScrollingLEDs3 in 'U_ScrollingLEDs3.pas' {Form1},
  U_LEDWindow3 in 'U_LEDWindow3.pas' {LEDForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TLEDForm, LEDForm);
  Application.Run;
end.
