program Catapult;

{$MODE Delphi}

{Copyright 2005, Gary Darby, www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Catapult simulator}
{%ToDo 'Catapult.todo'}
{%ToDo 'Catapult4.todo'}

uses
  Forms, Interfaces,
  U_Catapult in 'U_Catapult.pas' {Form1},
  URungeKutta4 in 'URungeKutta4.pas',
  NumEdit2 in 'NumEdit2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
