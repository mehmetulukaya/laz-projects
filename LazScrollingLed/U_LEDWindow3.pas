unit U_LEDWindow3;
  {Copyright  © 2001-2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{U_LEDWindow is the form used to disply the scrolling message when a separate
 display window is requested.}
 
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TLEDForm = class(TForm)
    Image2: TImage;
    procedure Image2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LEDForm: TLEDForm;

implementation

uses U_ScrollingLEDs3;

{$R *.DFM}


procedure TLEDForm.Image2Click(Sender: TObject);
begin
  form1.tag:=1;
  if form1.windowstate=wsminimized then form1.windowstate:=wsnormal;
end;

procedure TLEDForm.FormCreate(Sender: TObject);
begin
  doublebuffered:=true;
  width:=screen.width;
  left:=0;
end;

procedure TLEDForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  form1.tag:=1;
  if form1.windowstate=wsminimized then form1.windowstate:=wsnormal;
end;

end.
