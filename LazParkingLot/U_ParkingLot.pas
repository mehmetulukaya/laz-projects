unit U_ParkingLot;

{Beginner's program illustrating one way to draw and manipulate images on a canvas}

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TParkingSpot=record
     Id:string;
     Available:boolean ; {true is spot is empty}
     Location:Trect;   {where to draw it}
     Horizontal:boolean; {true if we need to draw the horizontal car image -  none in this demo}
   end;

  TForm1 = class(TForm)
    Lot: TImage;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure LotClick(Sender: TObject);
  private
    { Private declarations }
  public
    Himage,VImage:TBitmap;
    spaces:array[1..16] of TParkingSpot; {descriptors of the 16 parking slots}
    slotwidth, slotheight, offsetx:integer;
    Procedure Arrival(SlotNbr:integer); {show a car image}
    Procedure Departure(SlotNbr:integer); {cover a car image}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************* FormCreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
{Initilization}
var
  i,w,h,L:integer;
begin
   randomize;
   {Load the car images into bitmaps}
   HImage:=TBitMap.create;
   Himage.loadfromfile('CarH.bmp');
   VImage:=TBitMap.create;
   Vimage.loadfromfile('CarV.bmp');

   {draw the parking lot of the Lot Timage}
   offsetx:=10;
   w:=(lot.width-offsetx) div 8;  slotwidth:=w; {divide width into eighths}
   h:=lot.height div 3;  slotheight:=h;  {and vertically into thirds}
   with lot,canvas do
   begin
     brush.color:=clgray;
     fillrect(clientrect);
     pen.color:=clyellow;
     pen.width:=4;
     for i:=1 to 16 do  {draw 8 spaces across the top and 8 across the bottom}
     with spaces[i] do
     begin
       Id:=inttostr(i);
       Available:=random(2)=0;  {assign cars about 1/2 of the spots}
       Horizontal:=false;
       if i<=8 then
       begin
         L:=offsetx+w*(i-1); {Move over "i" slots}
         Location:=rect(L+4,4,L+w-4,h-4); {Define the drawable area for this slot}
         if i>1 then begin moveto(L,0); lineto(L,h); end; {Draw lane line on left side}
       end
       else
       begin
         L:=offsetx+w*(i-9); {move over "i-9" slots for last 8 slots}
         location:=rect(L+4,2*h+4,L+w-4,3*h-4);
         if i>9 then begin moveto(L,2*h); lineto(L,3*h); end;
       end;
       if random(2)=0 then arrival(i) else departure(i);
     end;
     pen.color:=clblack;
     pen.width:=2;
     brush.style:=bsclear; {no background for text}
     {Draw the outline of the parking lot}
     polygon([point(0,h), {start}
              point(offsetx,h), {over}
              point(offsetx,0), {up}
              point(width-offsetx,0), {over}
              point(width-offsetx,h), {down}
              point(width,h), {over}
              point(width,2*h), {down}
              point(width-offsetx,2*h), {back}
              point(width-offsetx,height),  {down}
              point(offsetx,height), {back}
              point(offsetx,2*h), {up}
              point(0,2*h)]); {back}
     brush.style:=bssolid;
   end;
end;

{Draw the car image in the passed spot number}
procedure tform1.arrival(slotnbr:integer);
var
  w:integer;
begin
  with lot, canvas, spaces[slotnbr] do
  begin
    If horizontal then stretchdraw(location, Himage)
    else stretchdraw(location, Vimage);
    brush.style:=bsclear;
    font.style:=[fsBold];
    {center the spot number text on the image}
    w:=textwidth(id);
    with location do canvas.textout(left+ (right-left-w) div 2 , (top+bottom) div 2 -4, id);
    available:=false;
  end;
end;

{***** Departure **********}
procedure tform1.departure;
{just draw gray floor over the car image}
begin
  with lot, canvas, spaces[slotnbr]  do
  begin
    brush.color:=clgray;
    fillrect(location);
    available:=true;
  end;
end;

{********* LotClick **********}
procedure TForm1.LotClick(Sender: TObject);
{Assign or unassign a parking space - in response to a user click on the lot}
var
  p:TPoint;
  index:integer;
begin
  p:=lot.screentoclient(mouse.cursorpos); {convert screen coordinates to TImage coordinates}
  index:=(p.x-offsetx) div slotwidth +1; {Convert horizontal coordinate to a slot number}
  if (p.y <= slotheight) or (p.y >= 2*slotheight) then {test if click was in top or bottom third}
  begin
    {if it was in the bottom third, increment to bottom indices by adding 8}
    if p.y>=2*slotheight then inc(index,8);
    if spaces[index].available then arrival(index) else departure(index);
  end;
end;

end.
