unit U_AstroDemo;
 {Copyright  © 2001-2015, Gary Darby,  www.DelphiForFun.org
  This program may be used or modified for any non-commercial purpose
  so long as this original notice remains in place.
  All other rights are reserved
 }

 {A fairly comprehensive Astronomy demo of TAstronomy, Delphi Astronomy unit
  based on a conversion of Basic routines contained in Peter Duffett-Smith's
  book "Astronomy With Your Personal Computer",  Cambridge University Press.
 }

{Version 2.0 adds "Decimal" Angle format and animation of Analemmas}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DateTimePicker,ComCtrls, ExtCtrls, Menus, ShellAPI, UAstronomy;

type

  T3DVector=record
    x,y,z:extended;
  end;

  TDrawMode=(moonlines, sunlines, analemma, none );

  { TForm1 }

  TForm1 = class(TForm)
    AltLbl: TLabel;
    AnalemmaBtn: TButton;
    AnalemmaPanel: TPanel;
    AnDateLbl: TLabel;
    AnimateBtn: TButton;
    AnTypeGrp: TRadioGroup;
    AzLbl: TLabel;
    Button1: TButton;
    DatePicker: TDateTimePicker;
    DLSRGrp: TRadioGroup;
    EclipseBtn: TButton;
    EWRGrp: TRadioGroup;
    HeightEdt: TEdit;
    HeightUD: TUpDown;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    LatEdt: TEdit;
    LongEdt: TEdit;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Memo1: TMemo;
    MoonBtn: TButton;
    N1: TMenuItem;
    Exit1: TMenuItem;
    NSRGrp: TRadioGroup;
    Options1: TMenuItem;
    Actions1: TMenuItem;
    Calctype1: TMenuItem;
    Panel1: TPanel;
    PBox: TPaintBox;
    PlanetBox: TComboBox;
    ShowBtn: TButton;
    StaticText1: TStaticText;
    SunriseSunset1: TMenuItem;
    Analemma2: TMenuItem;
    Checkunitconversions1: TMenuItem;
    Moonrisemoonset1: TMenuItem;
    Planetpositions1: TMenuItem;
    Displaycelestialpositonformat1: TMenuItem;
    LocalCiviltime1: TMenuItem;
    TimeBox: TComboBox;
    TimePicker: TDateTimePicker;
    TstBtn: TButton;
    TZBox: TComboBox;
    UniversalTime1: TMenuItem;
    GreenwichSiderealTime1: TMenuItem;
    LocalSidereal1: TMenuItem;
    EclOpt: TMenuItem;
    AzAltOpt: TMenuItem;
    RADeclOpt: TMenuItem;
    HADeclOpt: TMenuItem;
    GalOpt: TMenuItem;
    Mercury1: TMenuItem;
    Venus1: TMenuItem;
    Mars1: TMenuItem;
    Jupiter1: TMenuItem;
    Saturn1: TMenuItem;
    Neptune1: TMenuItem;
    Pluto1: TMenuItem;
    EclipseInfo1: TMenuItem;
    Saturn2: TMenuItem;
    AngleFormat1: TMenuItem;
    DMSFmt: TMenuItem;
    DecimalDegrees1: TMenuItem;
    procedure ShowBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AnalemmaBtnClick(Sender: TObject);
    procedure DatePickerUserInput(Sender: TObject;
      const UserString: String; var DateAndTime: TDateTime;
      var AllowChange: Boolean);
    procedure PBoxPaint(Sender: TObject);
    procedure LongEdtExit(Sender: TObject);
    procedure TstBtnClick(Sender: TObject);
    procedure MoonBtnClick(Sender: TObject);
    procedure EclipseBtnClick(Sender: TObject);
    procedure SelectTimeOptClick(Sender: TObject);
    procedure PlanetBoxClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure AngleOptionClick(Sender: TObject);
    procedure TimeBoxChange(Sender: TObject);
    procedure PlanetItemClick(Sender: TObject);
    procedure BaseDataChange(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure AnalemmaTypeClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure AnimateBtnClick(Sender: TObject);
    procedure AnTypeGrpClick(Sender: TObject);
    procedure DMSFmtClick(Sender: TObject);
    procedure DecimalDegrees1Click(Sender: TObject);
    procedure AnallemmPanelExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    JDate:integer;
    drawmode:TDrawMode;
    CurrentDisplayRtn:TNotifyEvent;
    {Drawing variables}
    cx,cy,clen:integer;
    middayaz:extended;
    moonphase:extended;
    waxing:boolean; {determies which side of moon to darken}
    bodyriseangle, bodysetangle:extended;
    anpoints:array of tPoint;  {analemma points for drawing}
    anscale:single; {analemma drawing scaling factor}
    anplotx, anploty:integer; {coordinates for plot of "date" on analemma}
    DisplayTimeType:TDTType;
    DisplayAngletype:TCoordType;
    LatestPoint:TRpoint; {last coords displayed - use to initialize Convert-Test form}
    CurrentTimeType:TDTType; {current timebox index - used to convert times when index changes}
    ShadowChecked, CameraSouthChecked:Boolean;
    function GetBaseData:boolean;
    procedure DisplayCoordsAsType(angle:TRPoint);
    procedure cleardisplay;
    Procedure DrawAnalemma(AnAstro:TAstronomy; DoDraw:boolean);
 end;


var
  Form1: TForm1;

implementation

{$R *.DFM}
Uses math,  U_ConvertTest;

const
  tab=chr(vk_tab);

{************************** Local Routines ******************}

  {degree trig functions}
  function cosd(t:extended):extended;
  begin  result:= cos(0.01745329251994 * t); end;

  function sind(t:extended):extended;
  begin  result:= sin(0.01745329251994 * t); end;

  function tand(t:extended):extended;
  var  x:extended;
  begin
    x:=degtorad(t);
    result:= tan(x);
  end;

      {Day of year function}
      function JulianDay(d:TDateTime):integer;
      var
        y,m,day:word;
      begin
        decodedate(d,y,m,day);
        result:=trunc(d-encodedate(y-1,12,31));
      end;

      function year(d:TDatetime):word;
      var
        m,day:word;
      begin
        decodedate(d,result,m,day);
      end;

     function eqoftime(jday:extended):extended;
     {Equations of time - hours that solar differs from mean tine an any day}
     var b:extended;
     begin
        b:= 360.0 * (jday-81) / 364;
        result:=(9.87*sind(2.0*b) - 7.53*cosd(b) - 1.5*sind(b)) / 60.;  {eq of time}
     end;

{**************** FormActivate ****************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  //ShortdateFormat:='yyyy-mm-dd'; {for testing with European date formats}
  Longtimeformat:='hh:nn:ss';
  TZBox.itemindex:=7;
  TimeBox.itemindex:=0;
  CurrentDisplayRtn:=nil;
  SelectTimeoptclick(sender);
  AngleoptionClick(sender);
  datePicker.date:=date;
  drawmode:=none;
  doublebuffered:=true;
  cx:=pbox.width div 2;
  cy:=pbox.height div 2;
  clen:=3*pbox.width div 8; {lines 3/4 out from center}
  LongEdtExit(sender);
  currenttimetype:=TDTType(timebox.itemindex);
  ShadowChecked:=true;
  CameraSouthChecked:=false;
  getbasedata;
end;

{******************** DatePickerUserInput  *********}
procedure TForm1.DatePickerUserInput(Sender: TObject;
  const UserString: String; var DateAndTime: TDateTime;
  var AllowChange: Boolean);
{to overcome some default date entry edit problems}
begin
  try
    DateAndTime:=strtodate(userstring);
  except
  end;
end;

{********************** GetBaseData ***************}
function TForm1.GetBaseData:boolean;
{load Astro data from form fields}
var
  p:TrPoint;
  newtime:TDateTime;
begin
  with astro do
  begin
    result:=true;
    Adate:=datepicker.date;
    JDate:=Julianday(Adate);
    tzHours:=tzBox.itemindex-12;
    height:=HeightUD.position;
    if strtoangle(longedt.text,p.x) then
    begin
      p.x:=abs(p.x);
      if EWRGrp.itemindex>0 then p.x:=-p.x;
    end
    else
    begin
       showmessage('Invalid longitude, must be 1 to 3 numbers separated by spaces');
       result:=false;
    end;
    if strtoangle(latedt.text,p.y) then
    begin
      p.y:=abs(p.y);
      if NSRGrp.itemindex>0 then p.y:=-p.y;
    end
    else
    begin
      showmessage('Invalid latitude, must be 1 to 3 numbers separated by spaces');
      result:=false;
    end;
    lonlat:=p;
    dlshours:=DLSRGrp.itemindex;
    {call this to convert input time to local}
    GetPrintDatetime(tDTType(timebox.itemindex),ttLocal,
                     int(datepicker.date)+ frac(timepicker.time),false, newtime );
    LocalTime:=(newtime);
  end;
end;

{****** ClearDisplay *******888}
procedure TForm1.Cleardisplay;
begin
  memo1.clear;
  drawmode:=none;
end;

{******** ScrollToTop *******}
procedure Scrolltotop(Memo:TMemo);
begin
  with memo do
  begin
    SelStart := 0;
    Perform(EM_SCROLLCARET, 0, 0);
  end;
end;


{***************** ShowBtnClick ********************}
procedure TForm1.ShowBtnClick(Sender: TObject);
  { Angles are in degrees, times are in hours. }
var
   {Direction cosines of a vector pointing toward the sun from the origin.}
   p:TRpoint;
   UpTmAz, DnTmAz:TRPoint;
   GS,UT, savetime, dummy:TDateTime;  {fields set by time conversion but not needed}
   az,alt:extended;
   sunrec,middayrec:TSunrec;
   errmsg:string;
   sunrise,sunset:TDateTime;
   CivilStart,CivilEnd:TDateTime;
   NauticalStart,NauticalEnd:TDateTime;
   AstronomicalStart,AstronomicalEnd:TDateTime;
   midday,middayalt:extended;
begin
   If GetBaseData then
   begin
     CurrentDisplayRtn:=ShowBtnClick;
     cleardisplay;
     if drawmode=analemma then memo1.lines.clear;
     p:=astro.lonlat;
     with astro do
     begin
       savetime:=localtime;
       sunpos(Sunrec);
       az:=sunrec.Trueazalt.x;
       alt:=sunrec.Trueazalt.y;
       {Get Sunrise,Sunset}
       errmsg:=Sunriseset(0,UpTMAz,DNTmAz);
       convertLSTime(UpTmaz.x/24.0,GS,sunrise,UT);
       convertLSTime(DnTmaz.x/24.0,GS,sunset,UT);
       bodyriseangle:=UpTmAz.y;
       bodysetangle:=DnTmAz.y;
       {Get Civil Twilight}
       if errmsg='' then  {Compute Civil Twilight}
       begin
         errmsg:=Sunriseset(1,UpTmAz,DNTmAz);
         convertLSTime(UpTmaz.x/24.0,GS,CivilStart,UT);
         convertLSTime(DnTmaz.x/24.0,GS,CivilEnd,UT);
       end;
       if errmsg='' then  {Compute Nautical twilight}
       begin
         errmsg:=Sunriseset(2,UpTmAz,DNTmAz);
         convertLSTime(UpTmaz.x/24.0,GS,NauticalStart,UT);
         convertLSTime(DnTmaz.x/24.0,GS,NauticalEnd,UT);
       end;
       if errmsg='' then  {Compute Astromonical Twilight}
       begin
         errmsg:=Sunriseset(3,UpTmAz,DNTmAz);
         convertLSTime(UpTmaz.x/24.0,GS,AstronomicalStart,UT);
         convertLSTime(DnTmaz.x/24.0,GS,AstronomicalEnd,UT);
       end;

       localtime:=(sunrise+sunset)/2;
       sunpos(Middayrec);
       midday:=localtime;
       Middayaz:=Middayrec.TrueAzalt.x;
       Middayalt:=Middayrec.TrueAzalt.y;
       localtime:=savetime;
       if errmsg='' then
       begin
         drawmode:=sunlines;
         PBox.invalidate;
       end;  { drawsunlines;  }
       with memo1,lines do
       begin
        add('SUNPOS: Longitude:'+angletostr(lonlat.x,DecimalFormat)
                    +', Latitude:' + angletostr(lonLat.y,DecimalFormat)
                    + '  '+datetostr(datepicker.date)
                    );
        if errmsg='' then

        begin
          add('Astronomical Twilight Start: ' +tab
                 + astro.GetPrintDatetime(ttLocal,DisplayTimeType,
                      AstronomicalStart,false {no date} , dummy )
                 +' ('+GetSTimeName(displayTimeType)+')');
          add('Nautical Twilight Start: '  +tab
                 + astro.GetPrintDatetime(ttLocal,DisplayTimeType,
                      NauticalStart,false {no date} , dummy )
                 +' ('+GetSTimeName(displayTimeType)+')');
          add('Civil Twilight Start: ' +tab  +tab
                 + astro.GetPrintDatetime(ttLocal,DisplayTimeType,
                      CivilStart,false {no date} , dummy )
                 +' ('+GetSTimeName(displayTimeType)+')');

          add('Sunrise:     '  +tab +tab+tab
                 +astro.GetPrintDatetime(ttLocal,DisplayTimeType,
                      sunrise,false {no date} , dummy )
                 +' ('+GetSTimeName(displayTimeType)+')'
                 +'   Azimuth: '+angletostr(bodyriseangle,DecimalFormat));

          add('Sunset:      '  +tab +tab+tab
                  +astro.GetPrintDatetime(ttLocal,DisplayTimeType,
                      sunset,false {no date} , dummy )
                 +' ('+GetSTimeName(displayTimeType)+')'
                 +'   Azimuth: '+angletostr(bodysetangle,DecimalFormat));

          add('Civil Twilight End: '    +tab +tab
                 + astro.GetPrintDatetime(ttLocal,DisplayTimeType,
                      CivilEnd,false {no date} , dummy )
                 +' ('+GetSTimeName(displayTimeType)+')');
          add('Nautical Twilight End: ' +tab
                 + astro.GetPrintDatetime(ttLocal,DisplayTimeType,
                      NauticalEnd,false {no date} , dummy )
                 +' ('+GetSTimeName(displayTimeType)+')');
          add('Astronomical Twilight End: '    +tab
                 + astro.GetPrintDatetime(ttLocal,DisplayTimeType,
                      AstronomicalEnd,false {no date} , dummy )
                 +' ('+GetSTimeName(displayTimeType)+')');
        end
        else  add('For '+datetostr(datepicker.date)+' the sun '+errmsg);

        add('Solar noon: ('+ astro.GetPrintDatetime(ttLocal,DisplayTimeType,
                      midday,false {no date} , dummy )
                     +' '+GetSTimeName(displayTimeType)+')');
        p:=rpoint(middayaz,middayalt);
        p.Coordtype:=ctAzAlt;
        DisplayCoordsAsType(p);
        add('');
        add('True position at '+ timetostr(localtime)+' Local Civil time');
        p:=rpoint(az,alt);
        p.Coordtype:=ctAzAlt;
        DisplayCoordsAsType(p);

        (*
        add('True  Azimuth: '+angletostr(az)+'  Altitude: '+angletostr(alt));
        add('      Ecliptic Longitude: '+angletostr(sunrec.trueEcllon)
            +format('   True Distance (AU): %7.5f',[sunrec.AUDistance]));
        add('      Right Ascension:     '+ Hourstostr24(sunrec.trueRADecl.x)
            +'    Declination:  '+angletostr(sunrec.trueRaDecl.y));
        *)

        add('Apparent  position: ');
        sunrec.appAzAlt.Coordtype:=ctAzAlt;
        DisplayCoordsAsType(sunrec.AppAzalt);

        (*
        add('Apparent  Azimuth: '+angletostr(sunrec.appAzAlt.x)
               +'  Altitude: '+angletostr(sunrec.appAzalt.y));
        add('      Ecliptic Longitude: '+angletostr(sunrec.appEcllon));
        add('      Right Ascension:     '+ hourstostr24(sunrec.AppRADecl.x)
            +'    Declination:  '+angletostr(sunrec.AppRaDecl.y));
        *)
        (*
        add(format('Position Vector (E,N,Up): %6.3f,%6.31f,%6.3f', [pos.x, pos.y, pos.z]));
        *)
         scrolltotop(memo1);
       end;
     end;
   end;
end;

{*********** MoonBtnClick ******}
procedure TForm1.MoonBtnClick(Sender: TObject);
var
  Moonrec:TMoonRec;
  UPTMAz,DnTmAz:TRpoint;
  moonrise,moonset:TDateTime;
  GS,UT, Dummy:TDateTime;
  msg:string;
  nextnewmoon, nextfullmoon:TDatetime;
  newlat,fulllat,altitude:extended;
  s:string;
begin
  If getbasedata then
  begin
    CurrentDisplayRtn:=MoonBtnClick;
    cleardisplay;
    Astro.Moonpos(Moonrec);
    moonphase:=moonrec.phase;
    msg:=Astro.MoonRiseSet(UpTMAz,DNTMAz, altitude);
    astro.convertLSTime(UpTmaz.x/24.0,GS,moonrise,UT);
    astro.convertLSTime(DnTmaz.x/24.0,GS,moonset,UT);
    if moonset<moonrise then moonset:=moonset+1;
    astro.Newfullmoon(datepicker.date,nextfullmoon,nextnewmoon,fulllat,newlat);
    if (astro.adate>nextnewmoon) and (astro.adate<nextfullmoon)
    then waxing:=true else waxing:=false;
    with memo1, lines, moonrec do
    begin
      add('**********************************');
      with astro,lonlat do
      add('Moon Position data for : Longitude: '+angletostr(x,DecimalFormat)
                      +', Latitude: ' + angletostr(y,DecimalFormat));
      add('On '+datetostr(datepicker.date));
      if uptmaz.y>=0
      then
      with astro do
      begin
        add('Moon rise at :    ' +
                astro.GetPrintDatetime(ttLocal,DisplayTimeType,
                      moonrise,false {no date} , dummy )
                     +' ('+GetSTimeName(displayTimeType)+')');
        add(tab+'   Azimuth: '+angletostr(uptmaz.y,DecimalFormat)
                 +'   Altitude: '+angletostr(altitude,DecimalFormat));
      end;
      If dntmaz.y>=0
      then
      with astro do
      begin
        add('Moon sets at:    '
          + astro.GetPrintDatetime(ttLocal,DisplayTimeType,
                      moonset,false {no date} , dummy )
                 +' ('+GetSTimeName(displayTimeType)+')');
        add(tab+'   Azimuth: '+angletostr(dntmaz.y,DecimalFormat)
               +'   Altitude: '+angletostr(altitude,DecimalFormat));
      end;
      add('Position on '{+datetostr(datepicker.date)+' at '

           +timetostr(timepicker.time) + ' local time, ');}
          +astro.GetPrintDatetime(tDTType(timebox.itemindex),DisplayTimeType,
                     int(datepicker.date)+ frac(timepicker.time),false,dummy )
                 +' ('+GetSTimeName(displayTimeType)+')');
      AzAlt.Coordtype:=ctAzAlt;
      DisplayCoordsAsType(AzAlt);

      add(' Horizontal parallax '+angletostr(Horizontalparallax,astro.DecimalFormat));
      add(format('Earth-Moon distance (KM): %8.0n',[KMToEarth]));
      add('Angular diameter: '+ angletostr(AngularDiameter,astro.DecimalFormat));
      if waxing then s:=' (Waxing)' else s:=' (Waning)';
      {not sure about the new or full moon day so blank waxing/waning msg}
      if (astro.adate=nextnewmoon) or (astro.adate=nextfullmoon) then s:='';
      add(format('Phase (1=Full): %6.3f'+s,[Phase]));
      If msg<>'' then
      begin
        add(msg);
      end;
      drawmode:=moonlines;
      bodyriseangle:=uptmaz.y;
      bodysetangle:=dntmaz.y;
      pbox.invalidate;

      add('Nearest New moon: '+ datetimetostr(Nextnewmoon
        +(astro.tzHours+astro.DLSHours)/24));
      add('Nearest Full moon:'+ datetimetostr(nextfullmoon+
                  (astro.tzHours+astro.DLSHours)/24));
    end;
  end;
end;

{********************* AnalemmaBtnClick **************************}
procedure TForm1.AnalemmaBtnClick(Sender: TObject);
{calculate the analemma as a shadow cast by a vertical pole
 plot top = south}
begin
  if getbasedata then
  with astro, memo1.lines  do
  Begin
    CurrentDisplayRtn:=AnalemmaBtnClick;
    cleardisplay;
    add('An analemma describes the shape of a figure formed by the sun''s'{);}
    +' position in the sky if observed at the same time each day for a year.');
    add('');
    add('A common way to do this is to plot the tip of the shadow cast on the'{); }
    +' ground by vertical stick.  This plot simulates that Shadow as well as'{);}
    +' a camera view with camera fixed pointing South or rotated to Sun position.');
  //  +'  Camera fixed south produces "fisheye" lens effect for early or late observation times since a very "wide angle lens" would be required');

    add('');
    add('The analemma looks best when plotted for hours around noon.  It is'
    +' automatically scaled and panned to fit in the plot area but when the sun gets near'
    +' the horizon, shadow lengths become very large.  This can result in'
    +' truncated plot results.'
    +' The "Use Shadow Scale" checkbox can force "South" and "Sun Position"types to plot with the "Shadow" scale.');
    add('');
    add(' The Yellow dot on analemma reflects the sun''s position on the date and time'{);}
    +' entered in the input area');
    add('');
    add('IF NO ANALEMMA IS DISPLAYED, CHANGE TIME TO A DAYLIGHT HOUR. '
         +'TIMES AROUND MIDDAY WORK BEST.');
    memo1.selstart:=0; memo1.sellength:=0;
    //shadowscale:=0;
    analemmaPanel.visible:=true;
    animatebtn.setfocus;
    DrawAnalemma(Astro,True);
  end;
