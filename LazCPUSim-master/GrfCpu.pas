unit GrfCpu;

{$MODE Delphi}

interface

uses
  ExtCtrls, Graphics, SysUtils;

const
  cmdAlu = 0;
  cmdFlags = 1;
  cmdGenReg = 2;
  cmdSP = 3;
  cmdT = 4;
  cmdPC = 5;
  cmdIVR = 6;
  cmdADR = 7;
  cmdMDR = 8;
  cmdMDRMux = 9;
  cmdMem = 10;

type
  TGrfCpu = class
  private
    own: TObject;
    procedure DrowBuss(tmpX: Integer; tmpY: Integer; tmpSz: Integer; tmpName: String; Use: Boolean);
    procedure DrowData(tmpXs: Integer; tmpYs: Integer; tmpXe: Integer; tmpYe: Integer; tmpTyp: String; Use: Boolean);
    procedure DrowALU(tmpX: Integer; tmpY: Integer; Use: Boolean);
    procedure DrowMUX(tmpX: Integer; tmpY: Integer; Use: Boolean);
    procedure DrowBGC(tmpXs: Integer; tmpYs: Integer; tmpXe: Integer; tmpYe: Integer; tmpTyp: String);
    procedure DrowResetImg();
  public
    constructor Create(tmpOwn: TObject);
    procedure ResetCpu();
    procedure PdSFLAGS;
    procedure PdDFLAGS;
    procedure pdSGenReg;
    procedure pdDGenReg;
    procedure pdSSP;
    procedure pdDSP;
    procedure pdST;
    procedure pdDT;
    procedure pdSPC;
    procedure pdDPC;
    procedure pdSIVR;
    procedure pdDIVR;
    procedure pdSADR;
    procedure pdDADR;
    procedure pdSMDR;
    procedure pdDMDR;
    procedure pdSIR;
    procedure pdDIR;
    procedure pdRALU;
    procedure pdCONDALU;
    procedure pdMem;
    procedure pmALU;
    procedure pmFLAGS;
    procedure pmGenReg;
    procedure pmSP;
    procedure pmT;
    procedure pmPC;
    procedure pmIVR;
    procedure pmADR;
    procedure pmMDR;
    procedure pmMuxMDR;
    procedure cmdMem;
  end;

implementation

uses main;

procedure TGrfCpu.DrowData(tmpXs: Integer; tmpYs: Integer; tmpXe: Integer; tmpYe: Integer; tmpTyp: String; Use: Boolean);
begin
  with (Own as TImage) do
  begin
    Canvas.Pen.Width := 1;
    Canvas.Pen.Style := psSolid;


    if pos('CMD', Uppercase(tmpTyp))>0 then
    begin
      if not use then
        Canvas.Pen.Color := clBlue
      else
        Canvas.Pen.Color := clFuchsia;
    end
    else
    begin
      if use then
        Canvas.Pen.Color := clRed
      else
        Canvas.Pen.Color := clGreen;
    end;

    Canvas.MoveTo(tmpXs, tmpYs);
    canvas.LineTo(tmpXe, tmpYe);

    if pos('START', Uppercase(tmpTyp))>0 then
    begin
      Canvas.MoveTo(tmpXs, tmpYs);
      Canvas.Brush.Style := bsSolid;
      Canvas.Brush.Color := Canvas.Pen.Color;
      Canvas.Ellipse(tmpXs - 3, tmpYs - 3, tmpXs + 3, tmpYs + 3);
    end;

    if pos('END', Uppercase(tmpTyp))>0 then
    begin
      Canvas.MoveTo(tmpXe, tmpYe);
      Canvas.Brush.Style := bsSolid;
      Canvas.Brush.Color := Canvas.Pen.Color;
      if pos('UP', Uppercase(tmpTyp))>0 then
      begin
        Canvas.LineTo(tmpXe - 3, tmpYe + 3);
        Canvas.LineTo(tmpXe + 3, tmpYe + 3);
        Canvas.LineTo(tmpXe, tmpYe);
      end;

      if pos('DOWN', Uppercase(tmpTyp))>0 then
      begin
        Canvas.LineTo(tmpXe - 3, tmpYe - 3);
        Canvas.LineTo(tmpXe + 3, tmpYe - 3);
        Canvas.LineTo(tmpXe, tmpYe);
      end;

      if pos('LEFT', Uppercase(tmpTyp))>0 then
      begin
        Canvas.LineTo(tmpXe + 3, tmpYe + 3);
        Canvas.LineTo(tmpXe + 3, tmpYe - 3);
        Canvas.LineTo(tmpXe, tmpYe);
      end;

      if pos('RIGHT', Uppercase(tmpTyp))>0 then
      begin
        Canvas.LineTo(tmpXe - 3, tmpYe + 3);
        Canvas.LineTo(tmpXe - 3, tmpYe - 3);
        Canvas.LineTo(tmpXe, tmpYe);
      end;
    end;
  end;
