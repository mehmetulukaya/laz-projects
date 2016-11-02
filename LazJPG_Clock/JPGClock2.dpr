program JPGClock2;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms, Interfaces,
  U_JPGClock2 in 'U_JPGClock2.pas' {Form1};

{$R *.res}
                   
begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
