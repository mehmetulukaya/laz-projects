unit U_AgeProblemSolver4;
{Copyright © 2007, 2008 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A program that interprets a class of age related story problems and tries to
 generate the equations which will solve the problem.  Current examples involve
 two people and two relevant sentences, each generating an equation in 2 unknowns,
 (the ages of the people).}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, shellapi, UTEVal, inifiles;

type
  TSentenceRec = record
    origsentence:string;{the sentence as entered}
    sentence:string; {the sentence as it gets modified while building equations}
    SList:TStringlist; {the separate words of the sentence in a stringlist}
  end;

type
  TForm1 = class(TForm)
    Solvebtn: TButton;
    OpenDialog1: TOpenDialog;
    NameDisplay: TMemo;
    Label1: TLabel;
    StaticText1: TStaticText;
    ProblemLbl: TLabel;
    LoadIniBtn: TButton;
    Label2: TLabel;
    OpenDialog2: TOpenDialog;
    BacktestBtn: TButton;
    PageControl1: TPageControl;
    IntroSheet: TTabSheet;
    Memo1: TMemo;
    ProblemSheet: TTabSheet;
    problem: TMemo;
    ParseSheet: TTabSheet;
    SentenceDisplayMemo: TMemo;
    OpenBtn: TButton;
    procedure OpenBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SolvebtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure LoadIniBtnClick(Sender: TObject);
    procedure BacktestBtnClick(Sender: TObject);
  public
    Sentences:Array of TSentenceRec;
    NameList:TStringList;
    FirstWordslist:TStringlist;
    UnNeededWordsList:TStringList;
    CapitalizedList:TStringlist;
    NumbersList:TStringList;
    DenomList:TStringlist;
    OpWordsList:TStringList;
    problemstr:string;
    Loaded:boolean;  {flag indicating that tables have been loaded}
    filename:string;
    tablesname:string;
    RunSilent:boolean; {true=do not display problem details; used for back testing}
    procedure loadfile(f:string);
    procedure setupProblem; {reset fields of currently loaded problem}
    procedure Preprocess(n:integer); {remove unneeded words, etc}
    function FindNames(n:integer):boolean; {Identify people's names and build namelist}
    procedure convertnumbers(n:integer); {convert number words to numbers}
    procedure convertops(num:integer); {table driven conversion to insert operators}
    procedure showsentence(n:integer; msg:String; showdelim:boolean); {display a sentence}
    procedure shownames; {display people names}
    function evaluate:boolean;  {returns true if solution found}
    function loadtables(filename:string):boolean;
    procedure ResultDisplay(const s:string);
    function solvecase:boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

type
  charset=set of char;

var
  delims:set of char=[' ', '.', ',', ';', '!','?'];
  eosdelims:set of char=['.', ';', '!','?'];  {these represent end of sentence}

 {*********** Getword ********}
   function getword(var s:string; const delims:charset; var delim:char):string;
   {return the first word in string "s" and delete it
    from the string.  Also return the delimiter found}
   var  i:integer;
   begin
     s:=s+' ';
     while (length(s)>0) and (s[1]in delims {=' '})  do delete(s,1,1);
     if length(s)>0 then
     begin
       i:=1;
       while (not (s[i] in delims)) do inc(i);
       result:=copy(s,1,i-1);
       delim:=s[i];
       delete(s,1,i);
     end
     else result:='';
   end;

{************ FormCreate ********}
procedure TForm1.FormCreate(Sender: TObject);
var
  filename:string;

begin
  setlength(sentences,0);

  {Create table lists}
  namelist:=TStringList.create;
  firstWordsList:=Tstringlist.create;
  UnneededWordsList:=Tstringlist.create;
  namelist.duplicates:=dupIgnore;
  CapitalizedList:=Tstringlist.create;
   NumbersList:=TStringList.create;
  DenomList:=TStringList.create;
  OpWordslist:=TStringlist.create;

  filename:=extractfilepath(application.exename)+'AgeProblemTables4.ini';
  opendialog1.initialdir:=extractfilepath(application.exename);
  opendialog2.initialdir:=opendialog1.initialdir;

  Loaded:=LoadTables(filename);

  if fileexists(opendialog1.initialdir+'\Default.txt') then
  begin
    loadfile(opendialog1.initialdir+'\Default.txt');
    PageControl1.ActivePage:=IntroSheet;
  end;
end;


{*********** Loadtables **************}
function TForm1.loadTables(filename:string):boolean;
var
  ini:TInifile;
begin
  if fileexists(filename) then
  begin
    result:=true;
    ini:=TInifile.create(filename);
    Tablesname:=extractfilename(filename);

    {Common capitalized first words to help identify names}


    if ini.sectionexists('FirstWords') then
    begin
      ini.readsection('FirstWords', FirstwordsList);
      Firstwordslist.sort;
    end;


    if ini.sectionexists('Unneeded') then
    begin
      ini.readsection('UnNeeded', UnNeededwordsList);
      UnNeededWordslist.sort;
    end;


    if ini.sectionexists('Capitalize') then
    begin
      ini.readsection('Capitalize', CapitalizedList);
      Capitalizedlist.sort{ed:=true};
    end;

   if ini.sectionexists('Numbers') then
   begin
     {Number words}
     ini.readsectionvalues('Numbers', Numberslist);
     Numberslist.sort;
   end;

   if ini.sectionexists('Denominators') then
   begin
    {Denominator words ("thirds", "fourths", etc.)}
    ini.readsectionvalues('Denominators', DenomList);
    Denomlist.sort;
   end;

   if ini.sectionexists('OpWords') then
   begin
    {Patterns which can be used to produce equations}

    ini.readsectionvalues('OpWords', OpWordsList);
    {the order of entries in this list is important so list is not sorted}
    end;
  end
  else
  begin
    showmessage('Missing tables file '+ filename);
    result:=false;
  end;
end;




var debug_s:string;

{************** FindNames ***********}
function TForm1.FindNames(n:integer):boolean;
{Build and/or check the list of names found}

  function InFirstWordList(s:string):boolean;
  var index:integer;
  begin
    result:=FirstWordsList.find(s,index);
    //if result then s:=firstwordslist.values[s];
  end;
var
  j:integer;
  s,w:string;
  newname:string;
  delim:char;
  index:integer;
begin
  result:=false;
  with sentences[n], slist do
  if count>0 then
  if (slist[0][1] in ['A'..'Z']) or (slist[0]='sum') then
  begin
    if (not infirstwordlist(slist[0])) and (slist[0]<>'sum')
    then result:=result or (namelist.add(slist[0])>=0);
    for j:=0 to count-1 do
    begin
      debug_s:=strings[j];
      if (J>0)
      and ((strings[j][1] in ['A'..'Z']) or (capitalizedlist.find(strings[j],index)))
      then result:=(namelist.add(strings[j])>=0) or result;

      {replace "she" or "he" with first name in the preceding sentence}
      if (lowercase(slist[j])='she') or (lowercase(slist[j])='he') and (n>0) then
      begin
        newname:=slist[j];
        with sentences[n-1] do
        begin
          s:=sentence;
          repeat
            w:=getword(s,delims,delim);
            if w<>'' then
            begin
              if namelist.indexof(w)>=0 then
              begin
                newname:=w;
                break;
              end;
            end;
          until w='';
        end;
        slist[j]:=newname;
        {only one of these tests('she' or 'he') should change anything!}
        sentence:=stringreplace(sentence,' she ', ' '+newname+' ',[rfreplaceall]);
        sentence:=stringreplace(sentence,' he ', ' '+newname+' ',[rfreplaceall]);
        result:=true;
      end;

      {process "their"}
      if (lowercase(slist[j])='their') and (namelist.count>1) then
      begin
        //stringreplace(sentence, ' their ', ' '+namelist[0] + ' '+namelist[1]+' ',[rfreplaceall]);
        result:=true;
      end;
      
    end;
  end;
end;

{*********** OpenBtnClick ***********}
procedure TForm1.OpenBtnClick(Sender: TObject);
{Load a problem}
begin
  runsilent:=false;
  If opendialog1.execute then loadfile(opendialog1.filename);
end;

{************* Loadfile ************}
procedure TForm1.loadfile(f:string);
begin
  filename:=extractfilename(f);
  pagecontrol1.activepage:=problemsheet;
  problem.visible:=not runsilent;
  problem.lines.loadfromfile(f);
  setupproblem;
  pagecontrol1.activepage:=problemsheet;
  problemlbl.caption:='Current problem: '+ extractfilename(f);
end;

{********* SetupProblem *********}
procedure TForm1.setupProblem;
var
  i:integer;
  s,w:string;
  newsentence:boolean;
  delim:char;
begin
    problemstr:='';
    for i:=0 to problem.lines.count-1 do problemstr:=problemstr+' '+problem.lines[i];
    if high(sentences)>0 then
    begin
      for i:= 0 to high(sentences) do sentences[i].slist.free;
      setlength(sentences,0);
    end;
    {now process problemstr and rebuild the sentences array}
    s:=problemstr;
    newsentence:=true;
    repeat
      w:=getword(s,delims+['-'],delim);
      if w<>'' then
      begin
        if newsentence then
        begin
          setlength(sentences, length(sentences)+1);
          with sentences[high(sentences)] do
          begin
            origsentence:='';
            sentence:='';
            slist:=TStringlist.create;
          end;
          newsentence:=false;
        end;
        i:=high(sentences);
        with sentences[i] do
        begin
          slist.add(w);
          origsentence:=origsentence+w+delim;
          sentence:=sentence+w+' ';
        end;
        if delim in eosdelims  then newsentence:=true;
      end;
    until s='';
    //sentencedisplayMemo.lines.clear;
    namelist.clear;
  end;


{************** Preprocess **********}
procedure TForm1.Preprocess(n:integer);
{Replace unneeded delimiters and words, expand contractions, etc.}

var
  i, len:integer;
  s,w:string;
  delim:char;
  finaldelim:char;

  function lastTwo(const s:string):string;
  {return last 2 characters of a string}
  begin
    if length(s)>2 then result:=copy(s,length(s)-1,2)
    else result:='';
  end;


begin
  with sentences[n] do
  begin
    s:=sentence;
    {remove final delimiter}
    if s[length(s)] in delims then
    begin
      finaldelim:=s[length(s)];
      delete(s,length(s),1);
    end
    else finaldelim:=' ';;
    {remove unnecessary words}
    for i:=0 to unneededwordslist.count-1 do
    with unneededwordslist do
    begin
      len:=length(strings[i]);
      {unneeded at start of sentence}
      if comparetext(lowercase(strings[i]+' '), copy(s,1,len+1))=0
      then system.delete(s,1,len);

      {unneeded word embedded}
      s:=stringreplace(s,' '+strings[i]+' ',' ',[rfReplaceall, rfignorecase]);

      {unneeded at end of sentence}
      if comparetext(' '+lowercase(strings[i]), copy(s,length(s)-len,len+1))=0
      then system.delete(s,length(s)-len,len+1);

      {unneeded only at end of sentence (strings[i] includes final delimiter)}
      if comparetext(' '+lowercase(strings[i]), copy(s,length(s+finaldelim)-len,len+1))=0
      then system.delete(s,length(s)-len,len+1);
    end;


    {Expand contractions}
     s:=stringreplace(s,'she''ll','she will',[rfreplaceall]);
     s:=stringreplace(s,'he''ll','he will',[rfreplaceall]);
     {later on, after identifying names, we will replace "she" or "he"
      with the first name in the preceding sentence}

    {rebuild word list (Slist)}
    sentence:='';
    slist.clear;
    repeat
      w:=getword(s,delims,delim);
      if w<>'' then
      begin
        if lasttwo(w)='''s' then delete(w,length(w)-1,2);
        slist.add(w);
        sentence:=sentence+w+delim;
      end;
    until s='';
  end;
end;

{*************** ShowSentence **********}
procedure TForm1.showsentence(n:integer; msg:string; showdelim:boolean);
{display the nth sentence }
var
  i:integer;
  s:string;
begin
  if not runsilent then
  with sentencedisplayMemo, sentences[n] do
  begin
    lines.add(msg);
    s:='';
    for i:=0 to slist.count-1 do s:=s+' '+ slist[i];
    if showdelim
    then if origsentence[length(origsentence)]='?' then s:=s+'?' else s:=s+'.';
    delete(s,1,1);   {delete the extra space added at the beginning}
    lines.add('     "'+s+'"');
  end;
end;

{*********  ResultDisplay ***********}
procedure TForm1.ResultDisplay(const s:string);
begin
  if not runsilent then sentencedisplaymemo.lines.add(s);
end;

{************* ShowNames ***********}
procedure TForm1.Shownames;
{display names in list}
var
  i:integer;
  s:string;
begin
  namedisplay.clear;
  if runsilent then exit;
  s:='';
  for i:=0 to namelist.count-1 do
  with namedisplay.lines do
  begin
    if indexof(namelist[i])<0 then
    begin
      namedisplay.lines.add(namelist[i]);
      s:=s+','+namelist[i];
    end;
  end;
  delete(s,1,1);  {delete that extra ','}
  Resultdisplay('Names: '+s);
end;



{************** ConvertNumbers ************}
procedure TForm1.Convertnumbers(n:integer);
{replace number words with numbers}
var
  i,index:integer;
  s:string;
begin
  with sentences[n] do
  begin
    for i:=0 to slist.count-1 do
    with slist do
    begin
      s:=lowercase(strings[i]);
      index:= numberslist.indexofname(s);
      if index>=0 then strings[i]:=numberslist.values[s];
    end;
  end;
end;


{*********** ConvertOps ***********}
procedure TForm1.ConvertOps(num:integer);
{Final step to build equation from the sentence words}
var
  i, j, n:integer;
  s, oldstr, newstr, w, sumstr:string;
  delim:char;
  ncount,vcount,dcount:integer;
  nums,vars,denoms:array[1..20] of string;
  global:char;
begin
  with sentences[num] do
  begin
    {make a version of the sentence with numbers and names identified}
    ncount:=0;
    vcount:=0;
    dcount:=0;
    global:=' ';
    for i :=0 to slist.count-1 do
    begin
      if slist[i][1] in ['1'..'9'] then
      begin
        s:=s+' &N';
        inc(ncount);
        nums[ncount]:=slist[i];
      end
      else if namelist.indexof(slist[i])>=0 then
      begin
        s:=s+' &V';
        inc(vcount);
        vars[vcount]:=slist[i];
      end
      else if denomlist.indexofname(slist[i])>=0 then
      begin
        s:=s+' &D';
        inc(dcount);
        denoms[dcount]:=denomlist.values[slist[i]];
      end
      else s:=s+' '+slist[i];
    end;
    delete(s,1,1);  {delete the leading blank}

    {Now we have rebuilt the sentence with numbers, and variables (people's
     names used for ages) identified.  Next step is to check for patterns in
     OpWordsList which are in the text and replace them with equation pieces}

    for i:=0 to opWordslist.count-1 do
    with opwordslist do
    begin
      oldstr:=names[i];
      newstr:=values[names[i]];
      {if an opening phrase specifies a past or future time, it will apply to
       both parties unless the sentence specifies "is now" or "current age"
       for person 2}
      N:=POS(lowercase(OLDSTR),lowercase(s));
      if n>0 then
      begin
       If    (length(newstr)>0)
          and (length(oldstr)>5)
          and (newstr[length(newstr)]='=')
          and (pos('=',s)=0) {the LEFT SIDE of the equation}
        then
        begin
           if (copy(oldstr,1,5)='in &N') then global:='+'
           else if (copy(oldstr,1,2)='&N')and (pos('ago',oldstr)>0)
                then global:='-';
           {If a sentence ends with a phrase indicating that global doesn't apply
               then remove the phrase and reset the global flag}
           if (global<>' ') and
           (
             (copy(s,length(s)-2,3)=' is')
             or (copy(s,length(s)-6,7)=' is now')
             or (copy(s,length(s)-3,4)=' now')
           )
           then
           begin
             global:=' ';
             {remove the current time phrase}
             if (copy(s,length(s)-2,3)=' is') then system.delete(s,length(s)-2,3)
             else if (copy(s,length(s)-6,7)=' is now') then system.delete(s,length(s)-6,7)
             else if (copy(s,length(s)-3,4)=' now') then system.delete(s,length(s)-3,4);
           end;
           s:=StringReplace(S, oldstr, newstr, [rfReplaceAll,rfignorecase]);
        end
        else
        if pos('=',newstr)>0 {the replacement is a complete equation}
        then  s:=StringReplace(S, oldstr, newstr, [rfReplaceAll,rfignorecase])
        else
        begin {a RIGHT SIDE}
          s:=StringReplace(S, oldstr, newstr, [rfReplaceAll,rfignorecase]);
          if global<>' ' then
          begin  {otherwise, insert +- global offset to 2nd person also}
            j:=length(s);
            while s[j]<>'&' do dec(j);
            system.insert('(',s,j{+1});
            s:=s+global+nums[1]+')';
          end;
          global:=' ';
        end;
        n:=pos('&SUM',s);  {replace &SUM by sum of ages}
        if n>0 then
        begin
          sumstr:=namelist[0];
          for j:=1 to namelist.count-1 do sumstr:=sumstr+'+'+namelist[j];
          s:=stringreplace(s,'&SUM',sumstr,[]);
        end;
      end;
    end;
    {reinsert the numbers and names}
    ncount:=0;
    repeat
      j:=pos('&N',s);
      if j>0 then
      begin
        inc(ncount);
        s:=stringreplace(s,'&N',nums[ncount],[rfIgnorecase]);
      end;
    until j=0;
    dcount:=0;
    repeat
      j:=pos('&D',s);
      if j>0 then
      begin
        inc(dcount);
        s:=stringreplace(s,'&D',denoms[dcount],[rfIgnorecase]);
      end;
    until j=0;

    vcount:=0;
    repeat
      j:=pos('&V',s);
      if j>0 then
      begin
        inc(vcount);
        s:=stringreplace(s,'&V',vars[vcount],[]);
      end;
    until j=0;

    {now rebuild the sentence from s}
    sentence:='';
    slist.clear;
    repeat
      w:=getword(s,delims,delim);
      if w<>'' then
      with sentences[num] do
      begin
        slist.add(w);
        sentence:=sentence+w+delim;
      end;
    until s='';
  end;
end;

{********* SolveBtnClick *********}
procedure TForm1.SolvebtnClick(Sender: TObject);
{Solve a problem}
begin
  RunSilent:=false;
  sentenceDisplayMemo.clear;
  SolveCase;
end;


function TForm1.SolveCase:boolean;
{Start the search for equations}
var
  i:integer;
begin
  if not loaded then
  begin
    showmessage('No parsing tables loaded');
    result:=false;
    exit;
  end;
  setupProblem; {reset tables and parameters}
  pagecontrol1.activepage:=Parsesheet;
  for i:=0 to high(sentences) do
  begin
    Resultdisplay('');
    Resultdisplay('Sentence #'+inttostr(i+1));
    with sentences[i] do
    if origsentence[length(origsentence)]<>'?' then
    begin
      Preprocess(i);
      showsentence(i,'After removing unneeded words, etc.',false);
      if FindNames(i) then
      begin  {sentence has at least one name}
        Resultdisplay('After finding names');
        shownames;
        convertnumbers(i);
        showsentence(i,'After converting numbers',true);
        convertops(i);
        showsentence(i,'After operations inserted, (hopefully an equation!)',false);
      end
      else Resultdisplay('Sentence ignored - No names');
    end
    else showsentence(i,'Question ignored',true);
  end;
  result:=evaluate;
end;

const
  maxage=100;


{************* Evaluate ************}
function Tform1.evaluate:boolean;
var
  i, j, k, m, index:integer;
  left1, right1, left2, right2:string;
  val1,val2,val3,val4:single;
  count, totcount, save1, save2:integer;
  eval:TEval;
  error:boolean;

  procedure showerror(msg:string);
  begin
    if not runsilent then showmessage(msg);
    error:=true;
  end;


begin
  If namelist.count>=2 then
  begin
    eval:=TEval.create;
    eval.silent:=runsilent;
    save1:=0; save2:=0;
    Resultdisplay('');
    Resultdisplay('-----------------------------');
    result:=true;
    totcount:=0;
    for i:=0 to high(sentences)-1 do  {for the 1st 2 equations}
    with sentences[i] do
    begin
      index:=pos('=',sentence);
      if index>0 then
      begin
        left1:=trim(copy(sentence,1,index-1));
        right1:=trim(copy(sentence,index+1,length(sentence)-index));
        for j:=i+1 to high(sentences) do
        with sentences[j] do
        begin
          index:=pos('=',sentence);
          if index>0 then
          begin
            Resultdisplay(format( 'Checking sentences %d and %d', [i+1,j+1]));
            left2:=trim(copy(sentence,1,index-1));
            right2:=trim(copy(sentence,index+1,length(sentence)-index));
            error:=false;
            count:=0;  {we're looking for a pair of equations with exactly one solutions}
            for k:=1 to maxage do
            begin
              for M:=1 to maxage do
              begin
                eval.clearvariables;
                eval.addvariable(namelist[0],k);
                eval.addvariable(namelist[1],m);

                if eval.evaluate(left1,val1) then
                begin
                  if eval.evaluate(right1,val2) then
                  begin
                    if trunc(100*val1)=trunc(100*val2) then
                    begin
                      if eval.evaluate(left2,val3) then
                      begin
                        if eval.evaluate(right2,val4) then
                        begin
                          if trunc(100*val3)=trunc(100*val4)
                          then
                          begin
                            inc(count);
                            save1:=k;
                            save2:=m;
                          end;
                        end
                        else showerror('Error in expression '+right2);
                      end
                      else showerror('Error in expression '+left2);
                    end;
                  end
                  else showerror('Error in expression '+right1);
                end
                else showerror('Error in expression '+left1);
                if error then break;
              end;
              if error then
              begin
                break;
                Resultdisplay('Error in one or both of these equations');
              end;
            end;
            if count=0
            then Resultdisplay('No Solution found for ages 1 to '
                                  +inttostr(maxage) +' for these equations')
            else if count=1
            then Resultdisplay(format('     Solution found: %s=%d and %s=%d',
                             [namelist[0],save1,namelist[1],save2]))

            else Resultdisplay('Multiple solutions found these equations');
            inc(totcount,count);  {update overall solution count}
          end; {If sentence is equaion (contains "=")}

        end; {for j loop - finished checking a pair of equations}
      end; {i loop}
    end;
    if totcount=0 then result:=false;
    eval.free;
   end
   else
   begin
     result:=false;
     if not runsilent then showmessage('Must have two names found');
   end;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.LoadIniBtnClick(Sender: TObject);
begin
  with opendialog2 do
  begin
    title:='Select a tables file';
    if opendialog2.execute then
    begin
      loadtables(opendialog2.filename);
    end;
  end;
end;

procedure TForm1.BacktestBtnClick(Sender: TObject);
var
  f:TSearchrec;
  r:integer;
  s:string;
begin
  {process all *.txt files in the program directory
   as age problem cases and summarize results}
   runsilent:=true;
   sentencedisplaymemo.Clear;
   r:=findfirst(extractfilepath(application.exename)+'*.txt',FAAnyfile,f);

   repeat
    if r=0 then
    begin
      s:=f.name;
      loadfile(s);
      if solvecase then s:=s+'  Solved'
      else s:=s+'  Not Solved';
      sentencedisplaymemo.lines.add(s);
      r:=findnext(f);
    end;
  until r<>0;
end;

end.