end;//procedure TGfrCpu.DrowData(tmpOwn: TObject; tmpXs: Integer; tmpYs: Integer; tmpXe: Integer; tmpYe: Integer; tmpTyp: String; Use: Boolean);

procedure TGrfCpu.DrowMUX(tmpX: Integer; tmpY: Integer; Use: Boolean);
var
  x, y: Integer;
begin
  with (Own as TImage) do
  begin
    if use then
      Canvas.Pen.Color := clRed
    else
      Canvas.Pen.Color := clGreen;

    Canvas.Pen.Width := 1;
    Canvas.Pen.Style := psSolid;
    Canvas.Brush.Style := bsClear;

    x:= tmpX + 10;
    y:= tmpY;

    Canvas.MoveTo(x, y);

    x := x - 10;
    y := y + 10;
    Canvas.LineTo(x, y);

    x := x;
    y := y + 10;
    Canvas.LineTo(x, y);

    x := x + 10;
    y := y + 10;
    Canvas.LineTo(x, y);

    x := x;
    y := y - 30;
    Canvas.LineTo(x, y);
  end;
end;//procedure TGfrCpu.DrowMUX(tmpOwn: TObject; tmpX: Integer; tmpY: Integer; Use: Boolean);

procedure TGrfCpu.DrowBGC(tmpXs: Integer; tmpYs: Integer; tmpXe: Integer; tmpYe: Integer; tmpTyp: String);
begin
  with (Own as TImage) do
  begin
    Canvas.Pen.Color := clBlack;
    Canvas.Pen.Width := 1;
    Canvas.Pen.Style := psSolid;

    Canvas.Brush.Style := bsClear;
    Canvas.Brush.Color := clWhite;

    Canvas.MoveTo(tmpXs, tmpYs);
    canvas.LineTo(tmpXs, tmpYe);
    canvas.LineTo(tmpXe, tmpYe);
    canvas.LineTo(tmpXe, tmpYs);
    canvas.LineTo(tmpXs, tmpYs);

    Canvas.TextOut(tmpXs + 10, tmpYs + 10, tmpTyp);
  end;
end;//procedure TGrfCpu.DrowBGC(tmpOwn: TObject; tmpXs: Integer; tmpYs: Integer; tmpXe: Integer; tmpYe: Integer; tmpTyp: String);

procedure TGrfCpu.DrowALU(tmpX: Integer; tmpY: Integer; Use: Boolean);
var
  x, y: Integer;
begin
  with (Own as TImage) do
  begin
    if use then
      Canvas.Pen.Color := clRed
    else
      Canvas.Pen.Color := clGreen;

    Canvas.Pen.Width := 1;
    Canvas.Pen.Style := psSolid;
    Canvas.Brush.Style := bsClear;

    x:= tmpX;
    y:= tmpY;

    Canvas.MoveTo(x, y);
    x := x + 20;
    y := y + 10;
    Canvas.LineTo(x, y);
    y := y + 20;
    Canvas.LineTo(x, y);
    x := x - 20;
    y := y + 10;
    Canvas.LineTo(x, y);
    x := x;
    y := y - 15;
    Canvas.LineTo(x, y);
    x := x + 5;
    y := y - 5;
    Canvas.LineTo(x, y);
    x := x-5;
    y := y - 5;
    Canvas.LineTo(x, y);
    x := x;
    y := y - 15;
    Canvas.LineTo(x, y);

    Canvas.Font.Name := 'arial';
    Canvas.Font.Size := 6;
    x := tmpX + 2;
    y := tmpY + 10 - round(Canvas.TextHeight('D')/2);
    Canvas.TextOut(x, y, 'D');

    Canvas.Font.Size := 6;
    x := tmpX + 2;
    y := tmpY + 30 - round(Canvas.TextHeight('S')/2);
    Canvas.TextOut(x, y, 'S');

    Canvas.Font.Size := 6;
    x := tmpX + 20 - Canvas.TextWidth('R') - 1;
    y := tmpY + 15;
    Canvas.TextOut(x, y, 'R');
  end;
