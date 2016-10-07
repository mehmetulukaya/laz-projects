program TrafficJams1A;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

  {Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  U_TrafficJams1A in 'U_TrafficJams1A.pas' {Form1},
  UAbout in 'UAbout.pas' {AboutBox},
  ULogon in 'ULogon.pas' {LoginForm},
  UWinnerDlg1A in 'UWinnerDlg1A.pas' {WinnerDlg};

{$R *.res}

begin
  {Application.Initialize;}
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TWinnerDlg, WinnerDlg);
  Application.Run;
end.
