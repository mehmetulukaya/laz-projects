unit U_AirportSim;

{$MODE Delphi}

{An airport simulation}
{See U_AirportDesc.Memo1 for complete problem description}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TQType=(Arrival,Departure);

    TRunwayObj=class(TListbox)
    public
    Nbr:integer;
    Available:boolean;
    Departures:Integer;
    DepartureWaitTime, MaxDepWait :Integer;
    Arrivals:integer;
    ArrivalWaitTime, MaxArrWait,Arrivalfuel:Integer;
    EmergencyLandings:Integer;
    EmergencyWaitTime:Integer;

    constructor create(Listbox:TListbox;
                      Newnbr:integer
                      );   overload;
    procedure clear;
    procedure RunwayDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
  end;

  TQobj=class(TListbox)
  {This should probably be a component,
   as an alternative for now, we'll just copy the visual aspects froma listbox}
   public
    Runway:TRunwayObj;
    qType:TqType;
    TotalIn,totalout:integer;
    labelbox:Tlabel;
    constructor create(listbox:Tlistbox;
                       NewQtype:TQType;
                       NewRunway:TRunwayObj);
     procedure clear;
  end;

  TPlaneObj=class(Tobject)
    PlaneNbr:Integer;
    FuelRemaining:Integer;
    ArrivalTime:Integer;
    Waittime:integer;
    constructor create(newnbr,newfuel,newtime:integer);
  end;

  TForm1 = class(TForm)
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    ListBox5: TListBox;
    StartBtn: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    ListBox6: TListBox;
    ListBox7: TListBox;
    ResetBtn: TButton;
    StepBtn: TButton;
    ListBox9: TListBox;
    ListBox8: TListBox;
    ListBox10: TListBox;
    LQLbl: TLabel;
    RunwayLbl: TLabel;
    TQLbl: TLabel;
    Button1: TButton;
    procedure StartBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure StepBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Queues:array[1..7] of TQObj;
    Runways:array[1..3] of TRunwayobj;
    Runtime:integer;
    NextArrivalNbr, NextDepartureNbr:integer;
    function shortestqueue(ptype:TQtype):integer;
    procedure timestep;
  end;

var
  Form1: TForm1;

implementation

uses U_AirportDesc;

{$R *.lfm}

{TQOBJ  methods }

 constructor TQobj.create(listbox:Tlistbox;
                       NewQtype:TQType;
                       NewRunway:TRunwayObj);
 begin
   inherited create(listbox.owner);
   parent:=listbox.parent;
   left:=listbox.left;
   top:=listbox.top;
   width:=listbox.width;
   height:=listbox.height;
   font:=listbox.font;
   color:=listbox.color;
   visible:=true;
   runway:=Newrunway;
   QType:=newQtype;
   labelbox:=TLabel.create(owner);
   with labelbox do
   begin
     left:=self.left;
     width:=64;
     height:=40;
     If qtype=arrival then top:=self.Top-height
     else top:=self.top+self.height;
     parent:=self.parent;
     autosize:=false;
   end
 end;

 procedure TQobj.clear;
 var i:integer;
 begin
   for i := 0 to items.count-1 do TPlaneobj(items.objects[i]).free;
   inherited;
   labelbox.caption:='';
   totalin:=0;
   totalout:=0;
 end;


{TRUNWAYOBJ methods}

constructor TRunwayObj.create(Listbox:TListbox;
                      Newnbr:integer
                      );
 begin
   inherited create(listbox.owner);
   parent:=listbox.parent;
   left:=listbox.left;
   top:=listbox.top;
   width:=listbox.width;
   height:=listbox.height;
   font:=listbox.font;
   color:=listbox.color;
   style:=lbOwnerDrawFixed;
   OnDrawItem:=RunwayDrawItem;
   clear;
   Nbr:=newnbr;
   listbox.free;

 end;

 procedure TRunwayObj.clear;
 begin
   Available:=true;
   Departures:=0;
   DepartureWaitTime:=0;
   MaxDepWait:=0;
   Arrivals:=0;
   ArrivalWaitTime:=0;
   Arrivalfuel:=0;
   MaxArrWait:=0;
   EmergencyLandings:=0;
   EmergencyWaitTime:=0;
   inherited clear;
   items.add(' ');  {just to redraw the centerstripe down the runway}


 end;

procedure TRunwayObj.RunwayDrawItem(Control: TWinControl; Index: Integer;
    Rect: TRect; State: TOwnerDrawState);
  begin
    If index=0 then
    with canvas do
    begin
      pen.width:=1;
      pen.color:=clwindow;
      pen.style:=psdash;
      moveto(clientwidth div 2, 1);
      lineto(clientwidth div 2, clientheight - 1 );
    end;
      canvas.textout(rect.left+2, rect.top+2,items[index]);
  end;

{PlaneObj methods}

constructor TPlaneObj.create(newnbr,newfuel,newtime:integer);
begin
  inherited create;
  Planenbr:=newnbr;
  fuelRemaining:=newfuel;
  arrivaltime:=newtime;
end;

{TForm1 methods}

procedure TForm1.FormCreate(Sender: TObject);

begin
  Runways[1]:=TRunwayObj.create(Listbox8,1);
  Runways[2]:=TRunwayObj.create(listbox9,2);
  Runways[3]:=TRunwayobj.create(listbox10,3);
  queues[1]:=TQobj.create(listbox1,arrival,runways[1]);
  queues[2]:=TQobj.create(listbox2,arrival,runways[1]);
  queues[3]:=TQobj.create(listbox3,arrival,runways[2]);
  queues[4]:=TQobj.create(listbox4,arrival,runways[2]);
  queues[5]:=TQobj.create(listbox5,departure,runways[3]);
  queues[6]:=TQobj.create(listbox6,departure,runways[1]);
  queues[7]:=TQobj.create(listbox7,departure,runways[2]);
  nextarrivalnbr:=0;
  nextdeparturenbr:=-1;
  runtime:=0;
  randomize;
end;


function Tform1.shortestqueue(ptype:TQtype):integer;
{find the shortest queue of specified type}
var
  i:integer;
  minqsize:integer;
begin
  minqsize:=high(minqsize);
  result:=-1;
  for i:= low(queues) to high(queues)  do
  with queues[i] do
  begin
    if (qtype=ptype) and (items.count<minqsize) then
    begin
      minqsize:=items.count;
      result:=i;
    end;
  end;
end;

procedure TForm1.StartBtnClick(Sender: TObject);
{Do Runtime iterations}
var
  i:integer;
begin
  resetbtnclick(sender);
  for i:= 1 to strtoint(edit1.text) do  timestep;
end;

procedure TForm1.StepBtnClick(Sender: TObject);
{Do a single timestep iterations}
begin
  TimeStep;
end;

procedure tform1.Timestep;
{Heart of the simulation}
{Create arrivals, departures, process emergency low fuel landings, then
 normal takeoff and landings and update stats displays}
var
  i,j,k,m:integer;
  p:TPlaneobj;
  {accumulators for displays}
  arrtot,arrtime, arrfueltot, totmaxarrwait:integer;
  deptot,deptime,totmaxdepwait:integer;
  emertot:integer;
  begin
    inc(runtime);
    {new arrivals}
    for j:=1 to random(4) do
    begin
      inc(nextarrivalnbr,2);
      p:=TPlaneObj.create(nextarrivalnbr,random(21),runtime);
      with queues[shortestqueue(arrival)] do
      begin
       items.addobject('Id#'+inttostr(nextarrivalnbr),p);
       inc(Totalin);
      end;
    end;
    {new departures}
    for j:=1 to random(4) do
    begin
      inc(nextdeparturenbr,2);
      p:=TPlaneobj.create(nextdeparturenbr,999,runtime);
      with queues[shortestqueue(departure)] do
      begin
       items.addobject('Id#'+inttostr(nextdeparturenbr),p);
       inc(totalin);
      end;
    end;
    {mark all runways available}
    for j:=low(runways) to high(runways) do runways[j].available:=true;
    {look for fuel emergencies}
    for j:=low(queues) to high(queues) do
    with queues[j] do
    if (qtype=arrival) and (items.count>0) then
    begin
      k:=0;
      while k<=items.count-1 do
      begin
        p:=TPlaneobj(items.objects[k]);
        if p.fuelremaining<=0 then
        begin
          if runways[3].available then {use runway 3 for 1st emergency landing}
          with runways[3] do
          begin
            inc(Arrivals);
            inc(ArrivalWaitTime,p.WaitTime);
            Inc(ArrivalFuel,p.fuelRemaining);
            inc(EmergencyLandings);
            inc(EmergencyWaitTime);
            available:=false;
            queues[j].items.delete(k); {delete the entry, no need to increment k}
            inc(queues[j].totalout);
            freeandnil(p);
          end
          else
          {try and find another available runway for emergency landing}
          for m:= 1 to 2 do
          if runways[m].available then
          with runways[m] do
          begin
            inc(arrivals);
            inc(arrivalwaittime,p.waittime);
            Inc(ArrivalFuel,p.fuelRemaining);
            inc(EmergencyLandings);
            inc(EmergencyWaitTime);
            available:=false;
            queues[j].items.delete(k); {delete the entry, no need to increment k}
            inc(queues[j].totalout);
            freeandnil(p);
            break;
          end;
          if assigned(p) then inc(k); {it couldn't land, skip it}
        end
        else inc(k);
      end;
    end;
    {Now process  normal landings and takeoffs}
    for j:=low(queues) to high(queues) do
    with queues[j] do
    begin
      if (items.count>0) then
      begin
        p:=TPlaneobj(items.objects[0]);
        if runway.available then
        with runway do
        begin
          if qtype=arrival then
          Begin
            inc(arrivals);
            inc(arrivalwaittime,p.waittime);
            Inc(ArrivalFuel,p.fuelRemaining);
            If p.waittime>maxarrwait then maxarrwait:=p.waittime;
          end
          else
          begin
            inc(departures);
            inc(departurewaittime,p.waittime);
            If p.waittime>maxdepwait then maxdepwait:=p.waittime;
          end;
          available:=false;
          queues[j].items.delete(0);
          inc(queues[j].totalout);
          freeandnil(p);
        end;
        {for the rest, increase wait time and decrease fuel}
        for k:=0 to items.count-1 do
        with TPlaneobj(items.objects[k]) do
        begin {inc waittime and reduce fuelremanining}
          inc(waittime);
          If qtype=departure then dec(fuelremaining);
        end;
      end;
    end;
    {display some stats}
    arrtot:=0; arrtime:=0; arrfueltot:=0;
    deptot:=0; deptime:=0;
    emertot:=0;
    totmaxarrwait:=0; totmaxdepwait:=0;
    for i:= low(runways) to high(runways) do
      with runways[i], items do
      Begin
        clear;
        add('Takeoffs');
        add('  Count:'+inttostr(Departures));
        add('  Wait:'+Inttostr(Departurewaittime));
        add('Landings');
        add('  Count:'+inttostr(Arrivals));
        add('  Wait:'+Inttostr(Arrivalwaittime));
        add('Emergencies');
        add('  Count:'+inttostr(EmergencyLandings));
        add('  Wait:'+Inttostr(Emergencywaittime));
        arrtot:=arrtot+Arrivals; arrtime:=arrtime+Arrivalwaittime;
        deptot:=deptot+departures; deptime:=deptime+DepartureWaittime;
        arrfueltot:=arrfueltot+ArrivalFuel;
        emertot:=emertot+EmergencyLandings;
        if maxarrwait>totmaxarrwait then totmaxarrwait:=maxarrwait;
        if maxdepwait>totmaxdepwait then totmaxdepwait:=maxdepwait;
      end;

      for i:= low(queues) to high(queues) do
      with queues[i], labelbox do
      Begin
        caption:='Totalin:'+inttostr(Totalin)
                 +#13+'TotalOut:'+Inttostr(Totalout);
      end;
      If arrtot>0 then
      LQLbl.Caption:='Landing Queues'+#13
                     +'Landings:'+inttostr(arrtot)+#13
                     + 'Avg Landing Wait: '+ format('%4.1f',[arrtime/arrtot])+#13
                     + 'Avg Fuel Remaining: '+ format('%4.1f',[arrfueltot/arrtot])
                     +#13+'Max Landing Wait: ' +inttostr(totmaxarrwait);
      If deptot>0 then
      TQLbl.Caption:='Takeoff Queues'+#13
                     + 'Takeoffs:'+inttostr(deptot)+#13
                     + 'Avg Takeoff Wait: '+ format('%4.1f',[deptime/deptot])
                     +#13+'Max Takeoff Wait:' +inttostr(totmaxdepwait);
      RunwayLbl.Caption:= 'Runways'+#13
                      + 'Emergencies: '+inttostr(emertot);
  end;   {TimeStep}


procedure TForm1.ResetBtnClick(Sender: TObject);
var
  i:integer;
begin
  runtime:=0;
  nextarrivalnbr:=0;
  nextdeparturenbr:=-1;
  For i:=low(queues) to high(queues) do queues[i].clear;
  for i:= 1 to 3 do runways[i].clear;
  LQLbl.Caption:='Landing Queues';
  TQLbl.Caption:='Takeoff Queues';
  RunwayLbl.Caption:= 'Runways';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  form2.showmodal;
end;

end.
