Unit U_TSP3;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

 {Copyright 2002, 2011, 2017 Gary Darby, www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }                                                              

 {The Traveling Salesman Problem - given a set of random US cities, find the
  shortest path connecting all of the cities.   This program allows human user
  to define their best attemnpt at a short path and then see the computer solution}

 {Version 2 adds the ability to select a starting city for "one way" itineraries and
  several other minor enhancements.}

 {Version 3 requires that cities be located based on latitide & longitude in the
 "Citylist.txt" file.  The first two cities in the file must be manually located
 one time on the screen map by double clicking on the appropriate locations. City
 names and pixel locations are saved in file "TSP.ini" which is automatically
 checked at startup time.  Users may now define itineraries to be routed by
 changing the "Mouse click action" radio group box.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, ShellAPI, DateUtils, ComCtrls, Inifiles,
  Buttons
  ,mathslib
  ,UcomboV2
  ;

type
  WideChar=Char;
  TModes=(Userpathsearch, ExhPathSearch, HeurPathSearch, UserDefineItinerary,
            AutoDefineItinerary ,{changecities,} unknown);
  TWaitFlag=(Wait, pointadded, Cancel);
  TCoordObj=class(TObject)
    cityname:string;
    StateId:String;
    x,y:integer;
    Lat:extended;
    Long:extended;
    visited:boolean;
  end;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    IntroSheet: TTabSheet;
    TabSheet2: TTabSheet;
    Image1: TImage;
    MilesLbl: TLabel;
    ShortMilesLbl: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SearchTimeLbl: TLabel;
    Userslist: TListBox;
    Programslist: TListBox;
    Panel1: TPanel;
    Label1: TLabel;
    ItineraryBtn: TButton;
    CityCountSpinEdit: TSpinEdit;
    RoundtripBox: TCheckBox;
    ModeGrp: TRadioGroup;
    Progressbar: TProgressBar;
    Timer1: TTimer;
    ScrollBox1: TScrollBox;
    RichEdit1: TMemo;
    Panel2: TPanel;
    Memo2: TMemo;
    CityLbl: TLabel;
    SaveDialog1: TSaveDialog;
    EstTimeLbl: TLabel;
    RichEdit2: TMemo;
    OpenDialog1: TOpenDialog;
    StaticText3: TStaticText;
    StopBtn: TButton;
    SaveBtn: TButton;
    ShortestPathBtn: TButton;
    HeuristicBtn: TButton;
    ResetPathBtn: TButton;
    ResetCitiesBtn: TButton;
    InstructLbl: TLabel;
    LocLbl: TLabel;
    MaxtimeGrp: TRadioGroup;
    Memo1: TMemo;

    procedure FormActivate(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
                            Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ItineraryBtnClick(Sender: TObject);
    procedure ResetPathBtnClick(Sender: TObject);
    procedure ShortestPathBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure HeuristicBtnClick(Sender: TObject);
    procedure CityCountSpinEditChange(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure RoundtripBoxClick(Sender: TObject);
    procedure ResetCitiesBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ModeGrpClick(Sender: TObject);
    procedure ProgramslistClick(Sender: TObject);
    procedure StaticText3Click(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
  public
    mode:TModes;
    CityList:TStringList;
    Listtoshow:TStringlist;  {list to show progress while finding path}
    mapname:string; {name of current map file}
    fname:string; {name of current citylist file}
    coordobj:TCoordObj;
    b:TBitmap;
    ShortPathPoints, UserpathPoints:array of TCoordobj; {ordered list of cities on path}
    ShortPathLength, UserPathLength: integer;
    milescale:single;
    starttime,runtime:TDatetime; {start time of current shortest path search}
    itineraryset:boolean;
    Scalingrec:TMercScalingrec;
    uselatlong:boolean;
    worklist:TStringlist;
    Waitflag:TWaitFlag; {flag set while waiting for user to locate a city}
    newCityPoint:TPoint;
    loopcount,maxcount:int64;
    thousandsep, decimalsep:char;
    procedure showcity(coordobj:TCoordObj; newcolor:TColor);
    procedure SaveList;
    function  oncity(x,y:integer; var name:string; var index:integer):boolean;
    procedure showcities(list:TStringlist);
    procedure drawuserpath;
    procedure drawshortpath;
    procedure redrawall;
    function recalcscale:boolean;
    function ScaleSetOK:boolean;
    function Getdist(c0,c1:TCoordobj):extended;
    function validCitylocRec(s:string; var c:TCoordobj):boolean;
    function getplotpoint(city:string; var p:TPoint):boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  U_CityDlg3;


const maxpoints=51;
  SolveitMsg:string='Click cities to travel a solution path.'
            +  'or use a search button to see program''s shortest path results';
  SelectCitiesMsg:string='Click on a city to start or continue your route. '
  +' Right click to finish route definition.  '
  +'Alternatively, click the "Generate" button to  create a random city set.';

{*********** RoundTo10 **************}
function roundto10(x:integer):integer;
begin
  result:= 10*((x+5) div 10)
end;

{****************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
var
  list:TStringList;
  i:integer;
  s:string;
  mr:integer;
  n:integer;
  ini:TIniFile;
  c0,c:TCoordobj;
  scaleset:boolean;
  p:TPoint;
  defaultdir:string;

    {---- Checkscaling - used for debugging ----}
    procedure checkscaling(c:TCoordobj;scalingrec:TMercScalingrec);
    var
      chkxy:TPoint;
      chklonglat:TRealpoint;
    begin
      with programslist,items do
      with c do
      begin
        add(format('%s  x:%d, y:%d, Long:%6.2f, lat:%6.2f',[cityname, x,y,long,lat]));
        chklonglat:=plotpttolonglat(point(x,y),scalingrec);
        with chklonglat do
        add(format('X Y to long lat, Long:%6.2f, lat:%6.2f',[x,y]));
        chkxy:=longlattoplotpt(long,lat,scalingrec);
        with chkxy do
        items.add(format('long lat to xy, X:%d, Y:%d',[x,y]));
      end;
    end;

begin  {formactivate}
  {$IfDef compilerversion>15}
  ThousandSep:=formatsettings.thousandSeparator;
  DecimalSep:=formatsettings.DecimalSeparator;;
{$ELSE}
  ThousandSep:=ThousandSeparator;
  DecimalSep:=DecimalSeparator;;
{$IFEND}
  randomize;
  stopbtn.BringToFront;
  savedialog1.initialdir:=extractfilepath(application.ExeName);
  panel2.bringtofront;
  panel2.visible:=false;
  worklist:=TStringlist.create;
  ini:=TInifile.Create(extractfilepath(application.exename)+'TSP3.ini');
  scaleset:=false;
  mode:=unknown;
  CityList:=TstringList.Create;
  ListToShow:=TStringList.create;
  //ListToShow.sorted:=true;{reomved sort so that random paths appear in order as created}
  b:=TBitmap.create;
  defaultdir:=extractfilepath(application.exename);
  mapname:=ini.readstring('Files','Mapname', defaultdir+'us-outln.bmp');
  if (not fileexists(mapname)) and (extractfilepath(mapname)<>defaultdir)
  then fname:=defaultdir+extractfilename(mapname);

  if not fileexists(mapname) then
  with opendialog1 do
  begin
    Title:='Enter name of Mercator scale map';
    initialdir:=extractfilepath(application.exename);
    filename:=mapname;
    if execute then mapname:=filename;
  end;
  if not fileexists(mapname) then
  begin
    showmessage('No map file loaded, program halted');
    halt;
  end
  else ini.WriteString('Files', 'MapName', mapname);

  image1.picture.loadfromfile(mapname);
  with image1 do
  begin
    height:=picture.height;
    width:=picture.width;
  end;
  (*
  b.LoadFromFile(mapname);
  with image1 do
  begin
    canvas.stretchdraw(rect(0,0,width,height),b);
  end;
  (*
  with image1 do
  begin
    height:=picture.height;
    width:=picture.width;
   end;
  *)
  with image1 do
  begin
   b.width:=width;
   b.height:=height;
  end;
  b.assign(image1.picture);

  fname:=ini.ReadString('Files','Citylist', defaultdir+'citylist.txt');

  if (not fileexists(fname)) and (extractfilepath(fname)<>defaultdir)
   then fname:=defaultdir+extractfilename(fname);

  if not fileexists(fname) then
  with opendialog1 do
  begin
    initialdir:=defaultdir;
    filename:=fname;
    if execute then fname:=filename;
  end;
  if not fileexists(fname) then
  begin
    showmessage('No City List file loaded, program halted');
    halt;
  end
  else ini.WriteString('Files', 'Citylist', fname);

  {Both files loaded OK, carry on!}
  list:=TStringlist.create;
  list.loadfromfile(fname);
  citydlg.modified:=false;
  for i :=0 to list.count-1 do
  begin
    s:=list[i];
    c:=Tcoordobj.create;
    if validCityLocrec(s, c) then
    begin
      if (i=0) or (i=1) then
      begin
        n:=ini.readinteger('ScalePoints',c.Cityname,0);
        if (n=0) {(and (getplotpoint(c.cityname,p))}
        then
        begin
          //showmessage('Missing pixel scaling values for one or both of the scaling cities'
                    //            +#13+'See documentation for scaling instructions');
          showmessage('Missing pixel scaling values for one or both of the scaling cities'
                      +#13 + 'Dynamic re-scaling not yet supported'
                      +#13 + 'Download TSP3.ini file again, or email feedback@delphiforfun.org for help');
          halt;
          ini.writeinteger('ScalePoints',c.cityname,1000*p.x+p.y);
          c.x:=p.x;
          c.y:=p.y;
        end
        else {we have scalepoints from inifile to decode}
        begin
          c.x:=n div 1000;
          c.y:=n mod 1000;
        end;
        citylist.addobject(format('%4d%4d',[roundto10(c.x),roundto10(c.y)]),c);
        listtoshow.addobject(format('%4d%4d',[roundto10(c.x),roundto10(c.y)]),c);
        showcity(c,clblack);
        if i=1 then
        begin
          c0:=TCoordobj(citylist.objects[0]);
          if ((c.x>0) or (c.y>0))  {some non-zero value assigned to each of
                                    1st 2 cities}
           and ((c0.x>0) or (c0.y>0))
          then {make scaling factors}
          begin
            scalingrec:=mercscaling(c0.long,c0.lat, c.long, c.lat,
                                     c0.x,c0.y,c.x,c.y);
            scaleset:=true;
          end;
        end;
      end
      else
      begin
        if not scaleset then
        begin
          showmessage('Scaling not entered for 1st two cities, program halted');
          halt;
        end
        else
        begin
          p:=longlatToplotpt(c.long,c.lat,scalingrec);
          c.x:=p.x;
          c.y:=p.y;
          //if i=3 then checkscaling(c,scalingrec);
          citylist.addobject(format('%4d%4d',[roundto10(c.x),roundto10(c.y)]),c);
          listtoshow.addobject(format('%4d%4d',[roundto10(c.x),roundto10(c.y)]),c);
          showcity(c,clblack);
        end;
      end;
    end;
  end;
  list.free;

  if reCalcScale then
  begin
    uselatlong:=true;
  end
  else
  begin
    showmessage('Scaling not set');
    milescale:=6.7335;
    mr:=messagedlg(
        'No lat-long calcs possible until lat-long info is entered in 1st 2 city records'
         +#13+'Would you like to do that now?', mtconfirmation,mbyesnocancel,0);
    If (mr=mryes) then  uselatlong:=scalesetOK;
    if not uselatlong then halt;
  end;
  setlength(UserpathPoints, CityCountSpinEdit.maxvalue+2);
  setlength(shortpathpoints, CityCountSpinEdit.maxvalue+2);
  stopbtn.bringtofront; {we need the stop button in front to hide other buttons,
                         but hiding them at design time is not nice, so we do it
                         at runtime}
  ResetCitiesBtnClick(sender);
  //modegrpclick(sender);
  //showcities(citylist);
  ini.Free;
end;


{************ ValidCityLocRec **********}
function TForm1.validCitylocRec(s:string; var c:TCoordobj):boolean;
var
  w:string;
  xx,yy:extended;
  errcode,count:integer;
  i:integer;
begin
  result:=false;
  worklist.clear;
  count:=ExtractStrings([','],[' ',#9],pchar(s),worklist);
  if count<4 then exit;

  for i:=0 to worklist.count-1 do
  begin
    w:=worklist[i];
    if w[1]='"' then delete(w,1,1);
    If w[length(w)]='"' then delete (w,length(w),1);
    worklist[i]:=w;
  end;


  if (length({city}worklist[0])=0) or ({stateId}length(worklist[1])=0) then exit;
  val(worklist[2], yy,errcode);
  if errcode=0 then val(worklist[3],xx,errcode);
  if errcode<> 0 then exit;
  with c do
  begin
    cityname:=worklist[0];
    Stateid:=worklist[1];
    lat:=yy;
    long:=xx;
    result:=true;
  end;
end;

{************ GetPlotPoint **************}
function TForm1.getplotpoint(city:string; var p:TPoint):Boolean;
{Associate a city name with a point on the map to establish scaling parameters}
var
  s:string;
  cnt:integer;
begin
 // exit;
  with memo2, lines do
  begin
    result:=false;
    panel2.Visible:=true;
    panel2.bringtofront;
    clear;
    s:='Two scaling points must be manually located to determine the scaling'
       +' for city display.  For best accuracy, the to cities should be located'
       +' near diagonally opposite corners of the map (Northeast & Southwest or'
       +' Northwest and Southeast).  The city location records must be the first'
       +' two lines in the city location list input file.';

    add(s);
    add('Locate '+city + ' now by double clicking on its location on the map, then click the OK button below to continue.');
    WaitFlag:=Wait;
    cnt:=0;
    application.processmessages;
    repeat
      sleep(500);
      inc(cnt);
      application.ProcessMessages;
      if cnt>360 then waitflag:=cancel;
    until  (waitflag<>wait);
    panel2.Visible:=false;
    if waitflag=pointadded then
    begin
      result:=true;
      p:=newcitypoint;
    end;
  end;
end;


{******************** Image1MouseMove **************}
procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var cname:string;
    index:integer;
begin
   if Oncity(x,y ,cname, index) then
   with citylbl do
   begin
     left:=x+image1.left+5;
     top:=y+image1.top-13;
     caption:=cname;
     visible:=true;
   end
   else citylbl.visible:=false;
   LocLbl.caption:=format('X: %d Y: %d',[x,y]);
end;

{************* RecalcScale *********}
function TForm1.recalcscale:boolean;
   var
     i:integer;
     c0,c1:TCoordobj;
     rp:TRealPoint;
   begin
      result:=true;
     (*
     C0:=Tcoordobj(citylist.objects[0]);
     C1:=Tcoordobj(citylist.objects[1]);
     if ((c0.lat<>0) or (c0.long<>0 ))
         and ((c1.lat<>0) or (c1.long<>0))
         and (c0.lat<1000) and (c1.lat<1000) then
     begin
       result:=true;
       Scalingrec:=MercScaling(C0.long,C0.lat,C1.long,C1.lat,c0.x, c0.y,c1.x,c1.y);
       for i:=2 to citylist.count-1 do
       with TCoordobj(citylist.Objects[i]) do
       begin
         rp:=PlotPtToLongLat(point(x,y),scalingrec);
         long:=rp.x;
         lat:=rp.y;
       end;

       milescale:=distance(c0.long,c0.lat,c1.long,c1.lat,0)/sqrt(sqr(c0.x-c1.x)+sqr(c0.y-c1.y));
     end
     else result:=false;
     *)
    end;

{************* ScaleSetOK **********}
function TForm1.ScaleSetOK:boolean;
begin
  result:=false;
  showmessage('Dynamic lat/long scale setting not yet implemented'
              +#13+'so, for now, manually edit the citylist.str file'
              +#13+'adding latitude and laongitude to 2 city records which are widely'
              +#13+'diagonally.  Make these the first 2 records in the file.  Format for'
              +#13+'lat & long values have is ddd:mm:ssX where ''X'' is ''N'' or ''S'' for'
              +#13+'latitudes and ''E'' or ''W'' for longitudes.  Latitudes appear in columns'
              +#13+'42 to 51 and Longitudes 53 to 64.');
end;

{********************** IMage1MouseUp ***************}
procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i:integer;
  key1:string;
  index1,index2:integer;
  found:boolean;
  d:extended;
  s:string;
  c:TCoordObj;
  longlatpt:TRealPoint;
  plotxy:tPoint;

    function InUserpath(C:TCoordObj):integer;
    var
      i:integer;
    begin
      result:=-1;
      for i:=1  to userpathlength do
      begin
        if userpathpoints[i]=c then
        begin
          result:=i;
          break;
        end;
      end;
    end;

    procedure closeItinerary;
    var
      i:integer;
     begin
       modegrp.itemindex:=0;
       listtoshow.clear;
       for i:=1 to UserPathLength do
       with  userpathPoints[i] do
       begin
         key1:=format('%4d%4d',[roundto10(x),roundto10(y)]);
         listtoshow.addobject(key1,userpathPoints[i]);
         showcities(listtoshow);
         UserPathLength:=0;
         userslist.clear;
         itineraryset:=true;
       end;
     end;

begin
   {round coordinates to 10 pixel increments for list key building}
   citydlg.key:=format('%4d%4d',[roundto10(x),roundto10(y)]);
   case mode of

   Userpathsearch: {add a point to (or remove points from) a user defined solution path}
     begin
       if itineraryset then
       begin
         key1:=format('%4d%4d',[roundto10(x),roundto10(y)]);
         //if listtoshow.find(key1, index1) then
         index1:=listtoshow.IndexOf(key1);
         if index1>=0 then
         begin {mouse is positioned on a city }
           with tCoordobj(listtoshow.objects[index1]) do
           begin
             if not visited then
             begin {add a city to path}
               visited:=true;
               inc(UserPathLength);
               UserpathPoints[UserPathLength]:=tCoordobj(listtoshow.objects[index1]){point(x,y)};
               drawuserpath;

               if (roundtripbox.checked) and (UserPathLength=listtoshow.count)
               then {all cities visited and round trip option set - close the loop}
               begin
                 visited:=true;
                 inc(UserPathLength);
                 UserpathPoints[UserPathLength]:=UserpathPoints[1];
                 d:=getdist(UserpathPoints[UserPathLength-1], UserpathPoints[UserPathLength]);
                 s:=format('%s %6.1f',[UserpathPoints[UserPathLength].cityname,d]);
                 userslist.items.addobject(s, UserpathPoints[UserPathLength]);
                 drawuserpath;
               end;
             end
             else
             begin  {clicked on existing path point, erase back to here}
               i:=UserPathLength;
               while UserpathPoints[i].cityname<>tCoordobj(listtoshow.objects[index1]).cityname do
               with UserpathPoints[i] do
               begin
                 {Don't unmark visited if city was the closure of a path}
                 if userpathpoints[i]<>userpathpoints[1] then visited:=false;
                 dec(UserPathLength);
                 UserpathPoints[i]:=nil;
                 dec(i);
                 with userslist.items do  delete(count-1);
               end;
               redrawall;

             end;
           end;
         end;
       end
       else
       begin
         showmessage('No itinerary route defined.  To define a route, click "Generate random.." button or "Define itinerary" radio button in the "Mouse Actions" box.');
       end;
     end;
   UserDefineItinerary:{add a point to a user selected city set}
     begin
       key1:=format('%4d%4d',[roundto10(x),roundto10(y)]);
       found:= listtoshow.find(key1, index1);
       index1:=listtoshow.IndexOf(key1);
       if index1>=0 then found:=true;
       if found then
       begin
         c:=TCoordobj(listtoshow.Objects[index1]);
         index2:=InUserPath(C);
         if (index2<0) or ((index2>=0) and (button=mbright)) then
         with c do {add a city to this itinerary or end route if city rightclicked)}
         begin
           if index2<0 then
           begin
             inc(UserPathLength);
             UserpathPoints[UserPathLength]:=c;
             drawuserpath;
           end;
           if button=mbright then
           begin {we are closing out the itininerary definition}
             closeitinerary;

           end;
         end
         else {city was found in list}
         begin {remove path cities back to this one}
           for i:=userslist.count-1 downto index2+1 do userslist.items.delete(i);
           UserPathLength:=index2{+1};
           showcities(listtoshow);
           drawuserpath;
         end;
       end
       else if button=mbright then closeitinerary;
     end; {defineUseritinerary}
   //(* {editing city record - not yet implemented.  Edit citylist.txt file manually for now}
   (*
   changecities:
     begin {define cities}
       with citydlg do index:=citylist.indexof(key);
       if citydlg.index<0 then
       begin {new entry}
         coordobj:=TCoordobj.create;
         with coordobj do
         begin
           cityname:='City name';
           if uselatlong then
           begin
             longlatpt:=plotpttolonglat(point(x,y),scalingrec);
             lat:=longlatpt.y;
             long:=longlatpt.x;
           end
           else
           begin
             lat:=0;
             long:=0;
           end;
         end;
       end
       else
       begin
         //citydlg.memo2.Clear;
         //citydlg.memo2.lines.add(format('Mouse Coordinates (%d,%d)',[x,y]));
         coordobj:=tcoordobj(citylist.objects[citydlg.index]);
         with CityDlg, coordobj do
         begin
           nameedt.text:=cityname;
           latedt.text:=angletostr10(lat,'N');
           longedt.text:=angletostr10(long,'W');

           with memo2 do
           begin
             lines.add(format('XY Coordinates (%d,%d)',[x,y]));
             if (lat<>0) or (long<>0) then
             begin
               lines.add(format('(Long,Lat) (%8.3f,%8.3f)',[long,lat]));
               plotxy:=LonglatToPlotPt(long,lat, scalingrec);
               lines.add(format('XY calculated from Long-Lat (%d,%d)',
                [plotxy.x,plotxy.y]));
             end
             else {calculate lat long from pixel coordinates}
             begin
               LongLatPt:=PlotPtToLonglat(point(x,y), scalingrec);
               long:=Longlatpt.x;
               lat:=Longlatpt.y;
               lines.add(format('Calculated Long-Lat (%8.3f,%8.3f)',[long,lat]));
             end;
           end;

         end;
         CityDlg.showmodal;
       end;
     end;
     *)
   end;{case}
 end;

{***************** drawuserpath *************}
procedure TForm1.drawuserpath;
var i:integer;
     miles:single;
     d:single;
     s:string;
begin
  begin
    miles:=0;
    with image1.canvas do
    begin
      pen.color:=clblack;
      pen.style:=psdash;
      pen.width:=2;
      brush.color:=clred;
      if mode=UserDefineItinerary then
      begin
        pen.style:=PSDot;//psSolid;
        pen.color:=clred;
        brush.color:=clyellow;
        with UserpathPoints[userpathlength] do ellipse(x-4,y-4,x+4,y+4);
        userslist.items.add(format('%s' ,[UserpathPoints[userpathlength].cityname]));
      end
      else
      begin {user's solution path}
        userslist.Clear;
        if UserPathLength>=1 then
        begin
          s:=format('From %s' ,[UserpathPoints[1].cityname]);
          userslist.items.addobject(s,UserpathPoints[1]);
          if UserPathLength>1 then
          begin
            moveto(UserpathPoints[1].x,UserpathPoints[1].y);
            for i:=2 to UserPathLength do
            with UserpathPoints[i] do
            begin
              d:=getdist(UserpathPoints[i-1], UserpathPoints[i]);
              s:=format('To %s %6.1f miles',[UserpathPoints[i].cityname,d]);
              userslist.items.addobject(s, UserpathPoints[i]);
              pen.color:=clblack;
              lineto(x,y);
              pen.color:=clred;
              brush.color:=clred;
              ellipse(x-4,y-4,x+4,y+4);
              miles:=miles+getdist(UserpathPoints[i-1],UserpathPoints[i]);
            end;
          end
          else
          begin
            pen.color:=clred;
            brush.color:=clred;
            with userpathpoints[1] do  ellipse(x-4,y-4,x+4,y+4);;
          end;  
          mileslbl.caption:=format('Path length %5.0f miles',[miles]);
          mileslbl.visible:=true;
        end
        else mileslbl.visible:=false;
      end;
    end;
  end;
end;

{********************* DrawShortpath *************}
procedure TForm1.drawShortPath;

var i:integer;
     miles:single;
     d:extended;
begin
  miles:=0;
  if shortpathlength>0 then
  begin
    programslist.clear;

    with image1.canvas do
    begin
      pen.color:=clred; //clyellow;
      //brush.color:=clred;
      pen.width:=4;
      //pen.style:=psdash;
      programslist.items.add(format('From %s',[shortpathpoints[1].cityname]));
      moveto(shortpathpoints[1].x,shortpathPoints[1].y);
      if shortpathlength>1 then
      for i:=2 to shortpathlength do
      begin
        lineto(shortpathPoints[i].x,shortpathPoints[i].y);
        d:=getdist(shortpathPoints[i-1], shortpathPoints[i]);
        with shortpathPoints[i] do
        programslist.items.add(format('To %s: %5.1f miles',[cityname,d]));
        miles:=miles+d;
      end;
    end;
    shortmileslbl.caption:=format('Shortest path length %5.0f miles',[miles]);
    shortmileslbl.visible:=true;
  end
  else if shortpathlength=0 then shortmileslbl.visible:=false;
end;

{****************** ShowCity ****************}
procedure TForm1.showcity(coordobj:TCoordObj; newcolor:TColor);
{Display a single city in given color at given coordinates}
begin
  with coordobj, image1.picture.bitmap.canvas  do
  begin
    brush.color:=newcolor;
    pen.color:=newcolor;
    ellipse(x-4,y-4,x+4,y+4);
  end;
end;

{******************** ShowCities **********}
procedure TForm1.showcities(list:TStringlist);
{Display all cities}
var i:integer;
    c:TColor;
begin
  image1.canvas.stretchdraw(rect(0,0,image1.width,image1.height),b);
  if (mode in [userpathsearch, exhpathsearch, autodefineitinerary])
  and  (not roundtripbox.checked) then  c:=CLRed else c:=clblack;
  showcity(tCoordobj(list.objects[0]), C);
  for i:=1 to list.count-1 do showcity(tCoordobj(list.objects[i]), CLBLACK)


end;

procedure TForm1.redrawall;
begin
   showcities(listtoshow);
   drawshortpath;
   drawuserpath;
end;

{******************** SaveList **************}
procedure TForm1.saveList;
var
  i:integer;
  list:TStringlist;
  s:string;
  backname:string;
  AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond:word;
begin
  list:=TStringlist.create;
  for i:=0 to citylist.count-1 do
  begin
    with TCoordobj(citylist.objects[i]) do
    begin
      s:=format('%4d%4d%32s %10s %10s',[x,y,cityname,angletostr10(lat,'N'),
                                       angletostr10(long,'E')]);
    end;
    list.add(s);
  end;

  DecodeDateTime(now, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
  backname:=format('CityBackup_%d_%d_%d_%d_%d_%d.txt',[Ayear,AMonth,Aday,AHour,AMinute,Asecond]);
  renamefile(fname,backname);
  list.savetofile(fname);
  list.free;
  CityDlg.modified:=false;
end;


{******************* OnCity ****************}
function TForm1.oncity(x,y:integer; var name:string; var index:integer):boolean;
{test if point (x,y) is on a city, if so return city name and set result true}
var
  key:string;
  //index:integer;
begin
  key:=format('%4d%4d',[roundto10(x), roundto10(y)]);  {round to nearest 10 pixels}
  //if listtoshow.find(key,index) then
  index:=listtoshow.IndexOf(key);
  if index>=0 then
  begin
    name:=TCoordobj( listtoshow.objects[index]).cityname;
    result:=true;
  end
  else result:=false;
end;

{******************** ItineraryBtnClick ************}
procedure TForm1.ItineraryBtnClick(Sender: TObject);
var i,n,index:integer;
begin
  //randseed:=1000000; make cases repeat for debugging}
  modegrp.itemindex:=0;
  //modegrpbtnclick(sender);
  resetpathBtnClick(sender);
  mode:=AutoDefineItinerary;
  listtoshow.clear;
  userslist.clear;
  programslist.clear;

  i:=0;
  while i< citycountspinedit.value do
  begin
    n:=random(citylist.count);
    //if not listtoshow.find(citylist[n],index) then
    index:=listtoshow.IndexOf(citylist[n]);
    if index<0 then
    begin
      listtoshow.addobject(citylist[n], citylist.objects[n]);
      inc(i);
    end;
    showcities(listtoshow);
  end;
  mode:=Userpathsearch;

  UserPathLength:=0;
  itineraryset:=true;
end;

{******************* ResetPathBtnClick *************}
procedure TForm1.ResetPathBtnClick(Sender: TObject);
var i:integer;
begin
  UserPathLength:=0;
  Shortpathlength:=0;
  showcities(listtoshow);
  for i:= 0 to listtoshow.count-1 do
  tCoordobj(listtoshow.objects[i]).visited:=false;
  mileslbl.visible:=false;
  userslist.clear;
  programslist.clear;
  mileslbl.Caption:='';
  shortmilesLbl.Caption:='';
  mode:=Userpathsearch;
  progressbar.position:=0;
end;

{************ ResetCitiesBtnCLick **********}
procedure TForm1.ResetCitiesBtnClick(Sender: TObject);
var
  i:integer;
begin
  //mode:=UserdefineItinerary;
  modegrp.itemindex:=1;
  modeGrpClick(sender);
  (*
  if mode= UserDefineItinerary then
  Instructlbl.caption:='Click on a city to start or continue city selection. '
  +' Right click to finish route definition. '
  + 'Alternatively, click the "Generate" button to  create a random city set.'
  else
  *)
  listtoshow.clear;
  for i:=0 to citylist.count-1 do listtoshow.addobject(citylist[i], citylist.objects[i]);
  resetpathbtnclick(sender);
  itineraryset:=false;
end;

{************** ShortestPathBtnClick ************}
procedure TForm1.ShortestPathBtnClick(Sender: TObject);
{Exhaustive search}
var
  nbrpoints:integer;
  ShortPath: array[1..maxpoints] of integer;
  minpath,UserPathLength:extended;
  d:array[1..maxpoints,1..maxpoints] of extended; {pairwise distances between points}
  points:array[1..maxpoints] of TCoordobj;
  startindex:integer;


    {----------- GetNextPath ---------}
    function GetNextPath:extended;
    var
      i,j:integer;
      dist:extended;
    Begin
      {Mod December 2009 - for roundtrips, we really only need to check permutations
       that begin with "startindex",  all other permutations will be some rotation of these,
        with the same total UserPathLength }
      if combos.getnextpermute
      then
      begin
        shortpath[1]:=startindex;

        {For round trips, initialize total path length (d) with distance from
         last point to first point, otherwise initialize to 0}
        with combos do if roundtripbox.checked
        then dist:=d[selected[nbrpoints-1]+1,1]
        else dist:=0;
        (*  {old method permuting nbrpoints values and ignoring those that do
             not begin with startindex}
        for i:= 1 to nbrpoints do
        if combos.selected[i]<>startindex then
        begin
          inc(j);
          shortpath[j]:=combos.selected[i];
          with points[shortpath[j]] do
          begin
            inc(dist,d[shortpath[j],shortpath[j-1]]);
            if dist>minpath then break;  {quit if path is not shortest}
          end;
        end;
        *)

        {12/2009 revised method - permute only nbrpoint-1 values, values within the
         permutation that are less than startindex are used as is, values >=
         startindex are incremented by 1.  So for example, if nbrpoints=5 and
         startindex=3, then we'll generate only permutations of length 4 and
         permutation 4,1,2,3 maps to path 3, 5, 1, 2, 4.  This extends the path
         length by one city for a given search time}
        shortpath[1]:=1;
        for i:= 1 to nbrpoints-1 do
        begin
          //inc(j);
          //if combos.Selected[i]<startindex then shortpath[j]:=combos.selected[i]
          //else
          j:=i+1;
          shortpath[j]:=combos.selected[i]+1;
          //with points[shortpath[j]] do
          begin
            dist:=dist+d[shortpath[i],shortpath[j]];
            if dist>minpath then break;  {quit if path is greater than shortest so far}
          end;
        end;
        result:=dist;
      end
      else result:=0;
    end;

    {----------- GetFirstPath -----------}
    function Getfirstpath:extended;
    {Initialize shortest path length search}
    var
      i, j, index:integer;
      s,city:string;
      p:TCoordobj;
      //x1,y1,x2,y2:integer;
      //rx1,rx2,ry1,ry2:extended;
      dist, mindist:extended;
      temppoints: array[1..maxpoints] of TCoordobj;
      used: array[1..maxpoints] of boolean;
      lowdistindex:integer;
    Begin
      with tcoordobj(listtoshow.objects[0]) do
      begin
        points[1]:=tcoordobj(listtoshow.objects[0]);
        used[1]:=true;
      end;
      for i:= 1 to nbrpoints-1 do
      with tcoordobj(listtoshow.objects[i]) do
      begin
        points[i+1]:=tcoordobj(listtoshow.objects[i]);
        used[i+1]:=false;
      end;

      {December 2009 change - every path has the same start city, so we'll only
       permute "nbrpoints-1" cities to fill in postion 2 thorugh nbrpoints
       and adjust the permute values as necessary (permute values >= startindex
       are incremented by 1)}
      combos.setup(nbrpoints-1,nbrpoints-1,permutations);
      minpath:=100000.0; {initialize shortest path length to high value}
      startindex:=1;
      if (not roundtripbox.checked) and (userslist.items.count>0) then
      {find the start city in listToShow, save that index as start point
      and permute the other cities in the list}
      begin
        s:=Tcoordobj(userslist.Items.Objects[0]).cityname;
        for i:=1 to nbrpoints do
        with points[i] do
        begin
          if oncity(x,y, city, index) and (city=s) then
          begin
            startindex:=i;
            break;
          end;
        end;
      end;
      p:=points[1];
      points[1]:=points[startindex];
      points[startindex]:=p;
      temppoints[1]:=points[1];
      startindex:=1;
      lowdistindex:=1;

      {sort the points by closest distance to next point
        - same answer and not much speed gain, converges faster}
      for i:= 2 to nbrpoints do
      begin
        mindist:=high(integer);
        for j:=2 to nbrpoints do
        if not used[j] then
        begin
          dist:=getdist(points[i-1], points[j]);
          if dist<mindist then
          begin
            mindist:=dist;
            lowdistindex:=j
          end
        end;
        used[lowdistindex]:=true;
        temppoints[i]:=points[lowdistindex];
      end;
      for i:= 1 to nbrpoints do points[i]:=temppoints[i];
      {set an array of distances between each pair of points to save calc time}
      for i:= 1 to nbrpoints do
      begin
        for j:= i to nbrpoints do
        begin
          if i<>j then d[i,j]:=getdist(points[i],points[j])
          else d[i,j]:=0.0;
          d[j,i]:=d[i,j];
        end;
      end;
      result:=getnextpath;
    end;

var
  i:integer;
  s:string;
  first:boolean;
  maxtime:single;
  index:integer;
  savemode:TModes;
begin
  if not itineraryset then
  begin
    showmessage('Generate an itinerary first');
    exit;
  end;

  tag:=0; {reset stop flag}
  //bevel1.Enabled:=false;
  loopcount:=0;
  savemode:=mode;
  mode:=ExhPathSearch;
  case maxtimegrp.itemindex of
    0:maxtime:=15;
    1:maxtime:=30;
    2:maxtime:=60;
    3:maxtime:=300;
    else maxtime:=24*3600;
  end;
  progressbar.Visible:=true;
  {Rather than juggle the points for each path, we'll just keep an array
   of point numbers and use those as pointers into the points array
   to draw a path}
  screen.cursor:=crHourGlass;

  {enhancement - sort the points so that each is near its closest neighbors}
  nbrpoints:=listtoshow.count;
  minpath:=getfirstpath;
  maxcount:=combos.getcount;
  stopbtn.visible:=true;
  first:=true;
  starttime:=now;
  timer1.enabled:=true;
  repeat
    UserPathLength:=(getnextpath); {returns 0 when no more paths}
    if ((UserPathLength>0) and (UserPathLength<minpath)) or first then
    begin
      if first then
      begin
        programslist.clear;
        programslist.items.add('Exhaustive search started');
        //first:=false;
      end;
      minpath:=UserPathLength;
      for i:=1 to nbrpoints do
      begin
        with points[shortpath[i]] do if oncity(x,y, s, index) then
        begin
          shortpathPoints[i]:=tcoordobj(listtoshow.Objects[index]);
          //programslist.items.add(s); {for debugging}
        end
        else showmessage('City not found, tell Grandpa');
      end;
      shortpathlength:=nbrpoints;
      if roundtripbox.checked then
      begin
        inc(shortpathlength);
        ShortpathPoints[shortpathlength]:=ShortpathPoints[1];
        //programslist.items.add(programslist.items[1]);{repeat 1st city in last position}
      end;
      redrawall;
      application.processmessages;
      first:=false;
    end;
    inc(loopcount);
    if loopcount and $1FFFFF = 0 then {check for exit every 2 million times through}
    Begin
      if runtime*secsperday>maxtime then
      begin
        showmessage('Time limit exceeded, a shorter path may exist');
        tag:=1; {interrupt the search}
        UserPathLength:=0;
      end;
      application.processmessages;  {stop button was hit}
    end;
  until (UserPathLength=0) or (tag>0);
  screen.cursor:=crDefault;
  stopbtn.visible:=false;
  timer1.enabled:=false;
  timer1timer(self);  {make sure time display gets called at least once}
  if tag=1 then programslist.items.add('Exhaustive search interrupted')
  else programslist.items.add('Exhaustive search complete');
  //bevel1.Enabled:=true;
  progressbar.Visible:=false;
  mode:=savemode;
end;


{***************** StopBtnClick *************}
procedure TForm1.StopBtnClick(Sender: TObject);
begin    tag:=1;  end;

{***************** Timer1Timer *************}
procedure TForm1.Timer1Timer(Sender: TObject);
{Pops every second while exhaustive search is under way to update time display}
begin
  if mode=exhPathSearch then
  begin
    runtime:=now-starttime;
    progressbar.Position:=100*loopcount div maxcount;
    if loopcount>0 then EstTimeLbl.caption:=formatdatetime('"Projected total:" hh:nn:ss',
                                        maxcount/loopcount*(runtime));
    SearchTimeLbl.caption:=formatDateTime('"Search time : " hh:nn:ss', runtime);
    application.processmessages;  {handle possible stop button press}
  end;

end;

{************* GetDist **************8}
function TForm1.Getdist(c0,c1:TCoordobj):extended;
{Get distance from 2 coordinate objects ********}
begin
  If assigned(c0) and assigned(C1) then
  begin
    if uselatlong then result:=distance(C0.lat, c0.long, c1.lat,c1.long,0)
    else result:=sqrt(sqr(c0.x-c1.x)+sqr(c0.y-c1.y));
  end
  else result:=0;
end;

type
  arrn=array[1..maxpoints] of integer;
  arrnn=array[1..maxpoints,1..maxpoints] of integer;

{******************* HeuristicBtnClick *************}
procedure TForm1.HeuristicBtnClick(Sender: TObject);

 {Algotihms below were downloaded from the Stony Brook Algorithm Repsoitory}
 {Originally appeared in Discrete Optimization Algorithms with Pascal Programs
  by Maciej M. Syslo, Narsingh Deo, and Janusz S. Kowalik}

    {Branch and Bounds Algorithm - not used -
               causes range check error for larger cases}
   (*
    procedure BABTSP(
           N,INF  :integer;
       var W      :ARRNN;
       var ROUTE  :ARRN;
       var TWEIGHT:integer);

       var BACKPTR,BEST,COL,FWDPTR,ROW:ARRN;
           I,INDEX                    :integer;

       procedure EXPLORE(EDGES,COST:integer;var ROW,COL:ARRN);
          var AVOID,C,COLROWVAL,FIRST,I,J,
              LAST,LOWERBOUND,MOST,R,SIZE :integer;
              COLRED,NEWCOL,NEWROW,ROWRED :ARRN;

          function MIN(I,J:integer):integer;
          begin
             if I <= J then MIN:=I else MIN :=J
          end;  { MIN }

          function REDUCE(var ROW,COL,ROWRED,COLRED:ARRN):integer;
             var I,J,RVALUE,TEMP:integer;
          begin
             RVALUE:=0;
             for I:=1 to SIZE do begin                    { REDUCE ROWS }
                TEMP:=INF;
                for J:=1 to SIZE do TEMP:=MIN(TEMP,W[ROW[I],COL[J]]);
                if TEMP > 0 then begin
                   for J:=1 to SIZE do
                      if W[ROW[I],COL[J]] < INF then
                         W[ROW[I],COL[J]]:=W[ROW[I],COL[J]]-TEMP;
                   RVALUE:=RVALUE+TEMP
                end;
                ROWRED[I]:=TEMP
             end;  { for I }
             for J:=1 to SIZE do begin                 { REDUCE COLUMNS }
                TEMP:=INF;
                for I:=1 to SIZE do TEMP:=MIN(TEMP,W[ROW[I],COL[J]]);
                if TEMP > 0 then begin
                   for I:=1 to SIZE do
                      if W[ROW[I],COL[J]] < INF then
                         W[ROW[I],COL[J]]:=W[ROW[I],COL[J]]-TEMP;
                   RVALUE:=RVALUE+TEMP
                end;
                COLRED[J]:=TEMP
             end;  { for J }
             REDUCE:=RVALUE
          end;  { REDUCE }

          procedure BESTEDGE(var R,C,MOST:integer);
             var I,J,K,MINCOLELT,MINROWELT,ZEROES:integer;
          begin
             MOST:=-INF;
             r:=0; c:=0;

             for I:=1 to SIZE do
                for J:=1 to SIZE do
                   if W[ROW[I],COL[J]] = 0 then begin
                      MINROWELT:=INF;  ZEROES:=0;
                      for K:=1 to SIZE do
                         if W[ROW[I],COL[K]] = 0 then ZEROES:=ZEROES+1
                         else MINROWELT:=MIN(MINROWELT,W[ROW[I],COL[K]]);
                      if ZEROES > 1 then MINROWELT:=0;
                      MINCOLELT:=INF;  ZEROES:=0;
                      for K:=1 to SIZE do
                         if W[ROW[K],COL[J]] = 0 then ZEROES:=ZEROES+1
                         else MINCOLELT:=MIN(MINCOLELT,W[ROW[K],COL[J]]);
                      if ZEROES > 1 then MINCOLELT:=0;
                      if (MINROWELT+MINCOLELT) > MOST then begin
                                         { A BETTER EDGE HAS BEEN FOUND }
                         MOST:=MINROWELT+MINCOLELT;
                         R:=I;  C:=J
                      end
                   end ; { if W[ROW[I],COL[J]] = 0, for J, I }
                  if (r=0) or (c=0) then showmessage('Invalid bestedge call')
          end;  { BESTEDGE }

       begin                                          { BODY OF EXPLORE }
          SIZE:=N-EDGES;
          COST:=COST+REDUCE(ROW,COL,ROWRED,COLRED);
          if COST < TWEIGHT then
             if EDGES = (N-2) then
             begin    { LAST TWO EDGES ARE FORCED }
                for I:=1 to N do BEST[I]:=FWDPTR[I];
                if W[ROW[1],COL[1]] = INF then AVOID:=1
                else AVOID:=2;
                BEST[ROW[1]]:=COL[3-AVOID];  BEST[ROW[2]]:=COL[AVOID];
                TWEIGHT:=COST
             end  { if EDGES = (N-2) }
             else
             begin
                BESTEDGE(R,C,MOST);
                LOWERBOUND:=COST+MOST;
                FWDPTR[ROW[R]]:=COL[C];  BACKPTR[COL[C]]:=ROW[R];
                LAST:=COL[C];       { PREVENT CYCLES }
                while FWDPTR[LAST] <> 0 do LAST:=FWDPTR[LAST];
                FIRST:=ROW[R];
                while BACKPTR[FIRST] <> 0 do FIRST:=BACKPTR[FIRST];
                COLROWVAL:=W[LAST,FIRST];  W[LAST,FIRST]:=INF;
                for I:=1 to R-1 do NEWROW[I]:=ROW[I];      { REMOVE ROW }
                for I:=R to SIZE-1 do NEWROW[I]:=ROW[I+1];
                for I:=1 to C-1 do NEWCOL[I]:=COL[I];      { REMOVE COL }
                for I:=C to SIZE-1 do NEWCOL[I]:=COL[I+1];
                EXPLORE(EDGES+1,COST,NEWROW,NEWCOL);
                W[LAST,FIRST]:=COLROWVAL;     { RESTORE PREVIOUS VALUES }
                BACKPTR[COL[C]]:=0;  FWDPTR[ROW[R]]:=0;
                if LOWERBOUND < TWEIGHT then
                begin
                   W[ROW[R],COL[C]]:=INF;
                   EXPLORE(EDGES,COST,ROW,COL);
                   W[ROW[R],COL[C]]:=0
                end
             end;  { else: EDGES < N-2 }
          for I:=1 to SIZE do                         { UNREDUCE MATRIX }
             for J:=1 to SIZE do
                W[ROW[I],COL[J]]:=W[ROW[I],COL[J]]+ROWRED[I]+COLRED[J]
       end;  { EXPLORE }

    begin                                                   { MAIN BODY }
       for I:=1 to N do
       begin
          ROW[I]:=I;  COL[I]:=I;
          FWDPTR[I]:=0;  BACKPTR[I]:=0
       end;
       TWEIGHT:=INF;
       EXPLORE(0,0,ROW,COL);
       INDEX:=1;
       for I:=1 to N do
       begin
          ROUTE[I]:=INDEX;  INDEX:=BEST[INDEX]
       end
    end;  { BABTSP }

  *)


    {--------------- Fitsp -------------}
    PROCEDURE FITSP(N,S,INF:INTEGER; VAR W:ARRNN; VAR ROUTE:ARRN; VAR TWEIGHT:INTEGER);
    {Furthest Insertion TSP}
    VAR END1,END2,FARTHEST,I,INDEX,
          INSCOST,J,MAXDIST,NEWCOST,NEXTINDEX :INTEGER;
       CYCLE,DIST                             :ARRN;
    BEGIN
       FOR I:=1 TO N DO CYCLE[I]:=0;
       CYCLE[S]:=S;
       FOR I:=1 TO N DO DIST[I]:=W[S,I];
       TWEIGHT:=0;
       FOR I:=1 TO N-1 DO
       BEGIN
          MAXDIST:=-INF;
          FOR J:=1 TO N DO
             IF CYCLE[J] = 0 THEN
                IF DIST[J] > MAXDIST THEN
                BEGIN
                   MAXDIST:=DIST[J];  FARTHEST:=J
                END;
          INSCOST:=INF;  INDEX:=S;
          End1:=Index; End2:=Index;
          FOR J:=1 TO I DO
          BEGIN
             NEXTINDEX:=CYCLE[INDEX];
             NEWCOST:=W[INDEX,FARTHEST]+W[FARTHEST,NEXTINDEX]-
                      W[INDEX,NEXTINDEX];
             IF NEWCOST < INSCOST THEN
             BEGIN
                INSCOST:=NEWCOST;
                END1:=INDEX;  END2:=NEXTINDEX
             END;
             INDEX:=NEXTINDEX
          END;  { FOR J }
          CYCLE[FARTHEST]:=END2;  CYCLE[END1]:=FARTHEST;
          TWEIGHT:=TWEIGHT+INSCOST;
          FOR J:=1 TO N DO
             IF CYCLE[J] = 0 THEN
                IF W[FARTHEST,J] < DIST[J] THEN DIST[J]:=W[FARTHEST,J]
       END;  { FOR I }
       INDEX:=S;
       FOR I:=1 TO N DO
       BEGIN
          ROUTE[I]:=INDEX;  INDEX:=CYCLE[INDEX]
       END
    END;  { FITSP }



    {------------- TwoOpt ---------------}

    PROCEDURE TWOOPT( N:INTEGER; VAR W:ARRNN; VAR ROUTE:ARRN; VAR TWEIGHT:INTEGER);
    {Two point exchange optimization}

       VAR AHEAD,I,I1,I2,INDEX,J,J1,J2,
           LAST,LIMIT,MAX,MAX1,NEXT,S1,S2,T1,T2:INTEGER;
           PTR                                 :ARRN;
    BEGIN
       FOR I:=1 TO N-1 DO PTR[ROUTE[I]]:=ROUTE[I+1];
       PTR[ROUTE[N]]:=ROUTE[1];
       REPEAT  { UNTIL MAX = 0 }
          MAX:=0;  I1:=1;
          FOR I:=1 TO N-2 DO
          BEGIN
             IF I = 1 THEN LIMIT:=N-1
             ELSE LIMIT:=N;
             I2:=PTR[I1];  J1:=PTR[I2];
             FOR J:=I+2 TO LIMIT DO
             BEGIN
                J2:=PTR[J1];
                MAX1:=W[I1,I2]+W[J1,J2]-(W[I1,J1]+W[I2,J2]);
                IF MAX1 > MAX THEN
                BEGIN   { BETTER PAIR HAS BEEN FOUND }
                   S1:=I1;  S2:=I2;
                   T1:=J1;  T2:=J2;
                   MAX:=MAX1
                END;
                J1:=J2
             END;  { FOR J }
             I1:=I2
          END;  { FOR I }
          IF MAX > 0 THEN
          BEGIN                    { SWAP PAIR OF EDGES }
             PTR[S1]:=T1;
             NEXT:=S2;  LAST:=T2;
             REPEAT
                AHEAD:=PTR[NEXT];  PTR[NEXT]:=LAST;
                LAST:=NEXT;  NEXT:=AHEAD
             UNTIL NEXT = T2;
             TWEIGHT:=TWEIGHT-MAX
          END  { IF MAX > 0 }
       UNTIL MAX = 0;
       INDEX:=1;
       Tweight:=0;
       FOR I:=1 TO N DO
       BEGIN
          ROUTE[I]:=INDEX;  INDEX:=PTR[INDEX];
          if i>1 then inc(TWeight,  w[route[i],route[i-1]]);
       END
    END;  { TWOOPT }



    {---------- ThreeOpt -------------}
    procedure THREEOPT(N:integer; var W:ARRNN; var ROUTE:ARRN; var tweight:integer);
    {three point exchange optimization}

       type SWAPTYPE  =(ASYMMETRIC,SYMMETRIC);
            SWAPRECORD=record
                          X1,X2,Y1,Y2,Z1,Z2,GAIN:integer;
                          CHOICE                :SWAPTYPE
                       end;
       var BESTSWAP,SWAP:SWAPRECORD;
           I,INDEX,J,K  :integer;
           PTR          :ARRN;

           {........... SwapCkeck ..........}
           procedure Swapcheck(var swap:swaprecord);
              var delweight,max:integer;
           begin
              with swap do begin
                 gain:=0;
                 delweight:=W[X1,X2]+W[Y1,Y2]+W[Z1,Z2];
                 MAX:=DELWEIGHT-(W[Y1,X1]+W[Z1,X2]+W[Z2,Y2]);
                 if MAX > GAIN then begin
                    GAIN:=MAX;  CHOICE:=ASYMMETRIC
                 end;
                 MAX:=DELWEIGHT-(W[X1,Y2]+W[Z1,X2]+W[Y1,Z2]);
                 if MAX > GAIN then begin
                    GAIN:=MAX;  CHOICE :=SYMMETRIC
                 end
              end  { with SWAP }
           end;  { SWAPCHECK }

           {.......... Reverse ...........}
           procedure REVERSE(START,FINISH:integer);
              var AHEAD,LAST,NEXT:integer;
           begin
              if START <> FINISH then begin
                 LAST:=START;  NEXT:=PTR[LAST];
                 repeat
                    AHEAD:=PTR[NEXT];  PTR[NEXT]:=LAST;
                    LAST:=NEXT;  NEXT:=AHEAD;
                 until LAST = FINISH
              end  { if START <> FINISH }
           end;  { REVERSE}

      begin {ThreeOpt}                                                  { MAIN BODY }
         for I:=1 to N-1 do PTR[ROUTE[I]]:=ROUTE[I+1];
         PTR[ROUTE[N]]:=ROUTE[1];
         repeat  { until BESTSWAP.GAIN = 0 }
            BESTSWAP.GAIN:=0;
            SWAP.X1:=1;
            for I:=1 to N do begin
               SWAP.X2:=PTR[SWAP.X1];  SWAP.Y1:=SWAP.X2;
               for J:=2 to N-3 do begin
                  SWAP.Y2:=PTR[SWAP.Y1];  SWAP.Z1:=PTR[SWAP.Y2];
                  for K:=J+2 to N-1 do begin
                     SWAP.Z2:=PTR[SWAP.Z1];
                     SWAPCHECK(SWAP);
                     if SWAP.GAIN > BESTSWAP.GAIN then BESTSWAP:=SWAP;
                     SWAP.Z1:=SWAP.Z2
                  end;  { for K }
                  SWAP.Y1:=SWAP.Y2
               end;  { for J }
               SWAP.X1:=SWAP.X2
            end;  { for I }
            if BESTSWAP.GAIN > 0 then
               with BESTSWAP do begin
                  if CHOICE = ASYMMETRIC then begin
                     REVERSE(Z2,X1);
                     PTR[Y1]:=X1;  PTR[Z2]:=Y2
                  end
                  else begin
                     PTR[X1]:=Y2;  PTR[Y1]:=Z2
                  end;
                  PTR[Z1]:=X2;
               end  { with BESTSWAP }
         until BESTSWAP.GAIN = 0;
         INDEX:=1;
         TWeight:=0;
         for I:=1 to N do
         begin
            ROUTE[I]:=INDEX;  INDEX:=PTR[INDEX];
            if i>1 then inc(TWeight,  w[route[i],route[i-1]]);
         end
      end;  { THREEOPT }



 var
  nbrpoints:integer;
  w:arrNN; {pairwise distances between points}
  points:array[1..maxpoints] of TPoint;
  route:array[1..3] of arrn;
  i,n:integer;
  ok:boolean;
  p:TPoint;
  key:string;
  index:integer;
  UserPathLength:array[1..3] of integer;

  {--------------- Init -----------}
  procedure init;
  var
    i,j, x1,x2,y1,y2:integer;
    begin
      for i:= 0 to nbrpoints-1 do
      with tcoordobj(listtoshow.objects[i]) do
      begin
        points[i+1]:=point(x,y);
        for j:=1 to 3 do route[j][i+1]:=i+1;
      end;
      for i:=1 to 3 do UserPathLength[i]:=0;
      {set an array of distances between each pair of points to save calc time}
      for i:= 1 to nbrpoints do
      for j:= i to nbrpoints do
      begin
        x1:=points[i].x;
        y1:=points[i].y;
        x2:=points[j].x;
        y2:=points[j].y;
        w[i,j]:=trunc(sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1)));
        if i=j then w[i,j]:=0 {999999 for BABTSP}
        else w[j,i]:=w[i,j];
      end;
    end;



begin  {Heuristic search}
  if not itineraryset then
  begin
    showmessage('Generate an itinerary first');
    exit;
  end;
  tag:=0; {reset stop flag}
  mode:=HeurPathSearch;
  screen.cursor:=crHourGlass;
  nbrpoints:=listtoshow.count;
  stopbtn.visible:=true;
  starttime:=now;
  timer1.enabled:=true;

  try
    {BABTSP( Nbrpoints, maxint, W, route, UserPathLength);}
    init;
    FITSP(Nbrpoints,1,999999,W,ROUTE[1],UserPathLength[1]);
    TWOOPT(nbrpoints,W,ROUTE[2],UserPathLength[2]);
    THREEOPT(nbrpoints,W,ROUTE[3], UserPathLength[3]);

  finally
    n:=1;
    if UserPathLength[2]<UserPathLength[1] then n:=2;
    if UserPathLength[3]<UserPathLength[n] then n:=3;
    programslist.clear;
    with programslist.items do
    begin
      add('Heuristic search started');
      if roundtripbox.checked then
      for i:=1 to 3 do
        inc(UserPathLength[i], w[route[i][1],route[i][nbrpoints]]);

      add(format('1. FITSP method length = %d pixels',[UserPathLength[1]]));
      add(format('2. TwoOpt method length = %d pixels',[UserPathLength[2]]));
      add(format('3. ThreeOpt method length = %d pixels',[UserPathLength[3]]));
      add(format('Method %d used',[n]));
    end;

    OK:=true;
     {Move points to ShortpathPoints just so we can reuse code from exhaustive search}
    for i:=1 to nbrpoints do
    begin
      p:=points[route[n][i]];
      key:=format('%4d%4d',[roundto10(p.x),roundto10(p.Y)]);
      index:=listtoshow.indexof(key);
      if index>=0 then ShortpathPoints[i]:=TCoordobj(listtoshow.objects[index])
      else
      begin
        programslist.items.Add('System error - heuristic path point '+key +' not found');
        OK:=false;
      end;
    end;
    if OK then
    begin
      shortpathlength:=nbrpoints;
      if roundtripbox.checked then
      begin
        inc(shortpathlength);
        shortpathPoints[shortpathlength]:=shortpathPoints[1];
      end;
      redrawall;
    end;
    screen.cursor:=crDefault;
    stopbtn.visible:=false;
    mode:=userpathsearch;
    timer1.enabled:=false;
    timer1timer(self);  {make sure time display gets called at least once}
    programslist.items.add('Heuristic search complete');
  end;
end;

{******** CityCountSpinEditChange *************}
procedure TForm1.CityCountSpinEditChange(Sender: TObject);
{Number of cities to visit has changed}
begin
  resetpathbtnclick(sender);
  Itinerarybtnclick(sender);
end;

{********** RoundTripBoxClick **********}
procedure TForm1.RoundtripBoxClick(Sender: TObject);
begin
  {heuristic search only works for round trips, so set button enabled acccordingly}
  heuristicbtn.enabled:=roundTripBox.Checked;
  resetpathbtnclick(sender);

end;

{********* FormClose ********}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {Save city location file if it has been modified}
  if CityDlg.modified then savelist;  {save the citylist if it has been modified}
  action:=caFree;
end;

{********** ModegrpClick ************}
procedure TForm1.ModeGrpClick(Sender: TObject);
var
  i:integer;
begin
  case modegrp.itemindex of
  0: {define solution path}
    begin
      mode:=userpathsearch;
      InstructLbl.caption:=solveItMsg;

    end;
  1:
    begin {define itinerary}
      begin
        mode:=UserDefineItinerary;
        userslist.clear;
        programslist.clear;
        listtoshow.clear;
        for i:=0 to citylist.count-1
          do listtoshow.addobject(citylist[i],tcoordobj(citylist.objects[i]));
        showcities(listtoshow);
        instructlbl.caption:=SelectCitiesMsg;

      end;
    end;
  end; {case}
end;

(*
{Inactive routine to save map image}
procedure TForm1.Button2Click(Sender: TObject);
begin
  image1.picture.Bitmap.pixelformat:=pf24bit;
  image1.picture.savetofile('TSP.bmp');
end;
*)


{************ Programslistclick *************}
procedure TForm1.ProgramslistClick(Sender: TObject);
var
  i:integer;
  f:textfile;
begin
  if savedialog1.execute then
  begin
    assignfile(f, savedialog1.filename);
    rewrite(f);
    for i:=0 to programslist.items.count-1 do writeln(f,programslist.items[i]);
    closefile(f);
  end;
end;

{*************** SaveBtnClick **********88}
procedure TForm1.SaveBtnClick(Sender: TObject);
{Save user and program solutions to a text file}
var
  f:textfile;
  i:integer;
  d, dsum:extended;
begin
  if savedialog1.Execute then
  begin
    assignfile(f,savedialog1.FileName);
    rewrite(f);
    if Shortpathlength>0 then
    begin
      writeln(f,'______________________________');
      writeln(f,'Program shortest path solution');
      with ShortPathPoints[1] do
      writeln(f,format('From: %s, %s ',[cityname,stateId,d]));
      dsum:=0.0;
      for i:=2 to shortPathlength do
      with ShortPathPoints[i] do
      begin
        d:=Getdist(ShortPathPoints[i-1],ShortpathPoints[i]);
        dsum:=dsum+d;
        writeln(f,format('To: %s, %s %.1f miles',[cityname,stateId,d]));
      end;
      writeln(f,format('Total miles this path: %.1f',[dsum]));
      writeln(f,'');
    end;
    if UserPathLength>0 then
    begin
      writeln(f,'______________________________');
      writeln(f,'Users shortest path solution');
      with UserPathPoints[1] do
      writeln(f,format('From: %s, %s ',[cityname,stateid,d]));
      dsum:=0.0;
      for i:=2 to UserPathlength do
      with UserPathPoints[i] do
      begin
        d:=GetDist(UserPathPoints[i-1],UserPathPoints[i]);
        dsum:=dsum+d;
        writeln(f,format('To: %s, %s %.1f miles',[cityname,stateid,d]));
      end;
      writeln(f,format('Total miles this path: %.1f',[dsum]));
      writeln(f,'');
    end;
  end;
end;

procedure TForm1.StaticText3Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://delphiforfun.org/programs/utilities/makecitylocationfile.htm',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
