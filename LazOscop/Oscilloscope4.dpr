program Oscilloscope4;
 {Copyright 2002-2004, Gary Darby, www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A simple Oscilloscope using  TWaveIn class.
 More info at http://www.delphiforfun.org/programs/oscilloscope.htm
}

uses
  Forms, Interfaces,
  U_Oscilloscope4 in 'U_Oscilloscope4.pas' {frmMain},
  ufrmOscilloscope4 in 'ufrmOscilloscope4.pas' {frmOscilloscope: TFrame},
  uColorFunctions in 'uColorFunctions.pas',
  uSettings in 'uSettings.pas',
  UWavein4 in 'UWavein4.pas',
  U_Spectrum4 in 'U_Spectrum4.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
