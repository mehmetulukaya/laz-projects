unit U_JPGClock2;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, {jpeg,} Spin, dateutils, Inifiles,

  DateTimePicker;

type
  TClockMode=(Realtime, Onetime, FastTime, Stopped);
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    MHandImg: TImage;
    HHandImg: TImage;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    HCxUD: TSpinEdit;
    HCyUD: TSpinEdit;
    MCxUD: TSpinEdit;
    MCyUD: TSpinEdit;
    Label3: TLabel;
    HScaleEdt: TEdit;
    MScaleEdt: TEdit;
    Label4: TLabel;
    FaceImage: TImage;
    ClockTimer: TTimer;
    ModeGrp: TRadioGroup;
    Testtime: TDateTimePicker;
    Label11: TLabel;
    ResetBtn: TButton;
    OpenDialog1: TOpenDialog;
    SaveBtn: TButton;
    LoadBtn: TButton;
    SaveDialog1: TSaveDialog;
    NewBtn: TButton;
    LoadClockDialog: TOpenDialog;
    SecondhandBox: TCheckBox;
    Memo1: TMemo;
    Label1: TLabel;
    ClockLbl: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HCUDChange(Sender: TObject);
    procedure MCUDChange(Sender: TObject);
    procedure ModeGrpClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure ScaleEdtChange(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure NewBtnClick(Sender: TObject);
    procedure TesttimeClick(Sender: TObject);
    procedure runclock;
    procedure FormActivate(Sender: TObject);
  public
    dir:string;
    FaceName, HHandname, MHandName:string;  {clock element file names}
    facecenter:TPoint;  {center of the face image}
    MCenter, HCenter:TPoint; {centers of rotation for the hands}
    facemap, HourBitMap, MinuteBitMap:TBitmap; {Bitmaps of the loaded images}
    minutehandmap, hourhandmap:TBitmap; {clock size bitmaps to hold rotated hand images}
    Minutehandcolor, HourhandColor:TColor;
    scaleH, ScaleM:single; {Hand scaling factors converting loaded sizes to display sizes}
    clockmode:TClockmode;   {clock running mode}
    fasttimesim:TTime;  {virtual time when running in FastTime mode}
    modified:boolean;  {set to false after clock is loaded, set true if centers or scale changes}
    showtime:TTime;
    SecHandLength, SecHandTailLength:Extended;
    function Getimage(fname:string):TBitmap;
    procedure newclock;  {Solicit new clock definition from user}
    procedure loadclock(filename:String);
    function ReInitClock:boolean;
    procedure RefreshClock;
    function checkmodified:boolean;
    {Two rotate bmp procedures tested: times and results are approximately equal}
    {Set world transfer method}
    (*
    procedure RotateBitmapSWT(Bmp: TBitmap; Rads: Single; AdjustSize: Boolean;
                              BkColor: TColor = clNone); *)
    {Parallelogram Blit method}
    procedure RotateBitmapPLG(Bmp: TBitmap; Rads: Single; AdjustSize: Boolean;
                              BkColor: TColor = clNone);
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}
uses math;
const
  TwoPi=2*Pi;
  halfPi=Pi/2;