end;

{************** AnimateBtn **********}
procedure TForm1.AnimateBtnClick(Sender: TObject);
var
  AstroBackup:TAstronomy;
begin
  if AnimateBtn.caption[1]='P'
  then  AnimateBtn.caption:='Animate'
  else
  begin
    Astrobackup:=Tastronomy.create;
    Astrobackup.assign(astro);
    CurrentDisplayRtn:=AnalemmaBtnClick;
    //cleardisplay;
    AnimateBtn.caption:='Pause';
    while AnimateBtn.caption[1]='P' do
    begin
      datepicker.date:=datepicker.date+1;
      Drawanalemma(astro,True);
      sleep(100);
      application.processmessages;
    end;
    astro.assign(Astrobackup);
    Astrobackup.free;
  end;
end;

{******** AnalemmaTypeClick ********}
procedure TForm1.AnalemmaTypeClick(Sender: TObject);
begin
  BasedataChange(sender);  {force redraw of analemma, if one is visible}
end;

{*********** AnTypeGrpClick *********}
procedure TForm1.AnTypeGrpClick(Sender: TObject);
var
  index:integer;
begin
  Case AnTypeGrp.itemindex of
    0: begin
         Shadowchecked:=true;
         CameraSouthChecked:=false;
       end;  
    1: begin
        CameraSouthchecked:=true;
        ShadowChecked:=false;
      end;
    //2: CameraAtSun.checked:=true;
  end;
  AnimateBtn.caption:='Animate';
  DrawAnalemma(Astro,True);