end;//procedure TGfrCpu.DrowALU(tmpOwn: TObject; tmpX: Integer; tmpY: Integer; Use: Boolean);

procedure TGrfCpu.DrowBuss(tmpX: Integer; tmpY: Integer; tmpSz: Integer; tmpName: String; Use: Boolean);
begin
  with (Own as TImage) do
  begin
    if use then
      Canvas.Pen.Color := clRed
    else
      Canvas.Pen.Color := clGreen;

    Canvas.Pen.Width := 3;
    Canvas.Pen.Style := psSolid;
    Canvas.Brush.Style := bsClear;

    Canvas.MoveTo(tmpX, tmpY);
    Canvas.LineTo(tmpX, tmpY + tmpSz);

    Canvas.Font.Name := 'arial';
    Canvas.Font.Size := 7;
    Canvas.TextOut(tmpX - Canvas.TextWidth(tmpName)-1, tmpY + 10, tmpName);
  end;
end;//procedure TGfrCpu.DrowBuss(tmpOwn: TObject; tmpX: Integer; tmpY: Integer; tmpSz: Integer; tmpName: String; Use: Boolean);

procedure TGrfCpu.DrowResetImg();
begin
  with (Own as TImage) do
  begin
    Canvas.Pen.Color := clWhite;
    Canvas.Brush.Color := clWhite;
    Canvas.Clear;
  end;
end;

constructor TGrfCpu.Create(tmpOwn: TObject);
begin
  own := tmpOwn;
end;//constructor TGfrCpu.Create();

procedure TGrfCpu.ResetCpu();
var
  i: Integer;
  regEnd: Integer;
  sel: Boolean;
