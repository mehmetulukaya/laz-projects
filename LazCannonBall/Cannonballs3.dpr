program Cannonballs3;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
uses
  Forms, Interfaces,
  U_Cannonballs3 in 'U_Cannonballs3.pas' {MainForm},
  U_Stats in 'U_Stats.pas' {Stats};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TStats, Stats);
  Application.Run;
end.
