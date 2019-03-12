program TSP3;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  Forms, Interfaces,
  U_TSP3 in 'U_TSP3.pas' {Form1},
  U_CityDlg3 in 'U_CityDlg3.pas' {CityDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TCityDlg, CityDlg);
  Application.Run;
end.
