program AirportSim;

{$MODE Delphi}

uses
  Forms, Interfaces,
  U_AirportSim in 'U_AirportSim.pas' {Form1},
  U_AirportDesc in 'U_AirportDesc.pas' {Form2};

{ R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
