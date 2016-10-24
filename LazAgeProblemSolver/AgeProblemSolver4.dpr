program AgeProblemSolver4;

uses
  Forms, Interfaces,
  U_AgeProblemSolver4 in 'U_AgeProblemSolver4.pas' {Form1},
  UTEval in 'UTEval.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
