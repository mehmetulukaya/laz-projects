{Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Thanks to viewer Arne for contributing this program and granting permission to
  publish it on DelphiForFun}

{This program illustrates molecules of different masses and radii moving in a
 box, colliding with the walls and with each other. Molecules are implemented as
 objects of class Molecule and drawn as circles on the canvas of Image1.
 A molecule is moved by erasing it, moving the center from (x,y) to
 (x+vx*dt,y+vy*dt), and then draw it in the new posision. Reflections are easy
 to handle, just flip vx to -vx, or vy to -vy.

 The most complicated event is a collision between two molecules. This is
 treated by transforming the velocities to a coordinate system S' with x-axis
 parallell to the line combining the centers. In this coordinate system the
 y-components do not change, while the x-components can be treated as if it
 were a head-on collision. Demanding conservation of energy and momentum, the
 formulas for the new velocities are easily obtained.

 Setup #1 illustrates two kinds of molecules, the blue heavier than the red.
 Although the red ones are initially at rest, it is obvious that after some time
 they move faster than the blue ones. This is a demonstration of the
 equipartition of energy, all the molecules have on the average the same kinetic
 energy.

 Setup #3 demonstrates Brownian motion. Here there is only one heavy molecule
 (particle), and many invisible light ones.}

unit U_Molecules;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, ComCtrls;

