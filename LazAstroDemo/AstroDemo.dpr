program AstroDemo;
{  Copyright  © 2001-2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {SunPos displays solar position and sunrise/sunset infor for any given date
 and time at any given location on earth.
 Also displays a plot of the shadow analemma for a location and time of day
 }


uses
  Forms, Interfaces,
  U_AstroDemo in 'U_AstroDemo.pas' {Form1},
  U_ConvertTest in 'U_ConvertTest.pas' {TConvertTest},
  UAstronomy in 'UAstronomy.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TTConvertTest, TConvertTest);
  Application.Run;
end.
