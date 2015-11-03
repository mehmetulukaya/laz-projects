program DrawRings;

uses
  Forms, Interfaces,
  U_DrawRings in 'U_DrawRings.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