begin
  regEnd := Form1.LabeledEdit1.Left + Form1.LabeledEdit1.Width;
  DrowResetImg();

  sel := false;
  DrowALU(300, 15, sel);

  //RBus
  DrowMUX(370, 85, sel);
  DrowBuss(430, 15, 485, 'RBus(16 b)', sel);//RBus
  DrowData(320, 35, 429, 35, 'DATA END Right', sel);//ALU -> RBus

  //COND
  DrowData(310, 50, 310, 60, 'DATA', sel);
  DrowData(310, 60, 400, 60, 'DATA', sel);
  DrowData(400, 60, 400, 95, 'DATA', sel);
  DrowData(400, 95, 380, 95, 'DATA END LEFT', sel);
  //COND

  DrowData(370, 100, regEnd, 100, 'DATA END LEFT', sel);//MUX -> Flags
  DrowData(430, 105, 380, 105, 'DATA START END LEFT', sel);//RBus -> MUX
  DrowData(430, 170, 414, 170, 'DATA START END LEFT', sel);//RBus -> GenReg

  //RBus -> Reg
  for i:=1 to 5 do
    DrowData(430, 250 + (i-1)*48, regEnd, 250+ (i-1)*48, 'DATA START END LEFT', sel);
  //RBus -> Reg

  DrowMUX(370, 475, sel);
  DrowData(430, 485, 380, 485, 'DATA START END LEFT', sel);//RBus -> MUX
  DrowData(370, 490, regEnd, 490, 'DATA END LEFT', sel);//Mux -> MDR
  //RBus

  //DBus
  DrowBuss(200, 15, 485, 'DBus(16 b)', sel);

  DrowData(200, 25, 300, 25, 'DATA START END RIGHT', sel);//DBus -> ALU
  DrowData(256, 93, 202, 93, 'DATA START END LEFT', sel);//FLAGS -> DBus
  DrowData(256, 150, 202, 150, 'DATA START END LEFT', sel);//GenReg -> DBus

  //reg - > DBus
  for i:=1 to 6 do
    DrowData(256, 245 + (i-1)*48, 202, 245+ (i-1)*48, 'DATA START END LEFT', sel);
  //reg - > DBus

  DrowData(229, 486, 229, 530, 'DATA START END DOWN', sel);//MDR -> Mem
  DrowData(126, 440, 198, 440, 'DATA START END RIGHT', sel);//IR -> DBus
  //DBus

  //SBus
  DrowBuss(150, 15, 485, 'SBus(16 b)', sel);
  DrowData(150, 45, 300, 45, 'DATA START END RIGHT', sel);//SBus -> ALU
  DrowData(256, 103, 152, 103, 'DATA START END LEFT', sel);//FLAGS -> SBus
  DrowData(256, 200, 152, 200, 'DATA START END LEFT', sel);//GenReg -> SBus

  //reg - > SBus
  for i:=1 to 6 do
    DrowData(256, 255 + (i-1)*48, 152, 255+ (i-1)*48, 'DATA START END LEFT', sel);
  //reg - > SBus

  DrowData(219, 448, 219, 530, 'DATA START END DOWN', sel);//ADR -> Mem
  DrowData(126, 430, 148, 430, 'DATA START END RIGHT', sel);//IR -> SBus
  //SBus

  //MemBus
  DrowData(15, 435, 20, 435, 'DATA END RIGHT', sel);//MemBus -> IR
  DrowData(15, 435, 15, 620, 'DATA', sel);//MemBus
  DrowData(15, 620, 400, 620, 'DATA', sel);//MemBus
  DrowData(400, 620, 400, 495, 'DATA', sel);//MemBus
  DrowData(400, 495, 380, 495, 'DATA END LEFT', sel);//MemBus
  DrowData(190, 604, 190, 620, 'DATA START END Down', sel);//Mem -> MemBus
  //MemBus

  //BGC
  DrowBGC(10, 100, 130, 500, 'BGC');
  //BGC

  //cmdAlu
  DrowData(50, 100, 50, 10, 'CMD START', sel);//BGC -> CmdALU
  DrowData(50, 10, 310, 10, 'CMD', sel);//mdALU
  DrowData(310, 10, 310, 20, 'CMD END DOWN', sel);//CmdALU -> ALU
  //cmdAlu

  //cmdFLAG
  DrowData(80, 100, 80, 70, 'CMD START', sel);//BGC -> CmdFLAGS
  DrowData(80, 70, 375, 70, 'CMD', sel);//CmdFLAGS
  DrowData(310, 70, 310, 87, 'CMD END DOWN', sel);//CmdFLAGS -> FLAGS
  DrowData(375, 70, 375, 88, 'CMD END DOWN', sel);//CmdFLAGS -> MUX
  //cmdFLAG

  //cmdGenReg
  DrowData(130, 115, 340, 115, 'CMD START', sel);//BGC -> cmdGenReg
  DrowData(340, 115, 340, 137, 'CMD END DOWN', sel);//cmdGenReg -> GenReg
  //cmdGenReg

  //cmdSP
  DrowData(130, 220, 300, 220, 'CMD START', sel);//BGC -> cmdSP
  DrowData(300, 220, 300, 240, 'CMD END DOWN', sel);//cmdSP -> SP
  //cmdSP

  //cmdT
  DrowData(130, 270, 300, 270, 'CMD START', sel);//BGC -> cmdSP
  DrowData(300, 270, 300, 287, 'CMD END DOWN', sel);//cmdSP -> SP
  //cmdT

  //cmdPC
  DrowData(130, 320, 300, 320, 'CMD START', sel);//BGC -> cmdPC
  DrowData(300, 320, 300, 335, 'CMD END DOWN', sel);//cmdPC -> SP
  //cmdPC

  //cmdIVR
  DrowData(130, 365, 300, 365, 'CMD START', sel);//BGC -> cmdIVR
  DrowData(300, 365, 300, 385, 'CMD END DOWN', sel);//cmdIVR -> SP
  //cmdIVR

  //cmdADR
  DrowData(130, 415, 300, 415, 'CMD START', sel);//BGC -> cmdADR
  DrowData(300, 415, 300, 431, 'CMD END DOWN', sel);//cmdADR -> SP
  //cmdADR

  //cmdMDR
  DrowData(130, 460, 300, 460, 'CMD START', sel);//BGC -> cmdMDR
  DrowData(300, 460, 300, 480, 'CMD END DOWN', sel);//cmdMDR -> SP
  //cmdMDR

  //cmdMDRMux
  DrowData(80, 500, 80, 510, 'CMD START', sel);//BGC -> cmdMDRMux
  DrowData(80, 510, 375, 510, 'CMD', sel);//cmdMDRmux
  DrowData(375, 510, 375, 500, 'CMD END UP', sel);//cmdMDRmux -> MDRMux
  //cmdMDRMux

  //cmdMem
  DrowData(50, 500, 50, 570, 'CMD START', sel);//BGC -> cmdMem
  DrowData(50, 570, 125, 570, 'CMD END Right', sel);//cmdMem -> Mem
  //cmdMem
