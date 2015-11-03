unit UGlobals;

interface

const
    AppName      = 'Maze';
    AppVersion   = 'v3.0';
    AppAuthor    = 'Kostas Symeonidis';
    AppCopyright = '©1996,2004 CyLog Software';

    MIN_COLS = 2;
    MIN_ROWS = 2;
    MAX_ROWS = 1024;
    MAX_COLS = 1024;

procedure ComputeMaxSize ( const a_iWidth, a_iHeight, a_iTileSize : integer; var rows, cols : integer );
procedure ComputeOrigin ( const a_iWidth, a_iHeight, a_iTileSize, a_iRows, a_iCols : integer; var x,y : integer );

implementation

uses
    clIntMath;

procedure ComputeMaxSize ( const a_iWidth, a_iHeight, a_iTileSize : integer; var rows, cols : integer );
begin
    cols := CorrectIntegerRange((a_iWidth div a_iTileSize)-1, MIN_COLS, MAX_COLS);
    rows := CorrectIntegerRange((a_iHeight div a_iTileSize)-1, MIN_ROWS, MAX_ROWS);
end;

procedure ComputeOrigin ( const a_iWidth, a_iHeight, a_iTileSize, a_iRows, a_iCols : integer; var x,y : integer );
begin
    x := (a_iWidth - a_iCols * a_iTileSize) div 2;
    y := (a_iHeight - a_iRows * a_iTileSize) div 2;
end;

end.
