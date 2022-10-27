unit test1Dparams;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, fpcunit, testutils, testregistry, bstypes, param1Dfuncs, math;

type

   Test1DParamFuncs= class(TTestCase)
   private
      FProfile:TSingleProfile;
   protected
      procedure SetUp; override;
      procedure TearDown; override;
   published
      {field statistics}
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
      procedure TestAveIFA1D_no_norm;
      procedure TestAveIFA1D_norm_cax;
      procedure TestAveIFA1D_norm_max;
      {interpolated parameters}
      procedure TestFieldEdgeLeft501D;
      procedure TestFieldEdgeRight501D;
      procedure TestFieldCentre501D;
      procedure TestFieldSize501D;
      procedure TestPenumbra8020Left1D;
      procedure TestPenumbra8020Right1D;
      procedure TestPenumbra9010Left1D;
      procedure TestPenumbra9010Right1D;
      procedure TestPenumbra9050Left1D;
      procedure TestPenumbra9050Right1D;
      {differential parameters}
      procedure TestFieldDiffLeft1D;
      procedure TestFieldDiffRight1D;
      procedure TestFieldCentreDiff1D;
      procedure TestFieldSizeDiff1D;
      {inflection point parameters}
      procedure TestFieldInflLeft1D;
      procedure TestFieldInflRight1D;
      {flatness and uniformity parameters}
      procedure TestFlatnessAve1D;
      procedure TestFlatnessDiff1D;
      procedure TestFlatnessRatio1D;
      procedure TestFlatnessCAX1D;
      procedure TestUniformityAve1D;
      {symmetry parameters}
      procedure TestSymmetryRatio1D;
      procedure TestSymmetryDiff1D;
      procedure TestSymmetryArea1D_Odd;
      procedure TestSymmetryArea1D_Even;
      {deviation parameters}
      procedure TestDeviationRatio1D;
      procedure TestDeviationDiff1D;
      procedure TestDeviationCAX1D;
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
   ProfileIFA: array of double = (NaN, NaN, NaN, NaN, NaN, NaN, NaN,
   NaN, NaN, NaN, 98.38, 98.78, 98.86, 99, 98.89, 98.98, 98.8, 98.95,
   98.9, 98.52, 98.05, 97.31, 96.26, 95.38, 94.59, 94.53, 94.47, 94.46, 94.49,
   94.57, 94.7, 95.18, 95.51, 96.51, 97.32, 97.82, 97.95, 97.99, 97.98, 98.2,
   98.33, 98.31, 98.33, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN,
   NaN);

implementation

procedure Test1DParamFuncs.SetUp;
begin
fProfile := TSingleProfile.Create;
fProfile.PArrX := ProfileArrX;
fProfile.PArrY := ProfileArrY;
fprofile.IFA.PArrY := ProfileIFA;
fProfile.IFA.PArrX := fProfile.PArrX;
fProfile.Len := 53;
fProfile.IFA.Len := fProfile.Len;
end;


procedure Test1DParamFuncs.TearDown;
begin
fProfile.Free;
end;


{-------------------------------------------------------------------------------
 Field statistics
-------------------------------------------------------------------------------}
procedure Test1DParamFuncs.TestCAXVal1D_no_norm;
begin
AssertEquals('Test CAX value, no normalisation','94.47',CAXVal1D(fProfile));
end;


procedure Test1DParamFuncs.TestCAXVal1d_norm_cax;
begin
fProfile.Norm := norm_cax;
AssertEquals('Test CAX value, normalisation to CAX','100.0%',CAXVal1D(fProfile));
end;


procedure Test1DParamFuncs.TestCAXVal1D_norm_Max;
begin
fProfile.Norm := norm_max;
AssertEquals('Test CAX value, normlisation to Max','95.32%',CAXVal1D(fProfile));
end;


procedure Test1DParamFuncs.TestMaxVal1D_no_norm;
begin
AssertEquals('Test Max value, no normalisation','99.00',MaxVal1D(fProfile));
end;


procedure Test1DParamFuncs.TestMaxVal1D_norm_cax;
begin
fProfile.Norm := norm_cax;
AssertEquals('Test Max value, normalisation to Cax','104.91%',MaxVal1D(fProfile));
end;


procedure Test1DParamFuncs.TestMaxVal1D_norm_max;
begin
fProfile.Norm := norm_Max;
AssertEquals('Test Max value, normlisation to Max','100.00%',MaxVal1D(fProfile));
end;


procedure Test1DParamFuncs.TestMinVal1D_no_norm;
begin
AssertEquals('Test Min value, no normalisation','2.18',MinVal1D(fProfile));
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
AssertEquals('Test Min IFA','94.46',MinIFA1D(fProfile));
end;


procedure Test1DParamFuncs.TestMinIFA1D_norm_cax;
begin
fProfile.Norm := norm_cax;
AssertEquals('Test Min IFA, normalisation to Cax','99.99%',MinIFA1D(fProfile));
end;


procedure Test1DParamFuncs.TestMinIFA1D_norm_max;
begin
fProfile.Norm := norm_max;
AssertEquals('Test Min IFA, normalisation to Max','95.31%',MinIFA1D(fProfile));
end;

procedure Test1DParamFuncs.TestAveIFA1D_no_norm;
begin
AssertEquals('Test Average IFA','97.16',AveIFA1D(fProfile));
end;


procedure Test1DParamFuncs.TestAveIFA1D_norm_cax;
begin
fProfile.Norm := norm_cax;
AssertEquals('Test Average IFA, normalisation to Cax','102.92%',AveIFA1D(fProfile));
end;


