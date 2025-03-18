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
      procedure TestAve2D_no_norm;
      procedure TestAve2D_norm_cax;
      procedure TestAve2D_norm_max;
      procedure TestMinIFA2D;
      procedure TestUniformityCAX2D;
      procedure TestUniformityAve2D;
      procedure TestUniformityIntegral2D;
      procedure TestUniformityDifferential2D;
      procedure TestSymmetryAve2D; //validate this
      procedure TestCoMVal2D;
      procedure TestCoMScaled2D;
      procedure TestXRes2D;
      procedure TestYRes2D;
      procedure TestXPixels2D;
      procedure TestYPixels2D;
      procedure TestXSize2D;
      procedure TestYSize2D;
      end;

implementation

uses importunit, param2Dfuncs;

procedure Test2DParamFuncs.SetUp;
begin
fBeam := TBeam.Create;
IFAType := Proportional;
IFAFactor := 0.8;
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


procedure Test2DParamFuncs.TestAve2D_no_norm;
begin
AssertEquals('Test average value, no normalisation','46.94',Ave2D(fBeam));
end;


procedure Test2DParamFuncs.TestAve2D_norm_cax;
begin
fBeam.Norm := norm_cax;
AssertEquals('Test average value, normalisation to CAX','49.69%',Ave2D(fBeam));
end;


procedure Test2DParamFuncs.TestAve2D_norm_max;
begin
fBeam.Norm := norm_max;
AssertEquals('Test average value, normalisation to max','46.94%',Ave2D(fBeam));
end;


procedure Test2DParamFuncs.TestMinIFA2D;
begin
AssertEquals('Test min IFA value','94.32',MinIFA2D(fBeam));
end;


procedure Test2DParamFuncs.TestUniformityCAX2D;
begin
AssertEquals('Test uniformity NCS-70','5.86%',UniformityCAX2D(fBeam));
end;


procedure Test2DParamFuncs.TestUniformityAve2D;
begin
AssertEquals('Test uniformity ICRU 72','5.80%',UniformityAve2D(fBeam));
end;


procedure Test2DParamFuncs.TestUniformityIntegral2D;
begin
AssertEquals('Test uniformity Integral','2.93%',UniformityIntegral2D(fBeam));
end;


procedure Test2DParamFuncs.TestUniformityDifferential2D;
begin
AssertEquals('Test uniformity Integral','1.44%',UniformityDifferential2D(fBeam));
end;


procedure Test2DParamFuncs.TestSymmetryAve2D; //validate this
begin
AssertEquals('Test symmetry NCS-70','2.59%',SymmetryAve2D(fBeam));
end;


procedure Test2DParamFuncs.TestCoMVal2D;
begin
AssertEquals('Test CoM (row,col)','(31.52,26.52)',CoMVal2D(fBeam));
end;


procedure Test2DParamFuncs.TestCoMScaled2D;
begin
AssertEquals('Test CoM (X,Y)','(13.26,15.76)',CoMScaled2D(fBeam));
end;


procedure Test2DParamFuncs.TestXRes2D;
begin
AssertEquals('Test X Res','5.08 dpi',XRes2D(fBeam));
end;


procedure Test2DParamFuncs.TestYRes2D;
begin
AssertEquals('Test Y Res','5.08 dpi',YRes2D(fBeam));
end;


procedure Test2DParamFuncs.TestXPixels2D;
begin
AssertEquals('Test number of X pixels','53',XPixels2D(fBeam));
end;


procedure Test2DParamFuncs.TestYPixels2D;
begin
AssertEquals('Test number of Y pixels','65',YPixels2D(fBeam));
end;


procedure Test2DParamFuncs.TestXSize2D;
begin
AssertEquals('Test X Size','26.00 cm',XSize2D(fBeam));
end;


procedure Test2DParamFuncs.TestYSize2D;
begin
AssertEquals('Test Y Size','32.00 cm',YSize2D(fBeam));
end;


initialization

   RegisterTest(Test2DParamFuncs);
end.

