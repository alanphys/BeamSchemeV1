program beamscheme;
{.DEFINE DEBUG}

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  {$IFDEF DEBUG}
  , SysUtils              //delete SysUtils if not using heaptrc
  {$ENDIF}
  { you can add units after this }, bsunit, TAChartLazarusPkg, tachartprint,
  dtrackbar, aboutunit, param2dfuncs, importunit, mathsfuncs, settingsunit, form2pdf;

{$R *.res}

begin
  {Set up -gh output for the Leakview package}
  {$IFDEF DEBUG}
  if FileExists('heap.trc') then
     DeleteFile('heap.trc');
  SetHeapTraceOutput('heap.trc');
  {$ENDIF}
   Application.Scaled:=True;
   Application.Title:='BeamScheme';
  Application.Initialize;
  Application.CreateForm(TBSForm, BSForm);
  Application.Run;
end.

