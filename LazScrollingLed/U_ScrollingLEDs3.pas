unit U_ScrollingLEDs3;
 {Copyright  © 2001-2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Scrolling LEDs program simulates those scrolling signs frequently used for
 advertising messages}

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, EditBtn, inifiles, shellapi, DateTimePicker;

type
  TLedchar=record
     ch:array of array of byte; {character image}
     charwidth:byte;  {width of character in LED units}
   end;

  { TForm1 }

  TForm1 = class(TForm)
    CountDate: TDateTimePicker;
    CountTime: TDateTimePicker;
    Image1: TImage;
    OpenDialog1: TOpenDialog;
    ColorDialog1: TColorDialog;
    LedGrp: TGroupBox;
    LEDPixelsUD: TUpDown;
    LEDSizeEdt: TEdit;
    Label3: TLabel;
    LEDColorBtn: TButton;
    LEDOffColorBtn: TButton;
    ShapeGrp: TRadioGroup;
    BoardColorBtn: TButton;
    StopBtn: TButton;
    SpeedBar: TTrackBar;
    Label2: TLabel;
    MessagePages: TPageControl;
    Textpage: TTabSheet;
    DateTimePage: TTabSheet;
    Label1: TLabel;
    TextEdt: TEdit;
    DTFormatGrp: TRadioGroup;
    LoadFontBtn: TButton;
    FontLbl: TLabel;
    NewScreenBox: TCheckBox;
    StaticText1: TStaticText;
    TabSheet1: TTabSheet;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    Yearbox: TCheckBox;
    DayBox: TCheckBox;
    HourBox: TCheckBox;
    MinuteBox: TCheckBox;
    SecondBox: TCheckBox;
    Timer1: TTimer;
    FormatGrp: TRadioGroup;
    ShowTextBtn: TButton;
    Memo1: TMemo;
    Label5: TLabel;
    procedure ShowTextBtnClick(Sender: TObject);
    procedure LoadFontBtnClick(Sender: TObject);
    procedure BoardColorBtnClick(Sender: TObject);
    procedure LEDColorBtnClick(Sender: TObject);
    procedure gth(Sender: TObject);
    procedure LEDOffColorBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure ShapeGrpClick(Sender: TObject);
    procedure SpeedBarChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure NewScreenBoxClick(Sender: TObject);
    procedure MessagePagesDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  public
    chars:array[0..255] of TLedchar;
    fontheight, maxcharwidth,nbrchars:integer;
    BoardColor,LEDOnColor,LEDOffColor:TColor; {Colors}
    LEDSize:integer;  {LED pixel size}
    RoundLED:boolean; {LED Shape}
    DelayMS:integer; {Scrolling speed}
    running:boolean;  {message is running}
    ininame:string;
    fontname:string;
    maximagewidth:integer;
    years,days,hours,minutes,seconds:integer;
    piece:array[1..5] of TBitmap;  {up to 5 pieces of the message}
    b:TBitmap;
    nbrpieces:integer;
    dtloc,ctloc:integer;
    dtval,ctval:string;
    dtindex,ctindex:integer;
    function loadfont(fname:string):boolean;
    procedure DrawBlankColumn(c:TCanvas; x1:integer);
    function drawLED(c:TCanvas; startx:integer; chr:char):integer;
    function  BuildMessage:string;
    procedure animate(const image:TImage);
    function getdatetimestring:string;
    function getcountdownstring:string;
    procedure savedata;
  end;

var
  Form1: TForm1;

implementation

uses U_LEDWindow3;

{$R *.DFM}
  {*************************** DrawBlankColumn *******************}
  procedure TForm1.DrawBlankColumn(c:TCanvas; x1:integer);
  {Draw a single column of LEDs in the off state at X1}
   var
     x2,y1,y2,i:integer;
   begin
     with c do
     begin
       pen.width:=2;
       pen.color:=BoardColor;
       brush.color:=Boardcolor;
       y1:=0;
       y2:=LEDSize;
       x2:=x1+LEDSize;
       for i:= 0 to fontheight-1 do
       begin
         rectangle(x1,y1,x2,y2);
         brush.color:=LEDOffColor;
         If roundLED then ellipse(x1+1,y1+1,x2-1,y2-1)
         else rectangle(x1,y1,x2,y2);
         inc(y1,ledsize);
         inc(y2,ledsize);
       end;
     end;
   end;

