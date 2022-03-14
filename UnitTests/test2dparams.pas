unit test2Dparams;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, fpcunit, testutils, testregistry, bstypes;

type

   Test2DParamFuncs= class(TTestCase)
   private
      fBeam    :TBeam;
   protected
      procedure SetUp; override;
      procedure TearDown; override;
   published
      procedure TestCaxVal2D_no_norm;
      procedure TestCaxVal2D_norm_cax;
      procedure TestCaxVal2D_norm_max;
      procedure TestMaxVal2D_no_norm;
      procedure TestMaxVal2D_norm_cax;
      procedure TestMaxVal2D_norm_max;
      procedure TestMinVal2D_no_norm;
      procedure TestMinVal2D_norm_cax;
      procedure TestMinVal2D_norm_max;
      procedure TestMinIFA2D;
      procedure TestUniformityCAX2D;
      procedure TestSymmetryAve2D; //validate this
      end;

implementation

uses importunit, param2Dfuncs;

procedure Test2DParamFuncs.SetUp;
begin
fBeam := TBeam.Create;
MapCheckOpen('../TestFiles/2-Sep-2011-A.txt',fBeam);
end;


procedure Test2DParamFuncs.TearDown;
begin
fBeam.Free;
end;


procedure Test2DParamFuncs.TestCaxVal2D_no_norm;
begin
AssertEquals('Test CAX value, no normalisation','94.47',CAXVal2D(fBeam));
end;


procedure Test2DParamFuncs.TestCaxVal2D_norm_cax;
begin
fBeam.Norm := norm_cax;
AssertEquals('Test CAX value, normalisation to CAX','100.0%',CAXVal2D(fBeam));
end;


procedure Test2DParamFuncs.TestCaxVal2D_norm_max;
begin
fBeam.Norm := norm_max;
AssertEquals('Test CAX value, normalisation to max','94.47%',CAXVal2D(fBeam));
end;


procedure Test2DParamFuncs.TestMaxVal2D_no_norm;
begin
AssertEquals('Test max value, no normalisation','100.00',MaxVal2D(fBeam));
end;


procedure Test2DParamFuncs.TestMaxVal2D_norm_cax;
begin
fBeam.Norm := norm_cax;
AssertEquals('Test max value, normalisation to CAX','105.86%',MaxVal2D(fBeam));
end;


procedure Test2DParamFuncs.TestMaxVal2D_norm_max;
begin
fBeam.Norm := norm_max;
AssertEquals('Test max value, normalisation to max','100.0%',MaxVal2D(fBeam));
end;


procedure Test2DParamFuncs.TestMinVal2D_no_norm;
begin
AssertEquals('Test min value, no normalisation','0.00',MinVal2D(fBeam));
end;


procedure Test2DParamFuncs.TestMinVal2D_norm_cax;
begin
fBeam.Norm := norm_cax;
AssertEquals('Test min value, normalisation to CAX','0.00',MinVal2D(fBeam));
end;


procedure Test2DParamFuncs.TestMinVal2D_norm_max;
begin
fBeam.Norm := norm_max;
AssertEquals('Test min value, normalisation to max','0.00',MinVal2D(fBeam));
end;


procedure Test2DParamFuncs.TestMinIFA2D;
begin
AssertEquals('Test min IFA value','94.32',MinIFA2D(fBeam));
end;


procedure Test2DParamFuncs.TestUniformityCAX2D;
begin
AssertEquals('Test uniformity NCS-70','5.86%',UniformityCAX2D(fBeam));
end;


procedure Test2DParamFuncs.TestSymmetryAve2D; //validate this
begin
AssertEquals('Test symmetry NCS-70','2.59%',SymmetryAve2D(fBeam));
end;


initialization

   RegisterTest(Test2DParamFuncs);
end.

