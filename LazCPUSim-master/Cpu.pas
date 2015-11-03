unit Cpu;

{$MODE Delphi}

interface
                                                
uses
  GrfCpu, ComCtrls, ExtCtrls, SysUtils, Classes, Dialogs, FileUtil, strutils;

const
  ERRFileNotFound = 0;
  ERRMInstrNotFound = 1;
  ERRMComadNotFound = 3;
  ERRMemOutLineAddr = 2;
  B1Class: array [1..7] of String = ('MOV', 'ADD', 'SUB', 'CMP', 'AND', 'OR', 'XOR');
  B2Class: array [1..15] of String = ('CLR', 'NEG', 'INC', 'DEC', 'ASL', 'ASR', 'LSR', 'ROL', 'ROR', 'RLC', 'RRC', 'JMP', 'CALL', 'PUSH', 'POP');
  B3Class: array [1..9] of String = ('BR', 'BNE', 'BEQ', 'BPL', 'BMI', 'BCS', 'BCC', 'BVS', 'BVC');

type
  TCode = record
    code: TStrings;
    codPoz: Integer;
  end;

  TMicroCode = record
    mInstr: String;
    mComenzi, adr: array of String;
    mComCnt: Integer;
  end;

  TInstr = record
    crInstr: String;
    madS, madD: Integer;
    valRS, valRD: String;
  end;

  ATMicroCode = record
    mCode: array of TMicroCode;
    MCDim: Integer;
  end;

  TCPU = class
  private
    memSZ: Integer;
    mCode: ATMicroCode;
    opCode: TCode;
    mPoz, mFaza, SBus, DBus, RBus, MEMBus, ALU, Flags: integer;
    cpuInUse, B1, B2, B3, B4, ACLOW, CIL, INTR: Boolean;
    tact: Byte;
    own, FLAGSReg, GenReg, SPReg, TReg, PCReg, IVRReg, ADRReg, MDRReg, MEM, IRReg: TObject;
    CrInstr: TInstr;
    CpuGrf: TGrfCpu;
    regFormat: Integer;
    function BinToInt(Value: string): Integer;
    function SGNBinToInt(Value: string): Integer;
    function GetRegValue(regNam: String): String;
    procedure SetRegValue(regNam: String; val: String);
    function MemRead(adr: Integer): Integer;
    procedure MemWrite(adr: Integer; val: Integer);
    function RegToInt(regVal: String): Integer;
    function IntToReg(intVal: Integer): String;
    function replStr(str: String; src: String; dst: string): String;
    function testClass(instr: String; cls: Array of String): Boolean;
    procedure GenErr(cod: Integer; errMes: String = '');
    procedure InstrFatch;
    procedure mStep;
    function JUMP(dest: String; startPo: Integer = 1): Integer;
    procedure excMLin(mLn: String);
    procedure excMInstr(mInstr: String);
    procedure excIFMInstr(mInstr: String);
    procedure decInstr(instr: String);
  public
    constructor Create(tmpOwn: TObject);
    procedure RegAssign(tmpFLAGSReg: TObject; tmpGenReg: TObject; tmpSPReg: TObject; tmpTReg: TObject; tmpPCReg: TObject; tmpIVRReg: TObject; tmpADRReg: TObject; tmpMDRReg: TObject; tmpMEM: TObject; tmpIRReg: TObject);
    function step: String;
    function GetCPUStatus: Boolean;
    procedure LoadCode(cod: TStrings);
    procedure setCpuIntr(tmpCIL: Boolean; tmpACL: Boolean; tmpINTR: Boolean);
    procedure getCpuIntr(var tmpCIL: Boolean;var tmpACL: Boolean;var tmpINTR: Boolean);
    procedure readMicroCod(fl: String);
    procedure cpuInit;
    procedure SetMemSz(sz: Integer);
  end;

implementation

function TCPU.BinToInt(Value: string): Integer;
var
  i, iValueSize: Integer;
begin
  Result := 0;
  iValueSize := Length(Value);
  for i := iValueSize downto 1 do
    if Value[i] = '1' then Result := Result + (1 shl (iValueSize - i));
end;//function TCPU.BinToInt(Value: string): Integer;

function TCPU.SGNBinToInt(Value: string): Integer;
var
  i, iValueSize: Integer;
begin
  Result := 0;
  iValueSize := Length(Value);
  if iValueSize = 16 then
  begin
    if Value[1] = '1' then
    begin
      for i := iValueSize downto 2 do
        if Value[i] = '0' then Result := Result + (1 shl (iValueSize - i));
    end
    else
    begin
      for i := iValueSize downto 1 do
        if Value[i] = '1' then Result := Result + (1 shl (iValueSize - i));
    end;
  end
  else
  begin
    for i := iValueSize downto 1 do
        if Value[i] = '1' then Result := Result + (1 shl (iValueSize - i));
  end;
end;//function TCPU.SGNBinToInt(Value: string): Integer;

function TCPU.GetRegValue(regNam: String): String;
var
  InsertItem: TListItem;
begin
  if regNam = 'FLAGS' then
  begin
    result := (FLAGSReg as TLabeledEdit).Text;
  end;

  if regNam = 'SP' then
  begin
    result := (SPReg as TLabeledEdit).Text;
  end;

  if regNam = 'PC' then
  begin
    result := (PCReg as TLabeledEdit).Text;
  end;

  if regNam[1] = 'R' then
  begin
    regNam := copy(regNam, 2, Length(regNam));

    with (GenReg as TListView)do
    begin
      Items.BeginUpdate;

      InsertItem := Items.Item[StrToInt(regNam)];
      result :=  InsertItem.Caption;

      Items.EndUpdate;
    end;
  end;
end;//function TCPU.GetRegValue(regNam: String): String;

procedure TCPU.SetRegValue(regNam: String; val: String);
var
  InsertItem: TListItem;