{*************** DrawLED ******************}
function TForm1.drawLED(c:TCanvas; startx:integer; chr:char):integer;
{Draw LED character chr at startx - return the width in pixels}
var
  i,j:integer;
  x1,x2,y1,y2:TColor;
begin
  with c  do
  begin
    pen.width:=2;
    pen.color:=BoardColor;
    for i:= 0 to fontheight-1 do
    if chars[ord(chr)].charwidth>0 then
    begin
      y1:=i*LEDSize;
      y2:=y1+LEDSize;
      for j:= 0 to high(chars[ord(chr)].ch[i]) do
      begin
        brush.color:=Boardcolor;
        x1:=startx+j*ledsize;
        x2:=x1+LEDSize;
        if x1>=0 then
        Begin
          if RoundLEd then rectangle(x1,y1,x2,y2);
          if chars[ord(chr)].ch[i,j]>0 then brush.color:=LEDOnColor
          else brush.color:=LEDOffColor;
          If RoundLED then ellipSe(x1+1,y1+1,x2-1,y2-1)
          else rectangle(x1,y1,x2,y2);
        end;
      end;

      {Now draw a blank column as spacer}
      Inc(x1,LEDSize);
      drawblankcolumn(c,x1);
    end;
  end;
  result := (chars[ord(chr)].charwidth+1)*LEDSize;
end;

{************* LoadFont ****************}
function TForm1.loadfont(fname:string):boolean;
{Load a new font}
var
  f:textfile;
  i,j,k:integer;
  charwidth,chrnbr:integer;
  line:string;
  errcode:integer;
  ext:string;

        {Loadfont Local routines}
        function getline:string;  {retrieve a line - skip comment lines}
        var
          comment:boolean;
        begin
          comment:=true;
          result:='';
          repeat
            readln(f,result);
            if (length(result)>=2) and (copy(result,1,2)='!!') then
            else  comment:=false;
          until eof(f) or (comment=false);
        end;

        procedure errmsg(msg:string); {Show error msg}
        begin
          showmessage(msg);
          result:=false;
        end;

begin  {LoadFont}
  result:=true;
  ext:=extractfileext(fname);
  assignfile(f,fname);
  reset(f);
  begin
    line:=trim(getline);
    val(line,fontheight,errcode);
    if errcode<>0 then errmsg('Invalid font FontHeight');
    inc(fontheight); {add room for a top row for internal leading}
    line:=trim(getline);
    val(line,maxcharwidth,errcode);
    if errcode<>0 then errmsg('Invalid font MaxCharWidth');
    line:=trim(getline);
    val(line,nbrchars,errcode);
    if errcode<>0 then errmsg('Invalid font NbrChars');
    for i:=1 to Nbrchars do
    begin
      if result=false then break;
      line:=trim(getline);
      {' ' is used to define the space character}
      if (length(line)=3) and (line=''' ''')  then line:=' ';
      if length(line)>0 then
      begin
        chrnbr:=ord(line[1]);
        setlength(chars[chrnbr].ch,fontheight);
        line:=trim(getline);
        val(line,charwidth,errcode);
        chars[chrnbr].charwidth:=charwidth;
        if errcode<>0
        then errmsg('Invalid font CharWidth');
         setlength(chars[chrnbr].ch[0],charwidth);
        for j:= 1 to fontheight-1 do   {start at 1 to leave 0th row blank}
        begin
          line:=getline;
          if length(line)<charwidth then line:=line+stringofchar(' ',charwidth);
          setlength(chars[chrnbr].ch[j],charwidth);
          for k:= 1 to charwidth do
          if line[k]='#' then chars[chrnbr].ch[j,k-1]:=1
          else chars[chrnbr].ch[j,k-1]:=0;
        end;
      end;
    end;
  end;
  closefile(f);
  if chars[ord(' ')].charwidth=0 then {no space char defined, the normal case}
  begin {make one}
    charwidth:=maxcharwidth div 2 - 1;
    chars[ord(' ')].charwidth:=charwidth;
    setlength(chars[ord(' ')].ch,fontheight);
    for j:=0 to fontheight-1 do setlength(chars[ord(' ')].ch[j],charwidth);
  end;
  If result then
  begin
    fontname:=extractfilename(fname) ;
    Fontlbl.caption:='Current Font: '+fontname;;
  end
  else FontLbl.caption:='No valid font loaded';
end; {Loadfont}

procedure TForm1.FormCreate(Sender: TObject);
  var s:string;
      i:integer;
       ini:TInifile;
