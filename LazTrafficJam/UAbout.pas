unit UAbout;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

 {Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  //Windows,
  LCLIntf, LCLType, {LMessages,}
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
  end;

var
  AboutBox: TAboutBox;

implementation
  {$R *.lfm}

end.
 
