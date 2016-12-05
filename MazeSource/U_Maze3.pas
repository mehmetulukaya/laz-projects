unit U_Maze3;

{$MODE Delphi}

{Copyright  © 2001, 2008, 2011 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


{The main Maze form}

{Version 2  replaces the DFF registered TIntEdit and TFloatEdit components with
 comparable versions which are generated at program startup time}
{Version 3 improves scrolling and printing behavior for large mazes. Also
 allows arrow keys to be used in addition to mouse for drawinbg a solutuion
 path}
{Version 3.1 fixes problem of incomplete erasing when clicking on a previous
 path point under some conditions}
{Version 3.2 fix problem of allowing a mouse click to draw a path through
 cell walls. }

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Menus, printers, ComCtrls, ToolWin,
  ImgList, PrintersDlgs, U_TMaze, NumEdit2;

  Type

    { TForm1 }

    TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Design1: TMenuItem;
    Options1: TMenuItem;
    OpenDialog1: TOpenDialog;
    PrintDialog1: TPrintDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    SaveDialog1: TSaveDialog;
    PopupMenu1: TPopupMenu;
    StartPoint1: TMenuItem;
    ExitPoint1: TMenuItem;
    N3: TMenuItem;
    Invertborderpoints1: TMenuItem;
    Eliminatearow1: TMenuItem;
    Elimateacolumn1: TMenuItem;
    N4: TMenuItem;
    Insertcolumnleft1: TMenuItem;
    Insertcolumnright1: TMenuItem;
    Insertrowabove1: TMenuItem;
    Insertrowbelow1: TMenuItem;
    Zoom1: TMenuItem;
    Zoomtoscreenheight1: TMenuItem;
    Zoomtoscreenwidth1: TMenuItem;
    //PrinterSetupDialog1: TPrinterSetupDialog;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    PrintSetup1: TMenuItem;
    PrintPreviewPrint1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    GenBtn: TBitBtn;
    DesignBtn: TButton;
    ResetBtn: TButton;
    ShowPathGroup: TRadioGroup;
    GroupBox1: TGroupBox;
    SolvedlengthLbl: TLabel;
    PlayMoveLbl: TLabel;
    B1: TMenuItem;
    About1: TMenuItem;
    InfoMemo: TMemo;
    New1: TMenuItem;
    ScrollBox1: TScrollBox;
    RandseedEdt: TEdit;
    TestBtn: TButton;

    procedure GenBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ShowPathGroupClick(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure Design1Click(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    {procedure SizeChange(Sender: TObject);}
    procedure StartPoint1Click(Sender: TObject);
    procedure ExitPoint1Click(Sender: TObject);
    procedure Invertborderpoints1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure PrintSetupClick(Sender: TObject);
    procedure PrintPreviewClick(Sender: TObject);
    procedure Eliminatearow1Click(Sender: TObject);
    procedure Elimateacolumn1Click(Sender: TObject);
    procedure Insertcolumnleft1Click(Sender: TObject);
    procedure Insertcolumnright1Click(Sender: TObject);
    procedure Insertrowabove1Click(Sender: TObject);
    procedure Insertrowbelow1Click(Sender: TObject);
    procedure Zoomtoscreenheight1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Zoomtoscreenwidth1Click(Sender: TObject);
    Function  checksave:boolean;
    procedure FormActivate(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure playmove(count:integer);
    procedure About1Click(Sender: TObject);
    procedure StatusBar1Click(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure New1Click(Sender: TObject);
    //procedure FormKeyDown(Sender: TObject; var Key: Word;
    //  Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TestBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure loadfile(filename:string);
    procedure savefile(filename:string);
    //function KeyboardHookProc(Code: Integer; WordParam: Word; LongParam: LongInt) : LongInt;
  end;

var
  Form1: TForm1;

  KBHook: HHook; {this intercepts keyboard input}

  {callback's declaration}
  function KeyboardHookProc(Code: Integer; WordParam: Word; LongParam: LongInt): LongInt; stdcall;



implementation

uses U_Options3, U_Preview
  //, U_Help
  , U_About;


{$R *.lfm}

function KeyboardHookProc(Code: Integer; WordParam: Word; LongParam: LongInt): LongInt;
var
  key:longint;
  p,p2:TPoint;
  x,y:integer;
begin
  key:=wordParam;
  result:=0;
  if not (key in [vk_up, vk_down, vk_left, vk_right]) then exit;
  getcursorpos(p);  {is the mouse on the maze?}
  p:=maze.screenToClient(p);
  x:=p.x div maze.Widthx+1;
  y:=p.y div maze.WidthY+1;
  with maze do
  if (x>=1) and (x<=NbrCols) and (y>=1) and (y<=NbrRows) then
  if (m[x,y].roomtype<>border) then
  begin
    p.x:=(x-1)*Widthx+halfwidthx;
    p.y:=(y-1)*WidthY+halfwidthy;
    p2:=p;
    case key of
      vk_left: dec(p2.X,maze.widthx);
      vk_right: inc(p2.X,maze.widthx);
      vk_up:   dec(p2.y,maze.widthy);
      vk_down: inc(p2.y,maze.widthy);
    end;
    if longparam and $80000000 =0 then
    begin
      MMouseDown(form1, mbleft,[ssleft],  p.X, p.Y);
      //form1.memo1.lines.add(format('Down (%d,%d) %8x',[p.X,p.Y,longparam]));
      MMouseMove(form1,[ssleft], p2.X, p2.Y);
    end
    else
    begin
      Maze.MMouseUp(form1, mbleft,[],  p2.X, p2.Y);
      //form1.memo1.lines.add(format('Up&Cursor (%d,%d) %8x',[p2.X,p2.Y,longparam]));
      p2:=maze.clienttoscreen(p2);
      setcursorpos(p2.x,p2.y);
    end;
  end;
  Result:=1;
end;



{*****************Form Routines ***********}


{******************** PlayMove *****************}
Procedure TForm1.playmove(count:integer);
{maze onplaymove exit to display player's move count}
Begin
  playMovelbl.caption:='Player moves: '+ inttostr(count);
end;

{********************** FormCreate ****************}
procedure TForm1.FormCreate(Sender: TObject);
var
  s:string;
  pKeyboardhookproc:pointer;
begin
  pKeyboardhookproc:=@keyboardhookproc;
  {Set the keyboard hook so we can intercept keyboard input}
 {KBHook:=SetWindowsHookEx(WH_KEYBOARD,
           //callback  @KeyboardHookProc,
                          HInstance,
                          GetCurrentThreadId()) ;}

  maze:=TMaze.create(Scrollbox1);
  {set max maze dimensions}
  maze.popupmenu:=popupmenu1;
  with maze do OnPlayMove:=Playmove;

  {$IFDEF Debug}
    NbrColsEdt.value:=4;
    NbrRowsEdt.value:=4;
  {$ENDIF}
  opendialog1.initialdir:=extractfilepath(application.exename);
  savedialog1.initialdir:=opendialog1.initialdir;
  with statusbar1 do
  begin
    font.size:=12;
    font.style:=[fsbold];
    panels[0].text:=' New maze';
  end;
  s:=opendialog1.FileName+'Default.maz';
  if not fileexists(s) then savefile(s);
end;

{**************** FormActivate **************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  windowstate:=wsMaximized;

  ScrollBox1.width:=clientwidth-panel1.width-16;
  ScrollBox1.height:=panel1.height;
  ScrollBox1.left:=panel1.width+1;
  ScrollBox1.top:=panel1.top;

  with ScrollBox1 do maze.SetScreenSize(0,0,clientwidth,clientheight);
  maze.setwidthx(optform.widthedt.value);
  maze.setwidthy(optform.heightedt.value);
   resetbtnclick(sender);
end;

{***************** GenBtnClick  ******************}
Procedure TForm1.GenBtnClick(Sender:TObject);
Begin
  //memo1.clear;
  Screen.cursor:=CrDefault;
  if (optform.NbrColsEdt.value<>maze.NbrCols) or (optform.NbrRowsEdt.value<>maze.NbrRows) then
  Begin
    if messagedlg('Size changed, reset maze?',mtconfirmation,
                     [mbyes,mbno],0)=mryes
    then
    Begin {reset maze}
      if checksave
      then maze.initialize(optform.NbrColsEdt.value,optform.NbrRowsEdt.value);
    end
    else
    with maze do
    Begin {no reset - just expand or contract}
      clearborders; {clear old borders}
      Setxsize(optform.NbrColsEdt.Value);
      Setysize(optform.NbrRowsEdt.Value);
      makeborders;
      setaspect;
    end;
  end;
  screen.cursor:=crHourGlass;
  statusbar1.panels[0].text:=' Generating Randseed';
  //memo1.lines.add('Randseed='+inttostr(randseed));
  maze.makeimage; {make a solution}
  Solvedlengthlbl.caption:='Solution path: '+ inttostr(maze.buildmoves.count);
  maze.drawimage;
  maze.setmode(play);
  activecontrol:=scrollbox1;
  statusbar1.panels[0].text:='Ready to solve  ';
  screen.cursor:=crDefault;
  infomemo.Clear;
  with infomemo.lines do
  begin
    add('Click and drag from S room  to E room to win. Click any point on '
              + 'partial path or drag back to erase.');
    add('Use File menu to print or save.');
  end;
end;

{********************* ShowPathGroupClick ***************}
procedure TForm1.ShowPathGroupClick(Sender: TObject);
begin
  Case showpathgroup.itemindex of
  0: {None}
    Begin
      maze.showpaths:=false;
      maze.showsolutionpath:=false;
    end;
  1:{Show solution}
    Begin
      maze.showpaths:=false;
      maze.showsolutionpath:=true;
    end;
  2:{Show All}
    Begin
      maze.showpaths:=true;
      maze.showsolutionpath:=true;
    end;
  end;
  maze.drawimage;
  invalidate;
end;

{******************** Design1Click **************}
procedure TForm1.Design1Click(Sender: TObject);
begin
  Screen.cursor:=crhandpoint;
  if (optform.NbrColsEdt.value<>maze.NbrCols) or (optform.NbrRowsEdt.value<>maze.NbrRows) then
  Begin
    if messagedlg('Size changed, reset maze?',mtconfirmation,
                     [mbyes,mbno],0)=mryes
    then
    {reset maze}
    If checksave then maze.initialize(optform.NbrColsEdt.value,optform.NbrRowsEdt.value);
  end;
  statusbar1.panels[0].text:=' Design mode';
  maze.drawoutlines;
  Invalidate;
  maze.Setmode(design);
  infomemo.Clear;
  with infomemo.lines do
  begin
    add('Left click to toggle normal and "border" rooms. '
              + 'Right click any room for more options. ');
    add('');
    add('Check Help for more information.');
  end;
end;

{*************   ResetBtnClick ********************}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  if checksave then
  (*
  with optform do
  Begin
    screen.cursor:=crDefault;
    Statusbar1.panels[0].text:='New maze';
    NbrColsEdt.value:=20;
    NbrRowsEdt.value:=20;
    Intedit1.value:=2;
    WidthEdt.value:=20;
    HeightEdt.value:=20;
    with ScrollBox1 do maze.setscreenSize(left,top,widthedt.value, heightedt.value);
    maze.setwidthx(optform.widthedt.value);
    maze.setwidthy(optform.heightedt.value);
    maze.drawimage;
    //maze.initialize(optform.NbrColsEdt.value,optform.NbrRowsEdt.value);
    //maze.drawoutlines;
    solvedlengthLbl.caption:='0';
    invalidate;
  end;
  *)
  //loadfile(extractfilepath(application.exename)+'Default.maz');
  design1Click(sender);
  invalidate;
end;

{********************** StartPoint1Click **********}
procedure TForm1.StartPoint1Click(Sender: TObject);
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

{******************* ExitPoint1Click ******************}
procedure TForm1.ExitPoint1Click(Sender: TObject);
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

{********************* INvertBorderPointsa1Click ************}
procedure TForm1.Invertborderpoints1Click(Sender: TObject);
begin
  maze.invertallblocks;
  maze.drawoutlines;
  invalidate;
end;

{********************  SaveAs1Click *****************}
procedure TForm1.SaveAs1Click(Sender: TObject);
begin
  if savedialog1.execute then  savefile(savedialog1.filename);
end;

procedure TForm1.savefile(filename:string);
Begin
  if uppercase(extractfileext(filename))='.MAZ' then
  begin
    maze.filename:=filename;
    maze.savemaze;
  end
  else
  if uppercase(extractfileext(filename))='.BMP' then
  begin
    maze.picture.savetofile(filename);
  end;
end;

{************* CheckSave *********************}

Function tForm1.checksave:boolean;
{Check if modified, save if modified and user confirms }
{ Return false if user clicks cancel button }
var
  r:integer;
Begin
  result:=true;
  if maze.modified then
  Begin
    r:= messagedlg('Save current maze?',
                  mtconfirmation,
                  [mbyes,mbno,mbcancel],0);
    if r=mryes then
    begin
      If maze.filename<>'' then maze.savemaze
      else saveas1Click(self);
    end;
    If r=mrcancel then result:=false else maze.modified:=false;
  end
end;

{******************* Open1Click ******************}
procedure TForm1.Open1Click(Sender: TObject);
Begin
  if checksave then
  if opendialog1.execute then
  Begin
    if (not maze.imageclear)
     and (messagedlg('Add this file to existing maze?'
                     ,mtconfirmation,[mbyes,mbno],0)=mryes)
    then maze.concatenate:=true
    else maze.concatenate:=false;
    loadfile(opendialog1.filename);
  end;
end;

{*********** LoadFile ****************}
procedure TForm1.loadfile(filename:string);
begin
  statusbar1.panels[0].text:=' Reading '+filename;
  screen.cursor:=crHourGlass;
  maze.readfromstream(filename);
  with optform do
  begin
    NbrColsEdt.value:=maze.NbrCols;
    NbrRowsEdt.Value:=maze.NbrRows;
    widthedt.value:=maze.widthx;
    heightedt.value:=maze.widthy;
  end;

  {If maze.openrooms then maze.makeopenrooms;}
  with maze, ShowPathgroup do
  begin
    if showpaths then itemindex:=2
    else if showsolutionpath then itemindex:=1
    else itemindex:=0;
  end;
  maze.drawimage;
  invalidate;
  statusbar1.panels[0].text:=' Ready to play';
  Solvedlengthlbl.caption:='Solution path: '+ inttostr(maze.buildmoves.count);
  screen.cursor:=crDefault;
end;

{************************* Options1Click ***************}
procedure TForm1.Options1Click(Sender: TObject);
begin
  optform.newformcolor:=color;
  OptForm.showmodal;
  color:=optform.newformcolor;
  maze.setaspect;
  maze.drawimage;
  invalidate;
end;

{**************** PrintSetup1Click *******************}
procedure TForm1.PrintSetupClick(Sender: TObject);
begin
  //PrinterSetupDialog1.execute;
end;

{******************* PrintPreviewClicki *****************}
procedure TForm1.PrintPreviewClick(Sender: TObject);
begin
  with previewform.image1 do
  begin
    previewform.showmodal;
  end;
end;

{**************** PrintClick ***************}
procedure TForm1.Print1Click(Sender: TObject);
var
  p:TPoint;
  s1,s2,s3,s4,s5:TColor;
  begin
    //If printdialog1.execute then
    with printer, maze  do
    begin
      p:=getscale(pagewidth-1,pageheight-1);
      s1:=outsidecolor;
      s2:=bkcolor;
      s3:=pathcolor;
      s4:=solvedpathcolor;
      s5:=wallcolor;
      outsidecolor:=clwhite;
      bkcolor:=clwhite;
      pathcolor:=clblack;
      solvedpathcolor:=clblack;
      wallcolor:=clblack;
      drawimage;
      Begindoc;
       printer.canvas.stretchDraw(rect(1,1,p.x-2,p.y-2),maze.picture.bitmap);
      Enddoc;
      outsidecolor:=s1;
      bkcolor:=s2;
      pathcolor:=s3;
      solvedpathcolor:=s4;
      wallcolor:=s5;
      drawimage;
      invalidate;
    end;
  end;

procedure TForm1.Eliminatearow1Click(Sender: TObject);
var
  newy:integer;
  i,j:integer;
begin
  with maze do
  Begin
    newy:=(savey) div widthy + 1;
    for j:=newy to NbrRows+1 do
    for i:=1 to NbrCols do m[i,j]:=m[i,j+1];
    j:=NbrRows-1;
    Setysize(j);
    optform.NbrRowsEdt.value:=NbrRows;
    modified:=true;
    drawoutlines;
  end;
end;

procedure TForm1.Elimateacolumn1Click(Sender: TObject);
  var
    newx:integer;
    i,j:integer;
  begin
    with maze do
    begin
      newx:=(savex) div widthx +1;
      {newy:=(savey) div widthy + 1;}
      for i:=newx to NbrCols do
      for j:=1 to NbrRows do
        m[i,j]:=m[i+1,j];
      i:=NbrCols-1;
      SetXsize(i);
      optform.NbrColsEdt.value:=NbrCols;
      modified:=true;
      drawoutlines;
    end;
  end;

{***** Insert ColumnLeft **************}
procedure TForm1.Insertcolumnleft1Click(Sender: TObject);
var
    newx,newy:integer;
    i,j:integer;
    w:TRoomType;
  begin
    with maze do
    begin
      setxsize(NbrCols+1);
      newx:=(savex) div widthx ; {nbr +1 ==> left column}
      newy:=savey div widthy + 1;
      w:=m[newx+1,newy].roomtype;
      for i:=NbrCols{+1} downto newx+1 do
      for j:= 0 to NbrRows+1 do m[i+1,j]:=m[i,j];
      for j:=0 to NbrRows do m[newx+1,j].roomtype:=w;
      optform.NbrColsEdt.value:=NbrCols;
      rescale(optform.NbrColsEdt.value,optform.NbrRowsEdt.value);
      drawoutlines;
    end;
  end;

{********** InsertColumnRight ************}
procedure TForm1.Insertcolumnright1Click(Sender: TObject);
var
    newx,newy:integer;
    i,j:integer;
    w:TRoomType;
  begin
    with maze do
    begin
      setxsize(NbrCols+1);
      newx:=(savex) div widthx +1;
      newy:=savey div widthy + 1;
      w:=m[newx,newy].roomtype;
      for i:=NbrCols{+1} downto newx+1 do
      for j:= 0 to NbrRows+1 do m[i+1,j]:=m[i,j];
      for j:=0 to NbrRows do m[newx+1,j].roomtype:=w;
      optform.NbrColsEdt.value:=NbrCols;
      rescale(optform.NbrColsEdt.value,optform.NbrRowsEdt.value);
      drawoutlines;
    end;
  end;

{************ InsertRowBelow *************}
procedure TForm1.Insertrowbelow1Click(Sender: TObject);
var
    newx,newy:integer;
    i,j:integer;
    w:TRoomType;
  begin
    with maze do
    begin
      setysize(NbrRows+1);
      newx:=(savex) div widthx +1;
      newy:=savey div widthy +1;
      w:=m[newx,newy].roomtype;
      for j:=NbrRows{+1} downto newy+1 do
      for i:= 0 to NbrCols+1 do m[i,j+1]:=m[i,j];
      for i:=0 to NbrCols do m[i,newy+1].roomtype:=w;
      optform.NbrRowsEdt.value:=NbrRows{+1};
      rescale(optform.NbrColsEdt.value,optform.NbrRowsEdt.value);
      drawoutlines;
    end;
  end;

{**************** InsertRowAbove *************}
procedure TForm1.Insertrowabove1Click(Sender: TObject);
var
    newx,newy:integer;
    i,j:integer;
    w:TRoomType;
  begin
    with maze do
    begin
      setysize(NbrRows+1);
      newx:=(savex) div widthx +1;
      newy:=savey div widthy; {not +1 = row abovve}
      w:=m[newx,newy+1].roomtype;
      for j:=NbrRows{+1} downto newy+1 do
      for i:= 0 to NbrCols+1 do m[i,j+1]:=m[i,j];
      for i:=0 to NbrCols do m[i,newy+1].roomtype:=w;
      optform.NbrRowsEdt.value:=NbrRows{+1};
      rescale(optform.NbrColsEdt.value,optform.NbrRowsEdt.value);
      drawoutlines;
    end;
  end;

{********************* Save1Click ************}
procedure TForm1.Save1Click(Sender: TObject);
begin
  If maze.filename='' then Saveas1Click(sender)
  else maze.savemaze;
end;

{****************** Exit1Click ******************}
procedure TForm1.Exit1Click(Sender: TObject);
begin
  close;
end;

{********************* FormCloseCloseQuery *****************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  {$ifndef Debug}
  canclose:=checksave;
  {$endif}
end;

{******************* ZoomToScreenHeight ****************}
procedure TForm1.Zoomtoscreenheight1Click(Sender: TObject);
var
  saveAspect:boolean;
begin
  {
  if ScrollBox1.height<>maze.origheight
  then  with ScrollBox1 do maze.SetScreenSize(left,top,width,height);
  }
  SaveAspect:=Maze.maintainaspect;
  Maze.maintainaspect:=true;
  with maze do setwidthy((scrollbox1.clientheight -12) {origheight} div NbrRows);
  maze.maintainaspect:=Saveaspect;
  {if maze.mode=play then} maze.drawimage;
  //invalidate;
end;



{******************** ZoomToClickScreenWidthClick ***********}
procedure TForm1.Zoomtoscreenwidth1Click(Sender: TObject);
var
  saveAspect:boolean;
begin

  //if ScrollBox1.width<>maze.origwidth then
  //  with ScrollBox1 do maze.SetScreenSize(left,top,width,height);

  SaveAspect:=Maze.maintainaspect;
  Maze.maintainaspect:=true;
  with maze do setwidthx((scrollbox1.clientwidth-12 {origwidth-16}) div NbrCols);
  maze.maintainaspect:=Saveaspect;
  {if maze.mode=play then} maze.drawimage;
end;



{***************** Help1Click ****************}
procedure TForm1.Help1Click(Sender: TObject);
begin
    //Helpform.show;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  Aboutbox.showmodal;
end;

procedure TForm1.StatusBar1Click(Sender: TObject);
begin
   OpenURL('http://www.delphiforfun.org/'); { *Converted from ShellExecute* }
end;

procedure TForm1.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var
  x:integer;
begin
  with statusbar do
  begin
    if panel.id=2 then
    begin
      font.color:=clblue;
      font.style:=[fsunderline];
      {center the text}
      x:=(rect.left+rect.right-canvas.textwidth(panel.text)) div 2;
      canvas.textout(x, rect.top,panel.text);
    end;
  end;
end;

procedure TForm1.New1Click(Sender: TObject);
begin
  maze.setwidthx(optform.widthedt.value);
  maze.setwidthy(optform.heightedt.value);
  maze.drawimage;
end;

(*
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  p,p2,p3:TPoint;
begin
  begin {move the cursor one box width (or height) in the specified direction}
    getcursorpos(p);
    p:=maze.screenToClient(p);
    p2:=p;
    case key of
      vk_left: dec(p2.X,maze.widthx);
      vk_right: inc(p2.X,maze.widthx);
      vk_up:   dec(p2.y,maze.widthy);
      vk_down: inc(p2.y,maze.widthy);
    end;
    if (p.x<>p2.X) or (p.y<>p2.Y) then {arrow key was pressed}
    with p2, maze do
    if (x>=0) and (x<=width) and (y>=0) and (y<=height) then
    begin
      p3:=maze.clienttoscreen(p2);
      setcursorpos(p3.x, p3.y);
      Maze.MMouseDown(Sender, mbleft,[],  p.X, p.Y);
      Maze.MMouseMove(Sender,[], p2.X, p2.Y);
      Maze.MMouseUp(Sender, mbleft,[],  p2.X, p2.Y);
    end;
  end;

end;
*)

procedure TForm1.FormResize(Sender: TObject);
begin
  if application.terminated then exit;
  with ScrollBox1 do maze.SetScreenSize(0,0,clientwidth-50,clientheight-50);
  maze.setwidthx(optform.widthedt.value);
  maze.setwidthy(optform.heightedt.value);
  maze.drawimage;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=cafree;
end;

procedure TForm1.TestBtnClick(Sender: TObject);
begin
  maze.concatenate:=false;
  loadfile('Test.maz');
  randseed:=strtoint(randseededt.text);
end;

end.