begin
  with opendialog1 do
  begin
    initialdir:=extractfilepath(application.exename);
    if fileexists(initialdir+'\arial.LED') then loadfont(initialdir+'\arial.LED')
    else
    if execute  then loadfont(filename)
    else
    begin
      showmessage('No LED font found, program stopped');
      close;
    end;
    ininame:=initialdir+'\LEDS.ini';
    ini:=TInifile.create(ininame);
    with ini do
    begin
      Textedt.text:=readstring('General','Text','Welcome to Burger King');
      NewScreenbox.checked:=ReadBool('General','SepWindow',false);
      SpeedBar.position:=ReadInteger('General','Speed',10);
      Messagepages.Activepageindex:=readinteger('General','PageNbr',0);
      fontname:=Readstring('Font','Name','arial.led');
      if fileexists(initialdir+'\'+fontname) then loadfont(fontname);
      LedPixelsUD.position:=readinteger('Font','LEDSize',10);
      LedOnColor:=ReadInteger('Font','OnColor',clRed);
      LedOffColor:=ReadInteger('Font','OffColor',$400040);
      BoardColor:=ReadInteger('Font','BoardColor',clBlack);
      ShapeGrp.Itemindex:=Readinteger('Font','LEDShape',0);
      DtFormatGrp.itemindex:=ReadInteger('General','DateFormat',0);
      formatgrp.itemindex:=readinteger('CountDown','Format',0);
      yearbox.checked:=readbool('Countdown','ShowYears',false);
      daybox.checked:=readbool('Countdown','ShowDays',false);
      Hourbox.checked:=readbool('Countdown','ShowHours',true);
      Minutebox.checked:=readbool('Countdown','ShowMinutes',true);
      Secondbox.checked:=readbool('Countdown','ShowSeconds',true);
      countdate.date:=readfloat('Countdown','Datetime',0);
      counttime.time:=frac(countdate.date);
    end;
    ini.free;
    maximagewidth:=image1.width;
  end;
  If shapeGRP.itemindex=0 then RoundLED:=true
  else RoundLED:=False;
  if speedbar.position>0 then DelayMS:=1000 div Speedbar.position
  else delayms:=10000;

  Stopbtn.left:=ShowtextBtn.left;
  Stopbtn.top:=ShowtextBtn.top;
  With DTFormatGrp do
  begin
    datetimetostring(s,'mmm dd hh:nn ampm',now); items[0]:=s;
    datetimetostring(s,'mmm dd, yyyy',now); items[1]:=s;
    datetimetostring(s,'hh:nn ampm',now); items[2]:=s;
    datetimetostring(s,'dddd, mmm dd, yyyy  hh:nn ampm',now); items[3]:=s;
  end;
  for i:=1 to 5 do piece[i]:=TBitmap.create;
  b:=TBitmap.create;
  doublebuffered:=true;
end;


{**************** GetDateTimeString ************}
function tform1.getdatetimestring:string;
  begin
    result:='';
    case dtformatgrp.itemindex of
      0: datetimetostring(result,'mmm dd hh:nn ampm',now);
      1: datetimetostring(result,'mmm dd, yyyy',now);
      2: datetimetostring(result,'hh:nn ampm',now);
      3: datetimetostring(result,'dddd, mmm dd, yyyy  hh:nn ampm',now);
    end;
  end;

{**************** GetCountdownString ************}
function tform1.getcountdownstring:string;
  begin
    result:='';
    case formatgrp.itemindex of
      0:
      begin
        result:=' ';
        if years>=0 then result:=inttostr(years)+':';
        if days>=0 then result:=result+inttostr(days)+':';
        if hours>=0 then result:=result+inttostr(hours)+':';
        if minutes>=0 then result:=result+inttostr(minutes)+':';
        if seconds>=0 then result:=result+inttostr(seconds)+':';
        delete (result,length(result),1);   {delete the extra final ":"}
      end;
      1:
      begin
        if years>=0 then result:=inttostr(years)+' years ';
        if days>=0 then result:=result+inttostr(days)+' days ';
        if hours>=0 then result:=result+inttostr(hours)+' hours ';
        if minutes>=0 then result:=result+inttostr(minutes)+' minutes ';
        if seconds>=0 then result:=result+inttostr(seconds)+' seconds ';
        delete(result,length(result),1); {delete the extra final ' '}
      end;
    end;
  end;

{************** Animate ****************}
procedure TForm1.animate(const image:TImage);
{run the message image until tag <>0}
var
  startx,w:integer;
  count:integer;
  s,s2,s3:string;


  procedure  rebuild;
  var i,n,start:integer;
  begin
    n:=piece[1].width;
    for i:=2 to nbrpieces do n:=n+piece[i].width;
    b.width:=n;
    b.canvas.draw(0,0,piece[1]);
    start:=piece[1].width;
    for i:=2 to nbrpieces do
    begin
       b.canvas.draw(start,0,piece[i]);
       start:=start+piece[i].width;
    end;

    image.picture.assign(b);
    image.Canvas.copyrect(rect(0,0,b.width,b.height), b.canvas,
                             rect(0,0,b.width,b.height));

  end;

begin  {animate}
  count:=0;
  (*
  WITH image DO setbounds(left,top,width,b.height);
  if b.width<image.width then image.width:=b.width;  {to handle short messages}
  if image.parent<>self {If standalone image then set form width = image width}
  then image.parent.clientwidth:=image.width;
  image.canvas.rectangle(0,0,image.width,image.height);
  image.picture.assign(b);
  *)
  buildmessage;
  rebuild;
  {image.Canvas.copyrect(rect(0,0,b.width,b.height),b.canvas,rect(0,0,b.width,b.height));}
  application.processmessages;
  {Now scroll it}
  startx:=0; {starting point for copying message bitmap to display image area}
  repeat
    if dtloc>0 then s2:=getdatetimestring;
    if ctloc>0 THEN s3:=getcountdownstring;
    if (s2>dtval) or (s3<>ctval) then rebuild;

    if delayms <10000 then  inc(startx,ledsize); {10,000= stopped msg, don't increment}
    if startx > b.width then startx:=0;
    {move image left one column}
     if startx+image.width<b.width then
    Image.canvas.copyrect(rect(0,0,image.width{b.width-startx},b.height),b.canvas,
                           rect(startx,0,startx+image.width{b.width},b.height))
    else
    begin
      Image.canvas.copyrect(rect(0,0,b.width-startx,b.height),b.canvas,
                           rect(startx,0,b.width,b.height));
      {move start of message to end of image area}
      Image.canvas.copyrect(rect(b.width-startx,0,b.width,b.height),b.canvas,
                            rect(0,0,startx,b.height));
    end;
    image.update;
    inc(count);
    if count > 64 div delayms then
    begin
      application.processmessages;
      count:=0;
    end;
    if delayms<10000 then sleep(Delayms) else sleep(1000);
  until form1.tag<>0;
end;

{***************** Buildmessage ***************}
function  TForm1.BuildMessage:string;
  {build display string}
var
  s:string;
  start,len:integer;


  procedure buildbitmap(var p:TBitmap; s:string);
  var i,sx,w,charwidth:integer;
  begin
    w:=0;
    for i:=1 to length(s) do w:=w+(chars[ord(s[i])].charwidth+1)*ledsize;
    sx:=0;
    p.width:=w;
    for i:= 1 to length(s) do
    begin
      charwidth:=drawled(p.canvas, sx, s[i]);
      sx:=sx+charwidth;
    end;
  end;


begin
  s:=textedt.text+'    '; {add a few extra spaces at end of message for separation}
  dtloc:=pos('&dt',s);  {look for date symbol}
  ctloc:=pos('&ct',s);  {look for countdown symbol}
  If dtloc>0 then
  begin
    dtval:=getdatetimestring;
    delete(s,dtloc,3);
    insert(trim(dtval),s,dtloc);
  end
  else dtval:='';
  ctloc:=pos('&ct',s);
  if ctloc>0 then
  begin
    ctval:=getcountdownstring;
    delete(s,ctloc,3);
    insert(trim(ctval),s,ctloc);
  end
  else ctval:='';

  {here we are going to build the image in pieces so that if a date or
   count down field changes, we only have to replace that piece of the
   message image}

   {Case 1, no $dt or &ct - 1 piece}
  if (dtloc=0) and (ctloc=0) then
  begin
    nbrpieces:=1;
    buildbitmap(piece[1],s);
  end
  else if (dtloc>0) and (ctloc=0) then
  {Case 2, &dt only - 3 pieces}
  begin
    nbrpieces:=3;
    buildbitmap(piece[1],copy(s,1,dtloc-1));
    buildBitmap(piece[2],dtval);
    buildBitmap(piece[3],copy(s,dtloc+length(dtval),length(s)-dtloc-length(dtval)-1));
  end
  else if (ctloc>0) and (dtloc=0) then
  {Case 3, &ct only 3 pieces}
  begin
    nbrpieces:=3;
    buildbitmap(piece[1],copy(s,1,ctloc-1));
    buildBitmap(piece[2],ctval);
    buildBitmap(piece[3],copy(s,ctloc+length(ctval) ,length(s)-ctloc-length(ctval)-1));
  end
  else if (dtloc>0) and (ctloc>0) and (dtloc<ctloc) then
  {Case 4, &dt and &ct with &dt first - 5 pieces}
  begin
    nbrpieces:=5;
    start:=1; len:=dtloc-1;
    buildbitmap(piece[1],copy(s,start,len));
    start:=start+len; len:=length(dtval);
    buildBitmap(piece[2],dtval);
    start:=start+len; len:=ctloc-(dtloc+length(dtval));
    buildBitmap(piece[3],copy(s,start,len));
    start:=start+len; len:=length(ctval);
    buildBitmap(piece[4],ctval);
    start:=start+len; len:=length(s)-start+1;
    buildBitmap(piece[5],copy(s,start,len));
  end
  else if (dtloc>0) and (ctloc>0) and (ctloc<dtloc) then
  {Case 5, &dt and &ct with &ct first - 5 pieces}
  begin
    nbrpieces:=5;
    start:=1; len:=ctloc-1;
    buildbitmap(piece[1],copy(s,start,len));
    start:=start+len; len:=length(ctval);
    buildBitmap(piece[2],ctval);
    start:=start+len; len:=dtloc-(ctloc+length(ctval)-1);
    buildBitmap(piece[3],copy(s,start,len));
    start:=start+len; len:=length(dtval);
    buildBitmap(piece[4],dtval);
    start:=start+len; len:=length(s)-start+1;
    buildBitmap(piece[5],copy(s,start,len));
  end;
  result:=s;
end;

{******************* ShowtextBtnClick ************}
procedure TForm1.ShowTextBtnClick(Sender: TObject);
{prepare the image for animation}
var
  s:string;
  i:integer;

  function messagewidth:integer;
  var
    i:integer;
  begin
    result:=piece[1].width;
    for i:= 2 to nbrpieces do result:=result+piece[i].width;
  end;



begin
  tag:=0;
  messagepages.enabled:=false;
  messagepages.Font.color:=clgray;
  LEDGrp.enabled:=false;
  ledgrp.font.color:=clgray; {gray out the text to indicate "disabled"}
  ledcolorbtn.enabled:=false;
  ledoffcolorbtn.enabled:=false;
  boardcolorbtn.enabled:=false;
  stopbtn.visible:=true;

  running:=true;
  for i:= 1 to 5 do piece[i].height:=fontheight*ledsize;
  b.height:=fontheight*LEDSize;

  {s:=buildmessage;}
  if (ctloc>0) then if secondbox.checked then timer1.interval:=500
                     else timer1.interval:=30000;

  if newscreenbox.checked then {show message on a separate form}
  begin
    ledform.clientheight:=b.height;
    {if b.width<ledform.clientwidth then ledform.clientwidth:=b.width;}
    windowstate:=wsminimized;
    ledform.show;
    animate(ledform.image2);
    ledform.hide;
  end
  else
  begin
    image1.width:=maximagewidth;  {reset width to max width}
    {if b.width<image1.width then image1.width:=b.width;} {reduce it for short messages}
    animate(image1);
  end;

  stopbtn.visible:=false;
  messagepages.enabled:=true;
  messagepages.font.color:=clblack;
  LEDGrp.enabled:=true;
  ledgrp.font.color:=clblack;
  ledcolorbtn.enabled:=true;
  ledoffcolorbtn.enabled:=true;
  boardcolorbtn.enabled:=true;
  running:=false;
  SaveData;
end;

{***************** SaveData ************}
procedure TForm1.savedata;
{Save info to ini file}
var ini:TInifile;
begin
  ini:=TInifile.create(ininame);
  with ini do
  begin
    writestring('General','Text',Textedt.text);
    writeBool('General','SepWindow',NewScreenbox.checked);
    writeInteger('General','Speed',SpeedBar.position);
    writeInteger('General','DateFormat',DtFormatGrp.itemindex);
    writeinteger('General','PageNbr',Messagepages.ActivePageindex);
    writeinteger('General','WindowLeft',ledform.left);
    writeinteger('General','WindowTop',ledform.top);
    writestring('Font','Name',fontname);
    Writeinteger('Font','LEDSize',LedPixelsUD.position);
    writeInteger('Font','OnColor',LedOnColor);
    WriteInteger('Font','OffColor',LedOffColor);
    WriteInteger('Font','BoardColor',BoardColor);
    writeinteger('Font','LEDShape',ShapeGrp.itemIndex);

    writeinteger('CountDown','Format',formatgrp.itemindex);
    writebool('Countdown','ShowYears',yearbox.checked);
    writebool('Countdown','ShowDays',daybox.checked);
    writebool('Countdown','ShowHours',Hourbox.checked);
    writebool('Countdown','ShowMinutes',Minutebox.checked);
    writebool('Countdown','ShowSeconds',Secondbox.checked);
    writefloat('Countdown','Datetime',int(Countdate.date)+frac(counttime.time));
  end;
  ini.free;
end;

{**************** LoadFontBtnClick *************}
procedure TForm1.LoadFontBtnClick(Sender: TObject);
var  savestate:boolean;
begin
  savestate:=running;
  if running then tag:=1;
  If opendialog1.execute then loadfont(opendialog1.filename);
  if savestate then ShowTextBtnClick(sender);
end;

{**************** BoardColorBtnClick ****************}
procedure TForm1.BoardColorBtnClick(Sender: TObject);
begin If colordialog1.execute then boardcolor:=colordialog1.color; end;

{************** LEDColorBtnClick ****************}
procedure TForm1.LEDColorBtnClick(Sender: TObject);
begin  If colordialog1.execute then LEDOncolor:=colordialog1.color; end;

{************* LEDSizeEdtChange ***************}
procedure TForm1.gth(Sender: TObject);
begin   LEDSize:=LEDPixelsUD.position;  end;

{**************** LEDOffColorBrnClick *************}
procedure TForm1.LEDOffColorBtnClick(Sender: TObject);
begin  If colordialog1.execute then LEDOffcolor:=colordialog1.color; end;

{**************** StopBtnClick ***************}
procedure TForm1.StopBtnClick(Sender: TObject);
begin    tag:=1;  end;

{************** ShapeGrpClick ************}
procedure TForm1.ShapeGrpClick(Sender: TObject);
begin
   If shapeGRP.itemindex=0 then RoundLED:=true  else RoundLED:=False;
end;
{******************* SpeedBarChange *************}
procedure TForm1.SpeedBarChange(Sender: TObject);
begin
  If speedbar.position>0 then DelayMs:=1000 div speedbar.position
  else delayms:=10000;
  if speedbar.position=speedbar.max then DelayMs:=1;
end;
{*************** FormClosrQuery ****************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tag:=1; {to stop message in case it's scrolling}
  canclose:=true;
end;

{****************** Minimizebtnclick **********}

{***************** NewScreenBoxCkick **********}
procedure TForm1.NewScreenBoxClick(Sender: TObject);
var savestate:boolean;
begin
  savestate:=running;
  if running then tag:=1;
  application.processmessages;
  if savestate then ShowTextBtnClick(sender);
end;

{************** MessagepagesDrawTab *******************}
procedure TForm1.MessagePagesDrawTab(Control: TCustomTabControl;
{Draw tabs in gray if control is disabled - no other way to do it?}
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  with TPageControl(control), canvas do
  begin
    if enabled then pen.color:=clred else pen.color:=clgray;
    case tabindex of
      0: textout(rect.left+4, rect.top+4, 'Message');
      1: textout(rect.left+4, rect.top+4, 'Date/Time');
      2: textout(rect.left+4, rect.top+4, 'Count up/down');
    end;
  end;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


procedure TForm1.Timer1Timer(Sender: TObject);
var dt:extended;
begin
  dt:=abs(int(countdate.date)+frac(counttime.time)-now);
  If yearbox.checked then
  begin
    years:=trunc(dt/365);
    dt:=dt-years*365;
  end
  else years:=-1;

  If daybox.checked then
  begin
    days:=trunc(dt);
    dt:=dt-days;
  end
  else days:=-1;

  if hourbox.checked then
  begin
    hours:=trunc(dt*24);
    dt:=dt-hours/24;
  end
  else hours:=-1;

  If minutebox.checked then
  begin
    minutes:=trunc(dt*1440);
    dt:=dt-minutes/1440;
  end
  else minutes:=-1;

  If secondbox.checked then
  begin
    seconds:=trunc(dt*1440*60);
  end
  else seconds:=-1;;

end;

end.