end;//procedure TGfrCpu.ResetCpu(own: TObject);

procedure TGrfCpu.PdSFLAGS;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(150, 15, 485, 'SBus(16 b)', sel);
  DrowData(150, 45, 300, 45, 'DATA START END RIGHT', sel);//SBus -> ALU

  DrowData(256, 103, 152, 103, 'DATA START END LEFT', sel);//FLAGS -> SBus

  pmFLAGS;
end;//procedure TGrfCpu.PdSFLAGS;

procedure TGrfCpu.PdDFLAGS;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(200, 15, 485, 'DBus(16 b)', sel);
  DrowData(200, 25, 300, 25, 'DATA START END RIGHT', sel);//DBus -> ALU

  DrowData(256, 93, 202, 93, 'DATA START END LEFT', sel);//FLAGS -> DBus

  pmFLAGS;
end;//procedure TGrfCpu.PdDFLAGS;

procedure TGrfCpu.pdSGenReg;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(150, 15, 485, 'SBus(16 b)', sel);

  DrowData(150, 45, 300, 45, 'DATA START END RIGHT', sel);//SBus -> ALU

  DrowData(256, 200, 152, 200, 'DATA START END LEFT', sel);//GenReg -> SBus

  pmGenReg;
end;//procedure TGrfCpu.pdSGenReg;

procedure TGrfCpu.pdDGenReg;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(200, 15, 485, 'DBus(16 b)', sel);

  DrowData(200, 25, 300, 25, 'DATA START END RIGHT', sel);//DBus -> ALU

  DrowData(256, 150, 202, 150, 'DATA START END LEFT', sel);//GenReg -> DBus

  pmGenReg;
end;//procedure TGrfCpu.pdDGenReg;

procedure TGrfCpu.pdSSP;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(150, 15, 485, 'SBus(16 b)', sel);

  DrowData(150, 45, 300, 45, 'DATA START END RIGHT', sel);//SBus -> ALU

  DrowData(256, 255, 152, 255, 'DATA START END LEFT', sel);//SP -> SBus

  pmSP;
end;//procedure TGrfCpu.pdSSP;

procedure TGrfCpu.pdDSP;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(200, 15, 485, 'DBus(16 b)', sel);

  DrowData(200, 25, 300, 25, 'DATA START END RIGHT', sel);//DBus -> ALU

  DrowData(256, 245, 202, 245, 'DATA START END LEFT', sel);//SP -> DBus

  pmSP;
end;//procedure TGrfCpu.pdDSP;

procedure TGrfCpu.pdST;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(150, 15, 485, 'SBus(16 b)', sel);

  DrowData(150, 45, 300, 45, 'DATA START END RIGHT', sel);//SBus -> ALU

  DrowData(256, 303, 152, 303, 'DATA START END LEFT', sel);//T -> SBus

  pmT;