end;

{************ DrawAnalemma ***********}
Procedure TForm1.DrawAnalemma(AnAstro:TAstronomy; DoDraw:boolean);
var
  i,n,anx,any:integer;
  dayinc:integer;
  xmax, ymax, xmin, ymin:integer;
  rangex, rangey:integer;
  nbrpoints:integer;
  anscaley,anscalex:extended;
  adjustx, adjusty:integer;
  pointto:extended;
  sunrec:TSunrec;

        procedure makepoint(az,alt:extended; var x,y:integer);
        var
          L:extended;
        begin
          If shadowchecked then
          begin
            L:=1000/tand(alt); {defines a circle (x^2+y^2=L^2) upon which lies the point}
            x:=-trunc(L*sind(az-180));
            y:=trunc(L*cosd(az-180));
          end
          else if CameraSouthChecked then
          begin
            x:=trunc(1000*sind(az-180));
            y:=trunc(1000*cosd(alt));
          end;
          (*
          else if CameraAtSun.checked then
          begin
            x:=trunc(1000*sind(az-pointto));
            y:=trunc(1000*cosd(alt));
          end;
          *)
        end;
begin
  if getbasedata then
  with Anastro do
  begin
    if dodraw then drawmode:=analemma else drawmode:=none;
    dayinc:=5; {sample interval in days}
    (*hour:=frac(localtime)*24; {which hour of the day to plot}*)
    nbrpoints:= 365 div dayinc+1;
    setlength(anpoints, nbrpoints);
    xmax:=0; ymax:=0;
    xmin:=maxint; ymin:=maxint;
    sunpos(Sunrec);
    AnDateLbl.caption:='Date: '+datetostr(datepicker.date);
    //AzLbl.caption:= 'Apparent Az: '+angletostr(sunrec.appAzAlt.x,DecimalFormat);
    //AltLbl.caption:=' Apparent Alt: '+angletostr(sunrec.appAzalt.y,DecimalFormat);
    AzLbl.caption:= 'Azimuth: '+angletostr(sunrec.TrueAzAlt.x,DecimalFormat);
    AltLbl.caption:='Altitude: '+angletostr(sunrec.TrueAzalt.y,DecimalFormat);
    {errmsg:=sunpos2(localtime*24);}
    pointto:=sunrec.Trueazalt.x;
    with sunrec.TrueAzAlt do
    makepoint(x,y,anx,any);  {depending on type or direction of camera}
    n:=0;
    i:=0;
    adate:= datepicker.date-dayinc; // encodedate(year(adate),6,1)-DAYINC;
    while i<nbrpoints do
    begin
      inc(i);
      adate:=adate+dayinc;
      localtime:=timepicker.time;
      sunpos(sunrec);
     {only generate points if altiude > 0
         - i.e. before shadow tries to go to infinite length}
      if sunrec.trueazalt.y>0 then
      begin
        inc(n);
        with anpoints[n-1] do
        begin
          with sunrec do  makepoint(trueazalt.x,trueazalt.y,x,y);
          xmax:=max(x,xmax);
          ymax:=max(y,ymax);
          xmin:=min(x,xmin);
          ymin:=min(y,ymin);
        end;
      end;
    end;
    setlength(anpoints,n);
  end;

  {set scale to 90% of plot size}
  rangey:=ymax-ymin;
  rangex:=xmax-xmin;
  if (rangey>0) and (rangex>0)then
  begin
    anscaley:=0.9*pbox.height/rangey;
    anscalex:=0.9*pbox.width/rangex;
    anscale:=min(anscalex,anscaley);
    if anscale<0.01 then anscale:=0.01;
    //If shadow.checked then shadowscale:=anscale;
    //if useShadowscale.checked and (shadowscale>0) then anscale:=shadowscale;
    //ScaleLbl.caption:=format('Scale: %.2f',[anscale]);
    adjustx:=(xmax+xmin) div 2;
    adjusty:=(ymax+ymin) div 2;
    {and scale the values for plotting}
    for i:= 0 to high(anpoints) do
    with anpoints[i] do
    begin
      x:=cx+trunc(anscale*(x-adjustx));
      y:=cy+trunc(anscale*(y-adjusty));
    end;
    {set plot coordinates for date entered by user}
    anplotx:=cx+trunc(anscale*(anx-adjustx));
    anploty:=cy+trunc(anscale*(any-adjusty));



  end;

  pbox.invalidate;
