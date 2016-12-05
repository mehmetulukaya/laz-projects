unit U_Options3;

{$MODE Delphi}

 {Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{The Options dialog }
 
interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, NumEdit2;

type
  TOptForm = class(TForm)
    ColorDialog1: TColorDialog;
    Exitbtn: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    WallBtn: TBitBtn;
    RoomBtn: TBitBtn;
    GroundBtn: TBitBtn;
    SPathBtn: TBitBtn;
    FPathBtn: TBitBtn;
    FormColorBtn: TBitBtn;
    KeepColorsBox: TCheckBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    
    Label1: TLabel;
    
    AspectBox: TCheckBox;
    TabSheet3: TTabSheet;
    OpenRoomsBox: TCheckBox;
    LongPathBox: TCheckBox;
    Label4: TLabel;
    Label7: TLabel;
    
    Label5: TLabel;
    Label6: TLabel;
    
    ColProto: TEdit;
    RowProto: TEdit;
    WidthProto: TEdit;
    HeightProto: TEdit;
    WallWidthProto: TEdit;
    DoorSizeProto: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    Label8: TLabel;
    Label9: TLabel;
    PathWidthProto: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Edit1: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure wallbtnclick(Sender: TObject);
    procedure RoomBtnClick(Sender: TObject);
    procedure GroundBtnClick(Sender: TObject);
    procedure SPathBtnClick(Sender: TObject);
    procedure FPathBtnClick(Sender: TObject);
    procedure IntEdit1Change(Sender: TObject);
    procedure AspectBoxClick(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure WidthEdtExit(Sender: TObject);
    procedure HeightEdtExit(Sender: TObject);
    procedure FormColorBtnClick(Sender: TObject);
    procedure LongPathBoxClick(Sender: TObject);
    procedure OpenRoomsBoxClick(Sender: TObject);
    procedure SizeEdtExit(Sender: TObject);
    procedure SizeEdtKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure ExitbtnClick(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure DoorSizeProtoChange(Sender: TObject);
    procedure KeepColorsBoxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PathWidthProtoChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    WidthEdt: TIntEdit;
    HeightEdt: TIntEdit;
    IntEdit1: TIntEdit;
    DoorSizeEdt: TIntEdit;
    PathWidthEdt:TIntEdit;
    nbrcolsEdt: TIntEdit;
    nbrRowsEdt: TIntEdit;
    newformcolor:TColor;
    Procedure makecolor(btn:TBitBtn;color:TColor);
    procedure SizeChange(Sender: TObject);
  end;

var
  OptForm: TOptForm;

implementation
  Uses U_TMaze, U_Maze3;

{$R *.lfm}

{********************** MakeColor ***************}
Procedure TOptform.makecolor(btn:TBitBtn;color:TColor);
var
  mybitmap:TBitmap;

Begin
  mybitmap:=tbitmap.create;
  mybitmap.width:=btn.glyph.width;
  mybitmap.height:=btn.glyph.height;
  with btn, mybitmap do
  Begin
    canvas.Brush.color:=color;
    canvas.rectangle(1,1,glyph.width-1,glyph.height-1);
    glyph.assign(mybitmap);
  end;
  mybitmap.free;
End;

{***************** FormActivate ***************}
procedure TOptForm.FormActivate(Sender: TObject);
begin
  makecolor(wallbtn,maze.wallcolor);
  makecolor(spathbtn,maze.solvedpathcolor);
  makecolor(roombtn,maze.bkcolor);
  makecolor(groundbtn,maze.outsidecolor);
  makecolor(fpathbtn,maze.pathcolor);
  makecolor(FormColorbtn,newformcolor);
  Aspectbox.checked:=maze.maintainaspect;
  LongPathBox.checked:=maze.longpaths;
  OpenroomsBox.checked:=maze.openrooms;
  Intedit1.value:=maze.wallwidth;
  WidthEdt.value:=maze.widthx;
  HeightEdt.value:=maze.widthy;
  nbrcolsEdt.value:=maze.NbrCols;
  nbrRowsEdt.value:=maze.NbrRows;
  doorsizeEdt.value:=maze.doorsize;
  PathWidthEdt.value:=maze.pathwidth;
  if maze.debug then optform.show;
  KeepColorsBox.checked:=maze.restorecolors;
   (* other maze variables for possible user control
      wallstyle
      pathstyle
      solvedpathstyle
      doorsize
      debug
      *)
end;

{******************* WallBtnClick **************}
procedure TOptForm.wallbtnclick(Sender: TObject);
begin
  If colordialog1.Execute then
  Begin
    makecolor(TBitBtn(sender),colordialog1.color);
    maze.wallcolor:=colordialog1.Color;
  end;
end;

{******************** RoomBtnClick ****************}
procedure TOptForm.RoomBtnClick(Sender: TObject);
begin
  If colordialog1.Execute then
  Begin
    makecolor(TBitBtn(sender),colordialog1.color);
    maze.bkcolor:=colordialog1.Color;
  end;
end;

{************************ GroundbtnClick **************}
procedure TOptForm.GroundBtnClick(Sender: TObject);
begin
  If colordialog1.Execute then
  begin
    makecolor(TBitBtn(sender),colordialog1.color);
    maze.outsidecolor:=colordialog1.Color;
  end;
end;

{*******************SPathBtnClick ****************}
procedure TOptForm.SPathBtnClick(Sender: TObject);
begin
  If colordialog1.Execute then
  Begin
    makecolor(TBitBtn(sender),colordialog1.color);
    maze.SolvedPathcolor:=colordialog1.Color;
  end;
end;

{****************** FPathBtnClick *******************}
procedure TOptForm.FPathBtnClick(Sender: TObject);
begin
  If colordialog1.Execute then
  Begin
    makecolor(TBitBtn(sender),colordialog1.color);
    maze.Pathcolor:=colordialog1.Color;
  end;
end;

{************************* FormColorBtnClick ************}
procedure TOptForm.FormColorBtnClick(Sender: TObject);
begin
  If colordialog1.Execute then
  Begin
    makecolor(TBitBtn(sender),colordialog1.color);
    newformcolor:=colordialog1.color;
  end;
end;

{******************** IntEdit1Chenge ***************}
procedure TOptForm.IntEdit1Change(Sender: TObject);
begin
  maze.wallwidth:=Intedit1.value;
  maze.drawimage;
end;

{****************** AspectBoxClick *******************}
procedure TOptForm.AspectBoxClick(Sender: TObject);
begin
  maze.maintainaspect:=Aspectbox.checked;
end;

{***************** CheckBox2Click *****************}
procedure TOptForm.CheckBox2Click(Sender: TObject);
begin
  {Maze.debug:= checkbox2.checked;}
end;

{********************** FormDeactivate ****************}
procedure TOptForm.FormDeactivate(Sender: TObject);
begin
  Optform.hide;
  maze.Setwidthx(WidthEdt.value);
  maze.setwidthy(HeightEdt.value);
  maze.restorecolors:=keepcolorsbox.checked;
end;

{********************** WidthEdtExit *************}
procedure TOptForm.WidthEdtExit(Sender: TObject);
var
  a:real;
begin
  with maze do
  Begin
    a:=widthx/widthy;
    Setwidthx(WidthEdt.value);
    If maintainaspect then
    Begin
      HeightEdt.value:=Trunc(widthx / a);
      setwidthy(HeightEdt.value);
    end;
  end;
end;

{******************** HeightEdtExit ****************}
procedure TOptForm.HeightEdtExit(Sender: TObject);
var
  a:real;
begin
  with maze do
  Begin
    a:=widthx/widthy;
    Setwidthy(HeightEdt.value);
    If maintainaspect then
    Begin
      WidthEdt.value:=Trunc(widthy * a);
      setwidthx(WidthEdt.value);
    end;
  end;
end;

{********************* LongPathBoxClick ****************}
procedure TOptForm.LongPathBoxClick(Sender: TObject);
begin
  maze.longpaths:=LongpathBox.checked;
end;

procedure TOptForm.OpenRoomsBoxClick(Sender: TObject);
begin
  if maze.openrooms<>OpenRoomsBox.checked then
  begin
    maze.openrooms:=openroomsbox.checked;
    if maze.openrooms then maze.makeopenrooms
    {else makeclosedrooms};
  end;
end;

procedure TOptForm.SizeEdtKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 {enter} then sizechange(sender);
end;

procedure TOptForm.SizeEdtExit(Sender: TObject);
begin
  if (nbrcolsEdt.value<>maze.NbrCols) or (nbrRowsEdt.value<>maze.NbrRows)
  then sizechange(sender);
end;

{*******************  SizeChange ******************}
procedure TOptForm.SizeChange(Sender: TObject);
begin
  if (nbrcolsEdt.value<>maze.NbrCols) or (nbrRowsEdt.value<>Maze.NbrRows)
  then
  If  form1.checksave
  then
  Begin
    maze.initialize(nbrcolsEdt.value,nbrRowsEdt.value);
    maze.Drawoutlines;
  end
  else
  begin {User changed her mind}
    nbrcolsEdt.value:=maze.NbrCols;
    nbrRowsEdt.value:=maze.NbrRows;
  end;
end;

procedure TOptForm.FormCreate(Sender: TObject);
begin
  WidthEdt:= TIntEdit.create(self,widthProto);
    HeightEdt:= TIntEdit.create(self,heightProto);
    IntEdit1:=TIntEdit.create(self,WallWidthProto);
    DoorSizeEdt:=TIntEdit.create(self,DoorSizeProto);
    PathWidthEdt:=TIntEdit.create(self,PathWidthProto);
    nbrcolsEdt:= TIntEdit.create(self,ColProto);
    nbrRowsEdt:= TIntEdit.create(self,RowProto);
  with maze do
  begin
    nbrcolsEdt.value:=NbrCols;
    nbrRowsEdt.value:=NbrRows;
    initialize(nbrcolsEdt.value,nbrRowsEdt.value);
    maze.drawimage;
  end;
end;

procedure TOptForm.ExitbtnClick(Sender: TObject);
begin
  {check for size changes not handled yet}
  sizeedtExit(sender);
  if maze.widthx<>widthedt.value then  widthedtexit(sender);
  if maze.widthy<>heightedt.value then heightedtexit(sender);
end;

procedure TOptForm.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  (*
  maze.wallwidth:=Intedit1.value;
  maze.drawimage;
  *)
end;

procedure TOptForm.DoorSizeProtoChange(Sender: TObject);
begin
  maze.doorsize:=DoorsizeEdt.value;
end;

procedure TOptForm.PathWidthProtoChange(Sender: TObject);
begin
  maze.pathwidth:=PathWidthEdt.value;
end;

procedure TOptForm.KeepColorsBoxClick(Sender: TObject);
begin
  maze.restorecolors:=KeepColorsBox.checked;
end;

procedure TOptForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  showmessage('closing');
  action:=caFree;
end;



end.

