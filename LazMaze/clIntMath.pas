{ --------------------------------------------------------------------------- }
{ clIntMath.pas                                                               }
{                                                                             }
{ This library contains helpful functions to perform some simple int-based    }
{ operations like, inclusion in a rectangle and range correction.             }
{                                                                             }
{ --------------------------------------------------------------------------- }
{ Update history:                                                             }
{                                                                             }
{ d1  19-Dec-2004  Kostas Symeonidis  Created.                                }
{ --------------------------------------------------------------------------- }

unit clIntMath;

interface

function InBox ( x,y,x1,y1,w,h : integer ) : boolean;

function CorrectIntegerRange ( a_i : integer; a_iMin, a_iMax : integer ) : integer;
function CorrectIntegerFloor ( a_i : integer; a_iMin : integer ) : integer;
function CorrectIntegerCeil ( a_i : integer; a_iMax : integer ) : integer;

implementation

function InBox ( x,y,x1,y1,w,h : integer ) : boolean;
begin
    InBox := (x >= x1) and (x <= x1+w-1) and (y >= y1) and (y <= y1+h-1);
end;

function CorrectIntegerRange ( a_i : integer; a_iMin, a_iMax : integer ) : integer;
begin
    Result := a_i;
    if a_i < a_iMin then
        Result := a_iMin
    else
        if a_i > a_iMax then
            Result := a_iMax;
end;

function CorrectIntegerFloor ( a_i : integer; a_iMin : integer ) : integer;
begin
    Result := a_i;
    if a_i < a_iMin then
        Result := a_iMin;
end;

function CorrectIntegerCeil ( a_i : integer; a_iMax : integer ) : integer;
begin
    Result := a_i;
    if a_i > a_iMax then
        Result := a_iMax;
end;

end.
