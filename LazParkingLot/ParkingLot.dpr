program ParkingLot;

uses
  Forms, Interfaces,
  U_ParkingLot in 'U_ParkingLot.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
