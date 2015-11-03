unit U_ConvertTest;
{ Copyright  © 2001-2003, Gary Darby,  www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, UAstronomy, Buttons, shellapi,DateTimePicker;

type

  T3DVector=record
    x,y,z:extended;
  end;

  TTConvertTest = class(TForm)
    DatePicker: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    TZBox: TComboBox;
    Label8: TLabel;
    NSRGrp: TRadioGroup;
    EWRGrp: TRadioGroup;
    LatEdt: TEdit;
    LongEdt: TEdit;
    DLSRGrp: TRadioGroup;
    BitBtn1: TBitBtn;
    GroupBox1: TGroupBox;
    TimeInRGrp: TRadioGroup;
    Label6: TLabel;
    CoordInRGrp: TRadioGroup;
    HrDegInLbl: TLabel;
    XInEdt: TEdit;
    Label9: TLabel;
    YInEdt: TEdit;
    GroupBox2: TGroupBox;
    Label14: TLabel;
    HrDegOutLbl: TLabel;
    Label16: TLabel;
    TimeOutRGrp: TRadioGroup;
    TimeOut: TDateTimePicker;
    CoordOutRGrp: TRadioGroup;
    XoutEdt: TEdit;
    YOutEdt: TEdit;
    Panel1: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    SRAz: TEdit;
    SSAz: TEdit;
    SRmsg: TEdit;
    SSTime: TEdit;
    SRTime: TEdit;
    TimeIn: TDateTimePicker;
    StaticText1: TStaticText;
    Label7: TLabel;
    Memo1: TMemo;
    {procedure FormActivate(Sender: TObject);}
    procedure TestBtnClick(Sender: TObject);
    procedure DatePickerUserInput(Sender: TObject;
      const UserString: String; var DateAndTime: TDateTime;
      var AllowChange: Boolean);
    procedure DLSRGrpClick(Sender: TObject);
    procedure CoordInRGrpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CoordOutRGrpClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sunrise:single; { Sunrise time                 }
    sunset:single; { Sunset time                  }
    sunriseangle, sunsetangle:extended;
    function GetBaseData:boolean;
 end;


var
  TConvertTest: TTConvertTest;

implementation

{$R *.DFM}
Uses math;

var
  deg:char=char(176);


function cosd(t:extended):extended;
  begin  result:= cos(0.01745329251994 * t); end;

function sind(t:extended):extended;
  begin  result:= sin(0.01745329251994 * t); end;

function tand(t:extended):extended;
  var
    x:extended;
  begin
    x:=degtorad(t);
    result:= tan(x);
  end;


function JulianDay(d:TDateTime):integer;
var
  y,m,day:word;
begin
  decodedate(d,y,m,day);
  result:=trunc(d-encodedate(y-1,12,31));
end;




{********************** GetBaseData ***************}
function TTConvertTest.GetBaseData:boolean;
  procedure setmessage(s:string);
  begin
    showmessage(s);
    result:=false;
  end;
var
  p:TRpoint;
begin
  with astro do
  begin
    result:=true;
    Adate:=datepicker.date;
    if tzbox.itemindex>0 then tzhours:=tzbox.itemindex-12
    else setmessage('Select a time zone from list');
    if strtoangle(longedt.text,p.x) then
    begin
      p.x:=abs(p.x);
      if EWRGrp.itemindex>0 then p.x:=-p.x;
    end
    else setmessage('Invalid longitude, must be 1 to 3 numbers separated by spaces');
    if strtoangle(latedt.text,p.y) then
    begin
      p.y:=abs(p.y);
      if NSRGrp.itemindex>0 then p.y:=-p.y;
    end
    else setmessage('Invalid latitude, must be 1 to 3 numbers separated by spaces');
    dlshours:=DLSRGrp.itemindex;
    lonlat:=p;
  end;
end;

procedure TTConvertTest.TestBtnClick(Sender: TObject);
{test Tastronomy class}
var
  inval,outval:TRPoint;
  srise,sset, LSTUp, LSTDown:extended;
  savetime:TDateTime;
begin
  if getbasedata then
  with astro do
  begin
    case TimeInRGrp.itemindex of
      0: {Local} localtime:=timeIn.time;
      1: {UT} Universaltime:=timeIn.time;
      2: {Greenwich Sidereal} GSTime:=timeIn.time;
      3: {Local Sidereal} LSTime:=timeIn.time;
    end;

    case TimeOutRGrp.itemindex of
      0: {Local} timeout.time:=localtime;
      1: {UT} timeout.time:=Universaltime;
      2: {Greenwich Sidereal} timeout.time:=GSTime;
      3: {Local Sidereal} timeout.time:=LSTime;
    end;
    If (CoordInRGrp.itemindex>=0) then
    begin
      strtoangle(XInEdt.text, inval.x);
      strtoangle(YInEdt.text,inval.y);
      case CoordInRGrp.itemindex of
       0: AzAlt:=inval;
       1: EcLonLat:=inval;
       2: HaDecl:=inval;
       3: RADecl:=Inval;
       4: GalLonLat:=inval;

      end;
      with coordOutRgrp do
      If (itemindex>=0) then
      begin
        case ItemIndex of
          0: outval:=AzAlt;
          1: Outval:=EcLonLat;
          2: outval:=HaDecl;
          3: Outval:=RADecl;
          4: OutVal:=GalLonLat;
        end;
        if (itemindex=2) or (itemindex=3)
        then
        begin
         XOutEdt.text:=formatdatetime('hh:mm:ss.z',Outval.x/24.0);
         HrDegOutLbl.caption:='X (H:M:S)';
        end
        else
        begin
          XOutEdt.text:=angletostr(Outval.x);
          HrDegOutLbl.caption:='X (D,M,S)';
        end;
        YOutEdt.text:=angletostr(Outval.y);
      end;

      (*
      SrMsg.text:=riseset(rpoint(RADecl.x*15,radecl.y),
                 0,srise, sset, LSTup,LSTDown);
      If srmsg.text='' then
      begin
        sunriseangle:=srise;
        sunsetangle:=sset;
        SRAz.text:=angletostr(sunriseangle);
        SSAz.text:=angletostr(sunsetangle);
        savetime:=localtime;
        //convertLSTime(UpTmaz.x/24.0,GS,sunrise,UT);
        //convertLSTime(DnTmaz.x/24.0,GS,sunset,UT);
        LSTime:=LstUp/24;
        SRTime.text:=Timetostr(localtime);
        LSTime:=LstDown/24;
        SSTime.text:=Timetostr(localtime);
        localtime:=savetime;
      end
      else
      begin
        SRAz.text:='0:0:0';
        SSAZ.text:='0:0:0';;
        SrTime.text:='0:0:0';
        SSTime.text:='0:0:0';
      end;
      *)
    end;
  end; {with astro}


end;

procedure TTConvertTest.DatePickerUserInput(Sender: TObject;
  const UserString: String; var DateAndTime: TDateTime;
  var AllowChange: Boolean);

begin
  try
    DateAndTime:=strtodate(userstring);
  except
  end;
end;

procedure TTConvertTest.DLSRGrpClick(Sender: TObject);
begin
  astro.DLSHours:=DLSRGrp.itemindex+1;
end;

procedure TTConvertTest.CoordInRGrpClick(Sender: TObject);
var
  LSTUp, LSTDown:TDatetime;
  uptmaz, dntmaz:TRPoint;
  GS,UT:TDateTime;
  sunrec:TSunrec;
  errmsg:string;

begin
  with astro,CoordInRGrp
  do
  if getbasedata then
  begin
    HrDegInLbl.caption:='X (D,M,S)';
    case itemindex of
    2,3: HrDegInLbl.caption:='X (H:M:S)';
    5: begin
         SunPos(Sunrec);
         Xinedt.Text:=angletostr(Sunrec.TrueAzAlt.x);
         YInedt.text:=angletostr(Sunrec.TrueAzAlt.y);
         CoordinRGrp.itemindex:=0;
       end;
    6: {sunrise}
       with astro do
       begin

         errmsg:=Sunriseset(0,UpTMAz,DNTmAz);
         xInedt.text:=angletostr(uptmaz.y);
         yInedt.text:=angletostr(-0.833333);{- 5/6 degree=alt of sun center at sunrise}
         convertLSTime(UpTmaz.x/24.0,GS,LSTUp,UT);
         localtime:=LSTUp;
         timein.time:=localtime;
         timeinrgrp.itemindex:=0;
         itemindex:=0;
       end;
     7: {sunset}
       with astro do
       begin
         errmsg:=Sunriseset(0,UpTMAz,DNTmAz);
         xInedt.text:=angletostr(Dntmaz.y);
         yInedt.text:=angletostr(-0.833333);{- 5/6 degree=alt of sun center at sunset}
         convertLSTime(DnTmaz.x/24.0,GS,LSTDown,UT);
         localtime:=LSTDown;
         timein.time:=localtime;
         timeinrgrp.itemindex:=0;
         itemindex:=0;
       end;
    end;
  end;

end;

procedure TTConvertTest.CoordOutRGrpClick(Sender: TObject);
{user changed output coordinate system}
begin
  with CoordOutRGrp
  do
   if (itemindex =2) or (itemindex=3)
   then HrDegOutLbl.caption:='X (H:M:S)'
   else HrDegOutLbl.caption:='X (D,M,S)';
   testbtnclick(sender);  {recalculate data}
end;

procedure TTConvertTest.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  modalresult:=MrOK;
end;



procedure TTConvertTest.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

end.




