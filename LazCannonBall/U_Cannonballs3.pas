unit U_Cannonballs3;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Spin, ExtCtrls, shellAPI, Grids , U_Stats;

type
  float=extended;
  
  TMainForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ElevationEdt: TSpinEdit;
    PowerBar: TTrackBar;
    Button1: TButton;
    ReloadBtn: TButton;
    TrackBar1: TTrackBar;
    Image1: TImage;
    ViewStatsBtn: TButton;
    StaticText1: TStaticText;
    Label3: TLabel;
    Label4: TLabel;
    Gravitybar: TTrackBar;
    Label6: TLabel;
    BLengthBar: TTrackBar;
    PowderLbl: TLabel;
    Distlbl: TLabel;
    GLbl: TLabel;
    BarLenLbl: TLabel;
    SymBox: TCheckBox;
    StatsType: TRadioGroup;
    procedure FormActivate(Sender: TObject);
    procedure ElevationEdtChange(Sender: TObject);
    procedure FirebtnClick(Sender: TObject);
    procedure ReloadBtnClick(Sender: TObject);
    procedure PowerBarChange(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure ViewStatsBtnClick(Sender: TObject);
    procedure BLengthBarChange(Sender: TObject);
    procedure GravitybarChange(Sender: TObject);
    procedure SymBoxClick(Sender: TObject);
    procedure StatsTypeClick(Sender: TObject);
  public
    { Public declarations }
    p1,p2,p3,p4:TPoint;
    origin:TPoint;  {center of rotation of cannon}
    firstpos :TPoint; {top left of cannonball}
    theta:float; {current elevation in radians}
    prevpoint:TPoint;  {previous location of ball while moving}
    barrelLength:integer;
    groundlevel:integer;
    v1:float; {initial velocity}
    g:float;  {gravity}
    ballleft,balltop,ballsize,ballradius:integer;
    targetrect:Trect;
    targetwidth,targetheight:integer;
    procedure UpdateImage;
    Procedure Drawcannon(const origin:TPoint;
                         const angle:float; const bore:integer);
   function hittarget(var msg:string):boolean;
   procedure TheroreticalCalc;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}
Uses math;

function distance(p1,p2:TPoint):float;
begin
  result:=sqrt(sqr(p1.x-p2.x)+sqr(p1.y-p2.y));
end;


{************** FormActivate *********8}
procedure TMainForm.FormActivate(Sender: TObject);
{startup stuff}
begin
  doublebuffered:=true;
  {initialize target values}
  with targetrect do
  begin
    targetwidth:=20;
    targetheight:=65;
    left:=627;
    top:=272;
    right:=left+targetwidth;
    bottom:=top+targetheight;
  end;
  {initialize cannonball and cannon}
  ballleft:=27;
  balltop:=295;
  ballsize:=25;
  {set origin for cannon}
  origin.x:=ballleft+ballsize div 2 {-image1.left};
  origin.y:=balltop+ballsize div 2 {-image1.top};
  firstpos.x:=ballleft; {cannon ball "home"}
  firstpos.y:=balltop;
  ballradius:=ballsize div 2;
  barrelLength:=BLengthBar.position; {3*(ballsize+4);}
  theta:=DegToRad(elevationEdt.value);
  drawcannon(origin,-theta,ballsize);
  groundlevel:=p1.y;
  with image1.picture.bitmap do
  begin
    width:=image1.width;
    height:=image1.height;
  end;
  powerbarchange(sender);
  gravityBarChange(sender);
  BLengthBarChange(sender);
  UpdateImage;
  with Stats.stringgrid1 do
  begin
    colwidths[0]:=100;
    cells[0,0]:='Status';
    cells[1,0]:='Total Time';
    cells[2,0]:='Flight Time';
    cells[3,0]:='V';
    cells[4,0]:='Vx';
    cells[5,0]:='Vy';
    cells[6,0]:='Dx';
    cells[7,0]:='Dy';
    cells[8,0]:='H.Dist';
    cells[9,0]:='Altitude';
  end;
end;

