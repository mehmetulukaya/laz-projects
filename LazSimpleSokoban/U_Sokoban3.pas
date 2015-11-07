unit U_Sokoban3;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  LCLType, { Windows,} Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  LCLIntf, {shellAPI,} StdCtrls, Grids, ExtCtrls, Types, ComCtrls, Inifiles;

type
  Tundo =record
    UMovenbr:integer;
    Ufromcol, Ufromrow, Utocol,Utorow:integer;
    Direction:char;  {l,r,u,d, or L,R,U,D if move includes box}
  end;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    StepLbl: TLabel;
    Label2: TLabel;
    InPlaceLbl: TLabel;
    LoadBtn: TButton;
    BoardGrid: TStringGrid;
    LoadSolBtn: TButton;
    Memo2: TMemo;
    ReplayBtn: TButton;
    Memo3: TMemo;
    Label3: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure BoardgridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LoadBtnClick(Sender: TObject);
    procedure LoadSolBtnClick(Sender: TObject);
    procedure ReplayBtnClick(Sender: TObject);
  public
    origsize:TPoint;{original board size, used when resizing for various game sizes}
    casename:string;
    manloc:TPoint;
    T:array of TUndo;
    Shortpath:string;
    SavedpathLength:integer;
    nbrmoves, movenbr:integer;{nbrmoves=>(box+man=2 moves),  movenbr=>(box+man=1 move)}
    nbrtargets, boxesInPlace:integer; {Solved when nbrtargets = BoxesInPlace}
    replaying:boolean;  {set to true while replaying}
    procedure loadcase(newname:string);
    procedure reset;
    procedure movepieces(const acol, arow, dx, dy:integer);
    procedure updatePathDisplay;
    procedure savesolution;
  end;

var
  Form1: TForm1;

implementation

// {$R *.DFM}
{$R *.dfm}

type
       TCodes=   (Space,  Wall, Floor,  Target,   Box,    Man,    None);
var
  // 16.06.2015 changed to x_colors for with operations...
  // colors:array [TCodes] of TColor=
  //             (clwhite,clgray,clblue, clLime, clYellow,$85C3ED,clwhite);
  x_colors:array [TCodes] of TColor=
              (clwhite,clgray,clblue, clLime, clYellow,$85C3ED,clwhite);

       {Space through Target appear in 1st character of 2 char cell value,
        Box and Man codes appear in 2nd character}
       StrCodes:array[Tcodes] of char=('0','1','2','3','B','M',' ');

