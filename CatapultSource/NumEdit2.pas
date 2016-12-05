unit NumEdit2;

{$MODE Delphi}

{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
 {This unit define 2 numeric edit controls2, TIntEdit for integer data and
  TFloatEdit for floating point input .  Usage is similar to TEdit except
  that input is restricted to valid numeric characters and the addition of a
  Value property.

  This version is intended for use without requiring that the controls be
  installed as compoinents
  }

 

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TIntEdit = class(TEdit)
  private
    { Private declarations }
    function getvalue:int64;
    procedure setvalue(NewVal:Int64);
  protected
    { Protected declarations }
    procedure KeyPress(var Key: Char); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; proto:TEdit); reintroduce;
  published
    { Published declarations }
    property Value: Int64 read GetValue write SetValue;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    //property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    //property ImeMode;
    //property ImeName;
    property MaxLength;
    //property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    //property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

 TFloatEdit = class(TEdit)
  private
    { Private declarations }
    function getvalue:Extended;
    procedure setvalue(NewVal:Extended);
  protected
    { Protected declarations }
    procedure KeyPress(var Key: Char); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; proto:TEdit); reintroduce;
  published
    { Published declarations }
    property Value: Extended read GetValue write SetValue;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    //property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    //property ImeMode;
    //property ImeName;
    property MaxLength;
    //property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    //property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;


implementation


{****************** TIntEdit Mettods *********************}
constructor TIntEdit.create(Aowner:TComponent; proto:TEdit);
begin
  inherited create(aowner);
  text:='0';
  //width:=33;
  {assign TEdit prototype to self}
  value:=strtointdef(proto.text,0);
  anchors:=proto.anchors;
  height:=proto.height;
  width:=proto.width;
  left:=proto.left;
  top:=proto.top;
  parent:=proto.parent;
  font:=proto.font;
  color:=proto.color;
  proto.visible:=false;
  OnChange:=proto.onchange;
  OnClick:=proto.onclick;
  OnContextPopup:=proto.oncontextpopup;
  OnDblClick:=proto.OnDblClick;
  OnDragDrop:=proto.ondragdrop;
  OnDragOver:=proto.ondragover;
  //OnEndDock:=proto.onenddock;
  OnEndDrag:=proto.onenddrag;
  OnEnter:=proto.onenter;
  OnExit:=proto.onexit;
  OnKeyDown:=proto.onkeydown;
  OnKeyPress:=proto.onkeypress;
  OnKeyUp:=proto.onkeyup;
  OnMouseDown:=proto.onmousedown;
  OnMouseMove:=proto.onmousemove;
  OnMouseUp:=proto.onmouseup;
  //OnStartDock:=proto.onstartdock;
  OnStartDrag:=proto.onstartdrag;
end;

function TIntEdit.getvalue:int64;
begin
  result:=StrToIntDef(text,0);
end;

procedure TIntEdit.Setvalue(Newval:int64);
begin
  text:=inttostr(newval);
end;

procedure TIntEdit.KeyPress(var Key: Char);
begin
  if not ( Key in ['+', '-', '0'..'9', #8,#13] ) then
  begin
    Key := #0;
    //MessageBeep(MB_ICONEXCLAMATION);
  end
  else inherited KeyPress(Key);
end;

{***************** TFloatEdit Methods *******************}
constructor TFloatEdit.create(Aowner:TComponent; proto:Tedit);
begin
  inherited create(Aowner);
  text:=proto.text;
  try
    value:=strtofloat(proto.text);
    except on Econverterror do value:=0.0;
  end;  
  anchors:=proto.anchors;
  height:=proto.height;
  width:=proto.width;
  left:=proto.left;
  top:=proto.top;
  parent:=proto.parent;
  font:=proto.font;
  color:=proto.color;
  proto.visible:=false;
  OnChange:=proto.onchange;
  OnClick:=proto.onclick;
  OnContextPopup:=proto.oncontextpopup;
  OnDblClick:=proto.OnDblClick;
  OnDragDrop:=proto.ondragdrop;
  OnDragOver:=proto.ondragover;
  //OnEndDock:=proto.onenddock;
  OnEndDrag:=proto.onenddrag;
  OnEnter:=proto.onenter;
  OnExit:=proto.onexit;
  OnKeyDown:=proto.onkeydown;
  OnKeyPress:=proto.onkeypress;
  OnKeyUp:=proto.onkeyup;
  OnMouseDown:=proto.onmousedown;
  OnMouseMove:=proto.onmousemove;
  OnMouseUp:=proto.onmouseup;
  //OnStartDock:=proto.onstartdock;
  OnStartDrag:=proto.onstartdrag;
end;

function TFloatEdit.getvalue:Extended;
begin
  try
    if (text='')
    or (text='-')
    then  result:=0.0
    else result:=StrToFloat(text);
  except
    on E: EConvertError do
    begin
      ShowMessage(E.ClassName + #13 + E.Message);
      result:=0.0;
    end;
  end;
end;

procedure TFloatEdit.Setvalue(Newval:extended);
begin
  text:=FloatTostr(newval);
end;

procedure TFloatEdit.KeyPress(var Key: Char);
begin
  if not (Key in ['+', '-', DecimalSeparator, '0'..'9', #0..#31] )
    or ((key = decimalseparator) and (pos(decimalseparator,text)>0))
  then
  begin
    Key := #0;
    //MessageBeep(MB_ICONEXCLAMATION);
  end
  else inherited KeyPress(Key);
end;

end.