{************ FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
{Initial call to set up clock}
begin
  pagecontrol1.activepage:=Tabsheet1;
  dir:=extractfilepath(application.exename);
  doublebuffered:=true;
end;

{************ FormActivate *********8}
procedure TForm1.FormActivate(Sender: TObject);
begin
  if fileexists(dir+'Default.clk') then loadclock(dir+'default.clk')
  else newclock;
end;
{********** NewClock *********}
procedure TForm1.Newclock;
{Let user select face and hands for a new clock}
var error:boolean;
begin
  if not checkmodified then exit; {Give user a chance to save previous clock}
  {get images}
  error:=false;
  clockmode:=stopped;
  with opendialog1 do
  begin
    if initialdir='' then initialdir:=dir;
    title:='Load clock face image';
    if execute then
    begin
      Facename:=filename;
      facemap:=getimage(Facename);
      if facemap=nil then error:=true
      else
      begin
        title:='Load hour hand image';
        if execute then
        begin
          HHandName:=filename;
          Hourbitmap:=getimage(HHandName);
          if hourbitmap=nil then error:=true
          else
          begin
            HCxUD.value:=hourBitmap.width div 2;
            HCyUD.value:=Hourbitmap.height-hourbitmap.width div 2;
            title:='Load minute hand image';
            if execute then
            begin
              MHandname:=filename;
              MinuteBitmap:=Getimage( MHandname);
              if minutebitmap=nil then error:=true
              else
              begin
                MCxUD.value:=Minutebitmap.width div 2;
                MCyUD.value:=MinuteBitmap.height-MinuteBitmap.width div 2;
                RefreshClock; {all is good, finish the clock}
              end;
            end else error:=true;
          end;
        end else error:=true
      end ;
    end else error:=true;
  end;
  if error then
  begin
    Showmessage('New clock definition cancelled, program stopped');
  end
  else
  begin
    modified:=true;
    ClockLbl.caption:='New clock';
  end;
end;

{************** GetImage ************}
function TForm1.Getimage(fname:string):TBitmap;
{Given a file name of a jpg or bmp file, retrieve and return it in a new bitmap.
{Return nil if file doesn't exist}
var
  jpg:TJPegImage;
  ext:string;
begin
  if fileexists(fname) then
  begin
    result:=TBitmap.create;
    ext:=uppercase(ExtractfileExt(fname));
    if (ext='.JPG') or (ext='.JPEG') then
    begin
      jpg:=TJpegImage.Create;
      jpg.LoadFromFile(fname);
      result.assign(jpg);
      jpg.Free;
    end
    else result.loadfromfile(fname);
  end
  else result:=nil;
end;

{************ RefreshClock **********}
 procedure TForm1.RefreshClock;
 {Once the three bitmaps, Facemap, HourBitmap, and minutebitmap have been
  created, complete the clock definition.}
  var x:extended;
  begin
    with facemap do
    begin
      facecenter:=point(width div 2, height div 2);
      canvas.Pen.Width:=3; {for drawing second hand}
      SecHandLength:=0.4*width;  {80% OF Face radius or second hand}
      SecHandTailLength:= 0.2*SechandLength; {add a tail to second hand}
    end;

    {Hour setup stuff}
    Hourbitmap.Transparent:=true;
    HCenter:=point(HCxUD.value, HCyUD.Value);
    with HHandimg.picture.bitmap, hcenter do
    begin
      {Save the hand bitmap to an image, then we'll reuse HourBitMap for rotating}
      assign(HourBitmap);
      hourhandcolor:=canvas.pixels[x,y]; {use this color to "erase" then pivot
                                          hole when it is moved}
      {Draw a yellow "pivot hole" to visually check center of rotation}
      canvas.brush.color:=clYellow;
      canvas.pen.color:=clyellow;
      canvas.ellipse(x-3, y-3, x+3, y+3);
    end;

    HourHandmap:=TBitMap.create;
    {Hour hand map is where we will draw the rotated hour hand }
    with HourHandmap do
    begin
      transparent:=true;
      width:=facemap.width;
      height:=facemap.height;
    end;

    x:=strtofloatdef(HScaleedt.Text,0.6);
    scaleH:=x*facecenter.x/HHandimg.height;  {Hour hand scaling factor}
    with hourbitmap do
    begin  {replace hourbitmap with the scaled version}
      width:=trunc(scaleH*HHandImg.Width);
      height:=trunc(scaleh*hhandimg.height);
      Canvas.StretchDraw(rect(0,0,width,height),HHandimg.picture.bitmap);
    end;

    {Minute setup stuff}
    MinuteBitmap.Transparent:=true;
    MCenter:=point(MCxUD.value, MCyUD.Value);
    with MHandImg.picture.bitmap, MCenter do
    begin
      assign(Minutebitmap);  {save the hand image, we'll reuse MinuteBitMap for rotating}
      minutehandcolor:=canvas.pixels[x,y];
      {Draw a yellow "pivot hole" to viually check center of rotation}
      canvas.pen.color:=clyellow;
      canvas.brush.color:=clyellow;
      canvas.ellipse(x-4, y-4,x+4, y+4); {draw the pivot "hole"}
    end;

    {Scale the minutebitmap}
    x:=strtofloatdef(MScaleedt.Text,0.8);
    ScaleM:=x*facecenter.X/MHandImg.height; {Minute hand scaling center}
    with minutebitmap do
    begin
      width:=trunc(scaleM*MHandimg.width);
      height:=trunc(scaleM*MHandImg.height);
      Canvas.StretchDraw(rect(0,0,width,height),Mhandimg.picture.bitmap);
    end;

    minutehandmap:=TBitMap.create;
    with minutehandmap do
    begin
      transparent:=true;
      width:=facemap.width;
      height:=facemap.height;
    end;
  end;

{************** HandAngles ************}
procedure HandAngles(Time:TDateTime; var h,m,s:extended);
{Convert hour of input time to clock face angle in radians}
begin
  h:=frac(2*time)*TwoPi; {24 hours = two hour hand revolutions so double the time}
  m:=frac(24*time)*TwoPi; {24 hours = 24 minute hand revolutions so 24 x time}
  s:=frac(1440*time)*twopi-halfpi; {24 hours = 1440 second hand revolutions so 1440 x time}
  {Note: Rotate routines assume 0 is vertical but trig calc for second hand
   needs to subtract 90 degrees (Pi/2)}
end;

{*************** ModeGrpClick ***********}
procedure TForm1.ModeGrpClick(Sender: TObject);
begin
  clockmode:=TClockmode(modegrp.ItemIndex);
  if clockmode=fasttime then fasttimesim:=time;
  runclock;
end;

{********** RunClock *********}
procedure TForm1.runclock;
var
  HourAngle, MinAngle, secangle:extended;
  UpdateInterval, runtime:integer;
  startclockmode:TClockMode;
  nexttime, starttime:TTime;
begin
  startclockmode:=clockmode;
  if clockmode=stopped then exit;
  repeat
    UpdateInterval:=1000;

    case clockmode of
      realtime:
      begin
        {current time rounded to exact second  boundary}
        showtime:=int(time*secsperday)/secsperday; {current time rounded to second }
      end;
      onetime: showtime:=testtime.Time;
      FastTime:
      begin
        updateinterval:=100;  {Update time by .01 seconds per update}
        showtime:=fasttimesim;
      end;
    end; {case}
    nexttime:=showtime+updateinterval/secsperday;
    starttime:=time;
    Handangles(showtime, HourAngle, MinAngle, Secangle);

    with minutehandmap, canvas do
    {We can't just rotate the handimage because of artifacts from the other
    hand. Also incremental movements as the hand appears to move will
    severely distort the hand image and a few rotations.
    Simple solution is to clear the current handmap image, redraw the
    the hand on it, then rotate to the desired angle.  }
    begin
      brush.color:=clWhite;
      fillrect(clientrect);
      transparent:=true;
      canvas.draw(facecenter.x-trunc(scalem*mcenter.x),
                 facecenter.y-trunc(scalem*Mcenter.y),minutebitmap);
    end;
    RotateBitmapPlg(minutehandmap, Minangle,false, clwhite);

    {rotate hour hand}
    with hourHandmap, canvas do
    begin
      transparent:=true;
      brush.color:=clWhite;
      fillrect(clientrect);
      canvas.draw(facecenter.x-trunc(scaleh*Hcenter.x),
                  facecenter.y-trunc(scaleh*Hcenter.y),Hourbitmap);
    end;
    RotateBitmapPLG(HourHandmap, HourAngle,false, clwhite);

    with faceimage.picture.Bitmap do
    begin
      assign(facemap);
      transparent:=true;
      canvas.pen.width:=3;
      canvas.draw(0,0,hourHandMap);
      canvas.draw(0,0,minuteHandMap);
      if (clockmode<>fasttime) and secondhandbox.Checked then
      begin
        canvas.moveto(facecenter.X+trunc(SecHandTailLength*cos(secangle+Pi)),
                      facecenter.y+trunc(SechandTailLength*sin(secangle+Pi)));
        canvas.lineto(facecenter.x+trunc(SecHandLength*cos(secangle)),
                      facecenter.y+trunc(SechandLength*sin(secangle)));
      end;
    end;
    runtime:=trunc(1000*(time-starttime)*secsperday);
    if clockmode=fasttime then fasttimesim:=fasttimesim+ 100/secsperday;
    if (clockmode=realtime) and (runtime<updateinterval) then sleep(updateinterval-runtime);
    application.processmessages;
  until (clockmode=stopped) or (clockmode=onetime);
end;


{************ HCUDChange **************}
procedure TForm1.HCUDChange(Sender: TObject);
{Hour hand center coordinates changed}
begin
  modegrp.itemindex:=ord(stopped);
  with HHandImg.picture.bitmap.canvas do
  begin
    brush.color:=pixels[HCenter.x+4,hcenter.y-4];
    pen.color:=brush.color;
    with hcenter do ellipse(x-2,y-2,x+2,y+2);
    brush.color:=clYellow;
    pen.color:=clYellow;
    hcenter.x:=HCxUD.value;
    hcenter.y:=HCyUD.value;
    with hcenter do ellipse(x-2,y-2,x+2,y+2);
  end;
  modified:=true;
end;

{*********** MCUDChange ***********}
procedure TForm1.MCUDChange(Sender: TObject);
{Minute hand center coordinates changed}
begin
  modegrp.itemindex:=ord(stopped);
  with MHandImg.picture.bitmap.canvas do
  begin
    {erase the old center}
    brush.color:=pixels[MCenter.x+4,Mcenter.y-4];
    pen.color:=brush.color;
    with Mcenter do ellipse(x-2,y-2,x+2,y+2);
    {Draw the new center}
    brush.color:=clyellow;
    pen.color:=clyellow;
    Mcenter.x:=MCxUD.value;
    Mcenter.y:=MCyUD.value;
    with Mcenter do ellipse(x-2,y-2,x+2,y+2);
  end;
  modified:=true;
end;

{************ ScaleEdtChange **********}
procedure TForm1.ScaleEdtChange(Sender: TObject);
begin
 modegrp.itemindex:=ord(stopped);
 reinitclock;
 modified:=true;
end;

{************* ResetBtnClick ************}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  ReInitClock
end;

{************ SaveBtnClick ********}
procedure TForm1.SaveBtnClick(Sender: TObject);
{Save current clock in a clock definition file}
var
  ini:TInifile;
begin
  with savedialog1 do
  begin
    initialdir:=dir;
    if execute then
    begin
      ini:=TInifile.create(filename);
      with ini do
      begin
        writestring('Files','Face', facename);
        writestring('Files','MHand', MHandname);
        writestring('Files','HHand', HHandname);
        writeinteger('Offsets','HCenterx',HCxUD.Value);
        writeinteger('Offsets','HCentery',HCyUD.Value);
        writeinteger('Offsets','MCenterx',MCxUD.Value);
        writeinteger('Offsets','MCentery',MCyUD.Value);
        writestring('Scales','MScale',MScaleEdt.text);
        writeString('Scales', 'HScale', HScaleEdt.text);
      end;
      ini.free;
      modified:=false;
    end;
  end;
end;

{************ LoadBtnClick ***********}
procedure TForm1.LoadBtnClick(Sender: TObject);
begin
  with LoadClockDialog do
  begin
    if initialdir='' then initialdir:=dir;
    if execute then loadclock(filename);
  end;
end;

{************ NewBtnClick **********}
procedure TForm1.NewBtnClick(Sender: TObject);
begin
  newclock;
end;

{*********** LoadClock **********}
procedure TForm1.loadclock(filename:String);
{Load a predefined clock definition}
var ini:TInifile;
begin
  if not checkmodified then exit;
  ini:=TInifile.create(filename);
  with ini do
  begin
    facename:=readstring('Files','Face','Face1.jpg');
    if extractfilepath(facename)='' then facename:=dir+facename;
    Mhandname:=readstring('Files','MHand','MHand1.jpg');
    if extractfilepath(MHandName)='' then MHandname:=dir+MHandname;
    HHandname:=readstring('Files','HHand', 'HHand1.jpg');
    if extractfilepath(HHandName)='' then HHandname:=dir+HHandname;
    HCXUD.value:=readinteger('Offsets','HCenterx',0);
    HCyUD.value:=readinteger('Offsets','HCentery',0);
    MCxUD.Value:=readinteger('Offsets','MCenterx',0);
    MCyUD.Value:=readinteger('Offsets','MCentery',0);
    MScaleEdt.text:=readstring('Scales','MScale','0.8');
    HScaleEdt.text:=readstring('Scales', 'HScale','0.5');
    ReInitClock;
    ini.free;
   end;
   modified:=false;
   ClockLbl.caption:=extractfilename(filename);
   Savedialog1.filename:=filename;
   modegrp.itemindex:=ord(realtime);
 end;

{******** ReInitClock **********}
function TForm1.ReInitClock:boolean;
{Free and reload all bitmaps}
var  error:string;
begin
  modegrp.itemindex:=ord(stopped);
  error:='';
  result:=true;
  if assigned(facemap) then
  begin
    facemap.free;
    HourBitMap.Free;
    MinuteBitMap.Free;
    minutehandmap.Free;
    hourhandmap.Free;
  end;
  facemap:=getimage(Facename);
  if facemap=nil then error:=facename
  else
  begin
    Hourbitmap:=getimage(HHandName);
    if hourbitmap=nil then error:=HHandname
    else
    begin
      MinuteBitmap:=Getimage( MHandname);
      if minutebitmap=nil then error:=MHandname
      else RefreshClock;
    end;
  end;
  if error<>'' then
  begin
    Showmessage('Load of image ' + error + ' failed');
    result:=false;
  end;
end;

{************ FormCloseQuesry ************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{Give user a chance to save clock if the definition has changed}
begin
  clockmode:=stopped;
  canclose:=checkmodified;
end;

{*********** CheckModified **********}
function TForm1.checkmodified:boolean;
{Give user a chance to save a new or changed clock before closing or overwriting it}
var  mr:integer;
begin
  result:=true;
  if modified then
  begin
    mr:=messagedlg('Save clock first?', mtconfirmation,mbyesnocancel,0);
    if mr=mryes then savebtnclick(self)
    else if mr=mrNo then modified:=false
    else if mr=mrcancel then result:=false;
  end;
end;

{*********** TestTimeClick *************}
procedure TForm1.TesttimeClick(Sender: TObject);
begin
  {User changed the testtime used for "singletime" clock mode}
  {Make sure that the clock display gets updated}
   clockmode:=onetime;
   runclock;
end;

(*
{SetWorldPlatform rotation method}
procedure TForm1.RotateBitmapSWT(Bmp: TBitmap; Rads: Single; AdjustSize: Boolean;
  BkColor: TColor = clNone);
var
  C: Single;
  S: Single;
  XForm: tagXFORM;
  Tmp: TBitmap;
begin
  C := Cos(Rads);
  S := Sin(Rads);
  XForm.eM11 := C;
  XForm.eM12 := S;
  XForm.eM21 := -S;
  XForm.eM22 := C;
  Tmp := TBitmap.Create;
  try
    Tmp.TransparentColor := Bmp.TransparentColor;
    Tmp.TransparentMode := Bmp.TransparentMode;
    Tmp.Transparent := Bmp.Transparent;
    Tmp.Canvas.Brush.Color := BkColor;
    if AdjustSize then
    begin
      Tmp.Width := Round(Bmp.Width * Abs(C) + Bmp.Height * Abs(S));
      Tmp.Height := Round(Bmp.Width * Abs(S) + Bmp.Height * Abs(C));
      XForm.eDx := (Tmp.Width - Bmp.Width * C + Bmp.Height * S) / 2;
      XForm.eDy := (Tmp.Height - Bmp.Width * S - Bmp.Height * C) / 2;
    end
    else
    begin
      Tmp.Width := Bmp.Width;
      Tmp.Height := Bmp.Height;
      XForm.eDx := (Bmp.Width - Bmp.Width * C + Bmp.Height * S) / 2;
      XForm.eDy := (Bmp.Height - Bmp.Width * S - Bmp.Height * C) / 2;
    end;
    SetGraphicsMode(Tmp.Canvas.Handle, GM_ADVANCED);
    SetWorldTransform(Tmp.Canvas.Handle, XForm);
    BitBlt(Tmp.Canvas.Handle, 0, 0, Tmp.Width, Tmp.Height, Bmp.Canvas.Handle,
      0, 0, SRCCOPY);
    Bmp.Assign(Tmp);
  finally
    Tmp.Free;
  end;
end;
*)

{Parallelogram  Blt}
procedure TForm1.RotateBitmapPLG(Bmp: TBitmap; Rads: Single; AdjustSize: Boolean;
  BkColor: TColor = clNone);
var
  C: Single;
  S: Single;
  Tmp: TBitmap;
  OffsetX: Single;
  OffsetY: Single;
  Points: array[0..2] of TPoint;
begin
  C := Cos(Rads);
  S := Sin(Rads);
  Tmp := TBitmap.Create;
  try
    Tmp.TransparentColor := Bmp.TransparentColor;
    Tmp.TransparentMode := Bmp.TransparentMode;
    Tmp.Transparent := Bmp.Transparent;
    tmp.transparentcolor:=clwhite;
    Tmp.Canvas.Brush.Color := BkColor;
    if AdjustSize then
    begin
      Tmp.Width := Round(Bmp.Width * Abs(C) + Bmp.Height * Abs(S));
      Tmp.Height := Round(Bmp.Width * Abs(S) + Bmp.Height * Abs(C));
      OffsetX := (Tmp.Width - Bmp.Width * C + Bmp.Height * S) / 2;
      OffsetY := (Tmp.Height - Bmp.Width * S - Bmp.Height * C) / 2;
    end
    else
    begin
      Tmp.Width := Bmp.Width;
      Tmp.Height := Bmp.Height;
      OffsetX := (Bmp.Width - Bmp.Width * C + Bmp.Height * S) / 2;
      OffsetY := (Bmp.Height - Bmp.Width * S - Bmp.Height * C) / 2;
    end;
    Points[0].X := Round(OffsetX);
    Points[0].Y := Round(OffsetY);
    Points[1].X := Round(OffsetX + Bmp.Width * C);
    Points[1].Y := Round(OffsetY + Bmp.Width * S);
    Points[2].X := Round(OffsetX - Bmp.Height * S);
    Points[2].Y := Round(OffsetY + Bmp.Height * C);
    PlgBlt(Tmp.Canvas.Handle, Points, Bmp.Canvas.Handle, 0, 0, Bmp.Width,
      Bmp.Height, 0, 0, 0);
    Bmp.Assign(Tmp);
  finally
    Tmp.Free;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;



end.
