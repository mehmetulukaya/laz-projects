unit U_Compass;
{Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, Spin;

type
  Float=double;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo1: TMemo;
    Compass: TPaintBox;
    Heading: TSpinEdit;
    TypeGrp: TRadioGroup;
    Label1: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure CompassPaint(Sender: TObject);
    procedure ForceRepaint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  end;
var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;


{************** FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  {The Compass Tpaintbox has Panel1 as its TWinControl Owner so setting
  Panel1.doublebuffered property to true with prevent "flashing" of the
  compass as it is redrawn}
  panel1.doublebuffered:=true;
end;

{************* CompassPaint *************}
procedure TForm1.CompassPaint(Sender: TObject);
{Redraw the compass at angle indicated by TSpinedit Heading.value}
Var LogRec: TLOGFONT;
    c:TPoint;
    r:float;
    {------------ DrawChar ---------}
    procedure drawchar(const s:string; dist,angle:Float);
    {draw angled characters}
    var
      x,y,w,h:integer;
      L, alpha:Float;
    begin
      with  compass, compass.canvas do
      begin
        {get center of string}
        w:=textwidth(s);
        H:=textheight(s);
        L:=sqrt(sqr(dist+h/2)+sqr(w/2)); {distance to top left corner}
        alpha:=angle+arcsin((w/2)/L);
        x:=round(compass.width/2+L*sin(alpha));
        y:=ROUND(compass.height/2+L*cos(alpha));
        LogRec.lfEscapement := trunc(1800*(1+angle/pi));  {escapement in 10ths of degrees}
        Font.Handle := CreateFontIndirect( LogRec );
        TextOut(x, y, s);
      end;
    end;
    {----------- DrawHand -----------}
    procedure drawhand(angle:float);
    var
      savepencolor,savebrushcolor:TColor;
      ox,oy:float;
      pw1,pw2:TPoint; {Wide points of pointer}
      begin
      with compass, canvas do
      begin
        savepencolor:=pen.color;
        savebrushcolor:=brush.color;
        pen.color:=clblack;
        (*
        {needle straight line version}
        moveto(trunc(c.x), trunc(c.y));
        lineto(trunc(c.x+cos(angle)*r), trunc(c.y+sin(angle)*r));
        *)

        {Tapered pointer version}
        pen.color:=clblack;
        ox:= cos(angle+pi/2)*10;
        oy:= sin(angle+pi/2)*10;

        (* {Original draw method, replaced by polygon calls below}
        {top half}
        moveto(trunc(c.x+cos(angle)*r), trunc(c.y+sin(angle)*r));
        lineto(trunc(c.x+ox),trunc(c.y+oy));
        lineto(trunc(c.x-ox),trunc(c.y-oy));
        lineto(trunc(c.x+cos(angle)*r), trunc(c.y+sin(angle)*r));
        brush.color:=clred;
        floodfill(trunc(c.x+cos(angle)*5), trunc(c.y+sin(angle)*5),
                         clblack, fsBorder);

        {bottom half}
        moveto(trunc(c.x+ox),trunc(c.y+oy));
        lineto(trunc(c.x-cos(angle)*r), trunc(c.y-sin(angle)*r));
        lineto(trunc(c.x-ox),trunc(c.y-oy));
        brush.color:=clblack;
        floodfill(trunc(c.x-cos(angle)*5), trunc(c.y-sin(angle)*5),
                         clblack, fsBorder);

        *)

        {top half}
        {width points at center of pointer}
        pw1:= point(trunc(c.x+ox),trunc(c.y+oy));
        pw2:= point(trunc(c.x-ox),trunc(c.y-oy));
        {top half}
        brush.color:=clred;
        polygon([point(trunc(c.x+cos(angle)*r), trunc(c.y+sin(angle)*r)),pw1, pw2]);
        {bottom half}
        brush.color:=clblack;
        polygon([point(trunc(c.x-cos(angle)*r), trunc(c.y-sin(angle)*r)),pw1, pw2]);

        {resotre entry values}
        pen.color:=savepencolor;
        brush.color:=savebrushcolor;
      end;
    end;

var
  Len, angle, angleinc, anglestart,jdist:Float;
  i,border:integer;
  rheading:float;


begin  {CompassPaint}

  with   compass, compass.canvas do
  begin
    if typegrp.itemindex=0
    then rheading:=heading.value*(pi/180) {rotate the compass}
    else rheading:=0; {moving the pointer}

    {assume center of dial is center of paintbox, diameter of dial is short side
     of paintbox}

    if compass.Width < compass.Height then compass.Height:=compass.Width
      else compass.Width:= compass.Height; {make paintbox square}

    pen.width:=4;
    pen.color:=clblack;
    brush.color:=clgray;
    brush.style:=bsSolid;
    rectangle(clientrect); {clear the previous drawing}
    pen.color:=clwhite;
    pen.width:=2;
    border:=30;
    ellipse(border,border,compass.width-border,compass.width-border);
    r:=compass.width div 2 - border;
    c:=point(compass.width div 2,compass.width div 2);
    {draw 10 degree marks}
    {let's try making them 10% of radius}
    len:=0.9*r;
    angleInc:= Pi/18; {2Pi/36 radians = 10 degrees}
    anglestart:=rheading;
    angle:=anglestart;
    for i:=1 to 36 do
    begin  {draw 10 degree marks}
      moveto(trunc(c.x+sin(angle)*len), trunc(c.y+cos(angle)*len));
      lineto(trunc(c.x+sin(angle)*r), trunc(c.y+cos(angle)*r));
      angle:=angle+angleinc;
    end;
    {and 5 degree marks at 5% of radius}
    len:=0.95*r;
    angle:=anglestart+angleinc/2.0;
    for i:= 1 to 36 do
    begin
      moveto(trunc(c.x+sin(angle)*len), trunc(c.y+cos(angle)*len));
      lineto(trunc(c.x+sin(angle)*r), trunc(c.y+cos(angle)*r));
      angle:=angle+angleinc;
    end;
    {Draw direction Letters}
    with compass.canvas.font do
    begin
      Name   := 'Arial';
      Size := 12;
      color:=clwhite;
    end;
    GetObject(compass.canvas.Font.Handle, SizeOf(LogRec),Addr(LogRec));
    pen.color:=clblack;
    brush.color:=clgray;
    jdist:=0.8*r;  {distance from center to top of letter}
    {  //for debugging
    i:=round(width/2-jdist);
    ellipse(i,i,width-i,width-i);
    brush.color:=clred;
    }
    angle:=anglestart+pi;
    {3 character strings (' X ') here have more consistent height than single chars}
    {Could also add "NNE", "NE", ENE", etc.}
    drawchar(' N ',jdist, angle);
    angle:=anglestart+pi/2.0;
    drawchar(' E ',jdist,angle);
    angle:=anglestart;
    drawchar(' S ',jdist,angle);
    angle:=anglestart+3*pi/2.0;
    drawchar(' W ',jdist,angle);
    {Add  degree values from 30 to 330 at 30 degree increments}
    for i:=1 to 11 do
    begin
      if i mod 3>0 then {but not over the direction letters}
      begin
        angle:=rheading+pi*(6-i)/6;
        drawchar(' '+inttostr(30*i)+' ',jdist,angle);
      end;
    end;

    if typegrp.itemindex=1   {draw the compass needle}
    then drawhand(heading.value*(pi/180)-pi/2)
    else  drawhand(-pi/2)
    (*
     {Draw lubber line}
    begin
      pen.color:=clred;
      pen.width:=3;
      moveto(c.x,c.y-trunc(r+border-4));
      lineto(c.x,c.y-trunc(r-border/4));
      pen.width:=2;;
    end;
    *)
  end;
end;

{*********** ForceRepaint ***********}
procedure TForm1.ForceRepaint(Sender: TObject);
{Called when display type or compass angle changes}
begin
  while heading.value<0 do heading.Value:=heading.Value+360;
  while heading.value>360 do heading.Value:=heading.Value-360;
  compass.Invalidate;
end;



procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
