program Prj_TstPlayMidi;

{$IFDEF FPC}
  {$MODE Delphi}
{$ELSE}
  {$E EXE}
{$ENDIF}

{$R '..\source\Midi2.rc'}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_TstPlayMidi in '..\source\Frm_TstPlayMidi.pas' {Form2},
  Unt_PlayMidi in '..\source\Unt_PlayMidi.pas';

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
