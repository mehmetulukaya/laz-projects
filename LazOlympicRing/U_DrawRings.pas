unit U_DrawRings;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved }

{Sample program to draw Olympic rings}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, shellAPI;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Button1: TButton;
    StaticText1: TStaticText;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  // colors:array[1..5] of Tcolor= (clblue, clblack, clred, clyellow, clgreen);  // mu changed look at below line
  x_colors : array[1..5] of Tcolor= (clblue, clblack, clred, clyellow, clgreen);

procedure TForm1.Button1Click(Sender: TObject);
var
  c:array [1..5] of TPoint; {centers}
  r:integer; {radius}
  i:integer;
begin
  x_colors[4] := rgb(242,196,0);  {make the 4th ring orange instead of yellow}

  with image2, canvas do
  begin
    {need to define picture size before we can draw on it}
    picture.bitmap.width:=Width;
    picture.bitmap.height := height;

    {clear the image space}
    pen.color:=clblack;
    pen.width:=1;
    brush.color:=clwhite;
    rectangle(clientrect);

    {define circle centers}
    {top row centers , 1/3 down, 20%-4, 50%, 80%+4 across}
    c[1]:=point( width div 5 - 4, height div 3);
    c[2]:=point( width div 2, height div 3);
    c[3]:=point( 4*width div 5 + 4, height div 3);

    {bottom row centers. 2/3 down, 1/3 and 2.3 across}
    c[4]:=point( width div 3, 2*height div 3 -6);
    c[5]:=point( 2*width div 3, 2*height div 3 -6);
    {radius, slightly less than 1.3 of height}
    r:=height div 3 - 6;
    brush.style:=bsclear; {clear brush lets overlapped areas show through}

    {draw the 5 circles}
    pen.width:=7;
    for i:=1 to 5 do
    begin
      pen.color:= x_colors[i];
      with c[i] do ellipse(x-r,y-r,x+r,y+r);
      sleep(1000);
      update;
    end;

    {oops, have to redraw draw some arcs to simuate where top row rings
     overlap bottom row}

    {1 and 4}
     pen.color:=x_colors[1];
     with c[1] do arc(x-r,y-r,x+r,y+r,   x+r,y+r,x+r,y);
     update; sleep(1000);

    {2 and 4}
     pen.color:=x_colors[2];
     with c[2] do arc(x-r,y-r,x+r,y+r,  x-r,y+r,x,y+r);
     update; sleep(1000);

     {2 and 5}
     with c[2] do arc(x-r,y-r,x+r,y+r,  x+r,y+r,x+r,y);
     update; sleep(1000);

     {3 and 5}
     pen.color:=x_colors[3];
     with c[3] do arc(x-r,y-r,x+r,y+r,  x-r,y+r,x,y+r);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
