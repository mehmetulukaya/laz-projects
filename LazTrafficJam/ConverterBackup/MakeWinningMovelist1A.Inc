 const
   maxvertices=100000;{max nbr of board positions to hold while loooking for solution}
   adjmax=16;  {max adjacencies - max nbr of "next" board configurations from any
                                  particular configuration}
 type
   Tvertex=class(tobject) {a particular board position}
       board:TBoardArray;  {board configuration}
       adjcount:smallint;  {nbr of next moves}
       adjacents:array[1..adjmax] of string; {adjacent board positions }
       moves:array[1..adjmax] of string[2]; {moves that get to each of the
                                             adjacent positions}
       procedure assign(source:TVertex);
     end;

   procedure TVertex.assign(source:TVertex);
   begin
     board:=source.board;
     adjcount:=source.adjcount;
     adjacents:=source.adjacents;
     moves:=source.moves;
   end;


  {**************** TForm1.Movepiece ****************}
   Function TForm1.movepiece(s:string;var board:TBoardarray):boolean;
   var
     n:integer;
     errcode:integer;
     i,dist,size:integer;
     h:tpoint;

   const
     preda=pred('A');
   Begin
     result:=true;
     n:=ord(s[1])-ord(predA);
     h:=gethead(n, board);
     size:=currentcase.vehicles[n].size;
     if validmove(s,board) then
     Begin
       case s[2] of
        'L':
           Begin
             for i:=h.x to h.x+size-1 do board[i,h.y]:=0;
             val(s[3],dist,errcode);
             for i:=0 to size-1 do board[h.x-dist+i,h.y]:=n;
           end;
         'R':
           Begin
             for i:=h.x to h.x+size-1 do board[i,h.y]:=0;
             val(s[3],dist,errcode);
             for i:=0 to size-1 do
               if h.x+dist+i<=maxdim then board[h.x+dist+i,h.y]:=n;
           end;
         'U':
           Begin
             for i:=h.y to h.y+size-1 do board[h.x,i]:=0;
             val(s[3],dist,errcode);
             for i:=0 to size-1 do board[h.x,h.y-dist+i]:=n;
           end;
         'D':
           Begin
             for i:=h.y to h.y+size-1 do board[h.x,i]:=0;
             val(s[3],dist,errcode);
             for i:=0 to size-1 do board[h.x,h.y+dist+i]:=n;
           end;
       end; {case}
     end
     else result:=false;
   End;  {movepiece}

{************************ TForm1.ValidMove ****************}
function TForm1.validmove(s:string;board:TBoardArray):boolean;
    const
      PredA=ord(pred('A'));
    var
      dist,errcode:integer;
      h:tpoint;
      n,size,i:integer;
    Begin
      result:=true;
      n:=ord(s[1])-predA;
      size:=currentcase.vehicles[n].size;
      h:=gethead(ord(s[1])-ord(pred('A')), board);
      val(s[3],dist,errcode);
      case s[2] of
      'L': if h.x-dist<1 then result:=false
           else
           for i:= h.x-1 downto h.x-dist do
            if board[i,h.y]<>0 then result:=false;
      'R': if (h.x+size-1+dist>maxdim)then result:=false
            else
            for i:= h.x+size to h.x+size-1+dist do
              if board[i,h.y]<>0 then result:=false;

      'U': if h.y-dist<1 then result:=false
           else
            for i:= h.y-1 downto h.y-dist do
            if board[h.x,i]<>0 then result:=false;
      'D': if h.y+currentcase.vehicles[n].size-1+dist>maxdim then result:=false
           else
           for i:= h.y+size to h.y+size-1+dist do
              if board[h.x,i]<>0 then result:=false;
      end;
    end; {validmove}

{******************** TForm1.OptimizeMoves ***************}
Procedure TForm1.Optimizemoves;
   {Combine moves into multiblock moves when possible}
       var
         i:integer;
         tempboard,testboard:TBoardArray;
         skipi:boolean;
         s1,s2:string;

       Begin
         tempboard:=tcase(cases[currentcasenbr-1]).board;
         i:=0;
         with currentcase do
         while i<= winningmoves.count-3 do
         Begin
           skipi:=false;
           s1:=winningmoves[i];
           s2:=winningmoves[i+2];
           if (s1[1]=s2[1]) and (s1[2]=s2[2]) then
           Begin
             s2[3]:=char(ord(s2[3])+ord(s1[3])-ord('0'));
             {try dropping 1st move}
             testboard:=tempboard;
             if validmove(winningmoves[i+1],testboard) then
             Begin
               movepiece(winningmoves[i+1],testboard);
               if validmove(s2,testboard) then
               Begin
                 winningmoves[i+2]:=s2;
                 winningmoves.delete(i);
                 skipi:=true;
               end;
             end
             else {try them the other way round}
             if validmove(s2,testboard) then
             Begin
               movepiece(s2,testboard);
               if validmove(winningmoves[i+1],testboard) then
               Begin
                 winningmoves[i]:=s2;
                 winningmoves.delete(i+2);
                 s1:=s2;
               end;
             end;
           end;
           if not skipi then
           begin
             movepiece(s1,tempboard);
             inc(i);
           end;
         end;
       end;

