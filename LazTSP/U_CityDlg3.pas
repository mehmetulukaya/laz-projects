unit U_CityDlg3;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

 {Copyright 2002, 2009 Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved.
 }

 
interface

uses
  SysUtils, {Windows,} Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, dialogs;

type
  TCityDlg = class(TForm)
    AddUpdtBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    NameEdt: TEdit;
    DeleteBtn: TButton;
    Memo2: TMemo;
    LatEdt: TLabeledEdit;
    LongEdt: TLabeledEdit;
    procedure AddUpdtBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    public
      key:string;
      index:integer;
      modified:boolean;
  end;

var
  CityDlg: TCityDlg;

implementation

{$R *.lfm}

Uses
  mathslib,
  U_TSP3;

procedure TCityDlg.AddUpdtBtnClick(Sender: TObject);
var
  p:TRealpoint;
  laterr,longerr:boolean;
begin
  laterr:=false;
  longerr:=false;
  with form1, citylist, coordobj do
  begin
    cityname:=nameedt.text;
    if not strtoangle(latedt.text,lat)
    then
    begin
      showmessage('Latitude '+latedt.Text +'has invalid format, not updated');
      laterr:=true;
    end
    else if (lat<-85.0) or (lat>85.0) then
    begin
      showmessage('Latitude '+latedt.Text +'must lie between -85 and +85 degrees, not updated');
      laterr:=true;
    end;

    if not strtoangle(longedt.text,long)
    then
    begin
      showmessage('Longitude '+longedt.Text +'has invalid format, not updated');
      longerr:=true;
    end
    else if (long<-180.0) or (long>180) then
    begin
      showmessage('Longitude '+longedt.Text +'must lie between -180 and +180 degrees, not updated');
      longerr:=true;
    end;
    if (index<0) and (not laterr) and (not longerr) then
    begin {new city}
      index:=citylist.add(key);
      citylist.objects[index]:=coordobj;
      if (index=0) or (index=1) then  form1.recalcscale;
      showcity(coordobj, clblack);
    end
    else {update}
    begin
      {nothing to do?}
      if (index=0) or (index=1) then form1.recalcscale;
    end;
    modified:=true;
  end;
end;



procedure TCityDlg.CancelBtnClick(Sender: TObject);
begin
  if index>=0 then
  with form1, coordobj do
  begin
    //cityname:=oldname;
    //x:=oldx;
    //y:=oldy;
    //lat:=oldlat;
    //long:=oldlong;
  end;
end;

procedure TCityDlg.DeleteBtnClick(Sender: TObject);
begin
  If  index>=0 then
  with form1, citylist do
  begin
    coordobj.free;
    delete(index);
    modified:=true;
    image1.canvas.stretchdraw(rect(0,0,image1.width,image1.height),b);
    showcities(Citylist);
  end;
end;

procedure TCityDlg.FormActivate(Sender: TObject);
begin
  NameEdt.setfocus;  {make sure edit field is initially selected}
end;

end.
