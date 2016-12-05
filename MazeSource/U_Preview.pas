unit U_Preview;

{$MODE Delphi}

  {Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {U_Preview previews and prints mazes built by TMaze}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, U_TMaze, NumEdit2 ;

type
  TPreviewForm = class(TForm)
    Image1: TImage;
    BitBtn1: TBitBtn;
    ScalingGroup: TRadioGroup;
    Layoutgroup: TRadioGroup;
    PrevBtn: TButton;
    NextBtn: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    PrintBtn: TButton;
    HdrBtn: TButton;

    PrintColorsBox: TCheckBox;
    TBProto: TEdit;
    LRProto: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LayoutgroupClick(Sender: TObject);
    procedure ScalingGroupClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure PrevBtnClick(Sender: TObject);
    procedure TBMarginEdtExit(Sender: TObject);
    procedure LRMarginEdtChange(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure HdrGroupClick(Sender: TObject);
    procedure PrintColorsBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    TBMarginEdt: TFloatEdit;
    LRMarginEdt: TFloatEdit;
    origwidth,origheight:integer;
    totpagesh,totpagesV,totpages:integer;
    currentpageH,currentpageV:integer;
    xpagesize,ypagesize:integer; {Pixels to increment for multple page displays}
    LMargin,TMargin:Integer;
    ToPrint:Boolean;
    Procedure DrawOutline;
    Procedure DrawRect(OutW,OutH:Integer;Canv:TCanvas);
    Procedure SetUpImage;
  end;

var
  PreviewForm: TPreviewForm;

implementation

{$R *.lfm}
Uses printers, U_Header, Math;

{****************** FormActivate ******************}
procedure TPreviewForm.FormActivate(Sender: TObject);
begin
  windowstate:=wsMaximized;
  prevbtn.enabled:=false;
  nextbtn.enabled:=false;
  ToPrint:=false;
  with layoutgroup do
  Case maze.paperlayout of
    poPortrait: itemindex:=0;
    poLandscape:itemindex:=1;
  end;
  {with ScalingGroup do
  Case maze.printscaling of
    poProportional: itemindex:=0;
    poPrintToFit: itemindex:=1;
  end;}
  drawoutline;
end;

{******************* Drawrect *****************}
 Procedure TPreviewform.Drawrect(Outw,OutH:Integer;Canv:TCanvas);
 var
   p:TPoint;
   TempBitmap:TBitMap;
   startx,starty,endx,endy:Integer;

  Function Getscale(maxw,maxh,origx,origy:integer{;aspect:real}):TPoint;
  var
    pw,ph:integer;
    a:real;
    a1,a2:real;
    Begin
      {Scale canvas size to aspect provided}
      {Mainly to scale preview canvas to print page orientation}
      a1:=maxw / origx;
      a2:=maxh / origy;
      if a2<a1 then a:=a2 else a:=a1;
      pw:=trunc(origx * a);
      ph:= trunc(origy * a);
      result.x:=pw;
      result.y:=ph;
    end; {Getscale}


     Begin
       with Canv do
       Begin
           startX:=(currentpageH)*xpagesize;
           starty:=(CurrentPageV)*ypagesize;
           endx:=min(startx+xpagesize,maze.width);
           endy:=min(starty+ypagesize,maze.height);
           tempbitmap:=tbitmap.create;
           with tempbitmap do
           Begin
             width:=xpagesize;
             height:=ypagesize;
             canvas.copyrect(rect(0,0,endx-startx,endy-starty)
                     ,maze.picture.bitmap.canvas
                     ,rect(startx,starty,endx,endy));
           end;
           {Get scale factors for target canvas}
           p:=getscale(OutW,OutH,tempbitmap.width,Tempbitmap.height);
           canv.stretchdraw(rect(LMargin,TMargin,p.x-1,p.y-1),tempbitmap);
           tempbitmap.free;
         end;
       End;

{********************** DrawOutline *************}
Procedure TPreviewform.Drawoutline;
 var
   p:Tpoint;
   ppi:integer;
   w,h:integer;
   done:boolean;
   SaveBkColor,SaveBordercolor:TColor;

 Begin
   If toprint then
   with printer do
   Begin
     {calculate ppi assuming 8 1/2 X 11 paper}
     ppi:=max(pagewidth,pageheight) div 11;
     w:=pagewidth;
     h:=pageheight;
   end
   else
   Begin
     ppi:=pixelsperInch;
     Setupimage;
     w:=image1.width;
     h:=image1.height;
   end;
   LMargin:=trunc(LRMarginEdt.value*PPI);
   TMargin:=trunc(TBMarginEdt.value*PPI);
   savebkcolor:=maze.bkcolor;
   saveborderColor:=maze.outsidecolor;
   if not Printcolorsbox.checked then
   begin
     maze.bkcolor:=clwhite;
     maze.outsidecolor:=clwhite;
     maze.drawimage;
   end;
   xpagesize:=maze.origwidth;
   ypagesize:=maze.origheight;
   {Case maze.printscaling of
     poprinttofit:
       Begin
         p:=maze.getscale(w,h);
         If toPrint then
         with printer, printer.canvas do
         Begin
           begindoc;
           stretchdraw(rect(1,1,p.x-1,p.y-1),maze.picture.bitmap);

           font.assign(maze.headerfont);
           font.Height:=maze.headerfont.height*pageheight div image1.height;
           if maze.headertype=footer then
             textout(lmargin,h-tmargin-abs(font.height),maze.headertext)
           else if maze.headertype=header then
             textout(lmargin,tmargin,maze.headertext);
           endDoc;
         End
         else
         with image1, image1.canvas do
         Begin
           stretchdraw(rect(1,1,p.x-1,p.y-1),maze.picture.bitmap);
           font.assign(maze.headerfont);
           if maze.headertype=footer then
             textout(lmargin,h-tmargin-abs(font.height),maze.headertext)
           else if maze.headertype=header then
             textout(lmargin,tmargin,maze.headertext);
         End;
         invalidate;
       End;
     PoProportional:
       Begin
         //Compute horizontal and vertical pages required
         totpagesH:=trunc((maze.width-1)/maze.origwidth)+1;
         totpagesv:=trunc((maze.height-1)/maze.origheight)+1;
         If (totpagesv=1) and (totpagesh>1) then
         Begin  //rescale to max page height

           xpagesize:=ypagesize*(w-2*LMargin) div (h-2*tMargin);
           totpagesH:=trunc((maze.width-1)/xpagesize)+1;
         end;
         totpages:=totpagesh*totpagesv;
         currentpageH:=0;
         CurrentpageV:=0;
         done:=false;
         If toPrint then
         with printer, printer.canvas do
         Repeat
           begindoc;
           brush.color:=clwhite;
           Drawrect(w-2*LMargin,h-2*TMargin,printer.canvas);
           font.assign(maze.headerfont);
           font.Height:=maze.headerfont.height*pageheight div image1.height;
           if maze.headertype=footer then
             textout(lmargin,(h-tmargin-abs(font.height)),maze.headertext)
           else if maze.headertype=header then
             textout(lmargin,tmargin,maze.headertext);
           printer.endDoc;
           Inc(currentpageH);
           if currentPageh>=totpagesh then
           Begin
             currentpageh:=0;
             inc(CurrentPageV);
             if Currentpagev>=TotpagesV then done:=true;
            End;
         until done
         else
         Begin
           Drawrect(w-2*LMargin,h-2*TMargin,Image1.canvas);
           image1.Canvas.font.assign(maze.headerfont);

           if maze.headertype=footer then
             image1.canvas.textout(lmargin,(h-tmargin-abs(font.height)),maze.headertext)
           else if maze.headertype=header then
             image1.canvas.textout(lmargin,tmargin,maze.headertext)
         end;
         prevbtn.enabled:=false;
         if totpages>1 then nextbtn.enabled:=true;
       End;
     End;//Case
     }
   invalidate;

   maze.bkcolor:=savebkcolor;;
   maze.OutsideColor:=saveBorderColor;
 end;

{****************** FormCreate ******************}
procedure TPreviewForm.FormCreate(Sender: TObject);
begin
  origwidth:=image1.width;
  origheight:=image1.height;
  TBMarginEdt:=TFloatEdit.create(self,TBProto);
  LRMarginEdt:=TFloatEdit.create(self,LRProto);
end;

{******************* SetUpImage *****************}
Procedure TPreViewForm.SetUpImage;
var
  pw,ph,iw,ih:integer;
  a:real;
  begin
    With image1 do
    Begin
      pw:=printer.pagewidth;
      ph:=printer.pageheight;
      a:= pw/ph;
      ih:=origheight;
      iw:=trunc(a*origheight);
      if iw>origwidth then
      Begin
        iw:=origwidth;
        ih:=trunc(iw*ph/pw);
      end;
      canvas.pen.width:=2;
      width:=iw;
      height:=ih;
      canvas.rectangle(0,0,iw,ih);
    End;
  End;

{****************** LayoutGroupClick ****************}
procedure TPreviewForm.LayoutGroupClick(Sender: TObject);
begin
  with layoutgroup do
  Case itemindex of
    0: maze.paperlayout:=poPortrait;
    1: maze.paperlayout:=poLandscape;
  end;
  printer.Orientation:=maze.paperlayout;
  drawoutline;
end;

{******************** ScalingGroupClick **************}
procedure TPreviewForm.ScalingGroupClick(Sender: TObject);
begin
  {with ScalingGroup do
  Case itemindex of
    0: maze.printscaling:=poProportional;
    1: maze.printscaling:=poPrintToFit;
  end; }
  drawoutline;
end;

{**************** NextBtnClick ********************}
procedure TPreviewForm.NextBtnClick(Sender: TObject);
begin
  prevbtn.enabled:=true;
  Inc(currentPageH);
  With image1 do Drawrect(width-2*LMargin,height-2*TMargin,canvas);
  if currentPageh>=totpagesh-1 then
  Begin
    currentpageh:=0;
    inc(CurrentPageV);
    if Currentpagev>=TotpagesV-1 then {at end}
    Begin
      nextbtn.enabled:=false;
      dec(currentpagev);
      currentpageh:=(totpagesh-1);
    end;
  End;
end;

{****************** PrevBtnClick ******************}
procedure TPreviewForm.PrevBtnClick(Sender: TObject);
begin
  nextbtn.enabled:=true;
  If currentpageh=0 then currentpageh:=totpagesh-1;
  dec(currentPageH);
  With image1 do Drawrect(width-2*LMargin,height-2*TMargin,canvas);
  if currentPageh<=0 then
  Begin
    currentpageh:=totpagesh-1;
    dec(CurrentPageV);
    if Currentpagev<=0 then
    Begin
      prevbtn.enabled:=false;
      inc(currentpagev);
      currentpageh:=0;
    End;
  End;

end;

{********************* TBMarginEdtExit ****************}
procedure TPreviewForm.TBMarginEdtExit(Sender: TObject);
begin
  TMargin:=Trunc(TBMarginEdt.value*Pixelsperinch);
  DrawOutline;
end;

{*********************LRMarginEdtChange ****************}
procedure TPreviewForm.LRMarginEdtChange(Sender: TObject);
begin
  LMargin:=Trunc(LRMarginEdt.value*Pixelsperinch);
  Drawoutline;
end;

{***************** PrintBtnClick *****************}
procedure TPreviewForm.PrintBtnClick(Sender: TObject);
begin
  ToPrint:=true;
  drawoutline;
  ToPrint:=false;
end;

{*************** HdrGroupClick ***************}
procedure TPreviewForm.HdrGroupClick(Sender: TObject);
begin
  HdrForm.ShowModal;
  drawoutline;
end;

procedure TPreviewForm.PrintColorsBoxClick(Sender: TObject);
begin
  maze.drawimage;
  drawoutline;
end;


end.
