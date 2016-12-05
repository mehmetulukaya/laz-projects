unit U_Catapult;

{$MODE Delphi}

 {Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Catapult simulator }

{ TODO : Add pivot bearing friction.
          (Torque=Radialforce * coefficient * pivot diameter/2) }
{ TODO : Add second driving force }
{ TODO : Add additional beam shapes for Moment Inertia calulation }



interface

uses          
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, URungeKutta4, ExtCtrls, ComCtrls, Spin, NumEdit2,
  inifiles, Buttons;

type
  TPositionrec=record
    time,xpos,xvel,ypos,yvel:float;
  end;
  TTriggerrec=record
    time,Theta,Omega,xpos,xvel,ypos,yvel,
    alpha, xspring2, yspring2, springlength, springangle, forceangle:float;
  end;

  TRealPoint=record
    x,y:float;
  end;

  TCatapultreal=record
    p:array[0..8] of trealpoint;
    {pivot,p1,p2,p3,bp1,bp2, springend1, springend2}
  end;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    SetUpSheet: TTabSheet;
    Image1: TImage;
    Button1: TButton;
    Test1InfoMemo: TMemo;
    Memo1: TMemo;
    Label7: TLabel;
    Image2: TImage;
    Button2: TButton;
    Label19: TLabel;
    Memo2: TMemo;
    ResetBtn: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Label26: TLabel;
    Label27: TLabel;
    SaveBtn: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label14: TLabel;
    Label23: TLabel;
    Maxsecs: TSpinEdit;
    ReturnSPS: TSpinEdit;
    CalcSPRet: TSpinEdit;
    Maxsecs2: TSpinEdit;
    ReturnSPS2: TSpinEdit;
    CalcSPRet2: TSpinEdit;
    UnitsGrp: TRadioGroup;
    FireBtn: TButton;
    LoadBtn: TButton;
    Memo4: TMemo;
    Button3: TButton;
    PageControl2: TPageControl;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Edit14: TEdit;
    GroupBox4: TGroupBox;
    Label12: TLabel;
    Label25: TLabel;
    Edit12: TEdit;
    Panel1: TPanel;
    GroupBox6: TGroupBox;
    Label29: TLabel;
    GroupBox7: TGroupBox;
    GroupBox5: TGroupBox;
    Label18: TLabel;
    Label24: TLabel;
    Edit5: TEdit;
    Edit15: TEdit;
    Label17: TLabel;
    Label13: TLabel;
    Label1: TLabel;
    Label10: TLabel;
    Label28: TLabel;
    Label9: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Label21: TLabel;
    Label20: TLabel;
    Edit1: TEdit;
    Edit6: TEdit;
    Edit16: TEdit;
    Edit9: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit4: TEdit;
    Edit3: TEdit;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label22: TLabel;
    Label11: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Edit2: TEdit;
    Edit10: TEdit;
    RotateRBtn: TRadioButton;
    Edit13: TEdit;
    Edit11: TEdit;
    SpringrBtn: TRadioButton;
    Panel2: TPanel;
    CatNameLbl: TLabel;
    Label31: TLabel;
    TrackBar1: TTrackBar;
    Label30: TLabel;
    StaticText1: TStaticText;
    Label32: TLabel;
    SaveResultsBtn: TButton;
    Label33: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FireBtnClick(Sender: TObject);
    procedure ParamChanged(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure UnitsGrpClick(Sender: TObject);
    procedure SetupEnter(Sender: TObject);
    procedure Label31Click(Sender: TObject);
    procedure SaveResultsBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  public
    {common values}
     StartTime, StopTime : Float; { Limits over which to approximate X  }
     ReturnInterval:Float;
     CalcInterval:Float;
     Error : byte; { Return flag from Rutte-kunga }
     positions:array of TTriggerrec;
     positions2:array of  TPositionrec;
     ValCount, valcount2:integer;
     Theta0Edt, FEdt, GravityEdt, MassEdt, FAngleEdt,ThetaEndEdt:TFloatEdit;
     DFEdt, DMEdt, LEdt, MBEdt, DragEdt :TFloatEdit;
     XSpring1Edt, YSpring1edt, KEdt, PivotheightEdt :TFloatEdit;

     {Cartapult definition inputs}
     Theta0, ThetaEnd:Float;
     F:float;
     Gravity:float;
     Mass:float;
     FAngle,Sangle {, xspring2, yspring2}:float;
     DF:Float; {Distance from pivot to force point}
     DM:Float; {Distance from pivot to Mass end}
     L:Float;  {Total length of beam}
     MB:FLoat; {Mass of beam}
     Drag:Float;  {Drag coeffiecient}
     Xspring1, YSpring1:float; {coordinates of fixed end of spring}
     K:Float; {Spring constant}
     PivotHeight: float;
     Inertia:Float;  {Moment of Inertia;}
     InitialAngle, InitialDeriv:float;
     TestFuncs:TFuncVect;
     Initialvalues:TnVector;
     NUmEquations:integer;
     scale:float;  {current scaling factor for cat diagram}
     catrect:Trect;
     ballsize:integer; {radius of projectile in pixels}
     wideline, medline:integer;

     catapultrec:TCatapultreal; {coordinates relative to pivot of cat points in units }
     catname:string; {name of cat file lasat loaded or saved}
     ininame:string; {name of ini file with last cat file loaded or saved}
     FirecatImagerect:Trect;  {Rectangle for redrawing catapult image on fir page}
     modified:boolean; {set true to indicate catapult definiton has changed since loading}
     changing:boolean;  {Flag to prevent updating while unit system is  changing}
     flightdist, flightheight,flighttime:single;

     {Units}
     LName, Mname, FName:string; {unit names}
     CurrentUnits:integer; {index of current units system}
     ConvL, ConvM, ConvF:Float; {Conversion factors to get user values to interna;l & back}
     procedure SetupValues;  {copy values from edit fields}
     procedure DrawResults;

     Function FireFunc1(v:TNVector):Float; {Calc next omega'' for fire phase}
     Function FlightFunc1(v:TNVector):Float; {Calc next x'' for flight pahse}
     Function FlightFunc2(v:TNVector):Float; {Calc next Y'' for flight phase}

     Function FireCallBackFunc(v:TNVector):boolean;{Svae values for time v[0].x}
     Function FlightCallBackFunc
                      (v:TNVector):boolean;{Save values for time v[0].x}
     procedure DrawCat1(Image:TImage;newcatrect:TRect); {pass 0 to bypass scale calc & use previous}
     procedure savecat;
     procedure loadcat(newname:string);
     procedure savecatname;
     procedure getspringValues(const angle:float; var xspring2,yspring2,springlength,sangle, fangle:float);
  end;

var Form1: TForm1;

implementation

{$R *.lfm}

Uses math;

{************* FormCreate **************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  Theta0Edt:=TFloatEdit.create(self,Edit1);  edit1.free;
  FEdt:=TFloatEdit.create(self,Edit2);     edit2.free;
  GravityEdt:=TFloatEdit.create(self,Edit3);   edit3.free;
  MassEdt:=TFloatEdit.create(self,Edit4);   edit4.free;

  ThetaEndEdt:=TFloatEdit.create(self,Edit6);   edit6.free;
  DFEdt:=TFloatEdit.create(self,Edit7);   edit7.free;
  DMEdt:=TFloatEdit.create(self,Edit8);   edit8.free;
  LEdt:=TFloatEdit.create(self,Edit9); edit9.free;
  Xspring1Edt:=TFloatEdit.create(self,Edit10);   edit10.free;
  Yspring1Edt:=TFloatEdit.create(self,Edit11);   edit11.free;
  MBEdt:=TFloatEdit.create(self,Edit12);   edit12.free;
  KEdt:=TFloatEdit.create(self,Edit13);   edit13.free;
  DragEdt:=TFloatEdit.create(self,Edit14);   edit14.free;
  PivotHeightEdt:=TFloatEdit.create(self,Edit16);   edit16.free;
  opendialog1.initialdir:=extractfilepath(application.exename);
  savedialog1.initialdir:=extractfilepath(application.exename);
  catname:='';
  pagecontrol1.activepage:=SetupSheet;
end;

{************ ParamChanged ***********}
procedure TForm1.ParamChanged(Sender: TObject);
begin
  if changing then exit;  {units are being converted - do not process change now}
  setupvalues;
  valcount:=0;
  valcount2:=0;
  Drawcat1(image2, image2.clientrect); {recalc scale & draw diagram}
  modified:=true;

end;

{**************** DrawCat1 ***************}
Procedure TForm1.drawcat1(Image:TImage; newcatrect:TRect);
{Geometry of catapult changed - redraw the diagram}
var
  xc,yc:integer;
  p1,p2,p3, pivot:TPoint; {Base (pivot)}
  bp1,bp2:TPoint; {Beam ends}
  stp:TPoint;  {Stopper}
  Sp1,sp2:TPoint; {spring ends}
  scale2:float;
  catwidth,catheight:integer;
  currenttheta:float;
  L1,l2,sign:integer;


      procedure drawspring(p1,p2:TPoint; coils:integer);
      var
        i:integer;
        d,sina,cosa,theta, dcoils:single;
        dxup,dyup,dxdown,dydown,x,y:single;
      begin
        with image, canvas do
        begin
           d:=sqrt(sqr(p1.x-p2.x)+sqr(p1.y-p2.y));
          if d<>0 then
          begin
            sina:=(p1.y-p2.y)/d;
            cosa:=(p1.x-p2.x)/d;
            //theta:=arcsin(sina);
            theta:=arctan2(p1.y-p2.y,p1.x-p2.x);
            dcoils:=d/coils;
            x:=p2.x+trunc(dcoils*cosa);
            y:=p2.y+trunc(dcoils*sina);
            moveto(p2.x,p2.y);
            lineto(trunc(x),trunc(y));
            dxup:=(dcoils*cos(theta+pi/4));
            dyup:=(dcoils*sin(theta+pi/4));
            dxdown:=(dcoils*cos(theta-pi/4));
            dydown:=(dcoils*sin(theta-pi/4));
            for i:= 1 to coils div 2  do
            begin
              x:=x+dxup; y:=y+dyup;
              lineto(trunc(x),trunc(y));
              x:=x+dxdown; y:=y+dydown;
              lineto(trunc(x),trunc(y));
            end;
            x:=x+dxup /2; y:=y+dyup / 2;
            lineto(trunc(x),trunc(y));
            lineto(p1.x,p1.y);
          end;
        end;  
      end;

      function setcatrect(pts:array of tpoint):Trect;
      {set pixel size of cat image based on range of passed points}
      var i:integer;
      begin
        result:=rect(pts[0].x,pts[0].y,pts[0].x,pts[0].y);
        for i:=1 to high(pts) do
        with pts[i] do
        begin
          if x<result.left then result.left:=x;
          if x>result.right then result.right:=x;
          if y < result.top then result.top:=y;
          if y > result.bottom then result.bottom:=y;
        end;
      end;

begin  {drawcat1}
  currenttheta:=positions[valcount].theta;
  catrect:=newcatrect;

  with catapultrec do {recalc coordinates which depend on beam angle}
  begin
    p[4].x:=-DM*cos(CurrentTheta);  p[4].y:=(DM)*sin(Currenttheta);
    p[5].x:=(L-DM)*cos(CurrentTheta);  p[5].y:=-(L-DM)*sin(currenttheta);
    p[7].x:=DF*cos(currenttheta); p[7].y:=-DF*sin(currenttheta);
  end;
  catwidth:=catrect.right-catrect.left{newcatwidth};
  catheight:=catrect.bottom-catrect.top {newcatheight};
  scale:=0.75*catwidth/L;  {make length of beam = 3/4 of width}
  scale2:=0.375*catwidth/dm;  {or pivot to mass = 3/8 of width}
  if scale2<scale then scale:=scale2; {pick smaller scale}
  scale2:=catheight/(dm*sin(thetaend)-catapultrec.p[1].y); {or height to end beam position}
  if scale2<scale then scale:=scale2; {pick smaller scale}
  with catapultrec do
  if p[6].y>p[1].y then
  begin
    scale2:=catheight/(catapultrec.p[6].y-catapultrec.p[1].y); {or height to spring end}
    if scale2<scale then scale:=scale2; {pick smaller scale}
  end;
  IF SCALE<0.1 THEN SCALE:=0.1;

  if catwidth>100 then
  begin
    wideline:=6;
    medline:=3;
  end
  else
  begin
    wideline:=2;
    medline:=1;
  end;
  with image, canvas do
  begin
    brush.color:=clwindow;
    fillrect(clientrect);
    {debugging}
    //brush.color:=clgray;
    //pen.color:=clblack;
    //rectangle(catrect {clientrect});
    //update;
    {calc pivot points}
    xc:=catwidth div 2;
    yc:=height+trunc(catapultrec.p[1].y*scale);{pivot loc above image bottom}

    with catapultrec do
    begin
      pivot.x:=xc+trunc(p[0].x*scale); pivot.y:=yc-trunc(p[0].y*scale);
      p1.x:=xc+trunc(p[1].x*scale);  p1.y:= yc-trunc(p[1].y*scale);
      p2.x:=xc+trunc(p[2].x*scale);  p2.y:= yc-trunc(p[2].y*scale);
      p3.x:=xc+trunc(p[3].x*scale);  p3.y:= yc-trunc(p[3].y*scale);
      bp1.x:=xc+trunc(p[4].x*scale);  bp1.y:=yc-trunc(p[4].y*scale);
      bp2.x:=xc+trunc(p[5].x*scale);  bp2.y:=yc-trunc(p[5].y*scale);
      sp1.x:=xc+trunc(p[6].x*scale);  sp1.y:=yc-trunc(p[6].y*scale);
      sp2.x:=xc+trunc(p[7].x*scale);  sp2.y:=yc-trunc(p[7].y*scale);
      stp.x:=xc+trunc(p[8].x*scale); stp.y:=yc-trunc(p[8].y*scale);
     end;

    {Draw beam}
    pen.width:=wideline;
    pen.color:=clblue;
    moveto(bp1.x, bp1.y); lineto(bp2.x, bp2.y);
    {finish drawing pivot base (so it is in front of beam}
    brush.color:=clred;
    pen.width:=medline;
    pen.color:=clblack;
    polygon([p1,p2,p3]);
    pen.width:=1; brush.color:=clblack; {draw axle}
    ellipse(pivot.x-medline, pivot.y-medline,pivot.x+medline, pivot.y+medline);

    {draw projectile}
    brush.color:=clgreen;pen.color:=clgreen;  pen.width:=1;
    ballsize:=3*wideline div 2;
    ellipse(bp1.x,bp1.y-ballsize div 4,bp1.x+ballsize,bp1.y-5*ballsize div 4 {wideline div 2} );
    {draw stopper}
    brush.color:=clred;pen.color:=clred;
    stp:=Point(pivot.x-trunc(3*scale*DM/4*cos(thetaend)),
               pivot.y-trunc(3*scale*DM/4*sin(thetaend)));
    rectangle(stp.x,stp.y,stp.x+8,stp.y+8);
    If springrbtn.checked then
    begin
     {draw spring}
      pen.width:=1;  pen.color:=clBlack;
      drawspring(sp1,sp2,12);
      {draw spring end support}
      pen.width:=medline;
      pen.color:=rgb(179,105,6);
      moveto(sp1.x,sp1.y-3);
      lineto(sp1.x,height);
    end
    else {draw force arrow}
    begin
       moveto(sp2.x,sp2.y);
       l1:=TRUNC((L/4)*SCALE);  {arrow shaft}
       l2:=trunc((l/8)*SCALE);   {arrow head}
       if df<0 then  {left of pivot} sign:=-1 else sign:=+1;
       lineto(sp2.x+sign*trunc(L1*cos(currenttheta-pi/2)),sp2.y+sign*trunc(L1*sin(currenttheta-pi/2)));
       moveto(sp2.x,sp2.y);
       lineto(sp2.x+sign*trunc(L2*cos(currenttheta-pi/3)),sp2.y+sign*trunc(L2*sin(currenttheta-pi/3)));
       moveto(sp2.x,sp2.y);
       lineto(sp2.x+sign*trunc(L2*cos(currenttheta-2*pi/3)),sp2.y+sign*trunc(L2*sin(currenttheta-2*pi/3)));
     end;
  end;
  if image=image2 then catrect:=setcatrect([point(0,0),point(image2.width,image2.height)]);
end;

function interpolate(d1,d2,i1,i2,t:extended):extended;  overload;
{interpolate dependent variable value}
{ given f(i1)=d1 and (f(i2)=d2, get estmate for f(t) by assuming f is a straight line}
begin
  if i1=i2 then result:=(d1+d2)/2
  else  result:=d1+ (d2-d1)*(i2-t)/(i2-i1);
end;

function interpolate(d1,d2:TDatetime; i1,i2,t:extended):TDatetime;  overload;
{interpolate time value as dependent variable}
{ given f(i1)=d1 and (f(i2)=d2, get estmate for f(t) by assuming f is a straight line}
begin
  if i1=i2 then result:=(d1+d2)/2
  else  result:=d1+ (d2-d1)*(i2-t)/(i2-i1);
end;

{************** DrawResults **********}
procedure TForm1.DrawResults;
var i:integer;
    xmax,ymax,scale2:float;
    offsetx,offsety,yc:integer;
    catx,caty:float;
    n:integer;
begin
  ymax:=0;
  catx:=(catrect.right-catrect.left)/scale; {cat image width in meters}
  caty:=(catrect.bottom-catrect.top)/scale;
  xmax:=positions2[ValCount2].xpos + catx;{allow room for cat image};
  for i:= 1 to ValCount2 do
    if positions2[i].ypos+caty>ymax then ymax:=positions2[i].ypos+caty;
  scale:=image1.width / xmax;
  scale2:=image1.height / ymax;
  If scale>scale2 then scale:=scale2;{ else scaley:=scale;  }
  with image1,canvas do
  begin
    brush.color:=clWindow;
    pen.color:=clblack;
    fillrect(image1.clientrect);
  end;  
  memo1.clear;
  n:=valcount;
  for i:= 1 to N do
  with positions[i] do
  begin
    memo1.lines.add(format('%5.2f            %6.2f         %6.2f         %6.2f     '
                     +'        (%6.2f,%6.2f)   (%6.2f,%6.2f) ',
        [time,theta/Pi*180,omega/Pi*180, alpha/Pi*180, xpos/COnvL, ypos/ConvL, xvel/ConvL, yvel/ConvL]));
    if springrbtn.checked then
    memo1.lines.add(format('   Spring -  (X,Y) (%6.2f,%6.2f), Length %6.2f,  Angle %6.2f, Force-Angle %6.2f',
            [xspring2/ConvL, yspring2/ConvL, springlength/ConvL, springangle/Pi*180, forceangle/pi*180]));
    update;
    valcount:=i;
    FireCatImageRect:= rect(0,height-trunc(caty*scale),
                         trunc(catx*scale),height);
    drawcat1(image1, firecatimagerect);
    application.processmessages;
    sleep(trunc(Trackbar1.max-trackbar1.position));
  end;
  memo1.lines.add('');
  memo1.lines.add(format( 'Projectile fired at %4.1f degrees with velocity of %6.1f %s/sec',
                [90-positions[valcount].theta/pi*180,
                 positions[valcount].omega*dm/ConvL,LName]));
  with  image1, canvas do
  begin
    memo2.clear;

    drawcat1(image1, rect(0,height-trunc(caty*scale),
                         trunc(catx*scale),height));
    offsetx:=(catrect.right-catrect.left)  div 2{+trunc(positions[valcount].xpos*scalex)};
    yc:=height+trunc(catapultrec.p[1].y*scale);

    brush.color:=clgreen;

    {Draw ground }
    moveto(0,height-pen.width div 2); lineto(width,height-pen.width div 2);

    {now do flight portion}
    pen.width:=1;
    pen.color:=clgreen;
    flightheight:=0;
    for i:= 1 to ValCount2 do
    with positions2[i] do
    begin
      {draw projectile}
      ellipse(trunc(offsetx+scale*xpos),
              yc-trunc(scale*ypos)-ballsize div 4,
              trunc(offsetx+scale*xpos)+ballsize,
              yc-trunc(scale*ypos)-5*ballsize div 4);
      //memo2.lines.add(format('%5.2f,            (%6.2f,%6.2f)               (%6.2f,%6.2f)',
      //  [time,xpos,ypos,xpos-positions2[1].xpos, ypos]));
      memo2.lines.add(format('%5.2f,       (%6.2f,%6.2f)            (%6.2f,%6.2f)',
                      [time,xpos/ConvL,ypos/ConvL,
                       (xpos-positions2[1].xpos)/ConvL, (ypos+pivotheight)/ConvL]));
      if ypos>flightheight then flightheight:=ypos;
      application.processmessages;
      sleep(trunc(trackbar1.max-trackbar1.position));
    end;
    flightdist:=interpolate(positions2[valcount2-1].xpos,positions2[valcount2].xpos,
                              positions2[valcount2-1].ypos,positions2[valcount2].ypos,
                              0)-positions2[1].xpos;
    flighttime:=interpolate(positions2[valcount2-1].time,positions2[valcount2].time,
                              positions2[valcount2-1].ypos,positions2[valcount2].ypos,
                              0);
  end;
end;

(*  Capture a picture for website}
procedure TForm1.Button1Click(Sender: TObject);
begin
  image1.picture.bitmap.pixelformat:=pf24bit;
  image1.picture.bitmap.savetofile(
      extractfilepath(application.exename)+'rungekutta_'
                     +inttostr(trunc(now*secsperday))+'.bmp');
end;
*)



{R-K functions}


procedure TForm1.getspringValues(const angle:float; var xspring2,yspring2,springlength,sangle, fangle:float);
{given the current angle of the beam, return coordinates of beam end of spring,
 its length, angle of the spring to horizontal, and and of the applied force to the beam}
begin
    {get coordinates of attach point}
    xspring2:=Df*cos(angle); {theta}
    yspring2:=-DF*sin(angle);
    {calc length of spring}
    springlength:=sqrt(sqr(xspring2-xspring1)+sqr(yspring2-yspring1));
    {calc angle of spring}
    SAngle:= Arctan2((yspring1-yspring2),(xspring1-xspring2));
    //if df<0 then springangle:=-springangle;
    FAngle:= SAngle+angle;
  end;

{************** FireFunc1 **********}
Function TForm1.FireFunc1(v:TNVector):Float;
{Next alpha , angular acceleration, called for eacc calculation point}
{calulate next angular accleration value based on current beam position
 and velocity}
var
 xspring2,yspring2,Springlength:Float;
begin
  If SpringRbtn.checked then
  begin
    GetSpringvalues(v[1].x, xspring2, yspring2, Springlength,Sangle, Fangle);
    {calculate force}
    F:=k*Springlength; {calulate new force}
  end;
  result:=-DF*F*sin(Fangle)/Inertia{ + 0.5*Dm*Dm*Gravity*cos(Fangle)};

end;


{************** FireCallBackFunc ***********}
Function TForm1.FireCallBackFunc(v:TNVector):boolean;
{Called for each returned point -
  save X & Y values for time which is in v[0].x }
var f:float;
begin
  inc(ValCount);

  if ValCount>high(positions) then setlength(positions, length(positions)+100);

  if v[1].xprime < positions[valcount-1].omega  {speed is decreasing - stop fire process}
  then
  begin
    dec(valcount);
    result:=false;
  end
  else
  if (v[1].x>thetaEnd) or  (Abs(Fangle)<0.001) then
  begin
    result:=false; {stop if Theta>thetaend }
    {interpolate to get last point}
    with positions[ValCount] do
    begin

      if v[1].x>thetaend then
      begin
        f:=(thetaend-positions[valcount-1].theta)/(v[1].x-positions[valcount-1].theta);
        time:=positions[valcount-1].time+f*1/returnsps.value;
        Theta:=thetaend{v[1].x};
        Omega:=positions[valcount-1].omega+f*(v[1].xprime-positions[valcount-1].omega);
      end
      else

      begin
        time:=v[0].x;
        theta:=v[1].x;
        Omega:=v[1].xprime;
      end;
      alpha:=omega-positions[valcount-1].omega;
      xpos:=-DM*cos(theta);
      xvel:=Dm*omega*cos(theta);
      ypos:=DM*sin(theta);
      yvel:=Dm*omega*sin(theta);
      Getspringvalues(theta, xspring2, yspring2, springlength, springangle, forceangle);
    end;
  end
  else
  begin  {save this position}
    result:=true;
    with positions[ValCount] do
    begin
      time:=v[0].x;
      Theta:=v[1].x;
      Omega:=v[1].xprime;
      alpha:=omega-positions[valcount-1].omega;
      xpos:=-DM*cos(theta);
      xvel:=Dm*omega*cos(theta);
      ypos:=DM*sin(theta);
      yvel:=Dm*omega*sin(theta);
      GetSpringvalues(theta,xspring2,yspring2,springlength,springangle, forceangle);
    end;
  end;
end;

{*********** FlightFunc1 **********8}
Function TForm1.FlightFunc1(v:TNVector):Float;
{Calc next x" in horizontal direction, called for each calc point}
begin
  result:=0-drag*{sqr}(v[1].xprime){/mass};
end;

{****** FlightFunc2 ***********}
Function TForm1.FlightFunc2(v:TNVector):Float;
{Calc next y" in vertical direction, called for each calc point}
begin
  if v[2].xprime>0 then result:=-gravity-drag*{sqr}(v[2].xprime){/mass}
  else result:=-gravity+drag*{sqr}(v[2].xprime){/mass};
end;

{************** FlightCallBackFunc **********}
Function TForm1.FlightCallBackFunc
                       (v:TNVector):boolean;
{Called for each returned point -
 Save X & Y values for time which is in v[0].x }
begin
  result:=true;
  inc(ValCount2);
  if ValCount2>high(positions2) then setlength(positions2, length(positions2)+100);
  with positions2[ValCount2] do
  begin
    time:=v[0].x;
    xpos:=v[1].x;
    xvel:=v[1].xprime;
    yPos:=v[2].x;
    yvel:=v[2].xprime;
  end;
  if v[2].x<catapultrec.p[1].y{x} then result:=false; {stop if Y<=ground level }
end;



{*********** SetupValues ********}
Procedure TForm1.SetupValues;
var xspring2, yspring2, springlength:float;
begin
  Theta0:=Theta0Edt.value/180*Pi;
  ThetaEnd:=ThetaEndEdt.value/180*Pi;
  starttime:=0;
  StopTime:=maxsecs.value;
  ReturnInterval:=1/Returnsps.value;
  CalcInterval:=returninterval/calcspret.value;
  positions[0].theta:=theta0; {used to plot 1st catapult diagram}
  Gravity:=GravityEdt.value*ConvL;
  Mass:=Massedt.value*ConvM;
  DM:=abs(DMedt.value)*ConvL;
  L:=Ledt.value*ConvL;
  F:=Fedt.value*ConvF;
  MB:=MBEdt.value*ConvM;
  DF:=DFEdt.value*ConvL;
  drag:=dragEdt.value;
  Pivotheight:=PivotHeightEdt.value*ConvL;
  XSpring1:=XSpring1Edt.value*ConvL;
  YSpring1:=YSpring1Edt.value*ConvL;
  if   springRbtn.checked then
  begin
   {get coordinates of attach point}
    xspring2:=Df*cos(theta0)*ConvL;
    yspring2:=-DF*sin(theta0)*ConvL;
    {calc length of spring}
    springlength:=sqrt(sqr(xspring1-xspring2)+sqr(yspring2-yspring1));
    {calc angle of spring}
    FAngle:= Arccos((xspring1-xspring2)/SpringLength) + theta0;
  end
  else
  begin
    Fangle:=Pi/2;
    if df>0 then Fangle:=-FAngle;{force opposite side from projectile, make force act upwards}
  end;

  K:=KEdt.value*ConvF/ConvL; {spring constant}
  {Inertia = Inertia of Projectile + Inertia of rectangular beam pivoting at DM from one end}
  //Inertia:= Mass*DM*DM + MB*L/3*(Intpower(DM/L,3)+Intpower((L-DM)/L,3));
  //Inertia:= Mass*DM*DM+ 1/12*MB*L*L+ MB*(Intpower((DM-L/2),2)+Intpower((L/2-DM),2));
  //Inertia:= Mass*DM*DM+ 1/3*MB*L*L;
  Inertia:= Mass*DM*DM+ 1/12*MB*L*L+ MB*(Intpower((DF-L/2),2));

  with catapultrec do  {calculate coordinates in current units relative to pivot}
  begin
    p[0].x:=0; p[0].y:=0;
    p[1].x:=-pivotheight/2; p[1].y:=-pivotheight;
    p[2].x:=0; p[2].y:=0.1*pivotheight;
    p[3].x:=pivotheight/2; p[3].y:=-pivotheight;
    p[4].x:=-DM*cos(Theta0);  p[4].y:=(DM)*sin(theta0);
    p[5].x:=(L-DM)*cos(Theta0);  p[5].y:=(L-DM)*sin(theta0);
    p[6].x:=xspring1; p[6].y:=yspring1;
    p[7].x:=DF*cos(theta0); p[7].y:=-DF*sin(theta0);
    p[8].x:=-(0.75*DM*cos(thetaend)); p[8].y:=-(0.75*DM*sin(thetaend));
  end;
end;


{************* FireBtnClick **************}
procedure TForm1.FireBtnClick(Sender: TObject);
{Setup and run Runge-Kutta for 2 equation case}
begin
  pagecontrol1.activepage:=tabsheet2;
  Error:=0;
  ValCount:=0;
  setlength(positions,100);
  setupValues;
  Initialvalues[0].x:=0;
  Initialvalues[1].x:=Theta0;
  Initialvalues[1].xprime:=0;
  TestFuncs[1]:=FireFunc1;
  {call runge-kutta}
  RungeKutta2ndOrderIC_System(StartTime, StopTime, InitialValues,
                      ReturnInterval, CalcInterval, Error,
                      1{NumEquations}, TestFuncs, FireCallBackFunc);

  with memo1.lines do
  case Error of  {check result of call}
    1 : add('The number of values to return must be greater than zero.');
    2 : begin
          add('The number of calc intervals must be greater than'
             + 'or equal to the number of values to return.');
        end;

    3 : add('The lower limit must be different from the upper limit.');
  end; { case }
  {OK - we have fired the projectile, now do ballistics calc}
  starttime:=positions[valcount].time;
  StopTime:=starttime+maxsecs2.value;
  ReturnInterval:=1/Returnsps2.value;
  CalcInterval:=returninterval/calcspret2.value;

  InitialAngle:=PI/2-positions[valcount].theta; {projectile flies at beam angle + 90 deg}
  InitialDeriv:=positions[valcount].omega*dm;
  Initialvalues[0].x:=starttime;
  Initialvalues[1].X:=positions[valcount].xpos; {INITIAL X}
  Initialvalues[1].XPRIME:=INITIALDERIV*COS(INITIALANGLE);
  Initialvalues[2].X:=positions[valcount].ypos; {INITIAL Y}
  Initialvalues[2].XPRIME:=INITIALDERIV*SIN(INITIALANGLE);
  Error:=0;
  ValCount2:=0;
  setlength(positions2,100);
  NumEquations:=2;
  TestFuncs[1]:=FlightFunc1;
  TestFuncs[2]:=FlightFunc2;

  {call runge-kutta to calc ballistic path}
  RungeKutta2ndOrderIC_System(StartTime, StopTime, InitialValues,
                      ReturnInterval, CalcInterval, Error,
                      NumEquations, TestFuncs, FlightCallBackFunc);

  with memo2.lines do
  case Error of  {check result of call}
    0: begin
         drawresults; {plot the resulting points}
       end;
    1 : add('The number of values to return must be greater than zero.');
    2 : begin
          add('The number of calc intervals must be greater than'
             + 'or equal to the number of values to return.');
        end;

    3 : add('The lower limit must be different from the upper limit.');
  end; { case }
end;

{************ FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
var ini:TInifile;
begin
  modified:=false;
  changing:=false;
  setlength(positions,100);
  valcount:=0;
  ConvL:=1; ConvM:=1; ConvF:=1;  {initialize conversion factors}
  currentunits:=unitsgrp.itemindex;
  ininame:=extractfilepath(application.exename)+'Catapult.ini';
  ini:=TInifile.create(ininame);
  catname:=ini.readstring('General','Cat Filename','');
  ini.free;
  if not fileexists(catname)
  then catname:=extractfilepath(application.exename)+'Sample.cat';
  if fileexists(catname)then loadcat(catname) else catname:='';
end;

{************* ResetBtnClick ***********}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  setupvalues;
  drawcat1(image2, image2.clientrect);
  valcount:=0;
  if valcount2>0 then
  begin
   valcount2:=0;
   drawcat1(image1, FirecatImagerect);
 end
 else  valcount2:=0;
end;

{********* SaveBtnClick **********}
procedure TForm1.SaveBtnClick(Sender: TObject);
begin
  If savedialog1.execute then
  begin
    catname:=savedialog1.filename;
    savecat;
  end;
end;

{********** LoadBtnClick **********}
procedure TForm1.LoadBtnClick(Sender: TObject);
var r:integer;
begin
  if modified then
  begin
    r:= messagedlg('Save current catapult first?',mtconfirmation,
                    [mbyes,mbno,mbcancel],0);
    if r=mrcancel then exit;
    if r=mryes then savebtnclick(sender);
  end;
  If opendialog1.execute then
  begin
    loadcat(opendialog1.filename);
  end;
end;

{************ Savecat *********}
procedure tform1.savecat;
{Save the current catapult definition}
var
  ini:TIniFile;
begin
   ini:=TInifile.create(catname);
   with ini do
   begin
     {**** General ****}
     {units}
     writeinteger('General','Unitstype',unitsgrp.itemindex);
     {gravity}
     writefloat('General', 'Gravity',GravityEdt.value);
     {drag}
     writefloat('General', 'Air Drag Coef',dragEdt.value);

     {**** Geometry ***}
     {iniital arm angle}
     writefloat('Geometry', 'Initial Angle',Theta0Edt.value);
     {Final arm angle}
     writefloat('Geometry', 'Final Angle',ThetaEndEdt.value);
     {PivotHeight}
     writefloat('Geometry', 'Pivot Height', PivotheightEdt.value);
     {force type}
     writebool('Geometry', 'Fixed Spring End',springrbtn.checked);
     if springrbtn.checked then
     begin
       {fixed spring end}
       writefloat('Geometry', 'Spring Fixed X',XSpring1Edt.value);
       writefloat('Geometry', 'Spring Fixed Y',YSpring1Edt.value);
     end
     {Initial force}
     else writefloat('Geometry', 'Fixed Angle Force',FEdt.value);
     {sprint constant}
     writefloat('Geometry', 'Spring Constant',KEdt.value);
     {force distance}
     writefloat('Geometry', 'Beam Force Dist.',DFEdt.value);
     {Beam length}
     writefloat('Geometry', 'Beam Length',LEdt.value);
     {Beam to projectile length}
     writefloat('Geometry', 'Beam Projectile Dist.',DMEdt.value);
     {Mass of beam}
     writefloat('Geometry', 'Beam Mass',MBEdt.value);
     {mass of projectile}
     writefloat('Geometry', 'Projectile Mass',MassEdt.value);
     {pivot coefficient of friction}

     {********* Simulation **********}
     {Firing Phase, Flight Phase}
     writeinteger('Simulator','Fire Max Secs',Maxsecs.value);
     writeinteger('Simulator','Flight Max Secs',Maxsecs2.value);
     writeinteger('Simulator','Fire Return rate',ReturnSPS.value);
     writeinteger('Simulator','Flight Max Secs',ReturnSPS2.value);
     writeinteger('Simulator','Fire Calc per return',CalcSPRet.value);
     writeinteger('Simulator','Flight Calc per return',CalcSPRet2.value);
   end;
   modified:=false;
   changing:=false;
   ini.free;
   savecatname;
   catnamelbl.caption:='Current Catapult - '+catname;
end;

{******** SaveCatName **********}
Procedure tform1.savecatname;
var ini:TInifile;
begin
  ini:=TInifile.create(ininame);
  with ini do
  begin
    writestring('General','Cat Filename',catname);
  end;
  ini.free;
  savedialog1.filename:=catname;
  opendialog1.filename:=catname;
end;

{************ Loadcat ************}
procedure tform1.loadcat(newname:string);
{load a saved catapult definition}
var
  ini:TIniFile;
begin
   If modified and (messagedlg('Save current catapult first?',mtConfirmation,
                                [mbyes,mbno,mbcancel],0)=mryes) then savecat;

   catname:=newname;
   catnamelbl.caption:='Current Catapult - '+catname;
   ini:=TInifile.create(catname);
   changing:=true;
   with ini do
   begin
     {**** General ****}
     {units}
     currentunits:=readinteger('General','Unitstype',0);
     unitsgrp.itemindex:=currentunits;
     {gravity}
     Gravityedt.value:=readfloat('General', 'Gravity',9.8);
     {drag}
     dragedt.value:=readfloat('General', 'Air Drag Coef',0);

     {**** Geometry ***}
     {iniital arm angle}
     Theta0Edt.value:=readfloat('Geometry', 'Initial Angle',0);
     {Final arm angle}
     ThetaEndEdt.value:=readfloat('Geometry', 'Final Angle',45);
     {Pivotheight}
     PivotheightEdt.value:=readfloat('Geometry', 'Pivot Height',1);
     {force type}
     Springrbtn.checked:=ReadBool('Geometry', 'Fixed Spring End',True);
     if springrbtn.checked then
     begin
       {fixed spring end}
       XSpring1Edt.value:=readfloat('Geometry', 'Spring Fixed X',1);
       YSpring1Edt.value:=readfloat('Geometry', 'Spring Fixed Y',1);
     end
     {Initial force}
     else FEdt.value:=readfloat('Geometry', 'Fixed Angle Force',2);
     {sprint constant}
     KEdt.value:=readfloat('Geometry', 'Spring Constant',25);
     {force distance}
     DFEdt.value:=readfloat('Geometry', 'Beam Force Dist.',1);
     {Beam length}
     LEdt.value:=readfloat('Geometry', 'Beam Length',3);
     {Beam to projectile length}
     DMEdt.value:=readfloat('Geometry', 'Beam Projectile Dist.',2);
     {Mass of beam}
     MBEdt.value:=readfloat('Geometry', 'Beam Mass',0);
     {mass of projectile}
     MassEdt.value:=readfloat('Geometry', 'Projectile Mass',2);
     {pivot coefficient of friction}

     {********* Simulation **********}
     {Firing Phase, Flight Phase}
     Maxsecs.value:=readinteger('Simulator','Fire Max Secs',1);
     Maxsecs2.value:=readinteger('Simulator','Flight Max Secs',10);
     ReturnSPS.value:=readinteger('Simulator','Fire Return rate',20);
     ReturnSPS2.value:=readinteger('Simulator','Flight Max Secs',20);
     CalcSPRet.value:=readinteger('Simulator','Fire Calc per return',10);
     CalcSPRet2.value:=readinteger('Simulator','Flight Calc per return',10);
   end;
   ini.free;
   savecatname;
   changing:=false;
   paramchanged(self);
   modified:=false;
end;


(*
{************* UnitsGrpClick **********}
procedure TForm1.UnitsGrpClick(Sender: TObject);
{Convert units system}
var
  L,M,F,G:float;

begin
  if (currentunits<>unitsgrp.itemindex)
     and (messagedlg('Convert current values?',
                     mtConfirmation, [mbYes, mbNo],0)=mryes) then
  begin
    L:=0; M:=0;{just to eliminate compiler warnings}
    case Unitsgrp.itemindex of
        0: {from x To Coarse Metric}
        begin
          G:=9.8066;
          case  currentunits of
             1: begin L:=1/100; m:=1/1000;  end;
             2: begin L:=1/3.2808; m:=1/2.25; end;
             3: begin L:=1/3.2808/12; m:=1/2.25/16; end;
          end;
        end;
        1: {To x to Fine Metric}
        begin
          G:=980.66;
          case  currentunits of
            0: begin L:=100; m:=1000;  end;
            2: begin L:=100/3.2808; m:=1000/2.25;  end;
            3: begin L:=100/3.2808/12; m:=1000/2.25/16;  end;
          end;
        end;
        2: {from x to Coarse English}
        begin
          G:=32.2;
          case  currentunits of
            0: begin L:=3.2808; m:=2.25; end;
            1: begin L:=3.2808/100; m:=2.25/1000;  end;
            3: begin L:=1/12; m:=1/16;  end;
          end;
        end;
        3: {from x to Fine English}
        begin
          G:=32.2*12;
          case  currentunits of
            0: begin L:=12*3.2808; m:=16*2.25; end;
            1: begin L:=12*3.2808/100; m:=16*2.25/1000;  end;
            2: begin L:=12; m:=16; end;
          end;
        end;
    end;{case}
    F:=M; {Force conversion factor = mass conversion factor}
    FEdt.value:=Fedt.value*F;
    GravityEdt.value:=GravityEdt.value*L;
    MassEdt.value:=MassEdt.value*M;
    DFEdt.value:=DFEdt.value*L;
    DMEdt.value:=DMEDt.value*L;
    LEdt.value:=LEdt.value*L;
    MBEdt.value:=MBEdt.value*M;
    XSpring1Edt.value:=XSpring1Edt.value*L;
    YSpring1edt.value:=YSpring1Edt.value*L;
    KEdt.value:=Kedt.value*f/L;
    PivotheightEdt.value:=PivotHeightedt.value*L;
  end;  {done coverting unit}

  CurrentUnits:=UnitsGrp.itemindex; {save new units}

  Case unitsgrp.itemindex of
    0: begin LName:='m'; Mname:='kg'; Fname:='Newtons'; end;
    1: begin LName:='cm'; Mname:='gram'; Fname:='CentiNewtons'; end;
    2: begin LName:='ft'; Mname:='lb'; Fname:='lb force'; end;
    3: begin LName:='inch'; Mname:='oz'; Fname:='oz force'; end;
  end;
  {Change units to new type}
  Label2.caption:='Applied force ('+Fname+')';
  Label22.caption:='X ('+Lname+')';
  Label11.caption:='Y ('+Lname+')';
  Label9.caption:='Length of beam ('+Lname+')';
  Label15.caption:='Spring Constant ('+Fname+'/'+Lname+')';
  Label28.caption:='Pivot height above ground ('+Lname+')';
  Label4.caption:='Distance pivot to force ('+Lname+')   '
                  +'negative = left of pivot';
  Label8.caption:='Distance pivot to projectile ('+Lname+')';
  Label21.caption:='Mass of projectile ('+Mname+')';
  Label20.caption:='Gravity ('+Lname+'/sec^2)';
  modified:=true;
end;
*)

{************* UnitsGrpClick **********}
procedure TForm1.UnitsGrpClick(Sender: TObject);
{Convert units system}
var
  LL, MM, Ff:float;

begin

  if (currentunits<>unitsgrp.itemindex)
     //and (messagedlg('Convert current values?', mtConfirmation, [mbYes, mbNo],0)=mryes)
  then
  begin
  
    LL:=0; MM:=0; ff:=0; {just to eliminate compiler warnings}

    case Unitsgrp.itemindex of
         0: {from x To Coarse Metric}
         case  currentunits of
          1: begin LL:=0.01; Mm:=0.001; ff:=0.01; end;
          2: begin LL:=1/3.2808; Mm:=1/2.20462; ff:=4.44822; end;
          3: begin LL:=1/(12*3.2808); Mm:=1/(16*2.20462);  ff:=4.44822/16; end;
        end;
      1: { from x to Fine Metric}
        case  currentunits of
          0: begin LL:=100; Mm:=1000; ff:= 100;  end;
          2: begin LL:=100/3.2808; Mm:=453.592; ff:= 448.22; end;
          3: begin LL:=100/(3.2808*12); Mm:=453.592/16;  ff:=448.22/16; end;
        end;

      2: {from x to Coarse English}
        case  currentunits of
          0: begin LL:=3.2808; Mm:=2.20462; ff:=1/4.44822;  end;
          1: begin LL:=3.2808/100; Mm:=1/453.592; ff:=1/448.22; end;
          3: begin LL:=1/12; Mm:=1/16; ff:=1/16; end;
        end;
      3: {from x to Fine English}
        case  currentunits of
          0: begin LL:=12*3.2808; Mm:=16*2.20462; ff:=16/4.44822;  end;
          1: begin LL:=12*3.2808/100; Mm:=16/453.592; ff:=16/448.22; end;
          2: begin LL:=12; Mm:=16;  ff:=16; end;
        end;
    end;{case}
    changing:=true; {prevent updating catapult image while we are convertine units}
    FEdt.value:=Fedt.value*fF;
    GravityEdt.value:=GravityEdt.value*LL;
    MassEdt.value:=MassEdt.value*MM;
    DFEdt.value:=DFEdt.value*LL;
    DMEdt.value:=DMEDt.value*LL;
    LEdt.value:=LEdt.value*LL;
    MBEdt.value:=MBEdt.value*MM;
    XSpring1Edt.value:=XSpring1Edt.value*LL;
    YSpring1edt.value:=YSpring1Edt.value*LL;
    KEdt.value:=Kedt.value*ff/LL;
    PivotheightEdt.value:=PivotHeightedt.value*LL;
    changing:=false;
  end;  {done coverting units}

  CurrentUnits:=UnitsGrp.itemindex; {save new units}

  {Set up unit names and factors to convert to/from large metric system}
  Case unitsgrp.itemindex of
    0: begin
         LName:='m'; Mname:='kg'; Fname:='N';
         ConvL:=1; ConvM:=1; ConvF:=1;
       end;
    1: begin
         LName:='cm'; Mname:='gram'; Fname:='cN';
         ConvL:=0.01; ConvM:=0.001; ConvF:=0.01;
       end;
    2: begin
         LName:='ft'; Mname:='lb'; Fname:='lbf';
         ConvL:=1/3.2808; ConvM:=1/2.20462; ConvF:=4.44822;
       end;
    3: begin
         LName:='inch'; Mname:='oz'; Fname:='ozf';
         ConvL:=1/(12*3.2808); ConvM:=1/(16*2.20462);  ConvF:=4.44822/16;
       end;
  end;
  {Change units to new type}
  Label2.caption:='Applied force ('+Fname+')';
  Label22.caption:='X ('+Lname+')';
  Label11.caption:='Y ('+Lname+')';
  Label9.caption:='Length of beam ('+Lname+')';
  Label15.caption:='Spring Constant ('+Fname+'/'+Lname+')';
  Label28.caption:='Pivot height above ground ('+Lname+')';
  Label4.caption:='Distance pivot to force ('+Lname+')   '
                  +'negative = left of pivot';
  Label8.caption:='Distance pivot to projectile ('+Lname+')';
  Label21.caption:='Mass of projectile ('+Mname+')';
  Label20.caption:='Gravity ('+Lname+'/sec^2)';
end;


{************ SetupEnter *********}
procedure TForm1.SetupEnter(Sender: TObject);
{Called when the Setup page is displayed}
begin
  If length(positions)=0 then exit; {fields not yet set up - exit}
  valcount:=0;
  setupvalues;
  drawcat1(image2, image2.clientrect);
end;

procedure TForm1.Label31Click(Sender: TObject);
begin
  OpenURL('http://www.delphiforfun.org/'); { *Converted from ShellExecute* }
end;

{************* SaveResultsBtnClick ***********}
procedure TForm1.SaveResultsBtnClick(Sender: TObject);
{Append results of this run to catapult file name with .txt extension.  Saved
 aCs CSV record for importing to Excel, etc.}
var
  S:string;
  unitstr,forcetypestr:string;
  fname:string;
  f:textfile;
begin
  {record format}
  s:='DateTime,UnitSys,BeamAngle1,BeamAngle2,PivotH,BeamLen,ForceDist,BallDist,BallMass,'+
     'Gravity,Forcetype,RotateForce,SpringX,SpringY,SpringK,BeamMass,AirDrag,'+
     'FlightTime, FlightDist, Flightheight';

 fname:=changefileext(catname,'.txt');
 assignfile(f,fname);
 If not  fileexists(fname) then
 begin
   rewrite(f);
   writeln(f,s);
   closefile(f);
 end;
 case unitsgrp.itemindex of
   0:unitstr:='LM';
   1:unitstr:='SM';
   2:unitstr:='LE';
   3:unitstr:='SE';
 end;
 if rotaterbtn.checked then forcetypestr:='RF' else forcetypestr:='SPF';
 append(f);
 s:=Datetimetostr(now)+format(',%s,%6.2f,%6.2f,%6.2f,'
                             + '%6.2f,%6.2f,%6.2f,%6.2f,%6.2f,'
     +'%s,%6.2f,%6.2f,%6.2f,%6.2f,%6.2f,%6.2f,%6.1f,%6.2f,%6.2f',
     [Unitstr,Theta0Edt.value,ThetaEndEdt.value,PivotheightEdt.value,
      Ledt.value,DFEdt.value,DMEdt.value, MassEdt.value,GravityEdt.value,
      ForcetypeStr,
      FEdt.value,XSpring1Edt.value,YSpring1Edt.value,KEdt.value,DragEdt.value,MBEdt.value,
      flighttime,flightdist/convL,flightheight/convL]);

 writeln(f,s);
 closefile(f);
end;

{************** FormCloseQuery *************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var r:integer;
begin
  canclose:=true;
  if modified then
  begin
    r:= messagedlg('Save current catapult first?',mtconfirmation,
                    [mbyes,mbno,mbcancel],0);
    if r=mrcancel then begin canclose:=false; exit; end;
    if r=mryes then savebtnclick(sender);
  end;
end;

end.


