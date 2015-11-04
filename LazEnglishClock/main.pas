unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ExtCtrls, StdCtrls;

type

  { TfrmEnglishClock }

  TfrmEnglishClock = class(TForm)
    lbl_IT: TLabel;
    lbl_PAST: TLabel;
    lbl_ONE: TLabel;
    lbl_THREE: TLabel;
    lbl_TWO: TLabel;
    lbl_FOUR: TLabel;
    lbl_FIVE: TLabel;
    lbl_SIX: TLabel;
    lbl_SEVEN: TLabel;
    lbl_EIGHT: TLabel;
    lbl_NINE: TLabel;
    lbl_IS: TLabel;
    lbl_TEN: TLabel;
    lbl_ELEVEN: TLabel;
    lbl_TWELVE: TLabel;
    lbl_OCLOCK: TLabel;
    lbl_HALF: TLabel;
    lbl_TEN_: TLabel;
    lbl_QUARTER: TLabel;
    lbl_TWENTY: TLabel;
    lbl_FIVE_: TLabel;
    lbl_MINUTES: TLabel;
    lbl_TO: TLabel;
    pnl_Time: TPanel;
    tmr_Clock: TTimer;

    procedure EnglishClock(t:TDateTime);
    procedure Set_Lbl_color(const cmp:TLabel; clr:TColor);
    procedure Set_Hour_Active(hh:word);
    procedure Set_Min_Active(mm:word);

    procedure tmr_ClockTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmEnglishClock: TfrmEnglishClock;

implementation

{$R *.lfm}

{ TfrmEnglishClock }

procedure TfrmEnglishClock.EnglishClock(t: TDateTime);
var
   hh,mm,ss ,ms : word;
begin
  //
  DecodeTime(t,hh,mm,ss,ms);

  case mm of
    0: begin       // c'clock

         Set_Lbl_color(lbl_OCLOCK,clLime);
         Set_Lbl_color(lbl_HALF,clSilver);
         Set_Lbl_color(lbl_PAST,clSilver);
         Set_Lbl_color(lbl_TO,clSilver);
         Set_Lbl_color(lbl_MINUTES,clSilver);
       end;

    30:begin       // half past

          Set_Lbl_color(lbl_OCLOCK,clSilver);
          Set_Lbl_color(lbl_HALF,clLime);
          Set_Lbl_color(lbl_PAST,clLime);
          Set_Lbl_color(lbl_TO,clSilver);
          Set_Lbl_color(lbl_MINUTES,clSilver);
       end;

    1..29:begin    // past

            Set_Lbl_color(lbl_OCLOCK,clSilver);
            Set_Lbl_color(lbl_HALF,clSilver);
            Set_Lbl_color(lbl_PAST,clLime);
            Set_Lbl_color(lbl_TO,clSilver);

              if (mm=15) then
                Set_Lbl_color(lbl_MINUTES,clSilver)   // exceptional state...
              else
                 Set_Lbl_color(lbl_MINUTES,clLime);

            Set_Min_Active(mm);
          end;

    31..59:begin   // to

              Set_Lbl_color(lbl_OCLOCK,clSilver);
              Set_Lbl_color(lbl_HALF,clSilver);
              Set_Lbl_color(lbl_PAST,clSilver);
              Set_Lbl_color(lbl_TO,clLime);

              if (mm=45) then
                  Set_Lbl_color(lbl_MINUTES,clSilver)   // exceptional state...
                else
                   Set_Lbl_color(lbl_MINUTES,clLime);

              Set_Min_Active(abs(60-mm));
              Set_Hour_Active(abs(hh mod 12)+1);
              exit;
           end;

  end;
  Set_Hour_Active(abs(hh mod 12));

end;

procedure TfrmEnglishClock.Set_Lbl_color(const cmp: TLabel; clr: TColor);
begin
  cmp.Font.Color := clr;
  if clr<>clLime then
      cmp.Font.Bold := false
  else
    cmp.Font.Bold := true;
end;

procedure TfrmEnglishClock.Set_Hour_Active(hh: word);
begin
  //

  Set_Lbl_color(lbl_ONE,clSilver);
  Set_Lbl_color(lbl_TWO,clSilver);
  Set_Lbl_color(lbl_THREE,clSilver);
  Set_Lbl_color(lbl_FOUR,clSilver);
  Set_Lbl_color(lbl_FIVE,clSilver);
  Set_Lbl_color(lbl_SIX,clSilver);
  Set_Lbl_color(lbl_SEVEN,clSilver);
  Set_Lbl_color(lbl_EIGHT,clSilver);
  Set_Lbl_color(lbl_NINE,clSilver);
  Set_Lbl_color(lbl_TEN,clSilver);
  Set_Lbl_color(lbl_ELEVEN,clSilver);
  Set_Lbl_color(lbl_TWELVE,clSilver);

  case hh of
    1 : Set_Lbl_color(lbl_ONE,clLime);
    2 : Set_Lbl_color(lbl_TWO,clLime);
    3 : Set_Lbl_color(lbl_THREE,clLime);
    4 : Set_Lbl_color(lbl_FOUR,clLime);
    5 : Set_Lbl_color(lbl_FIVE,clLime);
    6 : Set_Lbl_color(lbl_SIX,clLime);
    7 : Set_Lbl_color(lbl_SEVEN,clLime);
    8 : Set_Lbl_color(lbl_EIGHT,clLime);
    9 : Set_Lbl_color(lbl_NINE,clLime);
    10 : Set_Lbl_color(lbl_TEN,clLime);
    11 : Set_Lbl_color(lbl_ELEVEN,clLime);
    12 : Set_Lbl_color(lbl_TWELVE,clLime);
  end;
end;

procedure TfrmEnglishClock.Set_Min_Active(mm: word);
begin
  Set_Lbl_color(lbl_FIVE_,clSilver);
  Set_Lbl_color(lbl_TEN_,clSilver);
  Set_Lbl_color(lbl_QUARTER,clSilver);
  Set_Lbl_color(lbl_TWENTY,clSilver);
  Set_Lbl_color(lbl_OCLOCK,clSilver);
  case mm of
    1..3 : begin
              Set_Lbl_color(lbl_OCLOCK,clLime);
              Set_Lbl_color(lbl_TO,clSilver);
              Set_Lbl_color(lbl_PAST,clSilver);
              Set_Lbl_color(lbl_MINUTES,clSilver);

    end;
    4..7 : Set_Lbl_color(lbl_FIVE_,clLime);
    8..12 : Set_Lbl_color(lbl_TEN_,clLime);
    13..17 : begin
                Set_Lbl_color(lbl_QUARTER,clLime);
                Set_Lbl_color(lbl_MINUTES,clSilver);
    end;
    19..23 : Set_Lbl_color(lbl_TWENTY,clLime);
    24..29 : begin
               Set_Lbl_color(lbl_TWENTY,clLime);
               Set_Lbl_color(lbl_FIVE_,clLime);
             end;
  end;
end;

procedure TfrmEnglishClock.tmr_ClockTimer(Sender: TObject);
begin
  // show actual time of local system
  pnl_Time.Caption := FormatDateTime('hh:nn:ss AM/PM',now) ;
  EnglishClock(now);
end;

end.