{************ FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  with boardgrid do
  begin
    origsize:=point(width,height);
    color:=TForm(parent).color;
    reset;
    canvas.Font:=font;
    opendialog1.initialdir:=extractfilepath(application.exename);
  end;
  x_colors[space]:=color; {set outside grid colors same as form color}
end;

{**************** BoardGridDrawCell ***********}
procedure TForm1.BoardgridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  n:integer;
  code:TCodes;
  s:string;
begin
  with boardGrid, canvas, rect  do
  begin
    if length(cells[acol,arow])=2 then
    begin
      s:=cells[acol,arow];
      n:=strtoint(s[1]);
      code:=TCodes(n);
      brush.Color:=x_colors[code];
      fillrect(rect);
      If code=Target then
      begin
        textout((left+right) div 2 -4, (top+bottom) div 2 - 4,'T');
      end;
      if s[2]='M' then
      begin {draw stickman}
         brush.Color:=x_colors[man];
         ellipse(left+5, top+2, right-5, bottom-2);
         textout(left+12,top+8,'*  *');  {eyes}
         textout((left+right) div 2 -8, (top+bottom) div 2 - 4,'---');
      end
      else if s[2]='B' then
      with rect do
      begin {draw box}
        brush.Color:=x_colors[box];
        fillrect(types.rect(left+6, top+6, right-6, bottom-6));
        Textout((left+right) div 2 -12,(top+bottom) div 2 - 4,'Box');
      end;
    end
    else
    begin
      brush.color:=clwhite;
      fillrect(rect);
    end;
  end;
end;

{*********** Reset ************}
procedure TForm1.reset;
var
  i,j:integer;
begin
   with boardgrid do
   begin
     for i:=0 to colcount-1 do for j:=0 to rowcount-1 do cells[i,j]:=' ';
   end;
end;




{************ MovePieces ************}

procedure TForm1.movepieces(const acol, arow, dx, dy:integer);
 {move the man, and the box if we are pushing one in the dx, dy direction}

         {---------- MovePiece --------}
        procedure MovePiece(const movenbr, fromcol,fromrow,tocol,torow:integer;
                            const newdir:char );
        var
          s:string;
        begin
          with boardgrid do
          begin
            s:=cells[tocol,torow];
            s[2]:=cells[fromcol,fromrow][2];
            cells[tocol,torow]:=s;
            s:=cells[fromcol,fromrow];
            s[2]:=' ';
            cells[fromcol,fromrow]:=s;
            inc(nbrmoves);
            if nbrmoves>=length(t) then setlength(T,length(T)+100);
            {save move for future undo}
            with t[nbrmoves-1] do
            begin
              ufromcol:=fromcol;
              ufromrow:=fromrow;
              utocol:=tocol;
              utorow:=torow;
              umovenbr:=movenbr;
              direction:=newdir;
            end;

          end;
        end;  {movepiece}


var
  dir:char;
  len:integer;  {new solution length}
  msg:string;
begin  {movepieces}
  with boardgrid do
  begin
    inc(movenbr);
    if dx=1 then dir:='r'
    else if dx=-1 then dir:='l'
    else if dy=1 then dir:='d'
    else dir:='u';
    StepLbl.caption:=inttostr(movenbr);
    if (cells[acol+dx,arow+dy][2] =strcodes[box]) then
    begin
      movepiece(movenbr,acol+dx,arow+dy,acol+2*dx,arow+2*dy,' ');
      dir:=upcase(dir);
      if cells[acol+dx,arow+dy][1]=strcodes[target] then dec(boxesInPlace);
      if cells[acol+2*dx,arow+2*dy][1]=strcodes[target] then inc(boxesInPlace);
      inplacelbl.Caption:=inttostr(boxesinplace);
    end;
    movepiece(movenbr,acol,arow,acol+dx,arow+dy,dir);
    shortpath:=shortpath+dir;
    updatepathdisplay;
    manloc:=point(acol+dx,arow+dy);
    if (not replaying) and (boxesinplace=nbrtargets) then
    begin
      len:=length(shortpath);
      showmessage ('You solved it in '
                   +inttostr(len)+ ' moves!');
      if savedpathlength>0 then
      begin
        if (len=savedpathlength) then msg:='same as'
        else if (len<savedpathlength) then msg:='smaller than'
        else msg:='greater than';

        if messagedlg('New solution is '+ msg+ ' saved solution'+#13
        + 'Save new solution?',mtconfirmation,[mbyes,mbno],0)=mryes
        then savesolution;
      end
      else savesolution;
    end;
  end;
end;

{*********** UpdatePathDisplay *********}
procedure TForm1.updatePathDisplay;
 begin
   with memo2 do
   begin
     if lines.count>1 then
     begin
       clear;
       lines.add(shortpath);
     end
     else lines[0]:=shortpath;
   end;
 end;

{************* Formkeydown *****************}
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

    {--------- ValidMove --------}
    function ValidMove(const acol, arow, dx, dy:integer):boolean;
    begin
      with boardgrid do
      begin
        IF (
            (CELLS[ACOL+DX,AROW+DY][2] <>strcodes[box]) AND
             (CELLS[ACOL+DX,AROW+DY][1]IN[strcodes[floor], strcodes[target]])
           )
           OR
           (
            (CELLS[ACOL+DX,AROW+DY][2] =strcodes[box])  AND
             (
              (CELLS[ACOL+2*DX,AROW+2*DY]= strcodes[floor]+' ')
               OR
              (CELLS[ACOL+2*DX,AROW+2*DY]= strcodes[target]+' ')
             )
            )
        THEN RESULT:=TRUE
        ELSE RESULT:=FALSE;
      end;
    end; {validpiece}



    {--------- UndoMove -------}
    procedure UndoMove;
    {Undo the latest preceding move}
    var
      s:string;
      n:integer;
    begin
      if nbrmoves>0 then
      with t[nbrmoves-1], boardgrid do
      begin
        s:=cells[ufromcol,ufromrow];
        s[2]:=cells[utocol,utorow][2];
        if s[2]='M' then  manloc:=point(ufromcol,ufromrow)
        else if s[2]= strcodes[box] then
        begin
          {If we move a box back onto a target then inccrement boxesInPlace count}
          if cells[ufromcol,ufromrow][1] = strcodes[target] then inc(boxesinplace);
          {If we move a box vack off of a target then decrement boxesInPlace count}
          if cells[utocol,utorow][1] = strcodes[target] then dec(boxesinplace);
          inplacelbl.Caption:=inttostr(boxesinplace);
        end;
        cells[ufromcol,ufromrow]:=s;
        s:=cells[utocol,utorow];
        s[2]:=' ';
        cells[utocol,utorow]:=s;
        n:=umovenbr;
        dec(nbrmoves);
        if (nbrmoves>0) and (t[nbrmoves-1].umovenbr=n)
        then undomove {two pieces moved on this move}
        else
        begin {man move}
          dec(movenbr);
          steplbl.caption:=inttostr(movenbr);
          delete(shortpath, length(shortpath),1);
          UpdatePathDisplay;
          //memo2.lines[0]:=shortpath;
        end;
      end;
    end; {undomove}

var  acol,arow:integer;
begin
  acol:=manloc.X;
  arow:=manloc.Y;

  with Boardgrid do
  case key of

  vk_right: if validmove(acol,arow,1,0) then movepieces(acol,arow,1,0);

  vk_left:  if validmove(acol,arow,-1,0) then movepieces(acol,arow,-1,0);

  vk_down:  if validmove(acol,arow,0,1) then movepieces(acol,arow,0,1);

  vk_up:    if validmove(acol,arow,0,-1) then movepieces(acol,arow,0,-1);

  vk_back, ord('U'), ord('u'), ord('Z'), ord('z'):  {undo}
    Begin
      undomove;
      key:=0;
    end;

  ord('R'),ord('r'):  {Restart}
    begin
      loadcase(casename);
      key:=0;
    end;
  end;{case}

end;

{************** LoadBtnClick *********}
procedure TForm1.LoadBtnClick(Sender: TObject);
begin
  If opendialog1.execute then loadcase(opendialog1.FileName);
end;

{ Puzzle encoding }
{
space or - or _   floor or outside of walls
@   sokoban (warehouseman)
+   sokoban on target
#   wall
$   box
.   target
*   box on target
}

{*********** Loadcase ***********8}
procedure TForm1.loadcase(newname:string);
var
  i,j:integer;
  f:textfile;
  line:string;
  nbrcols:integer;
  firstwall, lastwall:integer; {range of wall segments on a line}
  ini:TInifile;
begin
  caption:='Sokobahn Version 3.0,  Current Puzzle: '+extractfilename(newname);
  casename:=newname;
  assignfile(f,newname);
  system.reset(f);

  {reset case related global variables}
  nbrTargets:=0;
  BoxesInPlace:=0;
  shortpath:='';
  memo2.Clear;
  memo2.Lines.add('Moves display here');
  nbrmoves:=0;
  movenbr:=0;
  steplbl.caption:='00';
  inplacelbl.caption:='00';

  with boardgrid  do
  begin
    nbrcols:=0;

    while (not eof(f)) do
    begin
      readln(f,line);
      if (length(line)>0) and (line[1]<>';') then
      begin  {its a real line. not empty and not a comment}
        If (nbrcols = 0)  then {set the board width}
        begin
          nbrcols:=length(line);
          colcount:=nbrcols;
          rowcount:=3;
          row:=0;
        end
        else
        begin
          if row+1>rowcount-1 then rowcount:=rowcount+1;
          row:=row+1;
        end;
        {fill next row}
        if length(line)>colcount
        then colcount:=Length(line);
        {find the first and last wall symbols, any space characters in between
         will be floor pieces}
        firstwall:=1;
        lastwall:=1;
        for i:=1 to length(line) do if line[i]='#' then
        begin
          firstwall:=i;
          break;
        end;
        for i:=length(line) downto 1 do  if line[i]='#' then
        begin
          lastwall:=i;
          break;
        end;
        if firstwall<lastwall then
        for i:=0 to length(line)-1 do
        begin
          case line[i+1] of
            ' ','-','_':
             begin
               if (i+1< firstwall) or (i+1>lastwall)
               then cells[i,row]:=strcodes[space]+strcodes[none] {outside of walls}
               else cells[i,row]:=strcodes[floor]+strcodes[none]; {floor}
             end;
            '#':
               begin
                 cells[i,row]:=strcodes[wall]+strcodes[none]; //{old code} inttostr(ord(Wall))+' ';   // W = Wall
               end;
            '@':   {man}
               begin
                 cells[i,row]:=strcodes[floor]+strcodes[man];   // M = Man on Floor
                 manloc:=point(i,row);
               end;
            '+':
               begin
                 cells[i,row]:=strcodes[target]+ strcodes[man];   // N = Man on Target
                 manloc:=point(i,row);
               end;
            '$': cells[i,row]:=strcodes[floor]+strcodes[box];   // B = Box on Floor
            '*':
              begin
                cells[i,row]:=strcodes[target]+strcodes[box];   // C = Box on Target
                Inc(nbrtargets);
                Inc(BoxesInPlace);
              end;
            '.':
              begin
                cells[i,row]:=strcodes[target] + strcodes[none];   // T = Target
                Inc(NbrTargets);
              end;
             else cells[i,row]:=strcodes[space]+strcodes[none]; //'0 ';
          end;
        end;
      end;
    end;
    closefile(f);
    defaultcolwidth:=(origsize.x) div (colcount+gridlinewidth);
    defaultrowheight:=(origsize.y) div (rowcount+gridlinewidth);
    {make the cells square}
    if defaultcolwidth<defaultrowheight
    then defaultrowheight:=defaultcolwidth
    else defaultcolwidth:=defaultrowheight;
    width:=colcount*(defaultcolwidth+2*gridlinewidth)-2*gridlinewidth;
    height:=rowcount*(defaultrowheight+2*gridlinewidth) -2*gridlinewidth;

    {Initialize any cells not filled while reading the file}
    for i:=0 to colcount-1 do for j:=0 to rowcount-1 do
    if length(cells[i,j])<>2 then cells[i,j]:=strcodes[space]+strcodes[none];//'0 ';
    setlength(T,100);  {Undo records}
    ini:=Tinifile.Create(extractfilepath(application.exename)+'Sokoban.ini');
    SavedPathLength:=ini.readinteger(extractfilename(casename),'SolutionPathLength', 0);
    ini.free;
    If savedpathlength>0
    then label3.caption:=format('This case has a saved solution with %d moves',
                                [savedpathlength])
    else label3.caption:='No saved solution for current case';                          ;
    boardgrid.setfocus;
  end;
end; {LoadCase}


procedure TForm1.SaveSolution;
var
  i,n:integer;
  ini:TiniFile;
  s:string;
  shortname:string;
begin
  ini:=TInifile.create(extractfilepath(application.exename)+'Sokoban.ini');
  with ini do
  begin
    s:='';
    setlength(s,nbrmoves);
    n:=0;
    for i:=1 to nbrmoves do s[i]:=' ';
    for i:=0 to nbrmoves-1 do if upcase(t[i].direction) in ['L','R','U','D'] then
    begin
      inc(n);
      s[n]:=t[i].Direction;
    end;
    s:=trim(s);
    shortname:=extractfilename(casename);
    writestring(shortname,'Solution',s);
    savedpathlength:=length(s);
    writeinteger(shortname,'SolutionPathLength', savedpathlength);
    label3.caption:=format('This case has a saved solution with %d moves',
                                [savedpathlength]);
  end;
  ini.free;
end;

procedure TForm1.LoadSolBtnClick(Sender: TObject);
var
  ini:TiniFile;
  s:string;
  shortname:string;
begin
  ini:=TInifile.create(extractfilepath(application.exename)+'Sokoban.ini');
  with ini do
  begin
    shortname:=extractfilename(casename);
    s:=readstring(shortname,'Solution','');
    SavedPathLength:=readinteger(shortname,'SolutionPathLength', 0);
    if length(s)=0 then showmessage('No solution saved for this puzzle')
    else
    begin
      shortpath:=s;
      UpdatePathDisplay;
    end;
  end;
  ini.Free;
end;

{************** ReplayBtnClick ***********}
procedure TForm1.ReplayBtnClick(Sender: TObject);
var
  i:integer;
  dx,dy:integer;
  s:string;
begin
  s:=shortpath;
  loadcase(casename);
  replaying:=true;
  for i:=1 to length(s) do
  begin
    dx:=0; dy:=0;
    case s[i] of
      'l','L': dx:=-1;
      'r','R': dx:=1;
      'u','U': dy:=-1;
      'd','D': dy:=1;
    end;
    with manloc do movepieces(x,y,dx,dy);
    application.processmessages;
    sleep(500);
  end;
  replaying:=false;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  {ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;}
  OpenURL('http://www.delphiforfun.org/');
end;




end.
