unit UfrmMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Buttons,
  UMakeMaze,   ExtCtrls, ComCtrls, Menus;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    cmExit: TMenuItem;
    pnlLeft: TPanel;
    Label3: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    sbCols: TScrollBar;
    sbRows: TScrollBar;
    spnRandSeed: TSpinEdit;
    chkRandSeed: TCheckBox;
    pnlPaintArea: TPanel;
    pb: TPaintBox;
    sb: TStatusBar;
    cmHelp: TMenuItem;
    cmAbout: TMenuItem;
    // XPManifest1: TXPManifest;
    lblRows: TLabel;
    lblCols: TLabel;
    cmNewMaze: TMenuItem;
    cmSolveMaze: TMenuItem;
    N1: TMenuItem;
    Label1: TLabel;
    cmRefresh: TMenuItem;
    pnlLine: TPanel;
    pnlSolution: TPanel;
    pnlNormal: TPanel;
    pnlStart: TPanel;
    pnlEnd: TPanel;
    btnCompute: TBitBtn;
    btnSolve: TBitBtn;
    chkAutoSolve: TCheckBox;
    spnTileSize: TSpinEdit;
    pnlVisited: TPanel;
    chkShowVisited: TCheckBox;
    Label4: TLabel;
    spnStepSize: TSpinEdit;
    Label6: TLabel;
    spnEndsSize: TSpinEdit;
    Label7: TLabel;
    dlgColor: TColorDialog;
    procedure cmExitClick(Sender: TObject);
    procedure sbColsChange(Sender: TObject);
    procedure sbRowsChange(Sender: TObject);
    procedure pbPaint(Sender: TObject);
    procedure pnlStartClick(Sender: TObject);
    procedure cmAboutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure pnlPaintAreaResize(Sender: TObject);
    procedure chkRandSeedClick(Sender: TObject);
    procedure cmNewMazeClick(Sender: TObject);
    procedure cmSolveMazeClick(Sender: TObject);
    procedure pbMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cmRefreshClick(Sender: TObject);
    procedure spnTileSizeChange(Sender: TObject);
    procedure chkShowVisitedClick(Sender: TObject);
  private
    dMazeCreationTime : double;
    dMazeSolutionTime : double;
    iVisitedCells     : integer;
    iSolutionLength   : integer;
    bCreated : boolean;
    bSolved  : boolean;
    maze     : TMaze;
    mazeRows : integer;
    mazeCols : integer;
    startRow,
    startCol,
    endRow,
    endCol   : integer;

    procedure UpdateStatusBar;
    procedure ShowMaze(c: TCanvas; var maze: TMaze; const rows, cols, w, stepWidth, endsWidth, ox, oy : integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses UGlobals;

{$R *.dfm}
{ --------------------------------------------------------------------------- }
{ ---- Private Methods ------------------------------------------------------ }
{ --------------------------------------------------------------------------- }

procedure TfrmMain.UpdateStatusBar;
begin
    if not bCreated then
        sb.SimpleText := ''
    else
        if not bSolved then
            sb.SimpleText := Format('Created in %0.3n seconds. Maze Size: %d cells',
                                    [dMazeCreationTime, mazeRows*mazeCols])
        else
            sb.SimpleText := Format('Created in %0.3n seconds, solved in %0.3n seconds. Maze Size: %d cells - Solution Length: %d - Visited Cells: %d',
                                    [dMazeCreationTime, dMazeSolutionTime, mazeRows*mazeCols, iSolutionLength, iVisitedCells]);
end;

procedure TfrmMain.ShowMaze ( c : TCanvas; var maze : TMaze; const rows, cols, w, stepWidth, endsWidth, ox, oy : integer );
var
    i,j                    : integer;
    stepOffset, endsOffset : integer;

begin
    stepOffset := ((w-stepWidth+1) div 2);
    endsOffset := ((w-endsWidth+1) div 2);
    with c do
    begin
        // normal color
        Brush.Color := pnlNormal.Color;
        Pen.Color := pnlNormal.Color;
        Rectangle (ox, oy, ox + (cols)*w, oy + (rows)*w);

        // backgrounds for solution and start/end cells
        for i := 0 to cols-1 do
            for j := 0 to rows-1 do
            begin
                // if this is a solution cell
                if (chkShowVisited.Checked) and (maze[j,i] and CELL_VISITED = CELL_VISITED) then
                begin
                    Brush.Color := pnlVisited.Color;
                    Pen.Color := pnlVisited.Color;
                    Rectangle (ox + i*w + stepOffset,             oy + j*w + stepOffset,
                               ox + i*w + stepOffset + stepWidth, oy + j*w + stepOffset + stepWidth);
                end;
                if maze[j,i] and CELL_SOLUTION = CELL_SOLUTION then
                begin
                    Brush.Color := pnlSolution.Color;
                    Pen.Color := pnlSolution.Color;
                    Rectangle (ox + i*w + stepOffset,             oy + j*w + stepOffset,
                               ox + i*w + stepOffset + stepWidth, oy + j*w + stepOffset + stepWidth);
                end;

                // paint Start and End Cell
                if (j = startRow) and (i = startCol) then
                begin
                    Brush.Color := pnlStart.Color;
                    Pen.Color := pnlStart.Color;
                    Rectangle (ox + i*w + endsOffset,             oy + j*w + endsOffset,
                               ox + i*w + endsOffset + endsWidth, oy + j*w + endsOffset + endsWidth);
                end;
                if (j = endRow) and (i = endCol) then
                begin
                    Brush.Color := pnlEnd.Color;
                    Pen.Color := pnlEnd.Color;
                    Rectangle (ox + i*w + endsOffset,             oy + j*w + endsOffset,
                               ox + i*w + endsOffset + endsWidth, oy + j*w + endsOffset + endsWidth);
                end;
            end;

        // lines
        Brush.Color := pnlNormal.Color;
        Pen.Color := pnlLine.Color;
        for i := 0 to cols-1 do
            for j := 0 to rows-1 do
            begin
                if maze[j,i] and EXIT_EAST = $00 then  // if there is NO exit EAST
                begin
                    MoveTo (ox + (i+1)*w, oy + j*w);
                    LineTo (ox + (i+1)*w, oy + (j+1)*w + 1);
                end;
                if maze[j,i] and EXIT_NORTH = $00 then  // if there is NO exit NORTH
                begin
                    MoveTo (ox + i*w,         oy + j*w);
                    LineTo (ox + (i+1)*w + 1, oy + j*w);
                end;
                if maze[j,i] and EXIT_WEST = $00 then  // if there is NO exit WEST
                begin
                    MoveTo (ox + i*w, oy + j*w);
                    LineTo (ox + i*w, oy + (j+1)*w + 1);
                end;
                if maze[j,i] and EXIT_SOUTH = $00 then  // if there is NO exit SOUTH
                begin
                    MoveTo (ox + i*w,         oy + (j+1)*w);
                    LineTo (ox + (i+1)*w + 1, oy + (j+1)*w);
                end;
            end;
    end;
end;

{ --------------------------------------------------------------------------- }
{ ---- End of Private Methods ----------------------------------------------- }
{ --------------------------------------------------------------------------- }

{ --------------------------------------------------------------------------- }
{ ---- IniFile Methods ------------------------------------------------------ }
{ --------------------------------------------------------------------------- }

{ --------------------------------------------------------------------------- }
{ ---- End of IniFile Methods ----------------------------------------------- }
{ --------------------------------------------------------------------------- }

{ --------------------------------------------------------------------------- }
{ ---- Form Events ---------------------------------------------------------- }
{ --------------------------------------------------------------------------- }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    Caption := AppName+' '+AppVersion+' '+AppCopyright;
    Application.Title := AppName+' '+AppVersion;

    bCreated := false;
    bSolved := false;
    dMazeCreationTime := 0.0;
    dMazeSolutionTime := 0.0;
    iVisitedCells     := 0;
    iSolutionLength   := 0;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
//
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
    lblCols.Caption := IntToStr(sbCols.Position);
    lblRows.Caption := IntToStr(sbRows.Position);

    cmNewMazeClick (nil);
    cmSolveMazeClick (nil);
    UpdateStatusBar;
end;

{ --------------------------------------------------------------------------- }
{ ---- End of Form Events --------------------------------------------------- }
{ --------------------------------------------------------------------------- }

{ --------------------------------------------------------------------------- }
{ ---- Menu Commands -------------------------------------------------------- }
{ --------------------------------------------------------------------------- }

procedure TfrmMain.cmNewMazeClick(Sender: TObject);
var
    t1, t2 : integer;

begin
    if chkRandSeed.Checked then
    begin
        RandSeed := spnRandSeed.Value;
    end
    else
    begin
        Randomize;
        RandSeed := Random(65536);
        spnRandSeed.Value := RandSeed;
    end;

    mazeRows := sbRows.Position;
    mazeCols := sbCols.Position;
    Screen.Cursor := crHourGlass;
    t1 := GetTickCount;
    MakeMaze (maze, mazeRows, mazeCols);
    t2 := GetTickCount;
    dMazeCreationTime := (t2-t1)/1000;

    // set start and end cell
    startRow := Random(mazeRows);
    startCol := 0;
    endRow   := Random(mazeRows);
    endCol   := mazeCols-1;

    Screen.Cursor := crDefault;
    bCreated := true;
    bSolved := false;

    if chkAutoSolve.Checked then
        cmSolveMazeClick(nil)
    else
        pb.Invalidate;
    UpdateStatusBar;
end;

procedure TfrmMain.cmSolveMazeClick(Sender: TObject);
var
    t1, t2 : integer;

begin
    if (not bCreated) or (bSolved) then   // if not created yet, or already solved then nothing to do
        Exit;
    Screen.Cursor := crHourGlass;
    t1 := GetTickCount;
    SolveMaze (maze, mazeRows, mazeCols, startRow, startCol, endRow, endCol, iSolutionLength, iVisitedCells);
    t2 := GetTickCount;
    dMazeSolutionTime := (t2-t1)/1000;

    bSolved := true;
    Screen.Cursor := crDefault;
    pb.Invalidate;
    UpdateStatusBar;
end;

procedure TfrmMain.cmRefreshClick(Sender: TObject);
begin
    pb.Invalidate;
end;

procedure TfrmMain.cmExitClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmMain.cmAboutClick(Sender: TObject);
begin
    ShowMessage (AppName+' '+AppVersion+#13#10'written by '+AppAuthor+#13#10+AppCopyright);
end;

{ --------------------------------------------------------------------------- }
{ ---- End of Menu Commands ------------------------------------------------- }
{ --------------------------------------------------------------------------- }

{ --------------------------------------------------------------------------- }
{ ---- Component Events ----------------------------------------------------- }
{ --------------------------------------------------------------------------- }

procedure TfrmMain.sbColsChange(Sender: TObject);
begin
     lblCols.Caption := IntToStr(sbCols.Position);
end;

procedure TfrmMain.sbRowsChange(Sender: TObject);
begin
    lblRows.Caption := IntToStr(sbRows.Position);
end;

procedure TfrmMain.pbPaint(Sender: TObject);
var
    orx, ory : integer;

begin
    if not bCreated then
        Exit;

    ComputeOrigin (pb.Width, pb.Height, Round(spnTileSize.Value), mazeRows, mazeCols, orx, ory);
    ShowMaze (pb.Canvas, maze, mazeRows, mazeCols, Round(spnTileSize.Value), Round(spnStepSize.Value), Round(spnEndsSize.Value), orx, ory);
end;

procedure TfrmMain.pnlPaintAreaResize(Sender: TObject);
var
    rows, cols : integer;

begin
    ComputeMaxSize (pb.Width, pb.Height, Round(spnTileSize.Value), rows, cols);
    sbRows.Max := rows;
    sbCols.Max := cols;
end;

procedure TfrmMain.pnlStartClick(Sender: TObject);
begin
    dlgColor.Color := (Sender as TPanel).Color;
    if dlgColor.Execute then
        (Sender as TPanel).Color := dlgColor.Color;
    pb.Invalidate;
end;

procedure TfrmMain.chkRandSeedClick(Sender: TObject);
begin
    spnRandSeed.Enabled := chkRandSeed.Checked;
end;

{ --------------------------------------------------------------------------- }
{ ---- End of Component Events ---------------------------------------------- }
{ --------------------------------------------------------------------------- }

procedure TfrmMain.pbMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    orx, ory, r, c : integer;

begin
    if bCreated then
    begin
        ComputeOrigin (pb.Width, pb.Height, Round(spnTileSize.Value), mazeRows, mazeCols, orx, ory);

        r := (y-ory) div Round(spnTileSize.Value);
        c := (x-orx) div Round(spnTileSize.Value);

        if InMazeBorders(r,c, mazeRows, mazeCols) then
        begin
            if (Button = mbLeft) then
            begin
                startRow := r;
                startCol := c;
            end
            else
            begin
                endRow := r;
                endCol := c;
            end;
            InvalidateMazeSolution (maze, mazeRows, mazeCols);
            bSolved := false;
            cmSolveMazeClick(nil);
            pb.Invalidate;
        end;
    end;
end;

procedure TfrmMain.spnTileSizeChange(Sender: TObject);
begin
    pnlPaintAreaResize(nil);
    pb.Invalidate;
end;

procedure TfrmMain.chkShowVisitedClick(Sender: TObject);
begin
    pb.Invalidate;
end;

end.
