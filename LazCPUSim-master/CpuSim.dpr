program CpuSim;

uses
  Forms,
  main in 'main.pas' {Form1},
  GrfCpu in 'GrfCpu.pas',
  Cpu in 'Cpu.pas',
  about in 'about.pas' {Form2},
  Settings in 'Settings.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
