program TestBeamScheme;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tachartlazaruspkg, test1Dparams,
  testbstypes, testimport, test2dparams;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