{*************** TForm1.MakeWinningMovesList **************}
procedure TForm1.MakeWinningmovesList(list:TStringlist);

  var
    queue :TStringlist;
    InitialVertex:TVertex;
    vertexcount:integer;
    verticea:array[0..maxvertices-1] of string;
    nbrvertices:integer;  {number of vertices saved in verticea}

  {*********************** Genkey *******************}
  {generate a unique key for this board configuration}
  Function GenKey(const pboard:TBoardarray):string;
  {key consists of letters representing the column or row
   where the head of vehicle resides (row for left-right movers,
   columns for up-down movers)}
  const
    predA=ord(pred('A'));
    blanks='                ';
  var
    i,j,n:integer;
  begin
    result:='';
    with currentcase do
    Begin
      result:=copy(blanks,1,currentcase.nbrvehicles+1);
      for i:= 1 to maxdim do {columns}
      for j:= 1 to maxdim do {rows}
      Begin
        n:=pboard[i,j];
        if (n>0) and (result[n]=' ') then
        case vehicles[n].direction of
          up,down:
              result[n]:=char(predA+j); {which row}
          lefft,right:
              result[n]:=char(predA+i); {which column}
         end;
       end;
    end;
  end; {genkey}

 {*********************** HashKey **************}
 Function hashkey(const key:string):integer;
 {Make an integer hash key from the string key}
 const
   preda=ord(pred('A'));
 var
   i:integer;
   sum:integer;
 Begin
   sum:=0;
   for i:= 1 to length(key) do sum:=sum shl 2 +(ord(key[i])-preda);
   result := sum mod maxvertices;
   if result<0 then result:=-result;
 end;

 {******************* VerticesAppend **************}
 Function VerticesAppend(const key:string):boolean;
 {return true if this position is new, false if already created}
   var
    hash:integer;
    i:integer;
    done:boolean;
  begin
    with form1 do
    Begin
      result:=true;
      hash:=hashkey(key);
      i:=hash-1;
      done:=false;
      repeat
        inc(i);
        if i>=maxvertices then i:=0;
        if verticea[i]=key
        then begin result:=false; done:=true; end
        else if verticea[i]='' then
        begin
          verticea[i]:=key;
          done:=true;
          inc(nbrvertices);
        end;
      until done or (i=hash-1);

    end;
  end;

  {******************* MakeVertexList ******************}
  {************** Version  without recursion  *************}
  {Breadth first search lets us stop when winning position is found}
   Procedure makevertexlist;
   const
     predA=ord(pred('A'));
   var
     i,j:integer;
     m,s,prevs:string;
     maxstack:integer;
     h:TPoint;
     vertex:TVertex;

    {**************** Check *****************}
    Procedure check(const i,j:integer; const chkdir:Tdirection);
    {check to see if we can generate a new position by moving a vehicle in
     chkdir direction to occupy this square}
    var
     n,size:smallint{integer};
     key:string;
     newvertex:Tvertex;
     chki,chkj,zi,zj:smallint{integer};
     chkdir2,chkdir3:TDirection;
     movedir:char;
     k:integer;

     begin
       chki:=0; chkj:=0;
       chkdir2:=lefft;  {Directions we need to move}
       movedir:='R';
       case chkdir of
         lefft: Begin chki:=-1;                 movedir:='R'; end;
         right: begin chki:=1;                  movedir:='L'; end;
         up:    begin chkj:=-1; chkdir2:=up;    movedir:='D'; end;
         down:  begin chkj:=1;  chkdir2:=up;    movedir:='U'; end;
       end;
       if (vertex.board[i+chki,j+chkj]<>0) then
       Begin
         n:=vertex.board[i+chki,j+chkj]; {found a vehicle one position away}
         size:=currentcase.vehicles[n].size;
         chkdir3:=lefft;  {direction of the the vehicle from the empty space}
         case currentcase.vehicles[n].direction of
           up,down:chkdir3:=up;
         end;
         {check the direction it can move}
         if chkdir2=chkdir3 then {need-to-move same as can-move}
         begin
           zi:=i+chki*size;
           zj:=j+chkj*size;
           If (zi>=1) and (zi<=maxdim) and (zj>=1) and (zj<=maxdim) then
           begin
             newvertex:=tvertex.create;
             newvertex.board:=vertex.board; {Copy the board}
             newvertex.board[i,j]:=n;   {make the move}
             newvertex.board[zi,zj]:=0;

             {check for a car, not the winning car having moved into the winning point in
              a horizontal direction (only works for horizontal right exits)}
             with currentcase do
             if (chki=-1) and (winningpoint.x=i-1) and (winningpoint.y=j)
                and (newvertex.board[i,j]>winningvehicle) then 
             for k:=zi+1 to i do newvertex.board[k,j]:=0;  {remove the car}


             key:=genkey(newvertex.board); {get a key for the new board}
             if not verticesappend(key) then newvertex.free
             else
             Begin
               inc(vertexcount);
               If vertex.adjcount<adjmax then
               Begin
                 inc(vertex.adjcount);
                 vertex.adjacents[vertex.adjcount]:=key;
                 vertex.moves[vertex.adjcount]:=char(ord(predA)+ord(n))+movedir+'1';
               end
               else
               begin
                 showmessage('More than max adjacencies found - email Grandpa');
                 exitflag:=true;
               end;
               {add this position to the end of the queue}
               queue.addobject(m+vertex.moves[vertex.adjcount],newvertex);
               newvertex.adjcount:=0;
             end;
           end;
         end;
       end;
     end; {check}

   Begin {MakeVertexList}
     maxstack:=0;
     vertex:=TVertex.create;
     repeat
       if exitflag then exit;
       application.processmessages;
       if queue.count>maxstack then maxstack:=queue.count;
       vertex.assign(TVertex(queue.objects[0]));
       tvertex(queue.objects[0]).free;
       m:=queue[0];   {get the top entry off of the queue}
       queue.delete(0);

       {check for horizontal vehicle at exit column, row}


       {check for winning position}
       h:=gethead(currentcase.winningvehicle,vertex.board);
       with currentcase do
       if (h.x=winningpoint.x) and (h.y=winningpoint.y) then winner:=true;
       (*
       {This only works for right exit games but it's faster}
       with currentcase do
       If (vertex.board[winningpoint.x,winningpoint.y]=winningvehicle) and
          (vertex.board[winningpoint.x-1,winningpoint.y]=0) then winner:=true;
       *)


       If not winner then
       Begin
         {look for an empty square and see what vehicles might move into it
          (from left, right, above, or below)}
         for i:=1 to maxdim  do  for j:= 1 to maxdim  do
         if vertex.board[i,j]=0 then
         Begin
           {checkleftside (rightmove)}  If i>1 then check(i,j,lefft);
           {checkrightside (leftmove)}  If i<maxdim then check(i,j,right);
           {checkabove (downmove)}      if j>1 then check(i,j,up);
           {checkbelow (upmove)}        if j<maxdim then check(i,j,down);
         end;
       end;
     until (winner) or (queue.count=0);
     vertex.free;
     If winner then
     Begin
       list.clear;
       i:=0;
       prevs:='   ';
       with currentcase, list do
       repeat
         s:=copy(m,2*i+1,2)+'1';
         if (s[1]=prevs[1]) and (s[2]=prevs[2]) then
         Begin
           s:=strings[count-1];
           s[3]:=char(ord(s[3])+1);
           strings[count-1]:=s;
         end
         else list.add(s);
         prevs:=s;
         inc(i);
       until 2*i+1 > length(m);
       {Now maybe we can rearrange some moves and then combine them again}
       {e.g. 6L1,3D1,6L1 (continuous move interrupted by another move) }
       {  can be safely changed to 3D1,6L2 (unless 3 was going to hit 6 wo 6L1}
       optimizemoves;
     end;
   end; {MakeVertexList}



   var
       initialkey:string;
       i:integer;
  {start the breadth first solution search}
  Begin {MakeWinningMovesList}
    screen.cursor:=crhourglass;
    for i:=0 to maxvertices-1 do verticea[i]:='';
    nbrvertices:=0;
    queue:=Tstringlist.create;
    queue.sorted:=false;
    queue.capacity:=2048;
    vertexcount:=0;
    exitflag:=false;
    winner:=false;
    initialVertex:=TVertex.create;
    initialvertex.board:=currentcase.board;
    initialvertex.adjcount:=0;
    initialkey:=genkey(currentcase.board);
    queue.addobject('', initialvertex);
    makevertexlist{(initialkey,InitialVertex)};
    for i:= 0 to queue.count-1 do TVertex(queue.objects[i]).free;
    queue.free;
    screen.cursor:=crdefault;
    if nbrvertices> 0.7*maxvertices {hash table getting full}
  then showmessage('Running out of capacity for this problem - please notify vendor');
  end; {Makewinningmoveslist}