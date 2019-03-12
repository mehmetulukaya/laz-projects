unit DFFUtils;
 {Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface
  uses Windows, Messages, Stdctrls, Sysutils, Classes, Grids;

  {TMemo routines}
  {Reset line lengths based on current TMemo width}
  procedure reformatMemo(const m:TCustomMemo);
  {Set pixel margins in a TMemo}
  procedure SetMemoMargins(m:TCustomMemo; const L,T,R,B:integer);  {in pixels}

  {Scroll the first line into view}
  procedure MoveToTop(memo:TMemo);
  procedure ScrollToTop(memo:TMemo);

  {Return the line clicked on by the mouse}
  function LineNumberClicked(memo:TMemo):integer;
  {same function with 3 alternate names (for me and other forgetful users)}
  function MemoClickedLine(memo:TMemo):integer;
  function ClickedMemoLine(memo:TMemo):integer;
  function MemoLineClicked(memo:TMemo):integer;

  {Return Line Position clicked}
  function LinePositionClicked(Memo:TMemo):integer;
  function ClickedMemoPosition(memo:TMemo):integer;
  function MemoPositionClicked(memo:TMemo):integer;


  {TStringGrid routines}

  {Adjust size to just fit cell dimensions}
  procedure AdjustGridSize(grid:TDrawGrid);
  {Delete a row}
  procedure DeleteGridRow(Grid: TStringGrid; Const ARow:integer);
  {Insert a row}
  procedure InsertgridRow(Grid: TStringGrid; Const ARow:integer);

  {Sort the grid rows by the specified column, ascending if no direction specified}
  procedure Sortgrid(Grid : TStringGrid; Const SortCol:integer);  overload;
  procedure Sortgrid(Grid : TStringGrid;
                     Const SortCol:integer; sortascending:boolean); overload;
  {Call IgnoreSelectDrawCell from an OnDrawCell exit to remove Selected cell highlighting}
  function IgnoreSelectedDrawCell(Sender: TObject; ACol, ARow: Integer;
                                  Rect: TRect; State: TGridDrawState):boolean;


  {String operations}

  procedure sortstrDown(var s: ANSIstring); {sort string characters descending}
  procedure sortstrUp(var s: ANSIstring);   {sort string characters ascending}
  procedure rotatestrleft(var s: ANSIstring); {rotate stringleft}
  function  strtofloatdef(s:ANSIstring; default:extended):extended;
  function  deblank(s:ANSIstring):ANSIstring;  {remove all blanks from a string}
  function IntToBinaryString(const n:integer; MinLength:integer):ANSIstring;

  {Free objects contained in a string list, Memo, or ListBox  and clear the strings}
  procedure FreeAndClear(C:TListBox); overload;
  procedure FreeAndClear(C:TMemo);   overload;
  procedure FreeAndClear(C:TStringList);   overload;

  {compute file size for files larger than 4GB}
  function getfilesize(f:TSearchrec):int64;

 {Shuffle an array of integers}
  procedure shuffle(var deck:array of integer);



implementation

  Type

    //Char=ANSIChar;
    wideString=ANSIString;


{************ Reformat **********}
procedure reformatMemo(const m:TCustomMemo);
{reformat the lines after removing existing Carriage returns and Line feeds}
{necessary to reformat input text from design time since text has hard breaks included}
var
  s:string;
  CRLF, CRCR:string;
begin
  {remove EXTRA carriage returns & line feeds}
  s:=m.text; {get memo text lines}
  CRLF:=char(13) + char(10);  {CR=#13=carriage retutn, LF=10=Linefeed}
  CRCR:=char(13)+char(13);
 {temporarily change real paragraphs (blank line), CRLFCRLF to double CR}
  s:=stringreplace(s,CRLF+CRLF,CRCR,[RfReplaceall]);
  {Eliminate input word wrap CRLFs}
  s:=stringreplace(s,CRLF,' ',[RfReplaceall]);
  {now change CRCR back to CRLFCRLF}
  s:=stringreplace(s,CRCR,CRLF+CRLF,[RfReplaceall]);
  m.text:=s;
  if m is TMemo then TMemo(m).wordwrap:=true; {make sure that word wrap is on}
end;

{**************** SetMemoMargins **********}
procedure SetMemoMargins(m:TCustomMemo; const L,T,R,B:integer);
var cr:Trect;
begin
  {Reduce clientrect by L & R margins}
  cr:=m.clientrect;
  if L>=0 then cr.left:=L;
  If T>=0 then cr.top:=T;
  If R>=0 then cr.right:=cr.right-r;
  If B>=0 then cr.bottom:=cr.Bottom-b;
  m.perform(EM_SETRECT,0,longint(@cr));

  reformatmemo(m); {good idea to reformat after changing margins}
end;

procedure MoveToTop(memo:TMemo);
{Scroll "memo" so that the first line is in view}
begin
  with memo do
  begin
    selstart:=0;
    sellength:=0;
  end;
end;

Procedure ScrollToTop(memo:TMemo);
begin
  Movetotop(memo);
end;



function LineNumberClicked(Memo:TMemo):integer;
{For a click on a memo line, return the line number (number is relative to 0)}
begin
  //result:=Memo.Perform(EM_LINEFROMCHAR, -1, 0);  {cause subrange error in XE5}
  result:=Memo.Perform(EM_LINEFROMCHAR, WPARAM(-1), 0);  {GDD 12/12/13}
end;


function ClickedMemoLine(memo:TMemo):integer;
begin  {return index of the clicked line in "memo"}
  result:=LineNumberClicked(memo);
end;
function MemoClickedLine(memo:TMemo):integer;
begin
  result:=LineNumberClicked(memo);
end;
function MemoLineClicked(memo:TMemo):integer;
begin  {return index of the clicked line in "memo"}
  result:=LineNumberClicked(memo);
end;


function LinePositionClicked(Memo:TMemo):integer;
{When a TMemo line is clicked, return the character position
 within the line (position is relative to 1)}
var LineIndex:integer;
begin
  with memo do
  begin
     LineIndex:=Perform(Em_LineIndex,ClickedMemoLine(memo),0);
     Result:=Selstart-Lineindex+1;
  end;
end;

function ClickedMemoPosition(memo:TMemo):integer;
begin
  result:=LinePositionClicked(Memo);
end;

function MemoPositionClicked(memo:TMemo):integer;
begin
  result:=LinePositionClicked(Memo);
end;


procedure memosort(memo:TMemo);
var
  i,j:integer;
  s:string;
  {Quick and dirty sort}
begin
  with memo,lines do
  begin
    beginupdate;
    for i:=0 to count-2 do
    for j:= i+1 to count-1 do
    if AnsiCompareStr(lines[i],lines[j])>0 then
    begin  {swap(lines[i],lines[j])}
      s:=lines[i];
      lines[i]:=lines[j];
      lines[j]:=s;
    end;
    endupdate;
  end;
end;


{**************** AdjustGridSize *************}
procedure AdjustGridSize(grid:TDrawGrid);
{Adjust borders of grid to just fit cells}
var   w,h,i:integer;
begin
  with grid do
  begin
    w:=0;
    for i:=0 to colcount-1 do w:=w+colwidths[i];
    width:=w;
    repeat width:=width+1 until fixedcols+visiblecolcount=colcount;
    h:=0;
    for i:=0 to rowcount-1 do h:=h+rowheights[i];
    height:=h;
    repeat height:=height+1 until fixedrows+visiblerowcount=rowcount;
    invalidate;
  end;
end;

(*
{alternative version which may be faster and more accurate - needs testing}
{*********** AdjustgridSize *********8}
procedure AdjustGridSize(grid:TDrawGrid);
{Adjust borders of grid to just fit cells}
var   w,h,i:integer;
begin
  with grid do
  begin
    w:=0;
    for i:=0 to colcount-1 do w:=w+colwidths[i];
    width:=w;

    //repeat width:=width+1 until fixedcols+visiblecolcount=colcount;
    width:=width+(colcount+1)*gridlinewidth;
    h:=0;
    for i:=0 to rowcount-1 do h:=h+rowheights[i];
    height:=h;
    //repeat height:=height+1 until fixedrows+visiblerowcount=rowcount;
    height:=height+(rowcount+1)*gridlinewidth;
    invalidate;
  end;
end;
*)


{************* InsertGridRow *************}
procedure InsertgridRow(Grid: TStringGrid; Const ARow:integer);
{Insert blank row after Arow}
var i:integer;
begin
  with Grid do
  if (arow>=0) and (arow<=rowcount-1) then
  begin
    rowcount:=rowcount+1;
    for i:=rowcount-1 downto Arow+2 do rows[i]:=rows[i-1];
    rows[arow+1].clear;
    row:=arow+1;
    {if insert is within fixed rows then increase fixed row count}
    {if insert is at or after the last fixed row, leave fixed row count alone}
    if fixedrows>arow then fixedrows:=fixedrows+1;
  end;
end;

{************* DeleteGridRow *************}
procedure DeleteGridRow(Grid: TStringGrid; Const ARow:integer);
{delete a stringgrid row.  Arow is a row index between 0 and rowcount-1}
var i:integer;
begin
  with Grid do
  if (arow>=0) and (arow<=rowcount-1) then
  begin
    for i:=Arow to rowcount-1 do rows[i]:=rows[i+1];
    rowcount:=rowcount-1;
    if fixedrows>arow then fixedrows:=fixedrows-1;
  end;
end;

{*********** SortGrid ************}
procedure Sortgrid(Grid:TStringGrid; Const SortCol:integer; sortascending:boolean);
var
   i,j : integer;
   temp:tstringlist;
begin
  temp:=tstringlist.create;
  with Grid do
  for i := FixedRows to RowCount - 2 do  {because last row has no next row}
  for j:= i+1 to rowcount-1 do {from next row to end}

  if ((sortascending) and (AnsiCompareText(Cells[SortCol, i], Cells[SortCol,j]) > 0))
  or ((not sortascending) and (AnsiCompareText(Cells[SortCol, i], Cells[SortCol,j]) < 0))
  then
  begin
    temp.assign(rows[j]);
    rows[j].assign(rows[i]);
    rows[i].assign(temp);
  end;
  temp.free;
end;

{*********** SortGrid ************}
procedure Sortgrid(Grid : TStringGrid; Const SortCol:integer);
begin
  Sortgrid(grid,Sortcol, true);  {ascending}
end;

{*********** IgnoreSelectDrawCell *************}
function IgnoreSelectedDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState):boolean;
{OK, here's the thing:  The Selected cell (current row and column) is drawn with
 the highlight color and font color which bugs the heck out of me.}
{Call this function from the OnDrawCell exit of any TStringGrid to redraw the
 Selected cell with the default font but without the highlighting.   Result is
 true if the selected cell has been redrawn, false otherwise. If your OnDrawCell
 exit is doing other special drawing, call this function first so that  it can be
 redrawn using your parameters.
}

var
  g:TStringGrid;
begin
  result:=false;
  if sender is TstringGrid then
  begin
    G:=TStringGrid(Sender); {G is just shorthand  for the grid object}
    If (gdselected in state) then
    with G, canvas do
    begin
      if canvas.font<>g.Font then font.assign(g.font);  {1st time, get the proper font for the canvas}
      brush.Color:=color;
      fillrect(rect);
      textrect(rect, rect.Left+2, rect.Top+2, cells[acol,arow]);
      result:=true;
    end;
  end;
end;


{************** SortStrDown ************}
procedure sortstrDown(var s: ANSIstring);
{Sort characters of a string in descending sequence}
var
  i, j: integer;
  ch: ANSIchar;
begin
  for i := 1 to length(s) - 1 do
    for j := i + 1 to length(s) do
      if s[j] > s[i] then
      begin  {swap}
        ch   := s[i];
        s[i] := s[j];
        s[j] := ch;
      end;
end;

{************** SortStrUp ************}
procedure sortstrUp(var s: ANSIString);
{Sort characters of a ANSIString in ascending sequence}
var
  i, j: integer;
  ch:   ANSIchar;
begin
  for i := 1 to length(s) - 1 do
    for j := i + 1 to length(s) do
      if s[j] < s[i] then
      begin  {swap}
        ch   := s[i];
        s[i] := s[j];
        s[j] := ch;
      end;
end;
{************ RotateStrLeft **********}
procedure rotatestrleft(var s: ANSIString);
{Move all characters of an ANSIString left one position,
 1st character moves to end of ANSIString}
var
  ch:   ANSIchar;
  len: integer;
begin
  len := length(s);
  if len > 1 then
  begin
    ch := s[1];
    move(s[2],s[1],len-1);
    s[len] := ch;
  end;
end;

{********** StrToFloatDef **********}
function strtofloatdef(s:ANSIString; default:extended):extended;
{Convert input ANSIString to extended}
{Return "default" if input ANSIString is not a valid real number}
begin
  try
    result:=strtofloat(trim(s));
    except  {on any conversion error}
      result:=default; {use the default}
  end;
end;

{*************** Deblank ************}
function  deblank(s:ANSIString):ANSIString;
{remove all blanks from a ANSIString}
begin
  result:=StringReplace(s,' ','',[rfreplaceall]);
end;


{************* IntToBinaryString **********}
function IntToBinaryString(const n:integer; MinLength:integer):ANSIString;
{Convert an integer to a binary ANSIString of at least length "MinLength"}
var i:integer;
begin
  result:='';
  i:=n;
  while i>0 do
  begin
    if i mod 2=0 then result:='0'+result
    else result:='1'+result;
    i:=i div 2;
  end;
  if length(result)<Minlength
  then result:=stringofchar('0',Minlength-length(result))+result;
end;


{*************** FreeAndClear *********}
procedure FreeAndClear(C:TListbox);   overload;
  var i:integer;
  begin
    with c.items do
    for i:=0 to count-1 do
    if assigned(objects[i]) then objects[i].free;
    c.clear;
  end;

  procedure FreeAndClear(C:TMemo);   overload;
  var i:integer;
  begin
    with c.lines do
    for i:=0 to count-1 do
    if assigned(objects[i]) then objects[i].free;
    c.clear;
  end;

  procedure FreeAndClear(C:TStringList);   overload;
  var i:integer;
  begin
    with c do
    for i:=0 to count-1 do
    if assigned(objects[i]) then objects[i].free;
    c.clear;
  end;

{************** GetFileSize **************}
function getfilesize(f:TSearchrec):int64;
{Given a TSearchrec describing file properties, compute file size for files
 larger than 4GB}
    var
      fszhi,fszlo,m:int64;
    begin
      {Here's the way to get file size that works for files larger than 4GB}
      fszhi:=f.FindData.nfilesizehigh;
      fszlo:=f.FindData.nfilesizelow;
      m:=high(longword);
      inc(m,1);
      result:=fszhi*m+fszlo;
    end;

{*********** Shuffle ***********}
procedure shuffle(var deck:array of integer);
{Shuffle = randomly rearrange  an array of integers}
var  i,n,temp:integer;
begin
  i:= high(deck); {starting from the end of the deck}
  while i>0 do
  begin
    n:=random(i+1);  {pick a random card, "n",  at or below this card}
    temp:=deck[i];   {and swap card "i" with card "n"}
    deck[i]:=deck[n];
    deck[n]:=temp;
    dec(i);       {move to the next prior card}
  end;            {and loop}
end;


end.

