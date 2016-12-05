unit U_Help;

{$MODE Delphi}

{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Browse the MAZE documentation file} 
interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  THelpForm = class(TForm)
    //RichEdit1: TRichEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HelpForm: THelpForm;

implementation

{$R *.lfm}

{************** FormCreate *******************}
procedure THelpForm.FormCreate(Sender: TObject);
var
  fname:string;
begin
  Fname:=extractfilepath(application.exename)+'mazehelp.rtf';
  If fileexists(fname) then
  Begin
   {oops - set margins doesn't work for richedit}
   {richedit1.perform(EM_SETMARGINS, EC_Leftmargin+EC_RightMargin,Makelong(32,16));}
   //richedit1.borderwidth:=20;   {this sort of works for margins}
   //richEdit1.lines.loadfromfile(fname);
  end
  else ;//richEdit1.Lines.add('Help file '+fname + ' not found. ');
end;

end.
