unit U_Stats;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Grids;

type
  TStats = class(TForm)
    Button1: TButton;
    StringGrid1: TStringGrid;
    Memo1: TMemo;
    Label1: TLabel;
  end;

var
  Stats: TStats;

implementation

{$R *.DFM}

end.
