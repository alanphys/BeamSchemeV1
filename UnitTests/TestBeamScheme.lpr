program TestBeamScheme;
{.DEFINE DEBUG}

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tachartlazaruspkg,
  {$IFDEF DEBUG}
  SysUtils,              //delete SysUtils if not using heaptrc
  {$ENDIF}
  test1Dparams, testbstypes, testimport, test2dparams, testprotocols,
testmathfuncs;

{$R *.res}

begin
  {$IFDEF DEBUG}
  if FileExists('heap.trc') then
     DeleteFile('heap.trc');
  SetHeapTraceOutput('heap.trc');
  {$ENDIF}
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