end;

{******* Swap *********}
procedure swap(var a,b:integer);
var n:integer;
begin
  n:=a; a:=b; b:=n;
end;

{****************** PBoxPaint ****************}
procedure TForm1.PBoxPaint(Sender: TObject);
var
  i:integer;
  Rad:integer;
  CosA1,SinA1,CosA2,SinA2:extended;
  sign:Integer;
  LX,RX,TY,BY,midx,midy:integer;
  midangle:extended;
  delta,ds,de, fillfrom:integer;
  begin
    with pbox.canvas do
    begin
      case drawmode of
        sunlines:  brush.color:=clblue;
        moonlines: brush.color:=clblue;
        analemma:
          begin
            if shadowchecked then
            begin
              brush.color:=$00404080;
            end
            else brush.color:=$00DEC847 {clSkyblue};
          end;  
        none:brush.color:=clbtnface;
      end;
      pen.color:=brush.color;
      rectangle(rect(0,0,width,height));

      if drawmode=none then exit;
      pen.color:=clblack;
      case drawmode of
      sunlines, moonlines:
        begin
          If round(middayaz)=180 then sign:=+1 else sign:=-1;
          Rad:=75*pbox.width div 200; {radius}
          clen:=rad+5;
          pen.color:=clblack;
          ellipse(cx-Rad, cy-Rad, cx+Rad, cy+Rad);
          font.size:=12;
          font.style:=[fsbold];
          textout(cx-10, cy-Rad-25,'N');
          textout(cx-10, cy+Rad,'S');
          textout(cx-Rad-25, cy-10,'W');
          textout(cx+Rad+10, cy-10,'E');
          ellipse(cx-2,cy-2,cx+2,cy+2);
          moveto(cx,cy);
          CosA1:=cos(degtorad(bodyriseangle-90));
          SinA1:=sin(degtorad(bodyriseangle-90));
          CosA2:=cos(degtorad(bodysetangle-90));
          SinA2:=sin(degtorad(bodysetangle-90));
          lineto(trunc(cx+clen*CosA1),
              trunc(cy+clen*SinA1));
          moveto(cx,cy);
          lineto(trunc(cx+clen*cosA2),
                 trunc(cy+clen*sinA2));
          if drawmode=sunlines then
          begin
            (*  attempt to plot ellipse sun area with tip proportional to altitude,
              not working for southern hemisphere

            c:=Rad*trunc(middayalt) div 90;
            arc(cx-trunc(Rad*cosA1), cy-sign*c+2*sign*trunc(rad*sinA1),
              cx+trunc(Rad*cosA1), cy+sign*c,
              cx-trunc(rad*cosA1), cy+trunc(rad*sinA1),
              cx+trunc(rad*cosA1), cy+trunc(Rad*sinA2));
             *)
            brush.color:=clyellow;
            floodfill(cx,cy+5*sign,clblack,fsborder);
            brush.color:=clolive;
            floodfill(cx,cy-5*sign,clblack,fsborder);
          end
          else {draw moon phase}
          begin
            {sinfrac:=trunc(rad*sin(pi*moonphase)/4);}
            midangle:=(bodyriseangle+bodysetangle) /2;
            Cosa1:=cos(degtorad(midangle-90));
            sina1:=sin(degtorad(midangle-90));
            midx:=trunc(cx+rad*cosA1/2);
            midy:=trunc(cy+rad*SinA1/2);
            {make the radius of the crescent vary from "rad/4" down to 0 as moonphase
            varies from 0 to 1/2 and then back to "rad/4" as phase goes to 1}
            delta:=trunc(rad*abs(moonphase-0.5) /2);
            {myblack:=clblack;}
            brush.color:=$C0E0E0; {B-G-R value $C0E0E0 = light GOLD}
            Lx:=midx-rad div 4;
            ty:=midy-rad div 4;
            Rx:=midx+rad div 4;
            by:=midy+rad div 4;
            ellipse(Lx,TY,RX,By); {draw the moon}
            pen.color:=clblack;
            ds:=ty-1;  {set arc start and end points}
            de:=by+1;
            if waxing then {increasing moon}
            begin
              {x coordinate for floodfill to black-out left side for waxing moon}
              fillfrom:=lx+2;
              {arc draws counter-clockwise, so to draw right half of ellipse, start at bottom}
              if moonphase<0.5 then swap(ds,de);
            end
            else {waning (decreasing) moon}
            begin
              fillfrom:=rx-2; {set right side point for floodfill}
              {same thing - waning moon with over 50% showing, draw right portion of ellipse}
              if moonphase>0.5 then swap(ds,de)
            end;
            if delta>1  {draw the arc dividing light and dark portions of the moon}
            then arc(midx-delta,ty,midx+delta,BY,midx,ds,midx,de)
            else {ellipse too narrow to draw, use a line}
            begin
              moveto(midx,ty);
              lineto(midy,by);
            end;
            brush.color:=clblack;
            If moonphase<0.99 then floodfill(fillfrom,midy,clblack,fsborder);
          end;
        end;

        analemma:
        if length(anpoints)>0 then
        begin
          if shadowchecked then pen.color:=clblack
          else pen.color:=clyellow;
          with anpoints[high(anpoints)] do moveto(x,y);
          for i:=low (anpoints) to high(anpoints) do
          with anpoints[i] do lineto(x,y);
          {draw current sun position}
          pen.color:=clyellow;
          brush.color:=clyellow;
          ellipse(anplotx-3,anploty-3,anplotx+3,anploty+3);
          {Add direction Letters}
          font.color:=clWhite;
          brush.color:=clBlue;
          textout(cx,2,'Higher');
          textout(cx,pbox.height-14,'Lower');
          textout(2,cy,'<-E');
          textout(pbox.width-30,cy,'W->');
        end;
      end; {case}
  end;