procedure Test1DParamFuncs.TestAveIFA1D_norm_max;
begin
fProfile.Norm := norm_max;
AssertEquals('Test Average IFA, normalisation to Max','98.10%',AveIFA1D(fProfile));
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


procedure Test1DParamFuncs.TestPenumbra8020Left1D;
begin
AssertEquals('Test penumbra left 80-20%','0.65 cm',Penumbra8020Left1D(fProfile));
end;


procedure Test1DParamFuncs.TestPenumbra8020Right1D;
begin
AssertEquals('Test penumbra right 80-20%','0.71 cm',Penumbra8020Right1D(fProfile));
end;


procedure Test1DParamFuncs.TestPenumbra9010Left1D;
begin
AssertEquals('Test penumbra left 90-10%','1.32 cm',Penumbra9010Left1D(fProfile));
end;


procedure Test1DParamFuncs.TestPenumbra9010Right1D;
begin
AssertEquals('Test penumbra right 90-10%','1.26 cm',Penumbra9010Right1D(fProfile));
end;


procedure Test1DParamFuncs.TestPenumbra9050Left1D;
begin
AssertEquals('Test penumbra left 90-10%','0.51 cm',Penumbra9050Left1D(fProfile));
end;


procedure Test1DParamFuncs.TestPenumbra9050Right1D;
begin
AssertEquals('Test penumbra right 90-10%','0.34 cm',Penumbra9050Right1D(fProfile));
end;


{-------------------------------------------------------------------------------
 Differential parameters
-------------------------------------------------------------------------------}
procedure Test1DParamFuncs.TestFieldDiffLeft1D;
begin
AssertEquals('Test field differential left','-9.50 cm',FieldDiffLeft1D(fProfile));
end;


procedure Test1DParamFuncs.TestFieldDiffRight1D;
begin
AssertEquals('Test field differential right','10.50 cm',FieldDiffRight1D(fProfile));
end;


procedure Test1DParamFuncs.TestFieldCentreDiff1D;
begin
AssertEquals('Test field centre differential%','0.50 cm',FieldCentreDiff1D(fProfile));
end;


procedure Test1DParamFuncs.TestFieldSizeDiff1D;
begin
AssertEquals('Test field size differential%','20.00 cm',FieldSizeDiff1D(fProfile));
end;


{-------------------------------------------------------------------------------
 Inflection point parameters
-------------------------------------------------------------------------------}
procedure Test1DParamFuncs.TestFieldInflLeft1D;
begin
AssertEquals('Test field differential left','-9.60 cm',FieldInflLeft1D(fProfile));
end;


procedure Test1DParamFuncs.TestFieldInflRight1D;
begin
AssertEquals('Test field differential right','10.39 cm',FieldInflRight1D(fProfile));
end;


{-------------------------------------------------------------------------------
 Flatness and uniformity parameters
-------------------------------------------------------------------------------}

procedure Test1DParamFuncs.TestFlatnessAve1D;
begin
AssertEquals('Test flatness average of min max','102.39%',FlatnessAve1D(fProfile));
end;


procedure Test1DParamFuncs.TestFlatnessDiff1D;
begin
AssertEquals('Test flatness difference','2.35%',FlatnessDiff1D(fProfile));
end;


procedure Test1DParamFuncs.TestFlatnessRatio1D;
begin
AssertEquals('Test flatness ratio','104.81%',FlatnessRatio1D(fProfile));
end;


procedure Test1DParamFuncs.TestFlatnessCAX1D;
begin
AssertEquals('Test flatness CAX','2.40%',FlatnessCAX1D(fProfile));
end;


procedure Test1DParamFuncs.TestUniformityAve1D;
begin
AssertEquals('Test uniformity ICRU','4.67%',UniformityAve1D(fProfile));
end;


{-------------------------------------------------------------------------------
 Symmetry parameters
-------------------------------------------------------------------------------}

procedure Test1DParamFuncs.TestSymmetryRatio1D;
begin
AssertEquals('Test symmetry ratio','102.66%',SymmetryRatio1D(fProfile));
end;


procedure Test1DParamFuncs.TestSymmetryDiff1D;
begin
AssertEquals('Test symmetry difference','2.69%',SymmetryDiff1D(fProfile));
end;


procedure Test1DParamFuncs.TestSymmetryArea1D_Odd;
begin
AssertEquals('Test symmetry difference','0.28%',SymmetryArea1D(fProfile));
end;


procedure Test1DParamFuncs.TestSymmetryArea1D_Even;
begin
fProfile.Len := 52;
AssertEquals('Test symmetry difference','0.28%',SymmetryArea1D(fProfile));
end;


{-------------------------------------------------------------------------------
 Deviation parameters
-------------------------------------------------------------------------------}

procedure Test1DParamFuncs.TestDeviationRatio1D;
begin
AssertEquals('Test deviation ratio','104.80%',DeviationRatio1D(fProfile));
end;


procedure Test1DParamFuncs.TestDeviationDiff1D;
begin
AssertEquals('Test deviation difference','4.80%',DeviationDiff1D(fProfile));
end;


procedure Test1DParamFuncs.TestDeviationCAX1D;
begin
AssertEquals('Test deviation difference','4.81%',DeviationCAX1D(fProfile));
end;


{-------------------------------------------------------------------------------
 Miscellaneous parameters
-------------------------------------------------------------------------------}

procedure Test1DParamFuncs.TestNoFunc1D;
begin
AssertEquals('Test empty function','Parameter not found',NoFunc1D(fProfile));
end;


initialization
   RegisterTest(Test1DParamFuncs);
end.