begin
  if regNam = 'FLAGS' then
  begin
    (FLAGSReg as TLabeledEdit).Text := val;
  end;

  if regNam = 'SP' then
  begin
    (SPReg as TLabeledEdit).Text := val;
  end;

  if regNam = 'PC' then
  begin
    (PCReg as TLabeledEdit).Text := val;
  end;

  if regNam[1] = 'R' then
  begin
    regNam := copy(regNam, 2, Length(regNam));

    with (GenReg as TListView)do
    begin
      Items.BeginUpdate;

      InsertItem := Items.Item[StrToInt(regNam)];
      InsertItem.Caption := val;

      Items.EndUpdate;
    end;
  end;
end;//procedure TCPU.SetRegValue(regNam: String; val: Integer);

function TCPU.MemRead(adr: Integer): Integer;
var
  InsertItem: TListItem;
begin
  result := 0;
  if round(adr/2) > (MEM as TListView).Items.Count - 1 then
  begin
    GenErr(ERRMemOutLineAddr);
  end
  else
  begin
    with (MEM as TListView)do
    begin
      Items.BeginUpdate;

      InsertItem := Items.Item[round(adr/2)];
      result := RegToInt(InsertItem.Caption);

      Items.EndUpdate;
    end;
  end;
end;//function TCPU.MemRead(adr: Inteeger): Integer;

procedure TCPU.MemWrite(adr: Integer; val: Integer);
var
  InsertItem: TListItem;
  tmpRegF: Integer;
begin
  if round(adr/2) > (MEM as TListView).Items.Count - 1 then
  begin
    GenErr(ERRMemOutLineAddr);
  end
  else
  with (MEM as TListView)do
  begin
    Items.BeginUpdate;

    InsertItem := Items.Item[round(adr/2)];
    InsertItem.Caption := IntToReg(val);

    tmpRegF := regFormat;
    regFormat := 16;

    InsertItem.SubItems[0] := IntToReg(val);

    regFormat := tmpRegF;

    Items.EndUpdate;
  end;
end;//procedure TCPU.MemWrite(adr: Integer; val: Integer);

function TCPU.RegToInt(regVal: String): Integer;
var
  buf: PChar;
begin
  result := 0;
  buf := '';
  case regFormat of
    2:
    begin
      result := BinToInt(regVal);
    end;
    10:
    begin
      result := StrToInt(regVal);
    end;
    16:
    begin
      HexToBin(pCHar(regVal), buf, 10);
      result := BinToInt(String(buf));
    end;
  end;
end;//function TCPU.RegToInt(regVal: String): Integer;

function TCPU.IntToReg(intVal: Integer): String;
begin
  result := IntToStr(intVal);
  case regFormat of
    2:
    begin
      result := copy(IntToBin(intVal, 32), 17, 16);
    end;
    10:
    begin
      result := IntToStr(intVal);
    end;
    16:
    begin
      result := IntToHex(intVal, 4);
    end;
  end;
end;//function TCPU.IntToReg(intVal: String): Integer;

function TCPU.replStr(str: String; src: String; dst: string): String;
var
  poz: Integer;
begin
  poz := pos(src, str);
  while poz>0 do
  begin
    result := copy(str, 1, poz-1);
    result := result + dst;
    result := result + copy(str, poz + Length(src), Length(str));
    str := result;
    poz := pos(src, str);
  end;
  result := str;
end;//function TCPU.replStr(str: String; src: String; dst: string): String;

function TCPU.testClass(instr: String; cls: Array of String): Boolean;
var
  i: Integer;
begin
  result := False;
  i:=0;
  while i<= High(cls) do
  begin
    if instr <> cls[i] then
      inc(i)
    else
    begin
      i := High(cls)+1;
      result := true;
    end;
  end;
end;//function TCPU.testClass(instr: String; cls: Array of String): Boolean;