end;

{********* LongEdtExit *********}
procedure TForm1.LongEdtExit(Sender: TObject);
{Autoset the time zone when longitude changes}
var W:extended;

begin
  if strtoangle(longedt.text,W) then
  begin
    if ewrgrp.itemindex=1 then W:=-w;
    If (W<>astro.lonlat.x) then tzbox.itemindex:=12+trunc(round(w) / 15); {guess 15 degrees per time zone}
  end;
end;

{********** TstBtnClick **********}
procedure TForm1.TstBtnClick(Sender: TObject);
begin
  with tconverttest do
  begin
    DatePicker.date:=self.datepicker.date;
    TZBox.itemindex:=self.tzbox.itemindex;
    NSRGrp.itemindex:=self.NSRGrp.itemindex;
    EWRGrp.itemindex:= self.EWRGrp.itemindex;
    LatEdt.text:=self.LatEdt.text;
    LongEdt.text:=self.LongEdt.text;
    DLSRGrp.itemindex:= self.DLSRGrp.itemindex;
    TimeIn.time:= Timepicker.time;
    with latestpoint do
    begin
      if coordtype in [ctRADecl,ctHADecl]
      then xinedt.Text:=hourstostr24(x)
      else xinedt.Text:=angletostr(x,astro.DecimalFormat);
      yinedt.text:=angletostr(y,astro.DecimalFormat);
      CoordInRGrp.itemindex:=ord(coordtype);
    end;
    top:=self.top;
    left:=self.left;
    showmodal;
  end;
