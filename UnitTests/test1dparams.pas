unit test1Dparams;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, fpcunit, testutils, testregistry, bstypes, param1Dfuncs;

type

   Test1DParamFuncs= class(TTestCase)
   private
      FProfile:TSingleProfile;
   protected
      procedure SetUp; override;
      procedure TearDown; override;
   published
      procedure TestCaxVal1D_no_norm;
      procedure TestCaxVal1D_norm_cax;
      procedure TestCaxVal1D_norm_max;
      procedure TestMaxVal1D_no_norm;
      procedure TestMaxVal1D_norm_cax;
      procedure TestMaxVal1D_norm_max;
      procedure TestMinVal1D_no_norm;
      procedure TestMinVal1D_norm_cax;
      procedure TestMinVal1D_norm_max;
      procedure TestMinIFA1D_no_norm;
      procedure TestMinIFA1D_norm_cax;
      procedure TestMinIFA1D_norm_max;
      procedure TestFieldEdgeLeft501D;
      procedure TestFieldEdgeRight501D;
      procedure TestFieldCentre501D;
      procedure TestFieldSize501D;
      procedure TestNoFunc1D;
   end;

{profile taken from TestFiles/2-Sep-2011-A.txt X direction position 0}
var ProfileArrX: array of double = (-13, -12.5, -12, -11.5, -11, -10.5, -10,
    -9.5, -9, -8.5, -8, -7.5, -7, -6.5, -6, -5.5, -5, -4.5, -4, -3.5, -3, -2.5,
    -2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5,
    7, 7.5, 8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 12, 12.5, 13);
   ProfileArrY: array of double = (2.18, 2.68, 3.27, 4.36, 5.83, 9.12, 15.44,
   63.73, 94.96, 97.26, 98.38, 98.78, 98.86, 99, 98.89, 98.98, 98.8, 98.95,
   98.9, 98.52, 98.05, 97.31, 96.26, 95.38, 94.59, 94.53, 94.47, 94.46, 94.49,
   94.57, 94.7, 95.18, 95.51, 96.51, 97.32, 97.82, 97.95, 97.99, 97.98, 98.2,
   98.33, 98.31, 98.33, 98.1, 97.7, 95.9, 92.2, 36.68, 12.18, 8.02, 4.92, 3.97,
   3.01);

implementation

procedure Test1DParamFuncs.SetUp;
begin
fProfile := TSingleProfile.Create;
fProfile.PArrX := ProfileArrX;
fProfile.PArrY := ProfileArrY;
fProfile.Len := 53;
end;


procedure Test1DParamFuncs.TearDown;
begin
fProfile.Free;
end;


{-------------------------------------------------------------------------------
 Field statistic
-------------------------------------------------------------------------------}
procedure Test1DParamFuncs.TestCAXVal1D_no_norm;
begin
AssertEquals('Test CAX value, no normalisation','94.5',CAXVal1D(fProfile));
end;


procedure Test1DParamFuncs.TestCAXVal1d_norm_cax;
begin
fProfile.Norm := norm_cax;
AssertEquals('Test CAX value, normalisation to CAX','100.0%',CAXVal1D(fProfile));
end;


procedure Test1DParamFuncs.TestCAXVal1D_norm_Max;
begin
fProfile.Norm := norm_max;
AssertEquals('Test CAX value, normlisation to Max','95.4%',CAXVal1D(fProfile));
end;


procedure Test1DParamFuncs.TestMaxVal1D_no_norm;
begin
AssertEquals('Test Max value, no normalisation','99.0',MaxVal1D(fProfile));
end;


procedure Test1DParamFuncs.TestMaxVal1D_norm_cax;
begin
fProfile.Norm := norm_cax;
AssertEquals('Test Max value, normalisation to Cax','104.8%',MaxVal1D(fProfile));
end;


procedure Test1DParamFuncs.TestMaxVal1D_norm_max;
begin
fProfile.Norm := norm_Max;
AssertEquals('Test Max value, normlisation to Max','100.0%',MaxVal1D(fProfile));
end;


procedure Test1DParamFuncs.TestMinVal1D_no_norm;
begin
AssertEquals('Test Min value, no normalisation','2.2',MinVal1D(fProfile));
end;


procedure Test1DParamFuncs.TestMinVal1D_norm_cax;
begin
fProfile.Norm := norm_cax;
AssertEquals('Test Min value, normalisation to Cax','0.00',MinVal1D(fProfile));
end;


procedure Test1DParamFuncs.TestMinVal1D_norm_max;
begin
fProfile.Norm := norm_max;
AssertEquals('Test Min value, normalisation to Max','0.00',MinVal1D(fProfile));
end;


procedure Test1DParamFuncs.TestMinIFA1D_no_norm;
begin
AssertEquals('Test Min IFA','94.5',MinIFA1D(fProfile));
end;


procedure Test1DParamFuncs.TestMinIFA1D_norm_cax;
begin
fProfile.Norm := norm_cax;
AssertEquals('Test Min IFA, normalisation to Cax','100.0%',MinIFA1D(fProfile));
end;


procedure Test1DParamFuncs.TestMinIFA1D_norm_max;
begin
fProfile.Norm := norm_max;
AssertEquals('Test Min IFA, normlisation to Max','95.4%',MinIFA1D(fProfile));
end;

{-------------------------------------------------------------------------------
 Interpolated parameters
-------------------------------------------------------------------------------}
procedure Test1DParamFuncs.TestFieldEdgeLeft501D;
begin
AssertEquals('Test field edge left 50%','-9.67 cm',FieldEdgeLeft501D(fProfile));
end;


procedure Test1DParamFuncs.TestFieldEdgeRight501D;
begin
AssertEquals('Test field edge right 50%','10.40 cm',FieldEdgeRight501D(fProfile));
end;


procedure Test1DParamFuncs.TestFieldCentre501D;
begin
AssertEquals('Test field centre 50%','0.37 cm',FieldCentre501D(fProfile));
end;


procedure Test1DParamFuncs.TestFieldSize501D;
begin
AssertEquals('Test field size 50%','20.08 cm',FieldSize501D(fProfile));
end;


procedure Test1DParamFuncs.TestNoFunc1D;
begin
AssertEquals('Test empty function','Parameter not found',NoFunc1D(fProfile));
end;


initialization
   RegisterTest(Test1DParamFuncs);
end.