procedure TCPU.GenErr(cod: Integer; errMes: String = '');
begin
  if cod = ERRfileNotFound then
  begin
    ShowMessage('Microcode file not found!' + #10 + #13 + 'Program will terminate!' + errMes);
    halt(1);
  end;

  if cod = ERRMInstrNotFound then
  begin
    cpuInit;
    ShowMessage('MicroInstructiunea nu a fost gasita' + errMes);
  end;

  if cod = ERRMemOutLineAddr then
  begin
    cpuInit;
    ShowMessage('Memory address out of range!' + errMes);
  end;

  if cod = ERRMComadNotFound then
  begin
    cpuInit;
    ShowMessage('Microcomanda Not Found!' + errMes);
  end;
end;//procedure TCPU.GenErr(cod: Integer);

procedure TCPU.InstrFatch;
begin
  (IRReg as TLabeledEdit).Text := IntToReg(memRead(RegToInt((PCReg as TLabeledEdit).Text)));
  opCode.codPoz :=round(RegToInt((PCReg as TLabeledEdit).Text)/2);

  CpuGrf.pdSADR;
  CpuGrf.pdMem;
end;//procedure TCPU.InstrFatch;

procedure TCPU.mStep;
begin
  inc(mFaza);

  if mFaza > mCode.mCode[mPoz].mComCnt then
  begin
    mFaza := 1;
    inc(mPoz);
  end;
end;//procedure TCPU.Step;

procedure TCPU.readMicroCod(fl: String);
var
  f: TextFile;
  ln: String;
begin
  if FileExistsUTF8(fl) { *Converted from FileExists* } then
  begin
    assignFile(f, fl);
    reset(f);
  end
  else
  begin
    GenErr(ERRfileNotFound);
  end;

  while not eof(f) do
  begin
    repeat
      readln(f, ln);

      ln := replStr(ln, #9, ' ');

      if pos('#', ln) > 0 then
        delete(ln, pos('#', ln), length(ln));

      if length(ln)>0 then
      begin
        while (ln[1] = ' ') do
        begin
          Delete(ln, 1, 1);
        end;
      end;
    until ln<>'';

    if pos(':', ln)>0 then
    begin
      inc(mCode.MCDim);
      SetLength(mCode.mCode, mCode.MCDim+1);
      mCode.mCode[mCode.MCDim].mInstr := UpperCase(copy(ln, 1, pos(':', ln)-1));
    end
    else
    begin
      inc(mCode.mCode[mCode.MCDim].mComCnt);
      SetLength(mCode.mCode[mCode.MCDim].adr, mCode.mCode[mCode.MCDim].mComCnt+1);
      SetLength(mCode.mCode[mCode.MCDim].mComenzi, mCode.mCode[mCode.MCDim].mComCnt+1);

      mCode.mCode[mCode.MCDim].adr[mCode.mCode[mCode.MCDim].mComCnt] := UpperCase(copy(ln, 1, pos(' ', ln)-1));
      delete(ln, 1, pos(' ', ln));
      while ln[1] = ' ' do
        delete(ln, 1, 1);

      mCode.mCode[mCode.MCDim].mComenzi[mCode.mCode[mCode.MCDim].mComCnt] := UpperCase(copy(ln, 1, Length(ln)));
    end;
  end;

  closeFile(f);
end;//procedure TCPU.readMicroCod(fl: String);

function TCPU.JUMP(dest: String; startPo: Integer = 1): Integer;
var
  i: Integer;
begin
  i:=startPo;
  result := -1;
  dest := UpperCase(dest);
  while i<= mCode.MCDim do
  begin
    if mCode.mCode[i].mInstr = dest then
    begin
      result := i;
      mFaza := 1;
      i:= mCode.MCDim + 1;
    end
    else
      inc(i);
  end;

  if result = -1 then
    GenErr(ERRMInstrNotFound, #10+#13+dest);
end;//function TCPU.JUMP(dest: String): Integer;

procedure TCPU.excMLin(mLn: String);
begin
  CpuGrf.ResetCpu;

  mLn := UPPerCase(mLn);

  if mLn = '(INTRACK, -2SP)' then
  begin
    mLn := 'INTRACK, -2SP'
  end;

  if (pos('(', mLn)=0)and(pos(')', mLn)=0)and(pos(',', mLn)>0) then
  begin
    mLn := replStr(mLn, ' ', '');
    while pos(',', mLn)>0 do
    begin
      excMInstr(copy(mLn, 1, pos(',', mLn)-1));
      delete(mLn, 1, pos(',', mLn));
    end;
    if mLn<>'' then
      excMInstr(mLn);

    mStep;
  end
  else
  begin
    if (pos('-2SP', mLn)>0)or(pos('READ', mLn)>0)or(pos('WRITE', mLn)>0)or(pos('A(1)BE0', mLn)>0) then
    begin
      excMInstr(mLn);
      mStep;
    end
    else
      if (pos('IF ', mLn)>0) then
      begin
        excIFMInstr(mLn);
      end
      else
      begin
        excMInstr(mLn);
      end
  end;
end;//procedure TCPU.excMLin(mLn: String);

procedure TCPU.excIFMInstr(mInstr: String);
var
  tmpStr: String;

  function ifCond(cond: String): Boolean;
  begin
    result := false;
    if cond = 'ACLOW' then
    begin
      result := ACLow;
    end;

    if cond = 'CIL' then
    begin
      result := CIL;
    end;

    if cond = 'B1' then
    begin
      if (IRReg as TLabeledEdit).text[1] = '1' then
        result := true
      else
        result := false;
    end;

    if cond = 'B2' then
    begin
      if (IRReg as TLabeledEdit).text[1]+(IRReg as TLabeledEdit).text[2]+(IRReg as TLabeledEdit).text[3]='000' then
        result := true
      else
        result := false;
    end;

    if cond = 'NINTR' then
    begin
      result := not INTR;
    end;

    if cond = 'NC' then
    begin
      if (FLAGSReg as TLabeledEdit).Text[16] = '0' then
        result := true
      else
        result := false;
    end;

    if cond = 'C' then
    begin
      if (FLAGSReg as TLabeledEdit).Text[16] = '1' then
        result := true
      else
        result := false;
    end;

    if cond = 'NV' then
    begin
      if (FLAGSReg as TLabeledEdit).Text[15] = '0' then
        result := true
      else
        result := false;
    end;

    if cond = 'V' then
    begin
      if (FLAGSReg as TLabeledEdit).Text[15] = '1' then
        result := true
      else
        result := false;
    end;

    if cond = 'NZ' then
    begin
      if (FLAGSReg as TLabeledEdit).Text[14] = '0' then
        result := true
      else
        result := false;
    end;

    if cond = 'Z' then
    begin
      if (FLAGSReg as TLabeledEdit).Text[14] = '1' then
        result := true
      else
        result := false;
    end;

    if cond = 'NS' then
    begin
      if (FLAGSReg as TLabeledEdit).Text[13] = '0' then
        result := true
      else
        result := false;
    end;

    if cond = 'S' then
    begin
      if (FLAGSReg as TLabeledEdit).Text[13] = '1' then
        result := true
      else
        result := false;
    end;

    if cond = 'MAD_AD' then
    begin
      if (IRReg as TLabeledEdit).text[11]+(IRReg as TLabeledEdit).text[12] = '01' then
        result := true
      else
        result := false;
    end;

    if cond = 'MAD_AM' then
    begin
      if (IRReg as TLabeledEdit).text[11]+(IRReg as TLabeledEdit).text[12] = '00' then
        result := true
      else
        result := false;
    end;

    if cond = 'NMAD_AD' then
    begin
      if (IRReg as TLabeledEdit).text[11]+(IRReg as TLabeledEdit).text[12] = '01' then
        result := false
      else
        result := true;
    end;

    if cond = 'NMAD_AI' then
    begin
      if (IRReg as TLabeledEdit).text[11]+(IRReg as TLabeledEdit).text[12] = '10' then
        result := false
      else
        result := true;
    end;

    if cond = 'NMAD_AX' then
    begin
      if (IRReg as TLabeledEdit).text[11]+(IRReg as TLabeledEdit).text[12] = '11' then
        result := false
      else
        result := true;
    end;
  end;

begin
  if pos('IF ', mInstr)>0 then
  begin
    delete(mInstr, 1, 3);
    while mInstr[1] = ' ' do
      delete(mInstr, 1, 1);

    if ifCond(copy(mInstr, 1, pos(' ', mInstr)-1)) then
    begin
      delete(mInstr, 1, pos(' ', mInstr));
      while mInstr[1] = ' ' do
        delete(mInstr, 1, 1);

      tmpStr := copy(mInstr, 1, pos(' ELSE ', mInstr)-1);
      excMInstr(tmpStr);
    end
    else
    begin
      delete(mInstr, 1, pos('ELSE ', mInstr)+ 4);
      while mInstr[1] = ' ' do
        delete(mInstr, 1, 1);

      excMInstr(mInstr);
    end;
  end;
end;//procedure TCPU.excIFMInstr(mInstr: String);

procedure TCPU.excMInstr(mInstr: String);
var
  exec: Boolean;
begin
  exec := false;
  if pos('JUMP ', mInstr)>0 then
  begin
    Delete(mInstr, 1, 5);

    if length(mInstr)> 0 then
    begin
      while mInstr[1] = ' ' do
        delete(mInstr, 1, 1);

      mPoz := JUMP(mInstr);
      mFaza := 1;
    end;

    exec := true;
  end;

  if pos('JUMPI ', mInstr)>0 then
  begin
    Delete(mInstr, 1, 6);

    mInstr := replStr(mInstr, ' ', '');

    while mInstr[1] = ' ' do
      delete(mInstr, 1, 1);

    mPoz := JUMP(replStr(copy(mInstr,1, pos('+', mInstr)-1), ' ', ''));
    if (pos('(IR11,IR10,0,0)', mInstr)>0) then
    begin
      mPoz := mPoz + BinToInt((IRReg as TLabeledEdit).Text[5]+(IRReg as TLabeledEdit).Text[6]);
    end;

    if (pos('(IR5,IR4,0,0)', mInstr)>0) then
    begin
      mPoz := mPoz + BinToInt((IRReg as TLabeledEdit).Text[11]+(IRReg as TLabeledEdit).Text[12]);
    end;

    if (pos('(IR12,IR11,IR10,IR9)', mInstr)>0) then
    begin
      mPoz := mPoz + BinToInt((IRReg as TLabeledEdit).Text[4]+(IRReg as TLabeledEdit).Text[5]+(IRReg as TLabeledEdit).Text[6]+(IRReg as TLabeledEdit).Text[7]);
    end;

    if (pos('(IR14,IR13,IR12,0)', mInstr)>0) then
    begin
      mPoz := mPoz + BinToInt((IRReg as TLabeledEdit).Text[2]+(IRReg as TLabeledEdit).Text[3]+(IRReg as TLabeledEdit).Text[4]);
    end;

    if (pos('(IR12,IR11,IR10,IR9,IR8,0,0)', mInstr)>0) then
    begin
      mPoz := mPoz + BinToInt((IRReg as TLabeledEdit).Text[4]+(IRReg as TLabeledEdit).Text[5]+(IRReg as TLabeledEdit).Text[6]+(IRReg as TLabeledEdit).Text[7]+(IRReg as TLabeledEdit).Text[8]);
    end;

    mFaza := 1;
    exec := true;
  end;

  if mInstr = UpperCase('STEP') then
  begin
    mStep;
    exec := true;
  end;

  //DBUS

  if mInstr = UpperCase('PdFLAGD') then
  begin
    CpuGrf.PdDFLAGS;
    DBus := RegToInt((FLAGSReg as TLabeledEdit).Text);
    exec := true;
  end;

  if mInstr = UpperCase('PdRGD') then
  begin
    CpuGrf.pdDGenReg;
    DBus := RegToInt(GetRegValue('R'+IntToStr(BinToInt((IRReg as TLabeledEdit).Text[13]+(IRReg as TLabeledEdit).Text[14]+(IRReg as TLabeledEdit).Text[15]+(IRReg as TLabeledEdit).Text[16]))));
    exec := true;
  end;

  if mInstr = UpperCase('PdSPD') then
  begin
    CpuGrf.pdDSP;
    DBus := RegToInt((SPReg as TLabeledEdit).Text);
    exec := true;
  end;

  if mInstr = UpperCase('PdTD') then
  begin
    CpuGrf.pdDT;
    DBus := RegToInt((TReg as TLabeledEdit).Text);
    exec := true;
  end;

  if mInstr = UpperCase('PdPCD') then
  begin
    CpuGrf.pdDPC;
    DBus := RegToInt((PCReg as TLabeledEdit).Text);
    exec := true;
  end;

  if mInstr = UpperCase('PdIVRD') then
  begin
    CpuGrf.pdDIVR;
    DBus := RegToInt((IVRReg as TLabeledEdit).Text);
    exec := true;
  end;

  if mInstr = UpperCase('PdADRD') then
  begin
    CpuGrf.pdDADR;
    DBus := RegToInt((ADRReg as TLabeledEdit).Text);
    exec := true;
  end;

  if mInstr = UpperCase('PdMDRD') then
  begin
    CpuGrf.pdDMDR;
    DBus := RegToInt((MDRReg as TLabeledEdit).Text);
    exec := true;
  end;

  if mInstr = UpperCase('PdIROfD') then
  begin
    CpuGrf.pdDIR;
    DBus := BinToInt(copy((IRReg as TLabeledEdit).Text, 8, 9));
    exec := true;
  end;

  if mInstr = UpperCase('Pd0d') then
  begin
    DBus := 0;
    exec := true;
  end;

  if mInstr = UpperCase('Pd1d') then
  begin
    DBus := 1;
    exec := true;
  end;

  //SBUS

  if mInstr = UpperCase('PdFLAGS') then
  begin
    CpuGrf.PdSFLAGS;
    SBus := RegToInt((FLAGSReg as TLabeledEdit).Text);
    exec := true;
  end;

  if mInstr = UpperCase('PdRGS') then
  begin
    CpuGrf.pdSGenReg;
    SBus := RegToInt(GetRegValue('R'+IntToStr(BinToInt((IRReg as TLabeledEdit).Text[7]+(IRReg as TLabeledEdit).Text[8]+(IRReg as TLabeledEdit).Text[9]+(IRReg as TLabeledEdit).Text[10]))));
    exec := true;
  end;

  if mInstr = UpperCase('PdSPS') then
  begin
    CpuGrf.pdSSP;
    SBus := RegToInt((SPReg as TLabeledEdit).Text);
    exec := true;
  end;

  if mInstr = UpperCase('PdTS') then
  begin
    CpuGrf.pdST;
    SBus := RegToInt((TReg as TLabeledEdit).Text);
    exec := true;
  end;

  if mInstr = UpperCase('PdNTS') then
  begin
    CpuGrf.pdST;
    SBus := (-1)*(RegToInt((TReg as TLabeledEdit).Text));
    exec := true;
  end;

  if mInstr = UpperCase('PdPCS') then
  begin
    CpuGrf.pdSPC;
    SBus := RegToInt((PCReg as TLabeledEdit).Text);
    exec := true;
  end;

  if mInstr = UpperCase('PdIVRs') then
  begin
    CpuGrf.pdSIVR;
    SBus := RegToInt((IVRReg as TLabeledEdit).Text);
    exec := true;
  end;

  if mInstr = UpperCase('PdADRS') then
  begin
    CpuGrf.pdSADR;
    SBus := RegToInt((ADRReg as TLabeledEdit).Text);
    exec := true;
  end;

  if mInstr = UpperCase('PdMDRS') then
  begin
    CpuGrf.pdSMDR;
    SBus := RegToInt((MDRReg as TLabeledEdit).Text);
    exec := true;
  end;

  if mInstr = UpperCase('PdIRS[RS]') then
  begin
    CpuGrf.pdSIR;
    SBus := StrToInt(CrInstr.valRS);
    exec := true;
  end;

  if mInstr = UpperCase('Pd0s') then
  begin
    SBus := 0;
    exec := true;
  end;

  if mInstr = UpperCase('Pd1s') then
  begin
    SBus := 1;
    exec := true;
  end;

  if mInstr = UpperCase('-1s') then
  begin
    SBus := -1;
    exec := true;
  end;

  //RBUS

  if mInstr = UpperCase('PmFLAG') then
  begin
    CpuGrf.pmFLAGS;
    (FLAGSReg as TLabeledEdit).Text := IntToReg(RBus);
    exec := true;
  end;

  if mInstr = UpperCase('PmRG') then
  begin
    CpuGrf.pmGenReg;
    SetRegValue('R'+IntToStr(BinToInt((IRReg as TLabeledEdit).Text[13]+(IRReg as TLabeledEdit).Text[14]+(IRReg as TLabeledEdit).Text[15]+(IRReg as TLabeledEdit).Text[16])), IntToReg(RBus));
    exec := true;
  end;

  if mInstr = UpperCase('PmSP') then
  begin
    CpuGrf.pmSP;
    (SPReg as TLabeledEdit).Text := IntToReg(RBus);
    exec := true;
  end;

  if mInstr = UpperCase('PmT') then
  begin
    CpuGrf.pmT;
    (TReg as TLabeledEdit).Text := IntToReg(RBus);
    exec := true;
  end;

  if mInstr = UpperCase('PmPC') then
  begin
    CpuGrf.pmPC;
    (PCReg as TLabeledEdit).Text := IntToReg(RBus);
    exec := true;
  end;

  if mInstr = UpperCase('PmIVR') then
  begin
    CpuGrf.pmIVR;
    (IVRReg as TLabeledEdit).Text := IntToReg(RBus);
    exec := true;
  end;

  if mInstr = UpperCase('PmADR') then
  begin
    CpuGrf.pmADR;
    (ADRReg as TLabeledEdit).Text := IntToReg(RBus);
    exec := true;
  end;

  if mInstr = UpperCase('PmMDR') then
  begin
    CpuGrf.pmMDR;
    CpuGrf.pmMuxMDR;
    (MDRReg as TLabeledEdit).Text := IntToReg(RBus);
    exec := true;
  end;

  //ALU

  if mInstr = UpperCase('PmC') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdCONDALU;
    CpuGrf.pmFLAGS;
    if not((FLAGSReg as TLabeledEdit).Text[16] = IntToStr(SBus)) then
      (FLAGSReg as TLabeledEdit).Text := copy((FLAGSReg as TLabeledEdit).Text, 1, 15)+IntToStr(SBus);
    exec := true;
  end;

  if mInstr = UpperCase('PmV') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdCONDALU;
    CpuGrf.pmFLAGS;
    if not((FLAGSReg as TLabeledEdit).Text[15] = IntToStr(SBus)) then
      (FLAGSReg as TLabeledEdit).Text := copy((FLAGSReg as TLabeledEdit).Text, 1, 14)+IntToStr(SBus)+(FLAGSReg as TLabeledEdit).Text[16];
    exec := true;
  end;

  if mInstr = UpperCase('PmZ') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdCONDALU;
    CpuGrf.pmFLAGS;
    if not((FLAGSReg as TLabeledEdit).Text[14] = IntToStr(SBus)) then
      (FLAGSReg as TLabeledEdit).Text := copy((FLAGSReg as TLabeledEdit).Text, 1, 13)+IntToStr(SBus)+(FLAGSReg as TLabeledEdit).Text[15]+(FLAGSReg as TLabeledEdit).Text[16];
    exec := true;
  end;

  if mInstr = UpperCase('PmS') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdCONDALU;
    CpuGrf.pmFLAGS;
    if not((FLAGSReg as TLabeledEdit).Text[13] = IntToStr(SBus)) then
      (FLAGSReg as TLabeledEdit).Text := copy((FLAGSReg as TLabeledEdit).Text, 1, 12)+IntToStr(SBus)+(FLAGSReg as TLabeledEdit).Text[14]+(FLAGSReg as TLabeledEdit).Text[15]+(FLAGSReg as TLabeledEdit).Text[16];
    exec := true;
  end;

  if mInstr = UpperCase('ClrCOND') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdCONDALU;
    CpuGrf.pmFLAGS;

    Flags := 0;
    exec := true;
  end;

  if mInstr = UpperCase('SetCOND') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdCONDALU;
    CpuGrf.pmFLAGS;

    Flags := 15;
    exec := true;
  end;

  if mInstr = UpperCase('SBUS') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdRALU;
    ALU := SBus;
    RBus := ALU;
    exec := true;
  end;

  if mInstr = UpperCase('NSBUS') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdRALU;
    ALU := not SBus;
    RBus := ALU;
    exec := true;
  end;

  if mInstr = UpperCase('DBUS') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdRALU;
    ALU := DBus;
    RBus := ALU;
    exec := true;
  end;

  if mInstr = UpperCase('SUM') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdRALU;
    ALU := SBus + DBus;
    Flags := 0;

    if ALU>65536 then
    begin
      ALU := abs(alu);
      Flags := Flags + 1;
    end;

    if ALU>65536 then
    begin
      ALU := abs(alu);
      Flags := Flags + 2;
    end;

    if ALU = 0 then
    begin
      Flags := Flags +4;
    end;

    if ALU<0 then
    begin
      ALU := abs(alu);
      Flags := Flags +8;
    end;

    RBus := ALU;
    exec := true;
  end;

  if mInstr = UpperCase('PDCOND') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdCONDALU;
    CpuGrf.pmFLAGS;
    (FLAGSReg as TLabeledEdit).Text := IntToReg(Flags);
    exec := true;
  end;

  if mInstr = UpperCase('AND') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdRALU;

    ALU := SBus AND DBus;
    RBus := ALU;
    exec := true;
  end;

  if mInstr = UpperCase('OR') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdRALU;

    ALU := SBus OR DBus;
    RBus := ALU;
    exec := true;
  end;

  if mInstr = UpperCase('XOR') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdRALU;

    ALU := SBus XOR DBus;
    RBus := ALU;
    exec := true;
  end;

  if mInstr = UpperCase('ASL') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdRALU;

    ALU := SBus shl 1;
    RBus := ALU;
    exec := true;
  end;

  if mInstr = UpperCase('ASR') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdRALU;

    ALU := SBus shr 1;
    RBus := ALU;
    exec := true;
  end;

  if mInstr = UpperCase('LSR') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdRALU;

    (FLAGSReg as TLabeledEdit).Text := copy((FLAGSReg as TLabeledEdit).Text, 1, 15)+IntToReg(ALU)[16];

    ALU := SBus shr 1;
    RBus := ALU;
    exec := true;
  end;

  if mInstr = UpperCase('ROL') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdRALU;

    ALU := rolword(SBus, 1);
    RBus := ALU;
    exec := true;
  end;

  if mInstr = UpperCase('ROR') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdRALU;

    ALU := rorword(SBus, 1);
    RBus := ALU;
    exec := true;
  end;

  if mInstr = UpperCase('RLC') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdRALU;

    ALU := SBus shl 1;

    ALU := RegToInt( copy(IntToReg(ALU), 1, 15) + (FLAGSReg as TLabeledEdit).Text[16]);

    (FLAGSReg as TLabeledEdit).Text := copy((FLAGSReg as TLabeledEdit).Text, 1, 15)+IntToReg(SBus)[1];

    RBus := ALU;

    exec := true;
  end;

  if mInstr = UpperCase('RRC') then
  begin
    CpuGrf.pmALU;
    CpuGrf.pdRALU;

    ALU := SBus shr 1;

    ALU := RegToInt((FLAGSReg as TLabeledEdit).Text[16] + copy(IntToReg(ALU), 2, 16));

    (FLAGSReg as TLabeledEdit).Text := copy((FLAGSReg as TLabeledEdit).Text, 1, 15)+IntToReg(SBus)[16];

    RBus := ALU;

    exec := true;
  end;

  //others

  if mInstr = UpperCase('INTRACK') then
  begin
    setCpuIntr(false, false, false);

    exec := true;
  end;

  if mInstr = UpperCase('A1BE0') then
  begin
    exec := true;
    mStep;
  end;

  if mInstr = UpperCase('A1BE1') then
  begin
    exec := true;
    mStep;
  end;

  if mInstr = UpperCase('A0BP0') then
  begin
    CpuInUse := False;
    exec := true;
  end;

  if mInstr = UpperCase('A1BVT') then
  begin
    exec := true;
  end;

  if mInstr = UpperCase('A1BVI') then
  begin
    exec := true;
    mStep;
  end;

  if mInstr = UpperCase('A0BI') then
  begin
    exec := true;
  end;

  if mInstr = UpperCase('A0BE') then
  begin
    exec := true;
  end;

  if mInstr = UpperCase('IFCH') then
  begin
    InstrFatch;
    exec := true;
  end;

  if mInstr = UpperCase('READ') then
  begin
    CpuGrf.pdMem;
    CpuGrf.cmdMem;
    CpuGrf.pmMDR;
    CpuGrf.pmMuxMDR;

    (MDRReg as TLabeledEdit).Text := IntToReg(MemRead(RegToInt((ADRReg as TLabeledEdit).Text)));

    exec := true;
  end;

  if mInstr = UpperCase('WRITE') then
  begin
    CpuGrf.pdMem;
    CpuGrf.cmdMem;
    CpuGrf.pmMDR;
    CpuGrf.pmMuxMDR;

    MemWrite(RegToInt((ADRReg as TLabeledEdit).Text), RegToInt((MDRReg as TLabeledEdit).Text));

    exec := true;
  end;

  if mInstr = UpperCase('+2PC') then
  begin
    CpuGrf.pmPC;
    (PCReg as TLabeledEdit).Text := IntToReg(RegToInt((PCReg as TLabeledEdit).Text)+2);
    exec := true;
  end;

  if mInstr = UpperCase('-2SP') then
  begin
    CpuGrf.pmSP;
    (SPReg as TLabeledEdit).Text := IntToReg(RegToInt((SPReg as TLabeledEdit).Text)-2);
    exec := true;
  end;

  if mInstr = UpperCase('+2SP') then
  begin
    CpuGrf.pmPC;
    (SPReg as TLabeledEdit).Text := IntToReg(RegToInt((SPReg as TLabeledEdit).Text)+2);
    exec := true;
  end;

  if mInstr = UpperCase('NONE') then
  begin
    exec := true;
  end;

  if not exec then
  begin
    genErr(ERRMComadNotFound, #10+#13+mInstr);
  end;
end;//procedure TCPU.excMInstr(mInstr: String);

constructor TCPU.Create(tmpOwn: TObject);
begin
  CpuGrf := TGrfCpu.Create(tmpOwn);
  Own := tmpOwn;
  cpuInUse := false;
  tact := 1;
  CpuGrf := TGrfCpu.Create(own);
  CpuGrf.ResetCpu;
  regFormat := 2;
  memSZ := 2048;
  opCode.code := TStringList.Create;
end;//constructor TCPU.Create(tmpOwn: TObject);

procedure TCPU.RegAssign(tmpFLAGSReg: TObject; tmpGenReg: TObject; tmpSPReg: TObject; tmpTReg: TObject; tmpPCReg: TObject; tmpIVRReg: TObject; tmpADRReg: TObject; tmpMDRReg: TObject; tmpMEM: TObject; tmpIRReg: TObject);
begin
  FLAGSReg := tmpFLAGSReg;
  GenReg := tmpGenReg;
  SPReg := tmpSPReg;
  TReg := tmpTReg;
  PCReg := tmpPCReg;
  IVRReg := tmpIVRReg;
  ADRReg := tmpADRReg;
  MDRReg := tmpMDRReg;
  MEM := tmpMEM;
  IRReg := tmpIRReg;
end;//procedure TCPU.RegAssign(FLAGSReg: TObject; GenReg: TObject; SPReg: TObject; TReg: TObject; PCReg: TObject; IVRReg: TObject; ADRReg: TObject; MDRReg: TObject; MEM: TObject; IRReg: TObject);

function TCPU.step: String;
begin
  if opCode.codPoz < opCode.code.Count then
  begin
    result := opCode.code.Strings[opCode.codPoz] + ':' + mCode.mCode[mPoz].mInstr + ':' + mCode.mCode[mPoz].mComenzi[mFaza];
    excMLin(mCode.mCode[mPoz].mComenzi[mFaza]);
  end
  else
  begin
    cpuInUse:= false;
  end;
end;//function TCPU.step: Boolean;

function TCPU.GetCPUStatus: Boolean;
begin
  result := cpuInUse;
end;//function TCPU.GetCPUStatus: Boolean;

procedure TCPU.decInstr(instr: String);
var
  tmpInstr: String;

  function getMad(reg: String): Integer;
  begin
    if reg[1] = '(' then
    begin
      result := 2;
    end
    else
      if (reg[1] >='0') and (reg[1] <= '9') then
      begin
        if pos('(', reg)=0 then
        begin
          result := 0;
        end
        else
        begin
          result := 3;
        end;
      end
      else
      begin
        result := 1;
      end;
  end;
begin
  B1:= false;
  B2:= false;
  B3:= false;
  B4:= false;
  CrInstr.crInstr := instr;

  instr := Uppercase(instr);

  while instr[1] = ' ' do
    delete(instr, 1, 1);

  tmpInstr := copy(instr, 1, pos(' ', instr)-1);

  if testClass(UpperCase(tmpInstr), B1Class) then
  begin
    B1:= true;
    B2:= false;
    B3:= false;
    B4:= false;
    delete(instr, 1, pos(' ', instr));

    instr := replStr(instr, ' ', '');

    CrInstr.valRD := copy(instr, 1, pos(',', instr)-1);
    CrInstr.madD := getMad(CrInstr.valRD);
    CrInstr.valRS := copy(instr, pos(',', instr) + 1, Length(instr));
    CrInstr.madS := getMad(CrInstr.valRS);
  end
  else
    if (testClass(UpperCase(tmpInstr), B2Class))and(instr<>'PUSH PC')and(instr<>'POP PC')and(instr<>'PUSH FLAG')and(instr<>'POP FLAG') then
    begin
      B1:= false;
      B2:= true;
      B3:= false;
      B4:= false;

      delete(instr, 1, pos(' ', instr));

      instr := replStr(instr, ' ', '');

      CrInstr.valRD := instr;
      CrInstr.madD := getMad(CrInstr.valRD);
    end
    else
    begin
      if testClass(UpperCase(tmpInstr), B3Class) then
      begin
        B1:= false;
        B2:= false;
        B3:= true;
        B4:= false;
        delete(instr, 1, pos(' ', instr));

        instr := replStr(instr, ' ', '');

        CrInstr.valRD := instr;
        CrInstr.madD := getMad(CrInstr.valRD);
      end
      else
      begin
      B1:= false;
      B2:= false;
      B3:= false;
      B4:= true;
      end;
    end;
//  faza := FI;
end;//procedure TCPU.decInstr(instr: String);

procedure TCPU.LoadCode(cod: TStrings);
var
  i, tmpInt, memAdr, memInc: Integer;
  rVal: String;

  function GetAdrMode(mad: Integer; val: String; adr: Integer): String;
  begin
    result := '';
    case mad of
      0:
      begin
        result := result + '00';
        result := result + '0000';
        memWrite(adr, StrToInt(val));
        memInc := memInc + 2;
      end;
      1:
      begin
        result := result + '01';
        result := result + copy(IntToBin(StrToInt(copy(val, 2, length(val))), 32),29, 4);
      end;
      2:
      begin
        result := result + '10';
        delete(val, 1, pos('(', val)+1);
        result := result + copy(IntToBin(StrToInt(copy(val,1 ,pos(')', val)-1)), 32),29, 4);
      end;
      3:
      begin
        result := result + '11';
        memWrite(adr, StrToInt(copy(val, 1, pos('(',val)-1)));
        memInc := memInc + 2;
        
        delete(val, 1, pos('(', val)+1);
        result := result + copy(IntToBin(StrToInt(copy(val,1 ,pos(')', val)-1)), 32),29, 4);
      end;
    end;
  end;

begin
  cpuInUse:= True;

  with (PCReg as TLabeledEdit)do
    Text := '0000000000000000';

  mPoz := JUMP('IF');
  mFaza :=1;

  SBus := 0;
  DBus := 0;
  RBus := 0;
  MEMBus := 0;

  CIL := false;
  ACLOW := false;
  INTR := false;

  CpuGrf.ResetCpu;

  memAdr := 0;
  opCode.codPoz := 0;
  opCode.code.Clear;

  for i:=0 to cod.Count-1 do
  begin
    rVal := '';
    memInc := 2;
    decInstr(cod.Strings[i]);
    if B1 then
    begin
      rVal := rVal + '1';
      tmpInt := jump('MOV');
      rVal := rVal + copy(IntToBin(jump(copy(CrInstr.crInstr, 1, pos(' ',CrInstr.crInstr)-1), tmpInt) - tmpInt, 32), 30, 3);

      rVal := rVal + GetAdrMode(CrInstr.madS, CrInstr.valRS, memAdr + memInc);
      rVal := rVal + GetAdrMode(CrInstr.madD, CrInstr.valRD, memAdr + memInc);

      memWrite(memAdr, RegToInt(rVal));
      memAdr := memAdr + memInc;

      opCode.code.Add(cod.Strings[i]);
      if memInc = 4 then
      begin
        opCode.code.Add('');
      end;
      if memInc = 6 then
      begin
        opCode.code.Add('');
      end;
    end;

    if B2 then
    begin
      rVal := rVal + '000';
      tmpInt := jump('CLR');
      rVal := rVal + copy(IntToBin(jump(copy(CrInstr.crInstr, 1, pos(' ',CrInstr.crInstr)-1), tmpInt) - tmpInt, 32), 29, 4);
      rVal := rVal + '000';

      rVal := rVal + GetAdrMode(CrInstr.madD, CrInstr.valRD, memAdr + memInc);

      memWrite(memAdr, RegToInt(rVal));
      memAdr := memAdr + memInc;

      opCode.code.Add(cod.Strings[i]);
      if memInc = 4 then
      begin
        opCode.code.Add('');
      end;
      if memInc = 6 then
      begin
        opCode.code.Add('');
      end;
    end;

    if B3 then
    begin
      rVal := rVal + '001';
      tmpInt := jump('BR');
      rVal := rVal + copy(IntToBin(jump(copy(CrInstr.crInstr, 1, pos(' ',CrInstr.crInstr)-1), tmpInt) - tmpInt, 32), 28, 5);

      rVal := rVal + copy(IntToBin(StrToInt(CrInstr.valRD), 32), 25, 8);

      memWrite(memAdr, RegToInt(rVal));
      memAdr := memAdr + memInc;

      opCode.code.Add(cod.Strings[i]);
      if memInc = 4 then
      begin
        opCode.code.Add('');
      end;
      if memInc = 6 then
      begin
        opCode.code.Add('');
      end;
    end;

    if B4 then
    begin
      rVal := rVal + '010';
      tmpInt := jump('BR');
      rVal := rVal + copy(IntToBin(jump(CrInstr.crInstr, tmpInt) - tmpInt, 32), 28, 5);
      rVal := rVal + '00000000';

      memWrite(memAdr, RegToInt(rVal));
      memAdr := memAdr + memInc;

      opCode.code.Add(cod.Strings[i]);
      if memInc = 4 then
      begin
        opCode.code.Add('');
      end;
      if memInc = 6 then
      begin
        opCode.code.Add('');
      end;
    end;
  end;
end;

procedure TCPU.setCpuIntr(tmpCIL: Boolean; tmpACL: Boolean; tmpINTR: Boolean);
begin
  CIL := tmpCIL;
  ACLOW := tmpACL;
  INTR := tmpINTR;
end;//procedure TCPU.setCpuIntr(cil: Boolean; ACL: Boolean; INTR: Boolean);

procedure TCPU.getCpuIntr(var tmpCIL: Boolean;var tmpACL: Boolean;var tmpINTR: Boolean);
begin
  tmpCIL := CIL;
  tmpACL := ACLOW;
  tmpINTR := INTR;
end;

procedure TCPU.cpuInit;
var
  InsertItem: TListItem;
  i: Integer;
begin
  cpuInUse := false;

  mPoz := JUMP('IF');
  mFaza :=1;

  SBus := 0;
  DBus := 0;
  RBus := 0;
  MEMBus := 0;

  CIL := false;
  ACLOW := false;
  INTR := false;

  CpuGrf.ResetCpu;

  with (MEM as TListView)do
  begin
    Items.BeginUpdate;
    Items.Clear;
    for i:= 1 to memSZ do
    begin
      InsertItem := Items.Insert(Items.Count);
      InsertItem.Caption:= intToReg(0);
      InsertItem.SubItems.Add('0000');
      InsertItem.SubItems.Add(IntToHex(i-1, 4));
    end;
    Items.EndUpdate;
  end;

  with (GenReg as TListView)do
  begin
    Items.BeginUpdate;
    Items.Clear;
    for i:= 1 to 16 do
    begin
      InsertItem := Items.Insert(Items.Count);
      InsertItem.Caption:= '0000000000000000';
      InsertItem.SubItems.Add('R' + IntToStr(i-1));
    end;
    Items.EndUpdate;
  end;

  with (FLAGSReg as TLabeledEdit)do
    Text := '0000000000000000';

  with (SPReg as TLabeledEdit)do
    Text := IntToReg(memSZ*2);

  with (TReg as TLabeledEdit)do
    Text := '0000000000000000';

  with (PCReg as TLabeledEdit)do
    Text := '0000000000000000';

  with (IVRReg as TLabeledEdit)do
    Text := '0000000000000000';

  with (ADRReg as TLabeledEdit)do
    Text := '0000000000000000';

  with (MDRReg as TLabeledEdit)do
    Text := '0000000000000000';

  with (IRReg as TLabeledEdit)do
    Text := '0000000000000000';
end;//procedure TCPU.cpuInit;

procedure TCPU.SetMemSz(sz: Integer);
begin
  memSZ := sz;
  cpuInit;
end;//procedure TCPU.SetMemSz(sz: Integer);

end.
