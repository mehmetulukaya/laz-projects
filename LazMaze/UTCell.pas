unit UTCell;

interface

type
    TCell = class(TObject)
    private
        f_Row : integer;
        f_Col : integer;
    protected
    public
        constructor Create ( const nr, nc :integer ); virtual;
        destructor Destroy; override;

        // properties
        property Row : integer read f_Row write f_Row;
        property Col : integer read f_Col write f_Col;
    end;

implementation

constructor TCell.Create;
begin
    inherited Create;
    f_Row := nr;
    f_Col := nc;
end;

destructor TCell.Destroy;
begin
    inherited Destroy;
end;

end.
