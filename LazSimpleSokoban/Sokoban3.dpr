program Sokoban3;

uses
  Forms, Interfaces,
  U_Sokoban3 in 'U_Sokoban3.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
