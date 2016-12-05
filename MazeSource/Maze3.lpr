program Maze3;

{$MODE Delphi}

  {Copyright  © 2001, 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ The MAZE Project file}
 
uses
  Forms, Interfaces,
  U_Maze3 in 'U_Maze3.pas' {Form1},
  U_Options3 in 'U_Options3.pas' {OptForm},
  U_Preview in 'U_Preview.pas' {PreviewForm},
  U_Header in 'U_Header.pas' {HdrForm},
  //U_Help in 'U_Help.pas' {HelpForm},
  U_About in 'U_About.pas' {AboutBox},
  U_TMaze in 'U_TMaze.pas' {MazeMsgForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TOptForm, OptForm);
  Application.CreateForm(TPreviewForm, PreviewForm);
  Application.CreateForm(THdrForm, HdrForm);
  //Application.CreateForm(THelpForm, HelpForm);
  Application.CreateForm(TMazeMsgForm, MazeMsgForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TMazeMsgForm, MazeMsgForm);
  Application.Run;
end.