end;

{*********** EclipseBtnClick *********8}
procedure TForm1.EclipseBtnClick(Sender: TObject);
var
  Eclipserec:TEclipseRec;
  MoonAdd:TMoonEclipseAdd;
  Dummy:TDateTime;
begin
  if Getbasedata then
  with memo1, lines, Eclipserec, MoonAdd do
  begin
    Astro.Eclipse('L', Astro.Adate, Eclipserec, MoonAdd);
    CurrentDisplayRtn:=EclipseBtnClick;
    cleardisplay;
    add('LUNAR ECLIPSE - '+msg );
    add('');
    if status<1 {3} then
    begin
      add('Time of max coverage:'+tab
           +astro.GetPrintDatetime(ttUT,DisplayTimeType,MaxEclipseUtime,true, Dummy)
                 +' ('+GetSTimeName(displayTimeType)+')');
      add('Maximum coverage:'+tab+tab+ inttostr(Trunc(100*Magnitude))+'%');
      add('');
      add('Penumbral phase begins:'+tab
              +astro.GetPrintDatetime(ttUT,DisplayTimeType,FirstContact,true, Dummy)
                 +' ('+GetSTimeName(displayTimeType)+')');
      add(tab+tab+ 'Ends: '+tab
              +astro.GetPrintDatetime(ttUT,DisplayTimeType,LastContact,true, Dummy)
                 +' ('+GetSTimeName(displayTimeType)+')');
      add('');
      If status =2 then add(' No Umbral phase ')
      else
      begin
        add('Umbral phase begins:'+tab
               +astro.GetPrintDatetime(ttUT,DisplayTimeType,UmbralStartTime,true, Dummy)
                 +' ('+GetSTimeName(displayTimeType)+')');
        add(tab+tab+'Ends:'+tab
            +astro.GetPrintDatetime(ttUT,DisplayTimeType,UmbralEndTime, true,Dummy)
                 +' ('+GetSTimeName(displayTimeType)+')');
        add('');
        If magnitude<1  {status =1} then
        add('     ** No total phase')
        else
        begin
          add('Total phase begins:        '+tab
             +astro.GetPrintDatetime(ttUT,DisplayTimeType,TotalStartTime,true, Dummy)
                 +' ('+GetSTimeName(displayTimeType)+')');
          add(tab+tab+'Ends:'+tab
          +astro.GetPrintDatetime(ttUT,DisplayTimeType,TotalEndTime,true, Dummy)
                 +' ('+GetSTimeName(displayTimeType)+')');
        end;
      end;
    end;
  end;
  Astro.Eclipse('S', Astro.Adate, EclipseRec, Moonadd);
  with memo1, lines, Eclipserec do
  begin
    add('');
    add('SOLAR ECLIPSE - ' + msg);
    if status=0 then
    begin
      add('Time of max coverage:'+tab
          +astro.GetPrintDatetime(ttUT,DisplayTimeType,MaxEclipseUTime,true, Dummy)
                 +' ('+GetSTimeName(displayTimeType)+')');
      add('Maximum sun coverage:'+ tab+inttostr(Trunc(100*Magnitude))+'%');
      add(tab+tab+ 'Begins:  ' +tab
        +astro.GetPrintDatetime(ttUT,DisplayTimeType,FirstContact,true, Dummy)
                 +' ('+GetSTimeName(displayTimeType)+')');
      add(tab+tab+ 'Ends:    '+tab
         +astro.GetPrintDatetime(ttUT,DisplayTimeType,LastContact,true, Dummy)
                 +' ('+GetSTimeName(displayTimeType)+')');
    end;
  end;
