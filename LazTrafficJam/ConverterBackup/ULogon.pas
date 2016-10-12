unit ULogon;

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
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TLoginForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TLoginForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then Begin  modalresult:=MrOK; key:=char($0); end
  else if length(edit1.text)=0 then key:=char(ord(key) and $DF); {convert 1st charatcer to upper case}
end;

end.
