unit U_TMaze;

{$MODE Delphi}

{Copyright 2001, 2011 Gary Darby, www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{The TMAZE class }

{****$DEFINE DEBUG}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, Printers, StdCtrls, ComCtrls,
  Types
  ;
Const
  {Version is saved with maze files and used at read time to correctly handle
   file format chnages}
  {version:integer=100;} {original}
  {version:integer=101;} {added 3 header/footer fields}
  version:integer=102; {correct header font save}
  MaxMazeRows=100;
  MaxMazeCols=300;

 Debugseed=100;
 erase=true;
 noerase= not erase;

type
  TDir=(Lefft,Right,Up,Down,Unknown);
  TDirArray=array[lefft..down] of byte;
  Troomtype=(open,closed,border);
  TMode=(play,design,building, buildingfalse);
  TMazerec = record
     roomtype:Troomtype;
     DirsTried:TDirArray; {Directions already tried from this block}
     exitpaths:TDirArray; {doors from this room}
   end;

  TOldMazerec = record
     roomtype:Troomtype;
     DirsTried:TDirArray; {Directions already tried from this block}
     exitpaths:TDirArray; {doors from this room}
   end;

  TMove=class (TObject) {to track moves in play mode}
      x,y:integer;
      dir:TDir;
    end;
  TMazeRows=array of TMazerec;
  TMazeArray=array of TMazeRows;
  THeaderType=(None, Header,Footer);
  TPlayMoveProc=Procedure(count:integer) of object; {OnMove Event}

const
  moveoffsets:array[lefft..down] of tpoint =
                ((x:-1;y:0),(x:+1;y:0),(x:0;y:-1),(x:0;y:+1));
  dirstrings:array[lefft..down] of string=
                ('L','R','U','D');

type
    TMouse=class(Tobject)
      CurPos:TPoint; {Current position}
      Path:TList;    {Path of past points}
    End;

    TMaze=class(Timage)
     Public {protected}

     //Public
       NbrCols:integer;
       NbrRows:integer;
       origwidth,origheight:integer;
       wallwidth,pathwidth:integer;
       bkcolor,wallcolor,pathcolor,solvedpathcolor,outsidecolor:TColor;
       wallstyle,pathstyle,solvedpathstyle:TPenStyle;
       widthx,widthy:integer;
       halfwidthx,halfwidthy:integer;
       mode:TMode;
       m: TMazearray;
       buildMoves, playmoves, buildMovesCopy :TStringList;
       curpoint, startpoint, endpoint :TPoint;
       doorsize:integer;  {percent of wall opening for doors}
       showpaths, showsolutionpath:boolean;
       modified:boolean;
       maintainaspect:Boolean;
       tracing:boolean;
       filename:string;
       debug:boolean;
       Concatenate:boolean; {Concatenate file reads}
       RestoreColors:boolean; {Load colors from saved mazes}
       lastpoint:Tpoint; {used in design mode to save previous room changed}
       aspect:real;
       openrooms:Boolean; {Make open rooms - remove unnecessary walls}
       longpaths:boolean; {Make 2 room moves when possible}

       {Print options}
       PaperLayout:TPrinterOrientation;
       //PrintScaling:TPrintScale;
       Headertype:THeaderType;
       Headertext:string;
       HeaderFont:TFont;

       ONPlayMove:TPlayMoveProc; {call back routine to pass move counts to caller}
       playcount:integer;
       mademove:boolean; {set by mousemove if position is a valid move location} 

         {Initialization}
         Constructor create(Aowner:TComponent);  override;
         Procedure SetScreensize(l,t,w,h:integer);
         Procedure initialize(maxx,maxy:integer);
         Procedure resetimage;
         Procedure SetAspect;
         Procedure setxsize(x:integer);
         Procedure setysize(y:integer);
         Procedure SetWidthx(wx:integer);
         Procedure SetWidthy(wy:integer);
         Procedure SetHeader(htype:THeaderType; htext:string;hFont:Tfont);
         Procedure Rescale(x,y:integer);
         procedure setmaxsize;

         {Image manipulation}
         Procedure makeborders;
         Procedure clearborders;
         Procedure makeimage;
         Procedure InvertAllblocks;
         Procedure makefalsepaths(p:TPoint);
         Procedure makepath(dir:TDir);{Make a path as long as possible}
         Function  imageclear:boolean; {Return true if no rooms defined in maze}
         Procedure setmode(modetype:TMode);
         Procedure MakeOpenRooms;


         {Primitive moving routines }
         Function CanMakeExit(Dir:TDir):boolean;
         Function CanMakeExit2(Dir:TDir):boolean; {Can make a 2 room move}
         Function CanMove(Dir:TDir):Boolean;
         Function ExistsMove:boolean;
         Procedure Move(Dir:TDir);
         Procedure backtrack(erasepath:boolean);
         Function opposite(dir:TDir):TDir;
         Function GetDirFromChar(C:char):TDir;
         Function ScreentoXY(x,y:integer):TPoint;
         Function inplaymovelist(p:Tpoint; var index:integer):boolean;
         Procedure resetplaymoves;

         {Drawing routines}
         Procedure DrawImage;
         //Procedure Drawtoscale(w,h:integer;Canv:TCanvas);
         Function  Getscale(maxw,maxh:integer):TPoint;
         Procedure drawoutlines;
         Procedure DrawAllPaths;
         Procedure DrawSolutionPath;
         Procedure drawblock(x,y:integer);
         Procedure printblock(x,y:integer;c:char);
         Procedure drawonepath(Var p:TPoint;d:tdir;eraseflag:boolean);
         //Procedure setcursor(p:TPoint);

         {I/O Routines}
         Procedure Savemaze;
         Procedure Readmaze(inname:string);
         Procedure ReadFromStream(inname:string);
         Procedure Debugdraw(s:string; x,y:integer);

         procedure MMouseDown(Sender: TObject; Button: TMouseButton;
                    Shift: TShiftState; X, Y: Integer);

         procedure MMouseMove(Sender: TObject; Shift: TShiftState; X,
                      Y: Integer);
         procedure MMouseUp(Sender: TObject; Button: TMouseButton;
                     Shift: TShiftState; X, Y: Integer);

     End;

type
  TMazeMsgForm = class(TForm)
    Image1: TImage;
    StatusBar1: TStatusBar;
    procedure StartPoint1Click(Sender: TObject);
    procedure ExitPoint1Click(Sender: TObject);
    procedure Invertborderpoints1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MazeMsgForm: TMazeMsgForm;
  maze:TMaze;
  savex,savey:integer;

implementation

{$R *.lfm}

Uses math; {to get access to min & max functions}

function equalpoint(p1,p2:TPoint):boolean;
{Return true if p1 = p2}
begin
  if (p1.x=p2.x) and (p1.y=p2.y) then result:=true
  else result:=false;
end;

{************** CREATE ****************}
Constructor TMaze.create;
Begin
  inherited create(AOwner);
  onmousedown:=MMousedown;
  OnMouseMove:=MMouseMove;
  OnMouseUp:=MMouseUp;
  if aowner is TWincontrol then parent:=TWincontrol(Aowner)
  else showmessage('TMaze owner must be a windowed control');
  buildmoves:=TStringList.create;
  buildmovesCopy:=TStringList.create;
  playmoves:=tstringlist.create;
  bkcolor:=clyellow;
  WallColor:=clblack;
  pathcolor:=clred;
  Solvedpathcolor:=clblue;
  outsidecolor:=clfuchsia;
  wallwidth:=2;
  wallstyle:=pssolid;
  pathwidth:=2;
  NbrCols:=20;
  NbrRows:=20;
  {$IFDEF DEBUG}
    NbrCols:=5;
    NbrRows:=5;
  {$ENDIF}
  pathstyle:=psdot;
  Solvedpathstyle:=psdashdot;
  doorsize:=100;
  showpaths:=false;
  showsolutionpath:=false;
  mode:=play;
  modified:=false;

  PaperLayout:=poLandscape;
  Printer.Orientation:=paperlayout;
  //PrintScaling:=poProportional;
  Headertype:=none;
  Headertext:='';
  Headerfont:=Tfont.create;
  headerfont.assign(font); {just to get something in there}
  maintainaspect:=false;
  openrooms:=true;
  restorecolors:=true;
end;

{***************** Set Screen Origin and size ************}
Procedure TMaze.SetScreensize(l,t,w,h:integer);
Begin
  left:=l;
  top:=t;
  width:=w;
  height:=h;
  origwidth:=width;
  origheight:=height;
end;

{**************** Initialize **************}
Procedure Tmaze.initialize(maxx,maxy:integer);
var
  i,j:integer;
  d:TDir;
  begin
    {$IFNDEF DEBUG}
     randomize; {so that each run is different}
     {$ELSE}
        randseed:=DebugSeed;
    {$ENDIF}
    Setxsize(maxx);
    Setysize(maxy);
    Setaspect;
    makeborders;
    for i:=1 to NbrCols do
    for j:= 1 to NbrRows do
    with m[i,j] do
    Begin
      roomtype:=closed;
      for d:=low(TDirArray) to high(TDirArray) do
      Begin
        if d<>unknown then
        begin
          dirstried[d]:=0;
          exitpaths[d]:=0;
        end
        else
        begin
          dirstried[d]:=1;
          exitpaths[d]:=1;
        end;
      End;
    end;
    with canvas do
    Begin
      brush.color:=bkcolor;
      pen.style:=wallstyle;
      pen.color:=wallcolor;
      pen.width:=wallwidth;
      fillrect(rect(0,0,width,height));
    end;
    startpoint:=point(1,1);
    endpoint:=point(NbrCols,NbrRows);
    modified:=false;
    drawoutlines;
  end;

{**************** Setaspect *******************}
{Set drawing widths and heights based on MaintainAspect flag}
Procedure TMaze.setaspect;
  Begin
    setwidthx(width div NbrCols) ;
    Setwidthy(height div NbrRows);
    if widthy>0 then aspect:=widthx/widthy else aspect:=1;
  End;

{**************** Rescale ******************}
Procedure Tmaze.Rescale(x,y:integer);
Begin
  Setxsize(x);
  Setysize(y);
  Setaspect;
end;

{*************** SetXSize *****************}
 Procedure TMaze.setxsize(x:integer);
 var
   oldsize:integer;
 Begin
   if x<>NbrCols then modified:=true;
   oldsize:=NbrCols;
   NbrCols:=x;
   if widthx>0 then width:=NbrCols*widthx;
   if endpoint.x>NbrCols then endpoint.x:=NbrCols;
   if endpoint.y>NbrRows then endpoint.y:=NbrRows;
   if startpoint.x>NbrCols then startpoint.x:=NbrCols;
   if startpoint.y>NbrRows then startpoint.y:=NbrRows;
   setlength(m,x+2);   {dynamic}
   if NbrCols>oldsize {need to reset NbrRows when NbrCols increases to set new row }
   then setysize(NbrRows);  {lengths for the new columns}
 End;

 {***************** SetYSize *****************}
 Procedure TMaze.setysize(y:integer);
 var
   i:integer;
 Begin
   if y<>NbrRows then modified:=true;
   NbrRows:=y;
   if widthy>0 then height:=NbrRows*widthy;
   if endpoint.x>NbrCols then endpoint.x:=NbrCols;
   if endpoint.y>NbrRows then endpoint.y:=NbrRows;
   if startpoint.x>NbrCols then startpoint.x:=NbrCols;
   if startpoint.y>NbrRows then startpoint.y:=NbrRows;
   for i:= low(m) to high(m)
     do setlength(m[i],y+2);  {dynamic}
 End;

 procedure TMaze.setmaxsize;
 begin
   setXsize(maxmazecols);
   setYsize(maxmazerows);
 end;


{********************* SetWidthX ***************}
 Procedure TMaze.SetWidthx(wx:integer);
 Begin
   widthx:=wx;
   if maintainaspect and (aspect<>0)
   then widthy:=trunc(widthx / aspect);
   if widthy>0 then
   begin
     height:=NbrRows*widthy;
   end;
   if widthx>0 then width:=NbrCols*widthx;
   halfwidthx:=widthx div 2;
   halfwidthy:=widthy div 2;
   Picture.bitmap.height:=height;
   Picture.bitmap.width:=width;
 End;

 {******************* SetWidthY **************}
 Procedure TMaze.SetWidthy(wy:integer);
 Begin
   widthy:=wy;
   if maintainaspect and (aspect<>0) then widthx:=trunc(widthy*aspect);
   if widthy>0 then height:=NbrRows*widthy;
   if widthy>0 then width:=NbrCols*widthx;
   halfwidthx:=widthx div 2;
   halfwidthy:=widthy div 2;
   Picture.bitmap.height:=height;
   Picture.bitmap.width:=width;
 End;

{***************** SetHeader ******************}
Procedure TMaze.SetHeader(htype:THeaderType; htext:string;hFont:Tfont);
  Begin
    HeaderType:=htype;
    HeaderText:=htext;
    HeaderFont.assign(hFont);
  End;

{****************** CanMakeExit ************}
{ Test is a move in direction Dir from current point could be valid}
Function TMaze.CanMakeExit(Dir:TDir):boolean;
var
  newx,newy:integer;
Begin
  result:=false;
  if dir=unknown then exit;
  with curpoint do
  begin
    if m[x,y].dirstried[dir]=1 then exit; {we've already tried that direction}
    newx:=x+moveoffsets[dir].x;
    newy:=y+moveoffsets[dir].y;
  end;
  if (m[newx,newy].roomtype=closed) then {it's an available room}
  case dir of
  up,down:
    {if wall or border left and right, then it's OK}
    if (m[newx+1,newy].roomtype>=closed) and (m[newx-1,newy].roomtype>=closed)
    then result:=true;
  lefft,right:
    {if wall or border above and below, then it's OK}
    if (m[newx,newy+1].roomtype>=closed) and (m[newx,newy-1].roomtype>=closed)
    then result:=true;
  end;
end;

{********************** CanMakeExit2 *******************+
{ Test for a valid new move 2 rooms away in direction Dir from current point}
Function TMaze.CanMakeExit2(Dir:TDir):boolean;
var
  newx1,newy1, newx2, newy2:integer;
  test1, test2:Troomtype;
Begin
  result:=false;
  if dir=unknown then exit;
  if m[curpoint.x,curpoint.y].dirstried[dir]=1 then exit;
  newx1:=curpoint.x+moveoffsets[dir].x;
  newy1:=curpoint.y+moveoffsets[dir].y;
  test1:=m[newx1,newy1].roomtype;
  newx2:=newx1+moveoffsets[dir].x;
  newy2:=newy1+moveoffsets[dir].y;
  if (newx2>=1) and (newx2<=NbrCols) and (newy2>=1) and (newy2<=NbrRows)
  then test2:=m[newx2,newy2].roomtype else test2:=border;
  if (test1=closed) and (test2=closed)
  then
  case dir of
  up,down:
    if (m[newx1+1,newy1].roomtype>=closed) and (m[newx1-1,newy1].roomtype>=closed)
      and (m[newx2+1,newy2].roomtype>=closed) and (m[newx2-1,newy2].roomtype>=closed)
      then result:=true;
  lefft,right:
    if (m[newx1,newy1+1].roomtype>=closed) and (m[newx1,newy1-1].roomtype>=closed)
       and (m[newx2,newy2+1].roomtype>=closed) and (m[newx2,newy2-1].roomtype>=closed)
       then result:=true;
  end;
end;

{****************** CanMove ************}
{ Test for a valid move in direction Dir from current point}
Function TMaze.CanMove(Dir:TDir):boolean;
Begin
  result:=false;
  if (dir<>unknown) and
    (m[curpoint.x,curpoint.y].exitpaths[dir]>0) then result:=true;
end;

{************** ExistMove ***********}
Function TMaze.ExistsMove:boolean;
{Return true if there is a valid move in at least one direction}
var
  dir:TDir;
  OK:boolean;
Begin
  dir:=low(TDir);
  OK:=false;
  repeat
    If CanMakeExit(dir) then OK:=true
    else if dir<down then inc(dir) else break {done:=true}
  until OK {or done};
  result:=OK;
End;

{*************** Move ***********}
{ Move one room from current point in Dir direction}
Procedure TMaze.Move(Dir:TDir);
Begin
  m[curpoint.x,curpoint.y].exitpaths[dir]:=1;
  m[curpoint.x,curpoint.y].dirstried[dir]:=1;
  curpoint.x:=curpoint.x+moveoffsets[dir].x;
  curpoint.y:=curpoint.y+moveoffsets[dir].y;
  with  m[curpoint.x,curpoint.y] do
  Begin
    roomtype:=open;
    exitpaths[opposite(dir)]:=1;
  end;
  If mode in [building, buildingfalse]  then
  begin
    buildmoves.add(dirstrings[dir]);
  end;
end;

{********************* Opposite **************}
{Return a direction opposite of supplied direction}
Function TMAze.opposite(dir:TDir):TDir;
Begin
  result:=unknown;
  case dir of
    lefft: result:=right;
    right: result:=lefft;
    up: result:=down;
    down: result:=up;
  end;
end;

{**************** GetDirFromChar ************}
{Return a direction from supplied character}
Function TMAze.GetDirFromChar(C:char):TDir;
Begin
  case c of
    'L': result:=lefft;
    'R': result:=right;
    'U': result:=up;
    'D': result:=down;
    else result:=unknown;
  end;
end;

{****************** ScreenToXY ******************}
Function TMaze.ScreentoXY(x,y:integer):Tpoint;
{convert  mouse coordinates to maze cell coordinates}
Begin
  result.x :=x div widthx + 1;
  result.y  := y div widthy + 1;
end;

{********************* InPlayMoveList *****************}
Function TMaze.inplaymovelist(p:Tpoint; var index:integer):boolean;
var
  found:boolean;
  moves:TMove;
Begin
  result:=false;
  If playmoves.count=0 then exit;
  found:= false;
  index:=0;
  while not found and (index<playmoves.count) do
  Begin
    moves:=TMove(playmoves.objects[index]);
    if (moves.x=p.x) and (moves.y=p.y) then found:=true
    else inc(index);
  end;
  result:=found;
end;

{**************** Backtrack **********}
Procedure TMaze.Backtrack(Erasepath:boolean);
{Reverse go back the way we entered this room from current point}
{Reconstruct the wall and forget how we got here if Erasepath is true}
var
  d,od:Tdir;
Begin
  if mode=play then d:=GetdirFromChar(playmoves[playmoves.count-1][1])
  else
  if mode in [building,buildingfalse] then
    If buildmoves.count>0 then
         d:=GetdirFromChar(buildmoves[buildmoves.count-1][1])
    else
    begin
      showmessage('Tried to backtrack past start -  call Grandpa');
      exit;
    end
  else
  Begin
    showmessage('Unknown mode while backtracking - call Grandpa');
    Exit;
  end;
  od:=opposite(d);
  if erasepath then
  with m[curpoint.x,curpoint.y] do
  Begin
    roomtype:=closed; {put wall back}
    exitpaths[od]:=0;
  end;
  curpoint.x:=curpoint.x+moveoffsets[od].x;
  curpoint.y:=curpoint.y+moveoffsets[od].y;
  if erasepath then m[curpoint.x,curpoint.y].exitpaths[(d)]:=0; {Mark not a path}
  if (mode in [building, buildingfalse]) and (buildmoves.count>0)
  then buildmoves.delete(buildmoves.count-1)
end;


{******************* ResetPlayMoves *****************}
 Procedure TMaze.resetplaymoves;
 Begin
    Playmoves.clear;
    playcount:=0;
    If assigned(onplaymove) then onplaymove(playcount);
    curpoint:=startpoint;
 end;

{*********************** ResetImage **************}
{Replace paths with walls - leave borders alone}
Procedure TMaze.resetimage;
var
  i,j:integer;
  d:TDir;
  Begin
    {$IFDEF DEBUG}
       Randseed:=DebugSeed;
    {$ENDIF}
    Resetplaymoves;
    buildmoves.clear;
    for i:=1 to NbrCols do
    for j:= 1 to NbrRows do
    with m[i,j] do
    Begin
      if roomtype=open then roomtype:=closed;
      for d:= low(TdirArray) to high(TdirArray) {lefft to down} do
      if d<>unknown then
      Begin
        dirstried[d]:=0;
        exitpaths[d]:=0;
      end
      else
      Begin
        dirstried[d]:=1;
        exitpaths[d]:=1;
      end;
    End;
    with canvas do
    Begin
      brush.color:=bkcolor;
      pen.style:=wallstyle;
      pen.color:=wallcolor;
      pen.width:=wallwidth;
      fillrect(rect(0,0,width,height));
    end;
    drawoutlines;
  end;

{****************** MakeBorders *******************}
 Procedure TMaze.makeborders;
 var
   i,j:integer;
   Begin
    for i:=0 to NbrCols+1 do
    begin
      m[i,0].roomtype:=border;
      m[i,NbrRows+1].roomtype:=border;
    end;
    for j:=0 to NbrRows+1 do
    begin
      m[0,j].roomtype:=border;
      m[NbrCols+1,j].roomtype:=border;
    end;
  end;

{****************** ClearBorders *************}
Procedure Tmaze.clearborders;
  var
    i:integer;
  Begin
    for i:= 0 to NbrCols+1 do m[i,NbrRows+1].roomtype:=closed;
    for i:= 0 to NbrRows+1 do m[NbrCols+1,i].roomtype:=closed;
  end;

{******************* MakeImage *************}
Procedure TMaze.makeimage;
{Make solution path}
var
  stuck:boolean;
  testdir:tdir;
  move2:boolean;
Begin
  {Makesolution path}

  resetimage;
  setmode(building);
  with m[startpoint.x,startpoint.y] do
  begin
    roomtype:=open;
  end;

  curpoint:=startpoint;
  stuck:=false;

  repeat
    if existsmove then
    Begin
      move2:=false;
      Repeat
        testdir:=tdir(random(ord(down)+1));
        if (longpaths) and CanMakeExit2(testdir) then move2:=true;
      until CanMakeExit(testdir);
      move(testdir);
      //form1.Memo1.Lines.add(format('Make path to (%d, %d)',[curpoint.x,curpoint.y]));
      if move2 then move(testdir);
    end
    else
    begin
      //oldpoint:=curpoint;
      backtrack(erase);
      //form1.Memo1.Lines.add(format('Backfrom (%d,%d) to (%d, %d)',
      //       [oldpoint.x, oldpoint.y,curpoint.x,curpoint.y]));
    end;
    {$IFDEF Debug2}
      inc(count);
      {If count mod 100 = 0 then}
      Begin
        drawimage;
        showmessage('Debug');
      end;
    {$ENDIF}

    {if backtracked back to beginning - not solvable}
    if equalPoint(curpoint,startpoint) then stuck:=true;
  until (stuck)or(equalpoint(curpoint,endpoint));
   {$IFDef Debug}
    showmessage('Debug- mazebuilt');
  {$Endif}
  If stuck then showmessage('Failed')
  else
  begin
    modified:=true;
    {Copy real moves so that false paths won't double back on them}
    BuildMovesCopy.assign(BuildMoves);
    setmode(buildingfalse);
    Makefalsepaths(Startpoint);
    setmode(building);
    If openrooms then MakeOpenRooms;
  end;
  curpoint:=startpoint;
end;

{******************* MakeFalsePaths **************}
Procedure TMaze.makeFalsepaths(p:TPoint);
Var
  holdmoves:TStringlist;
  i,j:integer;
  d:tdir;
  newp:Tpoint;
  Begin
    {Create a bunch of false paths - solution pretty easy otherwise}
    holdmoves:=TstringList.Create;
    holdmoves.AddStrings(buildmoves);
    buildmoves.clear;

    {clear out directions tried}
    for i:= 1 to NbrCols do
      for j:=1 to NbrRows do
        for d:=lefft to down do m[i,j].dirstried[d]:=0;

    {Generate false paths off of this path}
    curpoint:=p;
    for i:=0 to holdmoves.count-1 do
    case holdmoves[i][1] of
    'L','R':
      Begin
        if CanMakeExit(up) then makepath(up);
        if CanMakeExit(down) then makepath(down);
        If holdmoves[i][1]='L' then dec(curpoint.x)
        else inc(curpoint.x);
      end;

    'U','D':
      Begin
        if CanMakeExit(lefft) then makepath(lefft);
        if CanMakeExit(right) then makepath(right);
        If holdmoves[i][1]='U' then dec(curpoint.y)
        else inc(curpoint.y);
      End;
    end;{case}

    If buildmoves.count>0 then
    Begin
      {If we made a path, then make recursive call to make
       more paths off of this one}
      newp:=curpoint;
      makefalsepaths(newp);
    end;
    buildmoves.assign(holdmoves);
    holdmoves.free;
  end;

{****************** DrawBlock ***************}
Procedure tmaze.drawblock(x,y:integer);
var
  nx,ny:integer;
  halfwidth:integer;
Begin
  nx:=(x-1)*widthx;
  ny:=(y-1)*widthy;
  halfwidth:=wallwidth div 2;
  with canvas do
  Begin
    If m[x,y].roomtype=border then
    Begin
       //if pixels[nx,ny]<>outsidecolor
       //then form1.memo1.lines.add(format('Mismatch 1 x:%d, Y=%d',[x,y]));
       brush.color:=outsidecolor;
       fillrect(rect(nx-halfwidth+1 ,ny-halfwidth+1,nx+widthx+halfwidth-1,
                     ny+widthy+halfwidth-1));
    end
    else
    Begin
      pen.color:=wallcolor;
      pen.width:=wallwidth;
      (*
       if pixels[nx,ny]<>bkcolor
       then form1.memo1.lines.add(format('Mismatch 2 x:%d, Y=%d',[x,y]));
      *)
      brush.color:=bkcolor;
      canvas.rectangle(nx,ny,nx+widthx+1,ny+widthy+1);
    End;
  end;
  If (startpoint.x=x) and (startpoint.y=y) then printblock(x,y,'S')
  else If (endpoint.x=x) and (endpoint.y=y) then printblock(x,y,'E');
end;

{******************* Makepath **********}
Procedure TMaze.Makepath(dir:TDir);
{Draw a false path starting from curpoint in direction "dir"}
var
  start:TPoint;
  testdir:TDir;
  stuck:boolean;
Begin
  start:=curpoint;
  stuck:=false;
  If CanMakeExit(dir) then move(dir);
  repeat
    if existsmove then
    Begin
      Repeat
        testdir:=tdir(random(ord(down)+1));
      until CanMakeExit(testdir);
      move(testdir);
    end
    else backtrack(NoErase);
    {if backtracked back to beginning - we're done}
    if (curpoint.x=start.x) and (curpoint.y=start.y) then stuck:=true;
  until (stuck);
end;

{********************** ImageClear **************}
Function TMaze.imageclear:boolean; {Return true if no rooms defined in maze}
Var
  i,j:integer;
  roomfound:boolean;
  Begin
    roomfound:=false;
    i:=1;
    while (not roomfound) and (i<=NbrCols) do
    Begin
      j:=1;
      while (not roomfound) and (j<=NbrRows) do
      Begin
        if m[i,j].roomtype<>closed then roomfound:=true;
        inc(j);
      end;
      inc(i);
    End;
    result:=not roomfound;
  end;

  {******************** SetMode *************}
  Procedure TMaze.Setmode(modetype:TMode);
  var p:TPoint;
  Begin
    mode:=Modetype;
    if mode=design then
    begin
      lastpoint.x:=1;
      lastpoint.y:=1;
    end
    else if mode=play then
    begin
      with startpoint do
      p:=clienttoscreen(point((x-1)*widthx+halfwidthx,(y-1)*widthy+halfwidthy));
      setcursorpos(p.x,p.y);
    end;
  end;

{******************** MakOpenRooms *************}
  Procedure TMaze.MakeOpenRooms;
  var
    i,j,looped:integer;
    newx,newy:integer;
    d:TDir;
    p:TPoint;
        (*
        function exitcount(x,y:integer):integer;
        var
          d:TDir;
        begin
          result:=0;
          for d:=lefft to down do
          if m[x,y].exitpaths[d]<>0 then inc(result);
        end;
        *)
  Begin
    for i:=1 to NbrCols do
    for j:= 1 to NbrRows do
    if m[i,j].roomtype<>border then
    Begin
      {try this - if no exit paths from a room, open up one a wall at random}
      {original code - add an exit if there are none }
      If m[i,j].roomtype=closed {exitcount(i,j)=0} then {no outlet}
      Begin
        {find a way out of the room - but not into a room with no other exits}
        looped:=0;
        repeat
          d:=tdir(random(4));
          newx:=i+moveoffsets[d].x;
          newy:=j+moveoffsets[d].y;
          inc(looped);
        until ((m[newx,newy].roomtype<>border) and (m[newx,newy].roomtype=open))
        or (looped>20);
        p:=point(i,j);
        p.x:=p.x+moveoffsets[d].x;
        p.y:=p.y+moveoffsets[d].y;
        if m[p.x,p.y].roomtype<>border then
        begin
          m[i,j].exitpaths[d]:=1;
          m[i,j].roomtype:=open;
          {if we made an exit from a to b, we also made an exit from b to a}
          //p.x:=p.x+moveoffsets[d].x;
          //p.y:=p.y+moveoffsets[d].y;
          with m[p.x,p.y] do
          Begin
            roomtype:=open;
            exitpaths[opposite(d)]:=1;
          end;
        end;
      end;
    end;
  end;


  {*************** Printblock *********************}
  Procedure tmaze.printblock(x,y:integer;c:char);
  var
    p:TSize;
  Begin
    with canvas do
    Begin
      font.height:=widthy-2;
      font.style:=[fsbold];
      p:=textextent(c);
      textout((x-1)*widthx+1,(y-1)*widthy+1,c);
      if c=' ' then
      Begin
        brush.color:=bkcolor;
        If m[x,y].roomtype =border then brush.color:=outsidecolor;
        fillrect(rect((x-1)*widthx+1,
                      (y-1)*widthy+1,
                       x*widthx-wallwidth-1,
                       y*widthy-wallwidth-1));
      end
      {Start or end point shouldn't be a border point}
      else If m[x,y].roomtype =border then
      begin
        m[x,y].roomtype:=closed;
        drawblock(x,y);
      end;

  end;
end;


{********************* DebugDraw *****************}
Procedure TMAze.DebugDraw(s:string; x,y:integer);
var
  result:integer;
  Begin
    mazemsgform.image1.canvas.draw(0,0,self.picture.bitmap);

    mazemsgform.invalidate;
    mazemsgform.show;

    s:=s+ ' '+inttostr(x)+' '+inttostr(y);
    result:=messagedlgpos(s,mtconfirmation,[mbOK,mbcancel],0,50,50);
    if result=mrcancel
    then
    Begin
      debug:=false;
      mazemsgform.hide;
    end;
  end;


{***************** DrawOutlines ****************}
  Procedure TMaze.drawoutlines;
  var
    x,y:integer;
    i,j:integer;
  Begin
    {First fill in all sides}
    {$IFDEF Debug}
       {if debug then Mazemsgform.show;}
    {$ENDIF}
    with canvas do
    Begin
      {Draw all vertical lines}
      for x:=0 to NbrCols+1 do
      Begin
        moveto(x*widthx,0);
        lineto(x*widthx,NbrRows*widthy);
      End;
      {Draw all horizontal lines}
      for y:=0 to NbrRows+1 do
      Begin
        moveto(0,y*widthy);
        lineto((NbrCols)*widthx,y*widthy);
      End;
      {Draw all border blocks}
      for i:= 1 to NbrCols do
      for j:= 1 to NbrRows do
      begin
        if m[i,j].roomtype=border then drawblock(i,j); {draw borders}
        //if debug then debugdraw('borde drawn at',i,j);
      end;
      {draw all closes & open rooms}
      for i:= 1 to NbrCols do
      for j:= 1 to NbrRows do
      begin
        if m[i,j].roomtype<>border then drawblock(i,j);  {draw closed & open rooms}
        //if debug then debugdraw('Block drawn at',i,j);
      end;

    end;
    {If debug then MazeMsgform.hide;}
  end;

{*************** Drawonepath *******************}
{draw a path to next block and change p to point to new block}
Procedure TMaze.drawonepath(var p:TPoint;d:Tdir; eraseflag:boolean);
var
  cx,cy:integer;
  tox,toy:integer;
Begin
  with canvas, pen  do
  begin
    If eraseflag then color:=bkcolor else color:=solvedpathcolor;
    cx:=(p.x-1)*widthx;
    cy:=(p.y-1)*widthy;
    case d of
      lefft:
        begin
          moveto(cx+halfwidthx,cy+halfwidthy);
          tox:=cx-halfwidthx;
          toy:=cy+halfwidthy;
          lineto(tox,toy);
          dec(p.x)
        end;
      right:
        begin
          moveto(cx+halfwidthx,cy+halfwidthy);
          tox:=cx+widthx+halfwidthx;
          toy:=cy+halfwidthy;
          lineto(tox,toy);
          inc(p.x);
        end;
      up:
        begin
          moveto(cx+halfwidthx,cy-halfwidthy);
          tox:=cx+halfwidthx; toy:=cy+halfwidthy;
          lineto(tox,toy);
          dec(p.y);
        end;
      down:
        begin
          moveto(cx+halfwidthx,cy+halfwidthy);
          tox:=cx+halfwidthx; toy:=cy+halfwidthy+widthy;
          lineto(tox,toy);
          inc(p.y);
        end;
    end;{case}
    //p2:=clienttoscreen(point(tox,toy));
    //setcursorpos(p2.x,p2.Y);
  end;  {with canvas}
end;

(*
{*********** SetCursor ***********}
procedure TMaze.setcursor(p:TPoint);
{Set the mouse cursor to the passed maze point}
var
  p2:TPoint;
begin
  p2:=clienttoscreen(p);
  with p2 do setcursorpos((x-1)*NbrCols+halfwidthx,(y-1)*NbrRows+halfwidthy);
  form1.memo1.lines.add(format('Mouseto (%d,%d)',[p2.x,p2.Y]));
end;
*)


{******************* DrawSolutionPath **************}
 Procedure TMaze.DrawSolutionPath;
  var
    i:integer;
    p:Tpoint;
    flag:boolean;
    begin
      with canvas,Pen do
      begin
        if showSolutionpath then flag:=noerase {color:=Solvedpathcolor}
        else erase;//flag:=erase{color:=bkcolor};
        style:=solvedpathstyle;
        pen.width:=pathwidth;
      end;
      p:=startpoint;
      for i:=0 to buildmoves.count-1
      do drawonepath(p,getdirfromchar(buildmoves[i][1]),flag);
      //setcursor(p);
      invalidate;
    end;


{********************** DrawAllPaths ******************}
 Procedure TMaze.DrawAllPaths;
  var
    cx,cy,x,y:integer;
    p:Tpoint;
    doorstubx:integer;
    doorstuby:integer;
    w1:integer; {adjustment for wallwidth=1}
    usecolor:TColor;
    Wallpen, EraseWallpen, Pathpen, Savepen:TPen;
    Begin
      {Calculate door stub sizes}
      doorstubx:=(widthx*(100-doorsize) div 200)+wallwidth ;
      doorstuby:=(widthy*(100-doorsize) div 200)+wallwidth ;
      If wallwidth=1 then w1:=1 else w1:=0;
      If showpaths then usecolor:=pathcolor else usecolor:=bkcolor;
      savepen:=canvas.Pen;

      wallpen:=TPen.Create;
      erasewallpen:=TPen.create;
      Pathpen:=TPen.create;
      with wallpen do
      begin
        width:=wallwidth;
        color:=wallcolor;
        style:=wallstyle;
      end;
      with erasewallpen do
      begin
        width:=wallwidth;
        color:=bkcolor;
        style:=wallstyle;
      end;
      with Pathpen do
      begin
        width:=pathwidth;
        color:=usecolor;
        style:=pathstyle;
      end;
      {Move through map = knocking out walls as we go}

      p:=startpoint;
      {for dotted and dashed lines - between dots = brushcolor}
      canvas.brush.color:=bkcolor;
      for x:=1 to NbrCols do
      for y:=1 to NbrRows do
      with canvas, pen do
      Begin
        cx:=(x-1)*widthx;
        cy:=(y-1)*widthy;
        if m[x,y].roomtype=open then
        Begin
          {check adjacents}
          {lefft}
          If (m[x-1,y].roomtype=open) and (m[x,y].exitpaths[lefft]=1) then
          Begin {erase left}
            {erase doorway}
            pen.assign(erasewallpen);
            moveto(cx,cy+doorstuby);
            lineto(cx,cy+widthy-doorstuby+w1);
            {draw or erase path}
            pen.assign(pathpen);
            moveto(cx-halfwidthx,cy+halfwidthy);
            lineto(cx+halfwidthx,cy+halfwidthy);
          end;

          {erase right}
          If (m[x+1,y].roomtype=open) and (m[x,y].exitpaths[right]=1) then
          Begin
            pen.assign(erasewallpen);
            moveto(cx+widthx,cy+doorstuby);
            lineto(cx+widthx,cy+widthy-doorstuby+w1);
            pen.assign(pathpen);
            moveto(cx+halfwidthx,cy+halfwidthy);
            lineto(cx+widthx+halfwidthx,cy+halfwidthy);
          end;
          {erase up}
          If (m[x,y-1].roomtype=open) and (m[x,y].exitpaths[up]=1) then
          Begin
            pen.assign(erasewallpen);
            moveto(cx+doorstubx,cy);
            lineto(cx+widthx-doorstubx+w1,cy);
            pen.assign(pathpen);
            moveto(cx+halfwidthx,cy-halfwidthy);
            lineto(cx+halfwidthx,cy+halfwidthy);

          End;
          {erase down}
          If (m[x,y+1].roomtype=open) and (m[x,y].exitpaths[down]=1) then
          Begin
            pen.assign(erasewallpen);
            moveto(cx+doorstubx,cy+widthy);
            Lineto(cx+widthx-doorstubx+w1,cy+widthy);
            pen.assign(pathpen);
            moveto(cx+halfwidthx,cy+halfwidthy);
            lineto(cx+halfwidthx,cy+halfwidthy+widthy);
          end;
        end;
      end;
      wallpen.free;
      erasewallpen.free;
      pathpen.free;
      canvas.pen:=savepen;
    end;

{****************** DrawImage ****************}
  Procedure TMaze.DrawImage;
  Begin
    drawoutlines;
    Drawallpaths;
    DrawSolutionPath; {draw the real path}
    invalidate;
  end;

  {Draws a black and white maze image to scale on specified canvas}
  {Used for printpreview and printing }

(*
{******************* DrawToScale ********************}
  Procedure TMaze.Drawtoscale(w,h:integer;{aspect:real;}Canv:TCanvas);
  var
    p:TPoint;
  Begin
    p:=Getscale(w,h{,aspect});
    canv.stretchDraw(rect(1,1,p.x-2,p.y-2),picture.bitmap);
  end;
*)

  {*********************** GetScale ********************}
  Function TMaze.Getscale(maxw,maxh:integer{;aspect:real}):TPoint;
  var
    pw,ph:integer;
    a1,a2,aspect:real;
  Begin
    {Scale canvas size to aspect provided}
    {Mainly to scale preview canvas to print page orientation}
      a1:=maxw / width;
      a2:=maxh / height;
      if a2<a1 then aspect:=a2 else aspect:=a1;
      pw:=trunc(width * aspect);
      ph:= trunc(height * aspect);
      result.x:=pw;
      result.y:=ph;
  end;

{*************** InvertAll Blocks *************}
Procedure TMaze.InvertAllblocks;
{Reverses border and room blocks}
var
  i,j:integer;
Begin
  for i:=1 to NbrCols do
  for j:=1 to NbrRows do
  begin
    if m[i,j].roomtype=closed then m[i,j].roomtype:=border
    else if m[i,j].roomtype=border then m[i,j].roomtype:=closed;
  end;
end;


{****************** Savemaze **************}
Procedure TMaze.Savemaze;
var
  s:TFileStream;
  count,i,j:integer;
  style:TFontStyles;
  tmpstr:string;
  Begin
    s:=TFileStream.Create(Filename,fmCreate or fmShareExclusive);
    with s do
    try
      position:=0;
      Writebuffer(version,sizeof(version));
      writebuffer(NbrCols,sizeof(NbrCols));
      writebuffer(NbrRows,sizeof(NbrRows));
      writebuffer(origwidth,sizeof(integer));
      writebuffer(origheight,sizeof(integer));
      writebuffer(wallwidth,sizeof(integer));
      writebuffer(pathwidth,sizeof(integer));
      writebuffer(bkcolor,sizeof(TColor));
      writebuffer(wallcolor,sizeof(TColor));
      writebuffer(SolvedPathColor,sizeof(TColor));
      writebuffer(Outsidecolor,sizeof(TColor));
      writebuffer(wallstyle,sizeof(TPenStyle));
      writebuffer(pathstyle,sizeof(TPenStyle));
      writebuffer(SolvedpathStyle,sizeof(TPenStyle));
      writebuffer(widthx,sizeof(integer));
      writebuffer(widthy,sizeof(integer));
      writebuffer(mode,sizeof(TMode));
      for i:= 1 to NbrCols do
      for j:= 1 to NbrRows do
          writebuffer(m[i,j],sizeof(TMazerec));
      {writebuffer(m,sizeof(TMazeArray));}
      count:=buildmoves.count;
      writebuffer(count,sizeof(integer));
      if count>0 then
      Begin
        tmpstr:='';
        setlength(tmpstr,count);
        for i:=1 to buildmoves.count do tmpstr[i]:=buildmoves[i-1][1];
        writebuffer(tmpstr[1],length(tmpstr));
      end;
      writebuffer(curpoint,sizeof(TPoint));
      writebuffer(startpoint,sizeof(TPoint));
      writebuffer(endpoint,sizeof(TPoint));
      writebuffer(doorsize,sizeof(integer));
      writebuffer(showpaths,sizeof(boolean));
      writebuffer(showsolutionpath,sizeof(boolean));
      writebuffer(maintainaspect,sizeof(boolean));
      writebuffer(lastpoint,sizeof(TPoint));
      writebuffer(aspect,sizeof(real));
      writebuffer(PaperLayout,sizeof(TPrinterOrientation));
      //writebuffer(PrintScaling,sizeof(TPrintScale));
      writebuffer(Headertype,sizeof(HeaderType));
      count:=length(HeaderText);
      writebuffer(count,sizeof(count));
      if count>0 then writebuffer(Headertext[1],count);
      tmpstr:=headerfont.name;
      count:=length(tmpstr);
      writebuffer(count,sizeof(count));
      If count>0 then writebuffer(tmpstr[1],count);
      count:=headerfont.size;
      writebuffer(count, sizeof(count));
      style:=headerfont.style;
      writebuffer(style,sizeof(style));
    finally
      s.free;
    end; {try}
    modified:=false;
  end;

{******************** ReadFromStream ******************}
Procedure TMaze.ReadFromStream(inname:string);
var
  s:TFileStream;
  count,i,j:integer;
  style:TFontStyles;
  tmpstr:String;
  w1,w2:integer;
  a1,a2:real;
  version:integer;
  starti:integer;
  tmpxsize,tmpysize:integer;
  tempbkcolor,tempwallcolor,tempSolvedPathColor,tempOutsidecolor:TColor;
    {
    Function max(a,b:integer):integer;
      Begin if a>b then result:=a else result:=b; End;
    }
  Begin
    filename:=inname;
    s:=TFileStream.Create(Filename,fmOpenread);
    with s do
    try
      if concatenate then starti:=NbrCols +1
      else
      Begin
        resetimage;
        starti:=1;
      end;
      {multiple versions can be handled in future}
      readbuffer(version,sizeof(version));
      If version >1000 then
      Begin
        version:=200;
        position:=0;
      end;
      If version>=100 then
      Begin
        readbuffer(tmpxsize,sizeof(NbrCols));
        readbuffer(tmpysize,sizeof(NbrRows));
        If concatenate then
        Begin
          NbrCols:=tmpxsize+NbrCols;
          NbrRows:=max(tmpysize,NbrRows);
        end
        else
        begin
          NbrCols:=tmpxsize;
          NbrRows:=tmpysize;
        end;
        setxsize(NbrCols);
        setysize(NbrRows);
        readbuffer(origwidth,sizeof(integer));
        readbuffer(origheight,sizeof(integer));
        readbuffer(wallwidth,sizeof(integer));
        readbuffer(pathwidth,sizeof(integer));
        readbuffer(tempbkcolor,sizeof(TColor));
        readbuffer(tempwallcolor,sizeof(TColor));
        readbuffer(tempSolvedPathColor,sizeof(TColor));
        readbuffer(tempOutsidecolor,sizeof(TColor));
        If restorecolors then
        Begin
          bkcolor:=tempbkcolor;
          wallcolor:=tempwallcolor;
          Solvedpathcolor:=tempSolvedPathColor;
          Outsidecolor:=tempOutsidecolor;
        end;

        readbuffer(wallstyle,sizeof(TPenStyle));
        readbuffer(pathstyle,sizeof(TPenStyle));
        readbuffer(SolvedpathStyle,sizeof(TPenStyle));
        readbuffer(widthx,sizeof(integer));
        readbuffer(widthy,sizeof(integer));
        readbuffer(mode,sizeof(TMode));

        For i:= Starti to Starti+tmpxsize-1 do
        For j:= 1 to tmpysize do
        begin
          readbuffer(m[i,j],sizeof(TOldMazerec));
        end;
        readbuffer(count,sizeof(integer));
        buildmoves.clear;
        if count>0 then
        Begin
          setlength(tmpstr,count);
          readbuffer(tmpstr[1],count);
          for i:=1 to count do buildmoves.add(tmpstr[i]);
        end;
        readbuffer(curpoint,sizeof(TPoint));
        readbuffer(startpoint,sizeof(TPoint));
        readbuffer(endpoint,sizeof(TPoint));
        readbuffer(doorsize,sizeof(integer));
        readbuffer(showpaths,sizeof(boolean));
        readbuffer(showsolutionpath,sizeof(boolean));
        readbuffer(maintainaspect,sizeof(boolean));
        readbuffer(lastpoint,sizeof(TPoint));
        readbuffer(aspect,sizeof(real));
        readbuffer(PaperLayout,sizeof(TPrinterOrientation));
        //readbuffer(PrintScaling,sizeof(TPrintScale));

        If (version>100) and (version <200) then
        Begin
          readbuffer(Headertype,sizeof(HeaderType));
          readbuffer(count,sizeof(count));
          setlength(Headertext,count);
          If count>0 then readbuffer(Headertext[1],count);
          if version=101 then
          Begin
            readbuffer(headerFont,sizeof(headerFont));
            headerfont:=font; {not the real font but not garbage}
          end
          else
          if position<size then
          Begin {version 102 and greater}
            readbuffer(count,sizeof(count));
            setlength(tmpstr,count);
            If count>0 then readbuffer(tmpstr[1],count);
            headerfont.name:=tmpstr;
            readbuffer(count,sizeof(count));
            headerfont.size:=count;
            readbuffer(style,sizeof(style));
            headerfont.style:=style;
          end
          else headerfont.assign(font);

        end;
      end;
    Finally
      s.free;
    end; {try}
    modified:=false;

    Setxsize(NbrCols);
    Setysize(NbrRows);
    if (width>origwidth) and (height>origheight) then
    Begin
      {reduce one of them to avoid double scroll bars}
      w1:=width;
      w2:=origwidth;
      a2:=height / origheight;
      a1:=w1/w2;
      if a1>a2 then {reduce height}
      Begin
        Setwidthy(trunc(widthy / a2));
        Setwidthx(trunc(widthx / a2));
      end
      else {reduce width}
      Begin
        setwidthy(trunc(widthy / a1));
        setwidthx(trunc(widthx / a1));
      end;
      setxsize(NbrCols);{reset to recalc width}
      setysize(NbrRows);
    end;

    setaspect;
    makeborders; {Makesure there is a border all around}
    drawimage;
    if buildmoves.count>0 then setmode(play) else setmode(design);
  end;


{*************** ReadMaze ***************}
Procedure TMaze.Readmaze(inname:string);
var
  line,w:string;
  f:Textfile;
  i,j:integer;
  starti:integer;
  skipread:boolean;
  a1,a2:real;
  bigx:integer;
  w1,w2:real;

    Function getword(var s:string):string;
    var
      i:integer;
    Begin
      result:='';
      s:=trimleft(s);
      If length(s)=0 then exit;
      if s[length(s)]<>',' then s:=s+',';
      i:=1;
      while (i<=length(s)) and (s[i]<>',') do inc(i);
      result:=copy(s,1,i-1);
      delete(s,1,i);
    end;

  Begin

    if concatenate then starti:=NbrCols
    else
    Begin
      resetimage;
      starti:=0;
    end;
    filename:=inname;
    assignfile(f,filename);
    reset(f);
    j:=0;
    bigx:=0;
    skipread:=false;
    line:=' ';
    while (not skipread) and (not eof(f)) do
    Begin
      readln(f,line);
      w:=getword(line);
      if w<>'*' then
      Begin
        inc(j);
        i:=starti;

        while w<>'' do
        Begin
          inc(i);
          if i>maxmazecols then
          Begin
            showmessage('Max maze columns exceeded, read terminated');
            skipread:=true;
          end;
          if i>bigx then bigx:=i;
          if (w[1]='S') then
          Begin
            w[1]:='1';
            {Ignore new startpoint if this is an add-on file}
            If not concatenate then startpoint:=point(i,j);
          end
          else
          if w[1]='E' then
          Begin
            w[1]:='1';
            endpoint:=point(i,j);
          end;
          m[i,j].roomtype:=troomtype(strtoint(w));
          w:=getword(line);
        end;
      end
      else {Found solution moves line (starts with *)}
      If not concatenate then
      Begin
        buildmoves.clear;
        w:=getword(line);
        while w<>'' do
        Begin
          buildmoves.add(w);
          w:=getword(line);
        End;
      end;
    end;
    Setxsize(bigx);
    Setysize(j);
    if (width>origwidth) and (height>origheight) then
    Begin
      {reduce one of them to avoid double scroll bars}
      w1:=width;
      w2:=origwidth;
      a2:=height / origheight;
      a1:=w1/w2;
      if a1>a2 then {reduce height}
      Begin
        setwidthy(trunc(widthy / a2));
        setwidthx(trunc(widthx / a2));
      end
      else {reduce width}
      Begin
        setwidthy(trunc(widthy / a1));
        setwidthx(trunc(widthx / a1));
      end;
    end;
    setxsize(NbrCols);{reset to recalc width}
    setysize(NbrRows);
    closefile(f);
    setaspect;
    makeborders; {Makesure there is a border all around}
    drawimage;
  end; {readmaze}



{**************************** MMouseDown ******************}
procedure TMaze.MMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i,index:integer;
  p, p2, psave:Tpoint;
  moves:TMove;

begin
  If mode=play then
  Begin
    p:=screentoXY(x,y);
    if (p.x=startpoint.x) and (p.y=startpoint.y)and (playmoves.count=0) then
    begin
      tracing:=true;
      resetplaymoves;
      invalidate;
    end
    else
    if (inplaymovelist(p, index))then
    begin
      tracing:=true;
      {mouse down on an a point in the path, erase from end move back to here}
      for i:= playmoves.count-1 downto index  Do
      begin
        moves:=TMove(playmoves.objects[playmoves.count-1]);
        p2.x:=moves.x;
        p2.y:=moves.y;
        psave:=p2;
        {drawonepath updates curpoint and p2 with destination point
         but since we're erasing here and for speed I didn't want calculate the
         endpoint represented by this move and erase backward, curpoint and p2
         both reflect the far end of the line erased.  Psave is the correct
         endpoint resored after the loop}
        drawonepath(p2,moves.dir,erase);
        moves.free;
        playmoves.delete(i);
      end;
      curpoint:=psave;
      invalidate;
    end
    else
    begin
      if playmoves.count=0 then curpoint:=startpoint;
      {tracing:=true; }
    end;
  end
  else
  If mode = design
  then
  begin
    If Button=mbright then
    begin
      savex:=x;
      savey:=y;
      popupmenu.popup(x+left,y+top);
    end;
  end;
end;

{******************** MMouseMove ***********************}
procedure TMaze.MMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  p:Tpoint;
  dir:TDir;
  move:TMove;
begin
  If mode=design then
  Begin
    If ssleft in shift then
    Begin
    end;
  end
  else
  if (mode=play) and (ssleft in shift) then
  Begin
    mademove:=false;
    p:=screentoxy(x,y);
    dir:=unknown;
    if (p.x=curpoint.x) then
    Begin
      if p.y=curpoint.y then
      else
      if (p.y<curpoint.y) then dir:=up
      else dir:=down;
    end
    else if (p.y=curpoint.y) then
      if (p.x<curpoint.x)  then dir:=lefft
      else dir:=right;

    if dir<>unknown then
    begin
      if CanMove(dir) then
      Begin

        while (playmoves.count > 0) and
              (TMove(playmoves.Objects[playmoves.count-1]).dir=opposite(dir)) and
              (not equalpoint(curpoint,p)) do
        begin
          DrawonePath(curpoint,dir,erase);
          with playmoves do
          begin
            TMove(objects[count-1]).free;
            delete(playmoves.count-1);
          end;
        end;

        while (not equalpoint(curpoint,p)) and CanMove(dir) do
        begin
          move:=tmove.create;
          move.x:=curpoint.x;
          move.y:=curpoint.y;
          move.dir:=dir;
          playmoves.addobject(dirstrings[dir],move);
          inc(playcount);
          DrawonePath(curpoint,dir,noerase);
        end;


        (*
        If (playmoves.count>0)
         and (TMove(playmoves.Objects[playmoves.count-1]).dir=opposite(dir))
        then
        begin
          repeat {erase the path}
            DrawonePath(curpoint,dir,erase);
          until equalpoint(curpoint,p);
          with playmoves do
          begin
            TMove(objects[count-1]).free;
            delete(playmoves.count-1);
          end;
        end
        else
        begin
          repeat {draw the path house by house in case of erasures later}
            if not canmove(dir) then break;{V3.2: fix problem of moving through walls}
            move:=tmove.create;
            move.x:=curpoint.x;
            move.y:=curpoint.y;
            move.dir:=dir;
            playmoves.addobject(dirstrings[dir],move);
            inc(playcount);
            DrawonePath(curpoint,dir,noerase);
          until equalpoint(curpoint,p);
        end;
        *)
        //setcursor(curpoint);
        if assigned(OnPlayMove) then OnPlayMove(playcount); {update move display}
        if (curpoint.x=endpoint.x) and (curpoint.y=endpoint.y)
        then
        begin
          showmessage('You did it!'+#13+'REWARD YOURSELF!');
          resetplaymoves;
          drawimage;
        end;
        mademove:=true;
        invalidate;
      end;
    end;
  End;
end;


{************************* MMouseUp **********************}
procedure TMaze.MMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  newx,newy:integer;
  i,j:integer;
begin
  If mode=design then
  begin
    If button=mbleft then
    begin
      newx:=(x) div widthx +1;
      newy:=(y) div widthy + 1;
      If ssShift in Shift then
      begin
        for i:= min(lastpoint.x,newx) to max(lastpoint.x,newx) do
        for j:=min(lastpoint.y,newy) to max(lastpoint.y,newy) do
        begin
          If not((i=lastpoint.x) and (j=lastpoint.y)) then
          If (m[i,j].roomtype<>border) then m[i,j].roomtype:=border {set border}
          else m[i,j].roomtype:=closed;
          drawblock(i,j);
        end;
      end
      else
      begin
        {set border}
        If m[newx,newy].roomtype<>border then m[newx,newy].roomtype:=border
        else m[newx,newy].roomtype:=closed;
        drawblock(newx,newy);
      end;
      lastpoint.x:=newx;
      lastpoint.y:=newy;
      invalidate;
      modified:=true;
    end
    else if button=mbright then
    begin
      savex:=x;
      savey:=y;
    end;
  end
  else if mode = play then
  begin
    If tracing then tracing:=false
    else
    if button=mbleft then
    begin
      tracing:=true;
      {shift does not contain button on mouse up so we'll simulate it}
      Mmousemove(sender,{shift+}[ssleft],x,y);
      tracing:=false;
    end;
  end;
end;


{************************ StartPoint1Click *****************}
procedure TMazeMsgForm.StartPoint1Click(Sender: TObject);
var
  newx,newy:integer;
begin
  If maze.mode=design then
  with maze do
  Begin
    newx:=(savex) div widthx +1;
    newy:=(savey) div widthy + 1;
    m[newx,newy].roomtype:=closed;
    printblock(startpoint.x,startpoint.y,' ');
    startpoint:=point(newx,newy);
    printblock(newx,newy,'S');
    invalidate;
    modified:=true;
  end;
end;

{********************* ExitPoint1Click *****************}
procedure TMazeMsgForm.ExitPoint1Click(Sender: TObject);
var
  newx,newy:integer;
begin
  If maze.mode=design then
  with maze do
  Begin
    newx:=(savex) div widthx +1;
    newy:=(savey) div widthy + 1;
    m[newx,newy].roomtype:=closed;
    printblock(endpoint.x, endpoint.y,' ');
    endpoint:=point(newx,newy);
    printblock(newx,newy,'E');
    invalidate;
    modified:=true;
  end;
end;

{********************* InvertBorderPoints1Click ***************}
procedure TMazeMsgForm.Invertborderpoints1Click(Sender: TObject);
begin
  maze.invertallblocks;
  maze.drawoutlines;
  invalidate;
end;

end.