end;

{********** SelectTimeOptClick ************}
procedure TForm1.SelectTimeOptClick(Sender: TObject);
begin
  if sender is tmenuitem then tmenuitem(sender).checked:=true;
  If      LocalCivilTime1.checked then displayTimeType:=ttlocal
  else if Universaltime1.checked then  displayTimeType:=ttUT
  else if GreenwichSiderealtime1.checked then  displayTimeType:=ttGST
  else if LocalSidereal1.checked then  displayTimeType:=ttLST;
  If shadowchecked then AntypeGrp.itemindex:=0
  else if CameraSouthChecked then AntypeGrp.itemindex:=1
  ; //else AntypeGrp.itemindex:=2;
  BasedataChange(sender);
end;

{************* PlanetBoxClick *********}
procedure TForm1.PlanetBoxClick(Sender: TObject);
var
  planetLocRec:TPlanetLocrec;
  rpoint:TRPoint;
begin
  if getbasedata
    and (planetbox.itemindex >= ord(Mercury))
    and (planetbox.itemindex <= ord(Pluto))
  then
  with astro, memo1.lines, planetLocrec, planetBasedata do
  begin
    CurrentDisplayRtn:=PlanetBoxClick;
    cleardisplay;
    Planets(TPlanet(planetbox.itemindex),PlanetLocrec);
    Add('********************************');
    Add(Name + ' as of ' +DateTimetostr(Adate+localtime));
    if planetbox.itemindex=ord(Pluto)
    then Add('   No generalized data for Pluto is available')
    else
    begin
      add('HelioCentric Coordinates');
      add('  Ecliptic Longitude.................'
                + angletostr(HelioCentricLonLat.X,DecimalFormat));
      add('  Ecliptic Latitude.................'
                + angletostr(HelioCentricLonLat.Y,DecimalFormat));

      add('   Radius Vector.....................'+format('%9.6F',[RadiusVector]));
      add('True GeoCentric Coordinates');
      GeoEclLonLat.Coordtype:=ctEclLonLat;
      DisplayCoordsAsType(GeoEclLonLat);
      (*
       add('  Ecliptic Longitude.................'
                + angletostr(GeoEclLonLat.X));
      add('  Ecliptic Latitude.................'
                + angletostr(GeoEclLonLat.Y));
      *)
      add('UnCorrected Distance form Earth..............'
          + format('%9.6F',[UncorrectedEarthDistance]));
      {RPoint:=astro.convertcoord(ctEclLonLat,ctRadecl,GeoEclLonLat); }
      add('Appartent coordinates');
      ApparentRADecl.Coordtype:=ctRaDecl;
      rpoint:=apparentRadecl;
      rpoint.x:=15*rpoint.x; {change hours to angle}
      DisplayCoordsAsType(rpoint);
      add('Base Data....');
      Add('   Mean Longitiude:................. '+ chr(vk_tab)+angletostr(meanlon,DecimalFormat));
      Add('   Daily motion in Mean Longitude:...' +chr(vk_tab)+ angletostr(MeanLonMotion,DecimalFormat));
      Add('   Longitude of Perihelion:......... '+chr(vk_tab)+ angletostr(LonOfPerihelion,DecimalFormat));
      Add('   Eccentricity:..........................'+chr(vk_tab)+ format('%9.6f',[Eccentricity]));
      Add('   Inclination:............................ '+chr(vk_tab)+ angletostr(Inclination,DecimalFormat));
      Add('   Longitude of Ascending Node:..... '+chr(vk_tab)+ angletostr(LonAscendingNode,DecimalFormat));
      Add('   Lemgth of Semi-Major Axis (AU):...'+chr(vk_tab)+ format('%9.6f',[SemiMajorAxis]));
      Add('   Angular Diameter at 1 AU:........ '+chr(vk_tab)+ angletostr(AngularDiameter,DecimalFormat));
      Add('   Visual Magnitude:................ '+chr(vk_tab)+ format('%6.4f', [Magnitude]));               
      memo1.selstart:=0; memo1.sellength:=0;  {force top of text to be visible}
    end;
  end;
end;

