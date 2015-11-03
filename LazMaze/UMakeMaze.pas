{ --------------------------------------------------------------------------- }
{ UMakeMaze.pas                                                               }
{                                                                             }
{ An implementation of Prim's algorithm to create Mazes. The solution method  }
{ is a simple implementation of a Depth-First algorithm.                      }
{                                                                             }
{ --------------------------------------------------------------------------- }
{ Update history:                                                             }
{                                                                             }
{ d1  19-Dec-2004  Kostas Symeonidis  Created.                                }
{ --------------------------------------------------------------------------- }

unit UMakeMaze;

interface

uses
    SysUtils, Contnrs,
    UGlobals;

const
    NO_EXIT    = $00;
    EXIT_EAST  = $01;
    EXIT_NORTH = $02;
    EXIT_WEST  = $04;
    EXIT_SOUTH = $08;

    CELL_VISITED  = $10;
    CELL_FRONTIER = $20;
    CELL_SOLUTION = $40;
    CELL_UNUSED   = $80;  // unused

    DIR_EAST  = 0;
    DIR_NORTH = 1;
    DIR_WEST  = 2;
    DIR_SOUTH = 3;

    dc : array[0..3] of integer = (1,0,-1,0);   // 0..3 is E-N-W-S
    dr : array[0..3] of integer = (0,-1,0,1);   // 0..3 is E-N-W-S

type
    TMaze = array[0..MAX_ROWS-1, 0..MAX_COLS-1] of byte;

function InMazeBorders ( row, col, maxrow, maxcol : integer ) : boolean;
procedure InvalidateMazeSolution ( var maze : TMaze; const rows, cols : integer );
procedure MakeMaze ( var maze : TMaze; const rows, cols : integer );
procedure SolveMaze ( var maze : TMaze; const rows, cols, startRow, startCol, endRow, endCol : integer;
                      var iSolutionLength, iVisitedCells : integer );

implementation

uses UTCell;

function InMazeBorders ( row, col, maxrow, maxcol : integer ) : boolean;
begin
    // the coords must be between 0..max-1
    Result := (row > -1) and (row < maxrow) and (col > -1) and (col < maxcol);
end;

procedure InvalidateMazeSolution ( var maze : TMaze; const rows, cols : integer );
var
    r, c : integer;
    
begin
    // Now clear the Maze block upper bits and set a Start and an End Cell
    for r := 0 to rows-1 do
        for c := 0 to cols-1 do
            maze[r,c] := maze[r,c] and $0F;
end;

procedure MakeMaze ( var maze : TMaze; const rows, cols : integer );
var
    fCells : TObjectList;

    procedure MarkFrontierCells ( const row, col : integer );
    var
        i, r, c : integer;

    begin
        for i := 0 to 3 do
        begin
            r := row+dr[i];
            c := col+dc[i];

            // if r,c within Maze and CELL not VISITED NOR FRONTIER yet, then make it a frontier cell
            if InMazeBorders (r, c, rows, cols) and (maze[r,c] and CELL_VISITED  = $00) and (maze[r,c] and CELL_FRONTIER = $00) then
            begin
                maze[r,c] := maze[r,c] or CELL_FRONTIER;
                fCells.Add( TCell.Create(r,c) );
            end;
        end;
    end;

    procedure RemoveFrontierCell ( const row, col : integer );
    var
        i : integer;

    begin
        maze[row,col] := maze[row,col] xor CELL_FRONTIER;  // remove the frontier flag
        for i := 0 to fCells.Count-1 do
            if (TCell(fCells[i]).Row = row) and (TCell(fCells[i]).Col = col) then
            begin
                fCells.Delete(i);
                break;
            end;
    end;

    procedure RemoveWall ( const row, col, direction : integer );
    begin
        case direction of
        DIR_EAST  : begin
                        maze[row, col] := maze[row, col] or EXIT_EAST;
                        maze[row, col+1] := maze[row, col+1] or EXIT_WEST;
                    end;
        DIR_NORTH : begin
                        maze[row, col] := maze[row, col] or EXIT_NORTH;
                        maze[row-1, col] := maze[row-1, col] or EXIT_SOUTH;
                    end;
        DIR_WEST  : begin
                        maze[row, col] := maze[row, col] or EXIT_WEST;
                        maze[row, col-1] := maze[row, col-1] or EXIT_EAST;
                    end;
        DIR_SOUTH : begin
                        maze[row, col] := maze[row, col] or EXIT_SOUTH;
                        maze[row+1, col] := maze[row+1, col] or EXIT_NORTH;
                    end;
        end;
    end;

    procedure AttachCellToTree ( const row, col, dir : integer );
    var
        i, r, c, dirOffset, direction : integer;

    begin
        RemoveFrontierCell (row, col);
        // maze[row,col] := maze[row,col] xor CELL_FRONTIER;     // remove frontier
        maze[row,col] := maze[row,col] or CELL_VISITED;       // apply visited

        if dir = -1 then
        begin
            // find a VISITED cell in one random direction and remove the wall
            // between this cell and that one
            dirOffset := Random(4);
            for i := 0 to 3 do
            begin
                direction := (dirOffset + i) mod 4;
                r := row + dr[direction];
                c := col + dc[direction];

                // if this direction has a visited cell then
                if InMazeBorders (r, c, rows, cols) and (maze[r,c] and CELL_VISITED <> $00) then
                begin
                    RemoveWall (row, col, direction);
                    break;
                end;
            end;
        end
        else
        begin
            RemoveWall (row, col, dir);
        end;
    end;

    procedure CreateBranch ( const row, col : integer );
    var
        currRow, currCol    : integer;
        bMoved              : boolean;
        i, r, c,
        dirOffset, direction : integer;

    begin
        // attach cell to tree
        AttachCellToTree (row, col, -1); // pick a random direction
        MarkFrontierCells (row, col);
        currRow := row;
        currCol := col;

        repeat
            bMoved := false;
            // find a direction with a frontier cell and move onto it
            dirOffset := Random(4);
            for i := 0 to 3 do
            begin
                direction := (dirOffset + i) mod 4;
                r := currRow + dr[direction];
                c := currCol + dc[direction];

                // if this direction has a frontier cell then
                if InMazeBorders (r, c, rows, cols) and (maze[r,c] and CELL_FRONTIER <> $00) then
                begin
                    AttachCellToTree (r, c, (direction+2) mod 4);
                    MarkFrontierCells (r,c);
                    bMoved := true;
                    currRow := r;
                    currCol := c;
                    break;
                end;
            end;
        until not bMoved;
    end;

var
    n, r, c : integer;

begin
    // make all cells in the maze with no exits
    FillChar (maze, SizeOf(maze), NO_EXIT);

    // pick a random cell in the maze
    r := Random(rows);
    c := Random(cols);
    maze[r,c] := maze[r,c] or CELL_VISITED;  // add the visited flag
    fCells := TObjectList.Create(true);
    MarkFrontierCells (r,c);
    while fCells.Count > 0 do
    begin
        // pick a random Frontier cell and start a branch on it
        n := Random(fCells.Count);
        CreateBranch (TCell(fCells[n]).Row, TCell(fCells[n]).Col);
    end;
    fCells.Free;
    InvalidateMazeSolution (maze, rows, cols);
end;

procedure SolveMaze ( var maze : TMaze; const rows, cols, startRow, startCol, endRow, endCol : integer; var iSolutionLength, iVisitedCells : integer );

    function Solve ( r,c : integer ) : boolean;
    var
        i, direction, dirOffset : integer;
        tempR, tempC            : integer;

    begin
        Inc (iVisitedCells);
        Inc (iSolutionLength);
        maze[r,c] := maze[r,c] or CELL_VISITED;  // mark this cell as visited and...
        maze[r,c] := maze[r,c] or CELL_SOLUTION; // ... mark it as part of the solution so far

        if (r = endRow) and (c = endCol) then // if this is the final cell then Hurray, that was it! 
        begin
            Result := true;
            Exit;
        end;

        dirOffset := Random(4);
        for i := 0 to 3 do
        begin
            direction := (dirOffset + i) mod 4;

            // if there's an exit in that direction
            if (maze[r,c] and (1 shl direction) <> $00) then
            begin
                tempR := r + dr[direction];
                tempC := c + dc[direction];

                // if the destination cell is not visited yet, then try
                if (maze[tempR, tempC] and CELL_VISITED = $00) then
                begin
                    if Solve (tempR, tempC) then
                    begin
                        Result := true;
                        Exit;
                    end;
                end;
            end;
        end;

        // if none of the options was good
        maze[r,c] := maze[r,c] xor CELL_SOLUTION;  // unmark the cell as a solution cell...
        Dec (iSolutionLength);
        Result := false;                           // ...and return FALSE. This road was wrong!
    end;

begin
    iVisitedCells := 0;
    iSolutionLength := 0;
    Solve (startRow, startCol);
end;

end.
