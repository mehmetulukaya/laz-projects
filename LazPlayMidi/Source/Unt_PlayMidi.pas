unit Unt_PlayMidi;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses FileUtil;

type TPlayNotify=procedure(Sender:Tobject;Position,Length:string;var Break:boolean) of object;
procedure Midi(const aResName: String;Notify:TPlayNotify=nil);

implementation

uses
{$IFnDEF FPC}

{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
   windows,dialogs,forms,     mmSystem,classes,sysutils;

resourcestring
  {$IFDEF GERMAN}
  SResourceNotFound = 'Die Ressource kann nicht gefunden werden.';
  {$ELSE}
  SResourceNotFound = 'The resource can not be found.';
  {$ENDIF}

procedure Midi;
const
  Len: Cardinal = MAX_PATH;
  tmpFile: String = '~tmpFile01'; // Name of temporary file
var
  Stream: TCustomMemoryStream;
  BufLen, BufPos, tmpPath: String;
  breakFlag: Boolean;
  lBuflen: integer;
  lBufPos: integer;
begin
  // Get Temp-Directory
  SetLength(tmpPath, Len);
  GetTempPath(Len, PChar(tmpPath));
  tmpPath := StrPas(PChar(tmpPath)) + tmpFile;


  mciSendString('stop mySound', nil, 0, 0);
  mciSendString('close mySound', nil, 0, 0);
  {$IFDEF FPC}
  if FileExistsUTF8(tmpPath) then // delete temporary file, if exists
    DeleteFileUTF8(tmpPath);
  {$ELSE}
  if FileExists(tmpPath) then // delete temporary file, if exists
    DeleteFile(tmpPath);
  {$ENDIF}


  if FindResource(hInstance, PChar(aResName), 'MIDIFILE') <> 0 then
  begin // is Ressource availible ?
    try
      Stream := TResourceStream.Create(hInstance, aResName, 'MIDIFILE'); // create stream
      Stream.SaveToFile(tmpPath); // save temporary file
    finally
      Stream.Free;
    end;
  end
  else
  begin
    MessageBeep(MB_ICONEXCLAMATION);
    MessageDlg(SResourceNotFound, mtError, [mbOk], 0);
    Exit;
  end;


  mciSendString(PChar('open sequencer!' + tmpPath + ' alias mySound'), nil, 0, 0);
  mciSendString('play mySound' , nil, 0, 0);


  SetLength(BufLen, Len);
  SetLength(BufPos, Len);
  breakFlag:=False;
  mciSendString('status mySound length', pchar(BufLen), Len, 0); // get length of midifile ...
  trystrtoint(pchar(BufLen),lBuflen);
  repeat
    mciSendString('status mySound position', Pchar(BufPos), Len, 0); // get actual position ...
     trystrtoint(Pchar(BufPos),lBufPos);
    if assigned(notify) then
      notify(application,Pchar(BufPos), pchar(BufLen),breakFlag);
    Application.ProcessMessages;
    if Application.Terminated then
      break;
  until (lBufPos >= lBuflen) or breakFlag; // ... until end of file reached
  mciSendString('stop mySound', nil, 0, 0);
  mciSendString('close mySound', nil, 0, 0);


  {$IFDEF FPC}
  if FileExistsUTF8(tmpPath) then // delete temporary file
    DeleteFileUTF8(tmpPath);
  {$ELSE}
  if FileExists(tmpPath) then // delete temporary file
    DeleteFile(tmpPath);
  {$ENDIF}
end;

end.