type
  TsystemTime = record
                wYear   : Word;
                wMonth  : Word;
                wDayOfWeek      : Word;
                wDay    : Word;
                wHour   : Word;
                wMinute : Word;
                wSecond : Word;
                wMilliSeconds: Word;
                reserved        : array [0..7] of char;
        end;

    TTimeZone = record
         Bias:Int64;
         StdName:array[1..32] of char;
         StdDate:TSystemTime;
         StdBias:Int64;
         DLName:array[1..32] of char;
         DLDate:TSystemTime;
         DLBias:Int64;
       end;


{************* Button1Click ************}
procedure TForm1.Button1Click(Sender: TObject);
 var
   TZInfo:TTimeZoneInformation;
   DL,tz, dlbias:Integer;
   dt:TDatetime;
begin
  DL:=getTimeZoneInformation(TZinfo);
  TZ:=-trunc(TZinfo.bias/60);
  if (TZ>=-12) and (TZ<=11) then TZBox.itemindex:=TZ+12
  else
  begin
    showmessage('Unrecognized Windows time zone: '+inttostr(TZ)+', 0 assumed');
    TZBox.itemindex:=12;
  end;

   DlBias:=-trunc(TZInfo.daylightbias/60);
   if DL= Time_Zone_ID_Daylight then
   begin
     If (dlbias>=0) and (dlbias<=2) then DLSRGrp.itemindex:=DLBias
     else
     begin
       showmessage('Windows Daylight saving offset not 0, 1, or 2, hours, 0 assumed');
       dlsrgrp.itemindex:=0;
     end;
   end;
   {convert cureent datetime to specified time type}
   astro.getprintdatetime(ttlocal,TDtType(timebox.itemindex),now,true,dt);
   timepicker.time:=frac(dt);
   datepicker.date:=int(dt);
   If @currentDisplayRtn<>nil then CurrentDisplayRtn(Sender);
end;

{************* DisplayCoordsAsType **********8}
procedure TForm1.DisplayCoordsAsType(angle:TRPoint);

begin
  LatestPoint:=astro.convertcoord(angle.CoordType, displayAngletype, angle);

  with memo1.lines, astro  do
  case LatestPoint.CoordType of

    ctUnknown:
      Begin
       add('  Unknown type ......................'
                + angletostr( LatestPoint.X,DecimalFormat));
       add('  Unknown type ......................'
                + angletostr(LatestPoint.Y,DecimalFormat));
      End;

    ctAzAlt:
      Begin
        add('  Azimuth ..........................'
                + angletostr(LatestPoint.X,DecimalFormat));
        add('  Altitude .........................'
                + angletostr(LatestPoint.Y,DecimalFormat));
      End;
    ctEclLonLat:
      Begin
        add('  Ecliptic longitude ..............'
                + angletostr(LatestPoint.X,DecimalFormat));
        add('  Ecliptic latitude ................'
                + angletostr(LatestPoint.Y,DecimalFormat));
      End;
    ctRADecl:
     Begin
        add('  Right Ascension (HMS).............'
                + hourstoStr24(LatestPoint.X/15));
        add('  Declination ......................'
                + angletostr(LatestPoint.Y,DecimalFormat));
      End;
    ctHADecl:
       Begin
        add('  Hour Angle (HMS)..................'
                 + HoursToStr24(LatestPoint.X/15));
        add('  Declination ......................'
                + angletostr(LatestPoint.Y,DecimalFormat));
      End;
    ctGalLonLat:
       Begin
        add('  Galactic Longitude ...............'
                + angletostr(LatestPoint.X,DecimalFormat));
        add('  Galactic Latitude.................'
                + angletostr(LatestPoint.Y,DecimalFormat));
      End;
  end;

end;

{*********** AngleOptionClick *********}
procedure TForm1.AngleOptionClick(Sender: TObject);
begin
  if sender is tmenuitem then TMenuitem(sender).checked:=true;
  If EclOpt.checked then displayAngleType:=ctEclLonLat
  else if AzAltOpt.checked then displayAngleType:=ctAzAlt
  else if RADeclOpt.checked then displayAngleType:=ctRaDecl
  else if HADeclOpt.checked then displayAngleType :=ctHaDecl
  else if GalOpt.checked then displayAngleType:=ctGalLonLat;
  BaseDatachange(sender);
end;

{*********** TimeBoxChange *********}
procedure TForm1.TimeBoxChange(Sender: TObject);
var
  dt:TDateTime;
begin
  astro.getprintdatetime(currentTimetype,tDtType(timebox.itemindex),
                         int(datepicker.date)+frac(timepicker.time),true,dt);
  currenttimetype:=TDtType(timebox.itemindex);
  datepicker.date:=int(dt);
  timepicker.time:=frac(dt);
  BaseDataChange(sender);
end;

{********* PlanetItem *********8}
procedure TForm1.PlanetItemClick(Sender: TObject);
begin
  PlanetBox.itemindex:=TMenuItem(sender).tag;
  PlanetBoxClick(sender);
end;

{********** BaseDataChange **********}
procedure TForm1.BaseDataChange(Sender: TObject);
begin
   If @currentDisplayRtn<>nil then CurrentDisplayRtn(Sender);
end;

{********** FormClick *********}
procedure TForm1.FormClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

{********* FormResize ***********}
procedure TForm1.FormResize(Sender: TObject);
begin
  {showmessage('Resizing');}
end;



{********* Exi1Click ******}
procedure TForm1.Exit1Click(Sender: TObject);
begin
 close;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

(*
procedure TForm1.UseShadowScaleClick(Sender: TObject);
begin
  DrawAnalemma(Astro,true);
end;
*)
{******** DMSFmtClcik ********}
procedure TForm1.DMSFmtClick(Sender: TObject);
{set Angle format to Degrees, Minutes, Seconds format}
begin
  astro.DecimalFormat:=false;
  form1.refresh;
end;

{********* DecimalDegreesClick ***********}
procedure TForm1.DecimalDegrees1Click(Sender: TObject);
begin
  astro.DecimalFormat:=true;
  form1.refresh;
end;

procedure TForm1.AnallemmPanelExit(Sender: TObject);
{Stop animatiomation if running and hide the analemma panel}
begin
  If animatebtn.caption[1]='P' then animateBtnClick(sender); {Stop animation}
  AnalemmaPanel.visible:=false;
end;

End.