end;//procedure TGrfCpu.pdSSP;

procedure TGrfCpu.pdDT;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(200, 15, 485, 'DBus(16 b)', sel);

  DrowData(200, 25, 300, 25, 'DATA START END RIGHT', sel);//DBus -> ALU

  DrowData(256, 293, 202, 293, 'DATA START END LEFT', sel);//T -> DBus

  pmT;
end;//procedure TGrfCpu.pdDSP;

procedure TGrfCpu.pdSPC;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(150, 15, 485, 'SBus(16 b)', sel);

  DrowData(150, 45, 300, 45, 'DATA START END RIGHT', sel);//SBus -> ALU

  DrowData(256, 351, 152, 351, 'DATA START END LEFT', sel);//PC -> SBus

  pmPC;
end;//procedure TGrfCpu.pdSSP;

procedure TGrfCpu.pdDPC;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(200, 15, 485, 'DBus(16 b)', sel);

  DrowData(200, 25, 300, 25, 'DATA START END RIGHT', sel);//DBus -> ALU

  DrowData(256, 341, 202, 341, 'DATA START END LEFT', sel);//T -> DBus

  pmPC;
end;//procedure TGrfCpu.pdDSP;

procedure TGrfCpu.pdSIVR;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(150, 15, 485, 'SBus(16 b)', sel);

  DrowData(150, 45, 300, 45, 'DATA START END RIGHT', sel);//SBus -> ALU

  DrowData(256, 399, 152, 399, 'DATA START END LEFT', sel);//IVR -> SBus

  pmIVR;
end;//procedure TGrfCpu.pdSIVR;

procedure TGrfCpu.pdDIVR;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(200, 15, 485, 'DBus(16 b)', sel);

  DrowData(200, 25, 300, 25, 'DATA START END RIGHT', sel);//DBus -> ALU

  DrowData(256, 389, 202, 389, 'DATA START END LEFT', sel);//IVR -> DBus

  pmIVR;
end;//procedure TGrfCpu.pdDIVR;

procedure TGrfCpu.pdSADR;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(150, 15, 485, 'SBus(16 b)', sel);

  DrowData(150, 45, 300, 45, 'DATA START END RIGHT', sel);//SBus -> ALU

  DrowData(256, 447, 152, 447, 'DATA START END LEFT', sel);//ADR -> SBus
  DrowData(219, 448, 219, 530, 'DATA START END DOWN', sel);//ADR -> Mem

  pmADR;
end;//procedure TGrfCpu.pdSSP;

procedure TGrfCpu.pdDADR;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(200, 15, 485, 'DBus(16 b)', sel);

  DrowData(200, 25, 300, 25, 'DATA START END RIGHT', sel);//DBus -> ALU

  DrowData(256, 437, 202, 437, 'DATA START END LEFT', sel);//ADR -> DBus

  pmADR;
end;//procedure TGrfCpu.pdDSP;

procedure TGrfCpu.pdSMDR;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(150, 15, 485, 'SBus(16 b)', sel);

  DrowData(150, 45, 300, 45, 'DATA START END RIGHT', sel);//SBus -> ALU

  DrowData(256, 495, 152, 495, 'DATA START END LEFT', sel);//MDR -> SBus

  pmMDR;
end;//procedure TGrfCpu.pdSSP;

procedure TGrfCpu.pdDMDR;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(200, 15, 485, 'DBus(16 b)', sel);

  DrowData(200, 25, 300, 25, 'DATA START END RIGHT', sel);//DBus -> ALU

  DrowData(256, 485, 202, 485, 'DATA START END LEFT', sel);//MDR -> DBus
  DrowData(229, 486, 229, 530, 'DATA START END DOWN', sel);//MDR -> Mem

  pmMDR;
end;//procedure TGrfCpu.pdDSP;

procedure TGrfCpu.pdSIR;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(150, 15, 485, 'SBus(16 b)', sel);

  DrowData(150, 45, 300, 45, 'DATA START END RIGHT', sel);//SBus -> ALU

  DrowData(126, 430, 148, 430, 'DATA START END RIGHT', sel);//IR -> SBus
