unit U_Header;

{$MODE Delphi}

{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Create and edit headers and footers for printing }

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  THdrForm = class(TForm)
    FontDialog1: TFontDialog;
    HFEdt: TEdit;
    FontBtn: TButton;
    BitBtn1: TBitBtn;
    HFGroup: TRadioGroup;
    BitBtn2: TBitBtn;
    procedure FontBtnClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HdrForm: THdrForm;

implementation

{$R *.lfm}

Uses U_TMaze;

{******************** FontBtnClick ****************}
procedure THdrForm.FontBtnClick(Sender: TObject);
begin
  If fontdialog1.execute then HFEdt.font.assign(Fontdialog1.font);
end;

{****************** FormDeactivate ***************}
procedure THdrForm.FormDeactivate(Sender: TObject);
var
  htype:THeadertype;
begin
  If modalresult=mrOK then
  Begin
    htype:=THeaderType(HFGroup.itemindex);
    If (hfedt.font<>maze.headerfont)
      or (hfedt.text<>maze.headertext)
      or (htype<>maze.headertype)
    then maze.modified:=true;
     maze.setheader(htype,hfedt.text,hfedt.font);
  end;
end;

{***************** FormActivate *****************}
procedure THdrForm.FormActivate(Sender: TObject);
begin
  case maze.Headertype of
    none: HFGroup.itemindex:=0;
    header: HFGroup.itemindex:=1;
    footer: HFGroup.itemindex:=2;
  End;
  HFEdt.text:=maze.headertext;
  HFedt.font.assign(maze.HeaderFont);
  Fontdialog1.font.assign(maze.headerfont);
  HFGroup.itemindex:=ord(maze.headertype);
end;

{****************** FormCloseQuery ****************}
procedure THdrForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  htype:THeaderType;
begin
  canclose:=true;
  htype:=THeaderType(HFGroup.itemindex);
  If ((hfedt.font<>maze.headerfont)
      or (hfedt.text<>maze.headertext))
      and (htype=none)
  then
  Begin
     If messagedlg('Would you like to select header or footer type?',
                 mtconfirmation,[mbyes,mbno],0)=mryes
     then canclose:=false;
  end;
end;

end.