{*************** FireBtnClick **********}
procedure TMainForm.FireBtnClick(Sender: TObject);
{user pressed fire button}
var
  v2,vAv:Float;  {velocities}
  a,vx,vy,vy1,vy2,x,y,nexty:float;
  temp:float;
  stopped:boolean;
  msg:string;
  Barrellength:float;
  barreltop:TPoint;
  firstout:boolean;
  dx,dy:float;  {distances}
  SinTheta, CosTheta, TanTheta:float;  {pre calculate to save a little time}
  time1,time2:float;
  TimeInc:float; {time increment per loop}
  Sleeptime:integer;
  flightstart:TPoint;
  InBarrel: boolean;

    {----------------  InBarrel -------------}
    function isInBarrel:boolean;
    {check if the next move would still be in the barrel}
    var
      ballcenter:TPoint;
    begin
      result:=false;
      if not inbarrel then exit;
      if barrellength<ballradius
      then result:=false {return false for very short barrel length}
      else {handle longer barrel lengths}
      begin
        ballcenter:=Point(ballleft+ballradius,balltop+ballradius);
        {We will say the we are still in the barrel if the center of the ball
         is less than barrel length from where it started}
        result:=(distance(firstpos,ballcenter) < barrellength);
        inbarrel:=result;  {we'll set a flag and test it at the  top of the
                            routine so that once we are out, we will not
                            reutrn that we are in (even is the ball is
                            falling back clise to its starting point}
      end;
    end;



  {--------- WriteStats -----------}
  procedure writestats(msg:string);
  {Show shot statistics}
  begin
    with Stats.stringgrid1 do
    begin
      rowcount:=rowcount+1;
      If rowcount=2 then fixedrows:=1;
      row:=rowcount-1;
      cells[0,row]:=msg;
      cells[1,row]:=format('%6.1f',[time1+time2]);
      cells[2,row]:=format('%6.1f',[time2]);
      cells[3,row]:=format('%6.1f',[vAv]);
      cells[4,row]:=format('%6.1f',[vx]);
      cells[5,row]:=format('%6.1f',[vy]);
      cells[6,row]:=format('%6.1f',[Dx]);
      cells[7,row]:=format('%6.1f',[Dy]);
      cells[8,row]:=format('%3d',[ballleft-firstpos.x]);
      cells[9,row]:=format('%3d',[firstpos.y-balltop]);
    end;
  end;



Begin {firebtnclick}
  {precalculate trig function to save a little time in the fireing loop}
  sinTheta:=sin(theta);
  costheta:=cos(theta);
  //if theta>0 then TanTheta:=tan(theta)else TanTheta:=1000;
  reloadbtnclick(sender); {reset the cannonball}
  {set initial velocities}
  Barrellength:=distance(p1,p4);
  barreltop.y:=origin.y-round(barrellength*sintheta);
  barreltop.x:=origin.x+round(barrellength*costheta);
  flightstart:=point(0,0);
  tag:=0;
  x:=ballleft;
  y:=balltop;
  g:=gravitybar.position/100;
  a:=-g*sin(theta);
  v1:=powerbar.position;  {assume initial velocity up the barrel = 1/2 powder charge}
  time1:=0;
  time2:=0;
  timeinc:=0.5;
  {initialize vx & vy for 1st Inbarrel function call}
  Vx:= v1*costheta;
  vy:=v1*sintheta; {negative=moving up since y coordinate increases downwards}
  VAv:=v1;
  dx:=Vx*timeinc;
  dy:=Vy*timeinc;

  sleeptime:=1;
  firstout:=true;
  stopped:=false;
  stats.stringgrid1.rowcount:=1;
  distlbl.caption:='X distance: Flight 0.0  Total 0.0';
  theroreticalCalc;  {display theoretical results}
  inBarrel:=true;
  Viewstatsbtn.enabled:=false;
  repeat
    if statstype.itemindex=1 then writestats('       Time step');

    if IsInBarrel then
    begin
      {
       We'll assume that the cannonball inside the barrel is "rolling up a ramp"
       with the component of gravity acting parallel to the barrel being the
       force acting to reduce the velocity of the cannonball in both x and y directions
      }
      time1:=time1+timeinc;
      v2:=v1+a*timeinc;
      vAv:=(v1+v2)/2;
      vx:=vAv*costheta;
      vy:=vAv*sintheta;
      dx:=vx*timeinc;
      dy:=vy*timeinc;
      x:=x+dx;
      y:=y-dy;
      ballleft:=round(x);
      balltop:=round(y);

      if (v2<=0) and ((ballleft<firstpos.x) or (balltop>firstpos.y)) then
      begin
        stopped:=true;
        ballleft:=firstpos.x;
        balltop:=firstpos.y;
      end;
      sleep(SleepTime);
      v1:=v2;
    end
    else
    {cannonball has left the barrel}
    begin
      time2:=time2+timeinc;
      if firstout then
      begin {initialize for out of barrel}
        {now ball follows projectile motion rules}
        writestats('Left barrel');
        firstout:=false;
        flightstart:=Point(ballleft,balltop);
        {out of the barrel, all of gravity is now acting on the y coordinate}
        a:=-gravitybar.position/100;
        vy1:=vy; {velocity change is now only the vertical coordinate}
      end;
      distlbl.caption:=format('X distance: Flight %6.1f  Total %6.1f',
                              [x-flightstart.x,x-firstpos.x]);

      temp:=vy1+a*timeinc;
      if (vy1>=0) and (temp<=0) then writestats('Top of flight');
      vy2:= temp;
      vy:=(vy1+vy2)/2;

      dy:=vy*timeinc;
      nexty:=y-dy;

      If vy2<=0 then {moving down}
      begin
        if (y<=barreltop.y) and (nexty>=barreltop.y) then writestats('Passing barrel top');
        if (nexty>groundlevel-ballsize)
        then
        begin {next move goes below the floor}
          balltop:=groundlevel-ballsize;
          stopped:=true;
          writestats('Landed ');
        end
        else
        begin
          y:=nexty;
          balltop:=round(y); {balltop-trunc(dy)}
        end;
      end
      else {moving up}
      begin
        if (nexty<0) then
        begin  {next move will go through ceiling}
          dy:=0;  {bounce it off of the ceiling}
          vy2:=-vy1;
          if gravitybar.position=0 then stopped:=true;
        end
        else
        begin
          y:=nexty;
          balltop:=round(y);
        end;
      end;
      {move x (across) direction}
      if x+dx>image1.width then
      begin
        ballleft:=image1.width-ballsize;
        balltop:=groundlevel-ballsize;;
        stopped:=true;
      end
      else
      begin
        x:=x+dx;
        ballleft:=round(x);
      end;
      sleep(sleeptime); {delay a little for visual effect}
      vy1:=vy2;
      If hittarget(msg) then
      Begin
        showmessage(msg);
        writestats('Hit target');
        stopped:=true;
      end;
    end;
    UpdateImage;
    application.processmessages;  {in case the user hit reload button}
    if tag<>0 then stopped:=true;
  until stopped;
  Viewstatsbtn.enabled:=true;
end;



{************* TheoreticalCalc **********}
procedure TMainForm.TheroreticalCalc;
var
  root,T1, Vf:float;
  Vxf, Vyf:float;
  X1,Y1:float;
  TTop, Xtop,Ytop:float;
  Tlast, VyLast, Xlast:float;
  floor:float;
begin
  with stats.memo1.lines do
  begin
    clear;
    add(format('Barrel Len %d, Angle %6.1f, Initial V %6.1f, gravity %6.1f',
                [barrellength,180*theta/pi,v1,g]));
    if g=0 then g:=0.001;            
    root:= v1*v1 - 2*g*sin(theta)*Barrellength;
    if root>=0 then
    begin
      T1:=(v1 - sqrt(root))/(g*sin(theta+0.001));
      Vf:= v1 - g*sin(theta)*T1;
      Vxf:=Vf*cos(theta);
      Vyf:=Vf*sin(theta);
      X1:=Barrellength*cos(theta);
      Y1:=Barrellength*sin(Theta);
      floor:=(origin.y+ballradius)-groundlevel;
      {out of barrel, Vx remains constant, Vy := Vyf- g*DeltaT}
      {Vy=0 then Vyf-g*Ttop=0 or Ttop=Vyf/g}
      Ttop:=Vyf/g;
      {x distance at top} Xtop:=Vxf*Ttop;
      {height at top = average y velocity+ time}   Ytop:=(Vyf + 0)/2*TTop;
      {Time to fall from ytop to groundlevel, descending part of projectiles path}
      //Vylast:=2*g*(Ytop+Y1-floor); {speed when ball hits ground}
      TLast:=sqrt(2*(Y1+YTop-floor)/g );
      Xlast:=Vxf*TLast;
      add(format('Time in barrel %6.1f seconds',[T1]));
      add(format('X distance at end of barrel %6.1f',[X1]));
      add(format('Y distance at end of barrel %6.1f',[Y1]));
      add(format('Time to top of freeflight arc %6.1f, %6.1f total',[Ttop,T1+Ttop]));
      add(format('X distance to top of freeflight arc %6.1f, %6.1f total',[Xtop,X1+Xtop]));
      add(format('Height above barrel to top of freeflight arc %6.1f, %6.1f total',[Ytop,Y1+Ytop]));
      add(format('Time to reach ground from max height %6.1f, %6.1f total',[TLast,T1+Ttop+TLast]));
      add(format('X distance from top of freeflight arc to end %6.1f, %6.1f total',[XLast,X1+Xtop+XLast]));
    end
    else add('Velocity too low, cannonball does not exit barrel');
  end;
end;


{************** DrawCannon *************}
procedure TMainForm.drawCannon(const origin:TPoint;
                         const angle:float;
                         const bore:integer);

   procedure rotate(var p:Tpoint; a:float);
   {rotate a point to angle a from horizontal}
   var
     t:TPoint;
   begin
     t:=P;
     p.x:=trunc(t.x*cos(a)-t.y*sin(a));
     p.y:=trunc(t.x*sin(a)+t.y*cos(a));
   end;

   procedure translate(var p:TPoint; t:TPoint);
   {translate a point by t.x and t.y}
   Begin
     p.x:=p.x+t.x;
     p.y:=p.y+t.y;
   end;

var
  a:float;
  w:integer;
begin
  a:=angle;
  w:=bore div 2;
  {get the corners of a cannon centered at (0,0) and at 0 deg angle}
  {then rotate each corner to desired angle and move cannon to origin }
  p1:=point(-w,w);    rotate(p1,a); translate(p1,origin);
  p2:=point(-w,-w);   rotate(p2,a); translate(p2,origin);
  p3:=point(barrelLength,-w);  rotate(p3,a); translate(p3,origin);
  p4:=point(barrelLength,+w);  rotate(p4,a); translate(p4,origin);
  UpdateImage;
end;



{************* UpdateImage ***********}
procedure TMainForm.UpdateImage;
{redraw cannon, cannonball and background}
var
  barrelcenterX,barrelcenterY:integer;
begin
  with  image1, Canvas do
  begin
    brush.color:=clblue;
    fillrect(cliprect);
    {redraw the cannon barrel}
    pen.width:=2;
    pen.color:=clblack;
    polyline([p1,p2,p3,p4,p1,p2]);
    brush.color:=clgray;
    barrelcenterx:=(p1.x+p3.x) div 2;
    barrelcenterY:=(p1.y+p3.y) div 2;
    floodfill(barrelcenterX, barrelcenterY, clblack,fsborder);

    {redraw the ground level line}
    moveto(0,groundlevel);
    lineto(width,groundlevel);

    {color the ground}
    brush.color:=clgreen;
    floodfill(100,height-1,clblack,fsborder);

    {color the sky}
    brush.color:=clblue;
    floodfill(100,1,clblack,fsborder);

    {draw the cannonball}
    brush.color:=clmaroon;
    ellipse(ballleft,balltop,ballleft+ballsize,balltop+ballsize);

    {redraw the target}
     brush.color:=clred;
     rectangle(targetrect);

     update;
  end;
end;

{**************** ElevationEdtChange **********}
procedure TMainForm.ElevationEdtChange(Sender: TObject);
{User changed the angle, set new angle and redraw cannon }
begin
   theta:=DegToRad(elevationEdt.value);
   drawcannon(origin,-theta,ballsize);
   SymboxClick(sender);
end;


{*************** HitTarget ************}
function TMainForm.hittarget(var msg:string):boolean;
{Detect cases where overlaps or cannonball passes through target between samples}
{Also uses IntersectRect API function to detect intersections}
var
  //px,py,x,y:integer; {work fields}
  //m,b:float;
  Outrect:Trect;
begin
  result:=false;
  //with shape1 do
  begin
    if (ballleft+ballsize >= targetrect.left) then
    begin {could be there}
      if ballleft>targetrect.right then
      {we're past it, check if we passed right through since last sample}
      begin
        (*
        px:=prevpoint.x+ballsize;
        py:=prevpoint.y+ballsize;
        x:=ballleft+ballsize;
        y:=balltop+ballsize;
        m:=(y-py)/(x-px);  {slope of flight angle}
        b:=y-m*x;
        {does this line intersect the target rectangle?}
        {is the top right corner of the target line above the line?}
        *)
      end
      else
      begin {we could be there}
        if intersectrect(outRect,
                      rect(ballleft,balltop,ballleft+ballsize,balltop+ballsize),
                      targetrect)
        then
        begin
          {probable hit, but we have 2 special conditions to check}
          {1. top right corner of intersection rectangle is top right corner of target}
          {   means we just missed it, cll it a near miss}
          if (outrect.right=targetrect.right) and (outrect.top=targetrect.top)
          then
          begin
             msg:='Caught the top!';
             ballleft:=targetrect.right;
             balltop:=groundlevel-ballsize;
          end
          else
          begin
            {2. bottom left corner of intersection rectangle is top left corner of
            target}
            { it will hit, but move the ball so visually it looks like it already
              hit the target}
            if (outrect.left=targetrect.left) and (outrect.top=targetrect.top) then
            begin
              {now move ball so it touches the target}
              msg:='Left top hit!';
              ballleft:=targetrect.left-ballsize;
              balltop:=groundlevel-ballsize;
            end
            else
            begin
              ballleft:=targetrect.left-ballsize;
              balltop:=groundlevel-ballsize;
            end;
            msg:='Good shot!';
          end;
          result:=true;
          updateimage;
        end;
      end;
    end;
    prevpoint:=point(ballleft,balltop);
  end;
end;





{************** ReloadBtnClick ************}
procedure TMainForm.ReloadBtnClick(Sender: TObject);
{move cannonball back to cannon}
begin
  tag:=1;
  application.processmessages;
  ballleft:=firstpos.x;
  balltop:=firstpos.y;
  UpdateImage;
end;




procedure TMainForm.PowerBarChange(Sender: TObject);
begin
  powderlbl.caption:=inttostr(powerbar.position);
end;

procedure TMainForm.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


procedure TMainForm.SymBoxClick(Sender: TObject);
begin
  with image1,canvas do
  begin
    {redraw the ground level}
    If symbox.checked
    then groundlevel:=origin.y-trunc(barrellength*sin(theta))+ballradius
    else groundlevel:=origin.y+ballradius;
    targetrect.top:=groundlevel-(targetheight);
    targetrect.bottom:=groundlevel;
    if (ballleft<>origin.x-ballradius) or (balltop<>origin.y-ballradius) then balltop:=groundlevel-ballsize;
    UpdateImage;
  end;
end;



procedure TMainForm.TrackBar1Change(Sender: TObject);
begin
  targetrect.left:=trackbar1.position-10;
  targetrect.right:=targetrect.left+targetwidth;
  UpdateImage;
end;

{************* ViewStatsBtnClick **********}
procedure TMainForm.ViewStatsBtnClick(Sender: TObject);
begin
  stats.ShowModal;
end;

procedure TMainForm.BLengthBarChange(Sender: TObject);
begin
   barrellength:=BLengthbar.position;
   drawcannon(origin,-theta,ballsize);
   BarlenLbl.caption:=inttostr(BlengthBar.position);
   symboxclick(sender);
end;

procedure TMainForm.GravitybarChange(Sender: TObject);
begin
  GLbl.caption:=inttostr(Gravitybar.position);
end;

procedure TMainForm.StatsTypeClick(Sender: TObject);
begin
  viewstatsbtn.enabled:=false;
end;

end.