end;//procedure TGrfCpu.pdSSP;

procedure TGrfCpu.pdDIR;
var
  sel: Boolean;
begin
  sel := True;

  DrowBuss(200, 15, 485, 'DBus(16 b)', sel);

  DrowData(200, 25, 300, 25, 'DATA START END RIGHT', sel);//DBus -> ALU

  DrowData(126, 440, 198, 440, 'DATA START END RIGHT', sel);//IR -> DBus
end;//procedure TGrfCpu.pdDSP;

procedure TGrfCpu.pdRALU;
var
  sel: Boolean;
  i: Integer;
  regEnd: Integer;
begin
  regEnd := Form1.LabeledEdit1.Left + Form1.LabeledEdit1.Width;
  sel := True;

  DrowBuss(430, 15, 485, 'RBus(16 b)', sel);//RBus
  DrowData(320, 35, 429, 35, 'DATA END Right', sel);//ALU -> RBus

  DrowData(430, 105, 380, 105, 'DATA START END LEFT', sel);//RBus -> MUX
  DrowData(430, 170, 414, 170, 'DATA START END LEFT', sel);//RBus -> GenReg

  //RBus -> Reg
  for i:=1 to 5 do
    DrowData(430, 250 + (i-1)*48, regEnd, 250+ (i-1)*48, 'DATA START END LEFT', sel);
  //RBus -> Reg

  DrowData(430, 485, 380, 485, 'DATA START END LEFT', sel);//RBus -> MUX

  //cmdAlu
  DrowData(50, 100, 50, 10, 'CMD START', sel);//BGC -> CmdALU
  DrowData(50, 10, 310, 10, 'CMD', sel);//mdALU
  DrowData(310, 10, 310, 20, 'CMD END DOWN', sel);//CmdALU -> ALU
  //cmdAlu
end;//procedure TGrfCpu.pdRALU;

procedure TGrfCpu.pdCONDALU;
var
  sel: Boolean;
begin
  sel := True;

  //COND
  DrowData(310, 50, 310, 60, 'DATA', sel);
  DrowData(310, 60, 400, 60, 'DATA', sel);
  DrowData(400, 60, 400, 95, 'DATA', sel);
  DrowData(400, 95, 380, 95, 'DATA END LEFT', sel);
  //COND

  pmALU;
end;//procedure TGrfCpu.pdCONDALU;

procedure TGrfCpu.pdMem;
var
  sel: Boolean;
begin
  sel := True;

  //MemBus
  DrowData(15, 435, 20, 435, 'DATA END RIGHT', sel);//MemBus -> IR
  DrowData(15, 435, 15, 620, 'DATA', sel);//MemBus
  DrowData(15, 620, 400, 620, 'DATA', sel);//MemBus
  DrowData(400, 620, 400, 495, 'DATA', sel);//MemBus
  DrowData(400, 495, 380, 495, 'DATA END LEFT', sel);//MemBus
  DrowData(190, 604, 190, 620, 'DATA START END Down', sel);//Mem -> MemBus
  //MemBus

  //cmdMem
  DrowData(50, 500, 50, 570, 'CMD START', sel);//BGC -> cmdMem
  DrowData(50, 570, 125, 570, 'CMD END Right', sel);//cmdMem -> Mem
  //cmdMem
end;//procedure TGrfCpu.pdMem;

procedure TGrfCpu.pmALU;
var
  sel: Boolean;
begin
  sel := True;

  //cmdAlu
  DrowData(50, 100, 50, 10, 'CMD START', sel);//BGC -> CmdALU
  DrowData(50, 10, 310, 10, 'CMD', sel);//cmdALU
  DrowData(310, 10, 310, 20, 'CMD END DOWN', sel);//CmdALU -> ALU
  //cmdAlu
end;//procedure TGrfCpu.pmALU;

procedure TGrfCpu.pmFLAGS;
var
  sel: Boolean;