type
  TMolecule = class  { A molecule has a radius, mass, position, velocity and a color}
     r,m,x,y,vx,vy : Extended;
     col           : Tcolor;
     Canvas:TCanvas;
     {Image1:TImage;}
     Constructor Init(r1,m1,x1,y1,vx1,vy1:Extended; c1:Tcolor;newcanvas:TCanvas);
     procedure Move;           { Moves a molecule }
     procedure MoveTo(x1,y1 : Extended);  { Moves the molecule to (x1,y1) }
     procedure Draw;          { Draws a molecule }
     procedure Erase;         { Erases a molecule }
     procedure Reflect;       { Reflects a molecule from a wall }
  end;


  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Close1: TMenuItem;
    Start1: TMenuItem;
    Stop1: TMenuItem;
    Setup1: TMenuItem;
    Setup11: TMenuItem;
    Setup21: TMenuItem;
    Setup31: TMenuItem;
    Stup41: TMenuItem;
    Setup51: TMenuItem;
    StatusBar1: TStatusBar;
    Image1: TImage;
    procedure Close1Click(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SetupClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Image1Click(Sender: TObject);
  public
    { Public declarations }
    n : integer;     { Number of molecules }
    freq: int64;     { Windows timer frequency}
    molecules : array[1..100] of TMolecule;  {Array of molecules}
    stop  : boolean;  {Stop flag}
    setupnbr:integer;  {current setupnbr}

    procedure main;
    procedure Setup(casenbr:integer);
    procedure Collisions;  {handle collisions between molecules}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


var
  {fields set by TForm1 but used by Tmolecule}
  BGC   : TColor;       { Background color }
  dt    : extended;     { Time increment }
  w,h   : integer;      {canvas width and height}


{***************** TMolecule.Init *********}
constructor TMolecule.Init(r1,m1,x1,y1,vx1,vy1:Extended;c1:TColor;
                                                   newcanvas:TCanvas);
{Set size, mass, position and velocity of the molecule}
begin
  r:=r1;
  m:=m1;
  x:=x1; y:=y1;
  vx:=vx1; vy:=vy1;
  col:=c1;
  canvas:=newcanvas;
end;

{*********** TMolecule.Reflect **********}
procedure TMolecule.Reflect;
{If molecule is within radius, r, of an edge change it's direction to bounce it
 off of the wall}
begin
  { Start move at 0.5 pixel to avoid molecule sticking to the wall }
  if (x<r)   then begin vx:=-vx;  MoveTo(r+0.5,y);   end;
  if (x>w-r) then begin vx:=-vx; MoveTo(w-r-0.5,y); end;
  if (y<r)   then begin vy:=-vy;  MoveTo(x,r+0.5);   end;
  if (y>h-r) then begin vy:=-vy; MoveTo(x,h-r-0.5); end;
end;


{************* TMolecule.Draw ********}
procedure TMolecule.Draw;
begin
  Canvas.Pen.Color:=col;
  Canvas.Brush.Color:=col;
  Canvas.Ellipse(Trunc(x-r+0.5),Trunc(y-r+0.5),Trunc(x+r+0.5),Trunc(y+r+0.5));
end;

{*********** TMolecule.Erase ************}
procedure TMolecule.Erase;
begin
  Canvas.Pen.Color:=BGC;
  Canvas.Brush.Color:=BGC;
  Canvas.Ellipse(Trunc(x-r+0.5),Trunc(y-r+0.5),Trunc(x+r+0.5),Trunc(y+r+0.5));
end;

{************* TMolecule.Move ***********}
procedure TMolecule.Move;
{move the molecule forward one (dt) time unit}
begin
  Erase;
  x:=x+vx*dt;
  y:=y+vy*dt;
  Draw;
end;

{************ TMolecule.Moveto ***********}
procedure TMolecule.MoveTo(x1,y1 : Extended);
{ Used to avoid molecule penetrating borders }
begin
  Erase;
  x:=x1;
  y:=y1;
  Draw;
end;

{****************** FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
var i:integer;
begin
  for i:=low(molecules) to high(molecules) do molecules[i]:=TMolecule.create;
  h:=image1.height;
  w:=image1.width;
  queryperformancefrequency(freq);
  Randomize;
  Caption:='Molecules';
  dt:=0.1;
  setup(4);
  main;
end;



{************* Setup **********}
procedure Tform1.Setup(casenbr:integer);
{Define a set of molecules}
var  i,n1, n2, newr: integer;
begin
  setupnbr:=casenbr;
  with image1 do
  begin
    case casenbr of
      1:
      begin
        Caption:='Molecules Setup 1 - Inline molecules of equal mass.';
        n:=10;
        BGC:=clYellow;
        molecules[1]:=tmolecule.Init(10,1,20,300,10,0,clRed,canvas);
        for i:=2 to n do
        molecules[i]:=TMolecule.Init(10,1,100+70*i,300,0,0,clRed,canvas);
      end;

      2:
      begin
        Caption:='Molecules Setup 2 - Inline, blue molecule twice as heavy as the red molecules';
        n:=10;
        BGC:=clYellow;
        molecules[1]:=tMolecule.Init(20,3,20,300,10,0,clBlue,canvas);
        for i:=2 to n do
        molecules[i]:=tMolecule.Init(10,1,100+70*i,300,0,0,clRed,canvas);
      end;
      3:
      begin
        Caption:='Molecules Setup 3 - Brownian Motion. Invisible molecules collide with heavy blue particle. ';

        n:=60;
        BGC:=clYellow;
        molecules[1]:=TMolecule.Init(20,10,w div 2, h div 2,-5,-5,clBlue,canvas);
        for i:=2 to n div 2 do
        begin
          molecules[i]:=TMolecule.Init(10,1,10+30*i,100,30,30,
                                                            BGC, canvas);
          molecules[29+i]:=tMolecule.Init(10,1,10+30*I,150,30,30,
                                                       BGC, canvas);
        end;
        n:=59;
      end;
      4:
      begin
        Caption:='Molecules Setup 4 - Slow heavy blue molecules and 1/2 mass red molecules ';
        n:=40;
        BGC:=clYellow;
        n1:=n div 3;
        n2:=n1+1;
        newr:=(w div n2 -10) div 2; {radius = 1/2 available space - 10 pixels}
        for i:=1 to n1 do
        molecules[i]:=tMolecule.Init(newr,10,newr+(2*newr+10)*i,45,
                                    Random(60)-20,Random(40)-10,clBlue,canvas);

        n2:=n-n1+1;
        newr:=(w div n2 -10) div 2; {radius = 1/2 available space - 10 pixels}
        for i:=n1+1 to n do
        molecules[i]:=tMolecule.Init(newr,2,newr+(2*newr+10)*(i-n1),
                                 h*5 div 7,0,0,clRed,canvas);
      end;
      5:
      begin
        Caption:='Molecules Setup 5 - Fast heavy blue molecules and  1/10 mass red molecules';
        n:=50;
        BGC:=RGB(128,0,128);
        n1:=n div 3;
        n2:=n1+1;
        newr:=(w div n2 -10) div 2; {radius = 1/2 available space - 10 pixels}
        for i:=1 to n1 do
        with molecules[i] do
        repeat
          molecules[i]:=tMolecule.Init(newr,10,newr+(2*newr+10)*i,45,Random(80)-20,
                        Random(80)-10,clBlue,canvas);
        until (x+vx*dt>0) and (x+vx*dt<w);
        n2:=n-n1+1;
        newr:=(w div n2 -10) div 2; {radius = 1/2 available space - 10 pixels}
        for i:=n1+1 to n do
          molecules[i]:=tMolecule.Init(newr,2,newr+(2*newr+10)*(i-n1),
                                            height*5 div 7,0,0,clRed,canvas);
      end;
    end;
    Canvas.Brush.Color :=BGC;
    Canvas.fillrect(rect(0,0,w,H));
    for i:= 1 to n do with molecules[i] do
    begin {move; reflect;} draw; end;
  end;
end;


{******************** Collisions ***********}
Procedure TForm1.Collisions;
{Check for collisions between molecules }

          {local routines to help calculate new velocities}
          {**************** alpha *************}
          Function alfa(i,j : integer) : extended;
          {Compute the angle between the line combining molecule i
           and molecule j and the x-axis }
          var
            xi,yi,xj,yj  : extended;
          begin
            xi:=molecules[i].x; yi:=molecules[i].y;
            xj:=molecules[j].x; yj:=molecules[j].y;

            if abs(xi-xj)<0.0000001  { Avoid a zero denominator }
            then  alfa:=pi/2
            else  alfa:=arctan((yi-yj)/(xi-xj));
          end;

          {*************** Transform *************}
          Procedure Transform(x,y,alfa  : extended;
          { Transforms coordinates to a system at angle alpha with the x-axis }
                              var x1,y1 : extended);
          begin
            x1:= x*cos(alfa)+y*sin(alfa);
            y1:=-x*sin(alfa)+y*cos(alfa);
          end;

          {***************** Dist ****************}
          Function Dist(i,j : integer) : extended;
          {Distance between molecule i and molecule j one timestep in the future,
            prevents drawing artifacts when molecules are allowed to overlap}
          var  xi,yi,xj,yj  : Extended;
          begin
            with molecules[i] do
            begin xi:=x+vx*dt; yi:=y+vy*dt; end;
            with molecules[j] do
            begin xj:=x+vx*dt; yj:=y+vy*dt; end;
            Dist:=sqrt(sqr(xi-xj)+sqr(yi-yj));
          end;


var
     i,j, count           : integer;
     alfa1,g,mi,mj,ri,rj,
     uxinew,uxjnew,uyinew,uyjnew,
     uxi,uyi,uxj,uyj   : extended;
begin  {collisions}
  i:=1;
  repeat
    j:=i+1;
    repeat
      { We use a coordinate system S' with x-axis parallell to the line
        connecting the centers of the two molecules in collision. }
      ri:=molecules[i].r; rj:=molecules[j].r;
      if Dist(i,j)<=ri+rj then
      begin
        mi:=molecules[i].m; mj:=molecules[j].m;
        alfa1:=alfa(i,j);
        g:=mi/mj;
        {Transform velocities to S', u's are coordinates in S'  }
        Transform(molecules[i].vx,molecules[i].vy,alfa1,uxi,uyi);
        Transform(molecules[j].vx,molecules[j].vy,alfa1,uxj,uyj);

        uxinew:=((g-1)*uxi+2*uxj)/(1+g);{Compute velocities after collision in S'}
        uxjnew:=((1-g)*uxj+2*g*uxi)/(1+g);
        uyinew:=uyi;
        uyjnew:=uyj;

        {Now transform back to the original system }
        Transform(uxinew,uyinew,-alfa1,molecules[i].vx,molecules[i].vy);
        Transform(uxjnew,uyjnew,-alfa1,molecules[j].vx,molecules[j].vy);

        {Move molecules apart to avoid them sticking to each other}
        if Dist(i,j)<=ri+rj then
        begin
          count:=0;{prevent infinite loop if two stationary molecules get close}
          while (count<10) and (Dist(i,j)<=ri+rj) do
          begin
            molecules[i].Move;
            molecules[j].Move;
            inc(count);
          end;
        end;
      end;
      inc(j);
    until j>n;
    inc(i);
  until i>n-1;
end;

{****************  main *************}
procedure Tform1.main;
var
  nextstop, stopcount, timecountincrement : int64;
var i  : integer;
begin
  image1.Canvas.Brush.Color :=BGC;
  image1.Canvas.Pen.Color:=BGC;
  image1.Canvas.Rectangle(0,0,w,H);
  timecountincrement:=freq div 10000; {delay up to 0.1 ms per molecule move step}
  stop:=false;
  repeat
    i:=1;                { Main loop }
    queryperformancecounter(nextstop);
    repeat
      molecules[i].move;
      molecules[i].reflect;
      Collisions;
      repeat
        queryperformancecounter(stopcount);
      until stopcount>nextstop;
      nextstop:=nextstop+timecountincrement;
      inc(i);
    until i>n;
    application.processMessages;
  until stop;
end;

{************** Close1click ***********}
procedure TForm1.Close1Click(Sender: TObject);
begin
  stop:=true;
  Close;
end;

{************** Start1Click ***********}
procedure TForm1.Start1Click(Sender: TObject);
begin
  main;
end;

{*************** StopClick ************}
procedure TForm1.Stop1Click(Sender: TObject);
begin
  stop:=true;
end;



{*************** SetupClick ***********}
procedure TForm1.SetupClick(Sender: TObject);
{a setup menu item was clicked - tag says which one}
begin
  setup(TmenuItem(sender).tag);
  {main;}
end;

{***************** FormCloseQuery ***************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{Let the user exit even if running}
begin
  stop:=true;
  canclose:=true;
end;

{************ Image1Click ************}
procedure TForm1.Image1Click(Sender: TObject);
{Show/Hide  molecules on alternate clicks for Brownian demo setup}
var   i:integer;
begin
  if setupnbr=3 then
  for i:=2 to n do
  with molecules[i] do
    if col=bgc then col:=rgb(random(256), random(256), random(256))
    else col:=bgc;
end;

end.
