unit UWinnerDlg1A;

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
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs{, Printers}
  ;

type
  TWinnerDlg = class(TForm)
    OKBtn: TButton;
    Label2: TLabel;
    NextBtn: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    PrintBtn: TButton;
    //PrintDialog1: TPrintDialog;
    //PrinterSetupDialog1: TPrinterSetupDialog;
    procedure NextBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  public
    nextjam:integer;
  end;

var
  WinnerDlg: TWinnerDlg;

implementation

uses U_TrafficJams1A;

{$R *.lfm}

var
  winnermsgs: array[0..5] of string =
          ('HOORAY!',  'GOOD JOB!', 'You ARE Good',
          'HOT STUFF!', 'WOW! SUPER!',  'WHAT A BRAIN!');

{****************** NextBtnClick ****************}
procedure TWinnerDlg.NextBtnClick(Sender: TObject);
begin
  inc(nextjam);
  Button1Click(nil);
end;


{******************* PrintBtnClick *****************}
procedure TWinnerDlg.PrintBtnClick(Sender: TObject);
{Print board and soluton}
{var
  i,h,w,l,t:integer;
  nextline,spacing,pagebottom:integer;
  boardbottom,nextcolumn,columnwidth:integer;}
begin
{  if printersetupdialog1.execute then
  If Printdialog1.execute then
  with printer, printer.canvas do
  Begin
    begindoc;
    brush.color:=clwhite;

    form1.loadcurrentcase(nextjam);
    h:=pageheight div 2;
    w:=pagewidth div 2;
    if h>w then h:=w else w:=h;
    l:=4*pagewidth div 10;  // left side address (in pixels)
    t:=2*pageheight div 10; //  top
    boardbottom:=t+h;       //board bottom
    pagebottom:=9*pageheight div 10; //page bottom
    form1.currentCase.imageprint(rect(l,t,l+w,t+h),canvas, true);
    nextline:=t-6*textheight(caption);
    nextcolumn:=pagewidth div 10;
    font.size:=20;
    font.color:=clblack;
    textout(nextcolumn,nextline,caption);
    nextline:=nextline+2*abs(font.height);
    font.size:=12;
    font.style:=[fsunderline, fsbold, fsitalic];
    textout(nextcolumn,nextline,'Winning Moves');
    columnwidth:=pagewidth div 5;
    spacing:=3*abs(font.height) div 2;
    font.style:=[];
    nextline:=nextline+spacing;

    for i:= 0 to listbox1.items.count-1 do
    Begin
      nextline:=nextline+spacing;
      textout(nextcolumn,nextline,listbox1.items[i]);
      if textwidth(listbox1.items[i])>columnwidth then columnwidth:=textwidth(listbox1.items[i])+50;
      if nextline>pagebottom then
      Begin
        nextcolumn:=nextcolumn+columnwidth;
        nextline:= boardbottom+spacing;
      end;
    end;
    enddoc;
  end;
  }
end;



{******************** FormActivate ***************}
procedure TWinnerDlg.FormActivate(Sender: TObject);
begin
  {Show a random reward message}
  Label2.caption:=winnermsgs[random(length(winnermsgs))];
end;

procedure TWinnerDlg.Button1Click(Sender: TObject);
var
  b:TBitmap;
  s:string;
begin
  b:=TBitmap.create;
  with form1 do
  begin
    loadcurrentcase(nextjam); {reload initial position}
    b.width:=2*boardbox.width;
    b.height:=2*boardbox.height;
    currentCase.imageprint(rect(10,10,boardbox.width+10, boardbox.height+10), b.canvas, false);
    s:=extractfilepath(application.exename)+ currentcase.casename+'.bmp';
    b.savetofile(s);
  end;  
end;

end.