begin
  sel := True;

  //cmdFLAG
  DrowData(80, 100, 80, 70, 'CMD START', sel);//BGC -> CmdFLAGS
  DrowData(80, 70, 375, 70, 'CMD', sel);//CmdFLAGS
  DrowData(310, 70, 310, 87, 'CMD END DOWN', sel);//CmdFLAGS -> FLAGS
  DrowData(375, 70, 375, 88, 'CMD END DOWN', sel);//CmdFLAGS -> MUX
  //cmdFLAG
end;//procedure TGrfCpu.pmFLAGS;

procedure TGrfCpu.pmGenReg;
var
  sel: Boolean;
begin
  sel := True;

  //cmdGenReg
  DrowData(130, 115, 340, 115, 'CMD START', sel);//BGC -> cmdGenReg
  DrowData(340, 115, 340, 137, 'CMD END DOWN', sel);//cmdGenReg -> GenReg
  //cmdGenReg
end;//procedure TGrfCpu.pmGenReg;

procedure TGrfCpu.pmSP;
var
  sel: Boolean;
begin
  sel := True;

  //cmdSP
  DrowData(130, 220, 300, 220, 'CMD START', sel);//BGC -> cmdSP
  DrowData(300, 220, 300, 240, 'CMD END DOWN', sel);//cmdSP -> SP
  //cmdSP
end;//procedure TGrfCpu.pmSP;

procedure TGrfCpu.pmT;
var
  sel: Boolean;
begin
  sel := True;

  //cmdT
  DrowData(130, 270, 300, 270, 'CMD START', sel);//BGC -> cmdSP
  DrowData(300, 270, 300, 287, 'CMD END DOWN', sel);//cmdSP -> SP
  //cmdT
end;//procedure TGrfCpu.pmT;

procedure TGrfCpu.pmPC;
var
  sel: Boolean;
begin
  sel := True;

  //cmdPC
  DrowData(130, 320, 300, 320, 'CMD START', sel);//BGC -> cmdPC
  DrowData(300, 320, 300, 335, 'CMD END DOWN', sel);//cmdPC -> SP
  //cmdPC
end;//procedure TGrfCpu.pmPC;

procedure TGrfCpu.pmIVR;
var
  sel: Boolean;
begin
  sel := True;

  //cmdIVR
  DrowData(130, 365, 300, 365, 'CMD START', sel);//BGC -> cmdIVR
  DrowData(300, 365, 300, 385, 'CMD END DOWN', sel);//cmdIVR -> SP
  //cmdIVR
end;//procedure TGrfCpu.pmIVR;

procedure TGrfCpu.pmADR;
var
  sel: Boolean;
begin
  sel := True;

  //cmdADR
  DrowData(130, 415, 300, 415, 'CMD START', sel);//BGC -> cmdADR
  DrowData(300, 415, 300, 431, 'CMD END DOWN', sel);//cmdADR -> SP
  //cmdADR
end;//procedure TGrfCpu.pmADR;

procedure TGrfCpu.pmMDR;
var
  sel: Boolean;
begin
  sel := True;

  //cmdMDR
  DrowData(130, 460, 300, 460, 'CMD START', sel);//BGC -> cmdMDR
  DrowData(300, 460, 300, 480, 'CMD END DOWN', sel);//cmdMDR -> SP
  //cmdMDR
end;//procedure TGrfCpu.pmMDR;

procedure TGrfCpu.pmMuxMDR;
var
  sel: Boolean;
begin
  sel := True;

  //cmdMDRMux
  DrowData(80, 500, 80, 510, 'CMD START', sel);//BGC -> cmdMDRMux
  DrowData(80, 510, 375, 510, 'CMD', sel);//cmdMDRmux
  DrowData(375, 510, 375, 500, 'CMD END UP', sel);//cmdMDRmux -> MDRMux
  //cmdMDRMux
end;//procedure TGrfCpu.pmMuxMDR;

procedure TGrfCpu.cmdMem;
var
  sel: Boolean;
begin
  sel := True;

  //cmdMem
  DrowData(50, 500, 50, 570, 'CMD START', sel);//BGC -> cmdMem
  DrowData(50, 570, 125, 570, 'CMD END Right', sel);//cmdMem -> Mem
  //cmdMem
end;//procedure TGrfCpu.cmdMem;

end.
