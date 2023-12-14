unit TestBSTypes;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, fpcunit, testutils, testregistry, bstypes, math;

type

   TestSingleProfile= class(TTestCase)
   private
      fProfile:TSingleProfile;
   protected
      procedure SetUp; override;
      procedure TearDown; override;
   published
      procedure TestGetCentre_odd;
      procedure TestGetCentre_even;
      procedure TestLeftEdge;
      procedure TestRightEdge;
      procedure TestLeftEdge_Limits;
      procedure TestRightEdge_Limits;
      procedure TestMin;
      procedure TestMax;
      procedure TestAve;
      procedure TestMaxDiff;
      procedure TestSlope;
      procedure TestPeakFWHM;
      procedure TestArea;
      procedure TestLeftDiff;
      procedure TestRightDiff;
      procedure TestPeakDiff;
      procedure TestHPLeft;
      procedure TestHPRight;
      procedure TestLeftInfl;
      procedure TestRightInfl;
      procedure TestPeakInfl;
      procedure TestGetRelPosValue0_Left;
      procedure TestGetRelPosValue0_Right;
      procedure TestGetRelPosValueFWHM_Left;
      procedure TestGetRelPosValueFWHM_Right;
      procedure TestGetRelPosValueInfl_Left;
      procedure TestGetRelPosValueInfl_Right;
      procedure TestGetRelPosValueDiff_Left;
      procedure TestGetRelPosValueDiff_Right;
      procedure TestNormalise_none;
      procedure TestNormalise_cax;
      procedure TestNormalise_max;
      procedure TestTop;
      procedure TestPeakLSlope;
      procedure TestPeakRSlope;
   end;

   TestBeam= class(TTestCase)
   private
      fBeam    :TBeam;
   protected
      procedure SetUp; override;
      procedure TearDown; override;
   published
      procedure TestCentre_RowOddCollOdd;
      procedure TestCentre_RowOddCollEven;
      procedure TestCentre_RowEvenCollOdd;
      procedure TestCentre_RowEvenCollEven;
      procedure TestCoM;
      procedure TestMin;
      procedure TestMax;
      procedure TestAve;
      procedure TestInvert;
      procedure TestRescale;
      procedure TestCentre;
      procedure TestCreateXProfile;
      procedure TestCreateYProfile;
      procedure TestCreateOffsetProfile;
      procedure TestCreateDiagonalProfile;
      procedure TestCreateWideProfile;
      procedure TestCreateDiagonalOffsetWideProfile;
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
    NaN, NaN, NaN, NaN, 98.78, 98.86, 99, 98.89, 98.98, 98.8, 98.95,
    98.9, 98.52, 98.05, 97.31, 96.26, 95.38, 94.59, 94.53, 94.47, 94.46, 94.49,
    94.57, 94.7, 95.18, 95.51, 96.51, 97.32, 97.82, 97.95, 97.99, 97.98, 98.2,
    98.33, 98.31, 98.33, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN,
    NaN);

    {profile taken from TestFiles/14-Feb-2008-A.txt X direction position 0.
    Causes edge detection to fail if limits not correct.}
    ProfileArrX2: array of double = (-11, -10.5, -10, -9.5, -9, -8.5, -8, -7.5,
    -7, -6.5, -6, -5.5, -5, -4.5, -4, -3.5, -3, -2.5, -2, -1.5, -1, -0.5, 0,
    0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5,
    10, 10.5, 11);
    ProfileArrY2: array of double = (6.99, 54.45, 78.09, 83.19, 89.54, 88.81,
    88.75, 88.69, 88.36, 89.35, 90.01, 90.43, 91.43, 91.65, 88.05, 88.89,
    88.71, 87.7, 83.63, 87.44, 89.77, 88.88, 86.41, 87.68, 89.17, 87.74, 88.59,
    88.92, 92.95, 89.75, 90.66, 89.94, 94.57, 91.45, 89.57, 88.37, 87.25,
    87.51, 87.38, 86.8, 86.45, 82.94, 79.79, 55.68, 7.29);


    {profile taken from TestFiles/2-Sep-2011-A.txt Y direction position 0}
    ProfileArrX3: array of double = (-16,-15.5,-15,-14.5,-14,-13.5,-13,-12.5,
    -12,-11.5,-11,-10.5,-10,-9.5,-9,-8.5,-8,-7.5,-7,-6.5,-6,-5.5,-5,-4.5,-4,
    -3.5,-3,-2.5,-2,-1.5,-1,-0.5,0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5,5.5,6,6.5,7,
    7.5,8,8.5,9,9.5,10,10.5,11,11.5,12,12.5,13,13.5,14,14.5,15,15.5,16);
    ProfileArrY3: array of double = (2.26,2.47,2.64,3,3.33,3.76,4.2,4.79,5.48,
    6.47,7.82,12.57,51.86,88.72,95.73,96.52,97.17,97.51,97.57,97.89,97.99,97.94,
    97.78,97.76,97.3,97.01,96.39,95.8,95.02,94.84,94.5,94.45,94.47,94.61,94.87,
    95.25,95.63,96.25,96.8,97.32,97.77,97.93,97.9,98.02,98.13,98.12,98.01,97.81,
    97.48,96.62,95.25,87.88,34.17,10.08,6.93,5.9,5.01,4.38,3.76,3.45,3.07,2.74,
    2.38,2.27,2.09);
    ProfileIFA3: array of double = (NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,
    NaN,NaN,NaN,NaN,NaN,NaN,NaN,97.17,97.51,97.57,97.89,97.99,97.94,
    97.78,97.76,97.3,97.01,96.39,95.8,95.02,94.84,94.5,94.45,94.47,94.61,94.87,
    95.25,95.63,96.25,96.8,97.32,97.77,97.93,97.9,98.02,98.13,98.12,98.01,97.81,
    NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,
    NaN,NaN,NaN);

    {profile taken from TestFiles/2-Sep-2011-A.txt X direction position 20}
    ProfileArrX4: array of double = (-13, -12.5, -12, -11.5, -11, -10.5, -10,
    -9.5, -9, -8.5, -8, -7.5, -7, -6.5, -6, -5.5, -5, -4.5, -4, -3.5, -3, -2.5,
    -2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5,
    7, 7.5, 8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 12, 12.5, 13);
    ProfileArrY4: array of double = (0,0,2.18,2.87,3.58,5.6,9.02,28.11,47.2,
    49.28,51.36,51.63,51.9,52.15,52.39,52.03,51.67,52.01,52.34,52.93,53.51,
    52.72,51.92,52.14,52.36,52.11,51.86,51.15,50.43,51.35,52.27,52.78,53.28,
    52.91,52.55,51.92,51.29,53.49,55.68,55.53,55.38,55.29,55.2,56.04,56.87,
    53.89,50.92,16.86,6.65,4.65,3.17,0,0);

    {profile taken from TestFiles/2-Sep-2011-A.txt angle 45 offset 0 width 1}
    ProfileArrX5: array of double = (-18.38, -17.89, -17.39, -16.89, -16.4,
    -15.9, -15.4, -14.91, -14.41, -13.91, -13.42, -12.92, -12.42, -11.93,
    -11.43, -10.93, -10.43, -9.94, -9.44, -8.94, -8.45, -7.95, -7.45, -6.96,
    -6.46, -5.96, -5.47, -4.97, -4.47, -3.98, -3.48, -2.98, -2.48, -1.99,
    -1.49, -0.99, -0.5, 0, 0.5, 0.99, 1.49, 1.99, 2.48, 2.98, 3.48, 3.98,
    4.47, 4.97, 5.47, 5.96, 6.46, 6.96, 7.45, 7.95, 8.45, 8.94, 9.44, 9.94,
    10.43, 10.93, 11.43, 11.93, 12.42, 12.92, 13.42, 13.91, 14.41, 14.91,
    15.4, 15.9, 16.4, 16.89, 17.39, 17.89, 18.38);
    ProfileArrY5: array of double = (0, 0, 0, 0, 0, 2.74, 2.74, 3.82, 9.02,
    9.02, 60.6, 93.61, 93.61, 97, 97.89, 98.67, 98.67, 98.78, 98.93, 98.93,
    98.67, 98.37, 98.37, 98.56, 98.45, 98.51, 98.51, 98.47, 98.23, 98.23,
    98.11, 97.15, 97.15, 96.02, 94.92, 94.49, 94.49, 94.47, 94.52, 94.52,
    94.41, 94.72, 95.49, 95.49, 96.3, 97.77, 97.77, 98.26, 98.12, 98.12, 98.46,
    98.27, 98.5, 98.5, 98.79, 98.66, 98.66, 98.67, 98.62, 98.62, 98.26, 97.83,
    95.94, 95.94, 88.1, 31.8, 31.8, 5.54, 3.49, 3.49, 0, 0, 0, 0, 0);
    ProfileIFA5: array of double = (NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN,
    NaN,NaN,NaN,NaN,NaN,NaN,98.67, 98.67, 98.78, 98.93, 98.93, 98.67, 98.37,
    98.37, 98.56, 98.45, 98.51, 98.51, 98.47, 98.23, 98.23, 98.11, 97.15, 97.15,
    96.02, 94.92, 94.49, 94.49, 94.47, 94.52, 94.52, 94.41, 94.72, 95.49, 95.49,
    96.3, 97.77, 97.77, 98.26, 98.12, 98.12, 98.46, 98.27, 98.5, 98.5, 98.79,
    98.66, 98.66, 98.67, 98.62, 98.62, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN,
    NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN);

    {profile taken from TestFiles/2-Sep-2011-A.txt angle -20, width 11, offset -16 }
    ProfileArrX6: array of double = (-13.84, -13.34, -12.83, -12.33, -11.83,
    -11.32, -10.82, -10.32, -9.81, -9.31, -8.81, -8.3, -7.8, -7.3, -6.79, -6.29,
    -5.79, -5.28, -4.78, -4.28, -3.77, -3.27, -2.77, -2.26, -1.76, -1.26, -0.75,
    -0.25, 0.25, 0.75, 1.26, 1.76, 2.26, 2.77, 3.27, 3.77, 4.28, 4.78, 5.28,
    5.79, 6.29, 6.79, 7.3, 7.8, 8.3, 8.81, 9.31, 9.81, 10.32, 10.82, 11.32,
    11.83, 12.33, 12.83, 13.34, 13.84);
    ProfileArrY6: array of double = (0, 0, 0, 0, 0, 7.4, 12.33, 21.68, 43.5,
    114.99, 150.99, 261.16, 269.23, 270.8, 363.5, 361.83, 367.35, 461.32,
    460.83, 542.03, 549.07, 545.53, 635.79, 635.48, 638.15, 729.4, 727.42,
    733.38, 819.29, 821.95, 900.93, 912.22, 911.55, 1001.24, 1001.97, 1002.47,
    1063.27, 1066.15, 1065.8, 1076.24, 1078.98, 1080.03, 1083.97, 1083.89,
    1084.34, 1083.81, 1078.48, 1067.31, 927.67, 694.05, 430.67, 226.61, 106.01,
    59.24, 39.24, 19.3);
    ProfileIFA6: array of double = (NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN,
    NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 98.65, 98.33, 97.96,
    196.09, 196.08, 195.78, 293.81, 293.55, 391.81, 392.32, 392.12, 490.31,
    490.63, 490.96, 589.1, 589.58, 589.51, 688.04, 688.18, 786.98, 787.54,
    788.5, 888, 888.05, 789.67, 493.53, 295.8, NaN, NaN, NaN, NaN, NaN, NaN,
    NaN, NaN, NaN);

implementation

uses importunit;

{-------------------------------------------------------------------------------
TSingleProfile
-------------------------------------------------------------------------------}

procedure TestSingleProfile.SetUp;
begin
fProfile := TSingleProfile.Create;
fProfile.Len := 53;
fProfile.PArrX := ProfileArrX;
fProfile.PArrY := ProfileArrY;
fProfile.Res := 0.5;
fProfile.Norm := no_norm;
end;

procedure TestSingleProfile.TearDown;
begin
fProfile.Free;
end;


procedure TestSingleProfile.TestGetCentre_odd;
begin
AssertEquals('Test Centre value, odd length',94.47,fProfile.Centre.ValueY);
AssertEquals('Test Centre position, odd length',0,fProfile.Centre.ValueX);
AssertEquals('Test Centre index, odd length',26,fProfile.Centre.Pos);
end;


procedure TestSingleProfile.TestGetCentre_even;
begin
fProfile.Len := 52;
AssertEquals('Test Centre value, odd length',94.5,fProfile.Centre.ValueY);
AssertEquals('Test Centre position, odd length',-0.25,fProfile.Centre.ValueX);
AssertEquals('Test Centre index, odd length',25,fProfile.Centre.Pos);
end;


procedure TestSingleProfile.TestLeftEdge;
begin
AssertEquals('Test left edge value',47.235,fProfile.LeftEdge.ValueY);
AssertEquals('Test left edge position',-9.6708,fProfile.LeftEdge.ValueX);
AssertEquals('Test left edge index',7,fProfile.LeftEdge.Pos);
end;


procedure TestSingleProfile.TestRightEdge;
begin
AssertEquals('Test right edge value',47.235,fProfile.RightEdge.ValueY);
AssertEquals('Test right edge position',10.4049,fProfile.RightEdge.ValueX);
AssertEquals('Test right edge index',46,fProfile.RightEdge.Pos);
end;


procedure TestSingleProfile.TestLeftEdge_Limits;
begin
fProfile.ResetAll;
fProfile.PArrX := ProfileArrX2;
fProfile.PArrY := ProfileArrY2;
fProfile.Len := 45;
AssertEquals('Test extreme left edge value',43.205,fProfile.LeftEdge.ValueY);
AssertEquals('Test extreme left edge position',-10.6185,fProfile.LeftEdge.ValueX);
AssertEquals('Test extreme left edge index',1,fProfile.LeftEdge.Pos);
end;


procedure TestSingleProfile.TestRightEdge_Limits;
begin
fProfile.ResetAll;
fProfile.PArrX := ProfileArrX2;
fProfile.PArrY := ProfileArrY2;
fProfile.Len := 45;
AssertEquals('Test extreme right edge value',43.205,fProfile.RightEdge.ValueY);
AssertEquals('Test extreme right edge position',10.6289,fProfile.RightEdge.ValueX);
AssertEquals('Test extreme right edge index',43,fProfile.RightEdge.Pos);
end;


procedure TestSingleProfile.TestMin;
begin
AssertEquals('Test minimum value',2.18,fProfile.Min.ValueY);
AssertEquals('Test minimum position',-13,fProfile.Min.ValueX);
AssertEquals('Test minimum index',0,fProfile.Min.Pos);
end;


procedure TestSingleProfile.TestMax;
begin
AssertEquals('Test maximum value',99.0,fProfile.Max.ValueY);
AssertEquals('Test maximum position',-6.5,fProfile.Max.ValueX);
AssertEquals('Test maximum index',13,fProfile.Max.Pos);
end;


procedure TestSingleProfile.TestAve;
begin
AssertEquals('Test average value',74.67566,fProfile.Ave);
end;


procedure TestSingleProfile.TestMaxDiff;
begin
AssertEquals('Test maximum difference', 76.76, fProfile.MaxDiff);
end;


procedure TestSingleProfile.TestSlope;
begin
AssertEquals ('Test slope',-0.0853542780748663,fProfile.GetSlope(10,43));
end;

procedure TestSingleProfile.TestPeakFWHM;
begin
AssertEquals('Test peak value',94.46,fProfile.PeakFWHM.ValueY);
AssertEquals('Test peak position',0.3671,fProfile.PeakFWHM.ValueX);
AssertEquals('Test peak index',27,fProfile.PeakFWHM.Pos);
end;


procedure TestSingleProfile.TestArea;
begin
AssertEquals('Test area value',77231.8,fProfile.GetArea(6,46));
end;


procedure TestSingleProfile.TestLeftDiff;
begin
AssertEquals('Test left Diff value',79.52,fProfile.LeftDiff.ValueY);
AssertEquals('Test left Diff position',-9.5,fProfile.LeftDiff.ValueX);
AssertEquals('Test left Diff index',7,fProfile.LeftDiff.Pos);
end;


procedure TestSingleProfile.TestRightDiff;
begin
AssertEquals('Test right Diff value',-80.02,fProfile.RightDiff.ValueY);
AssertEquals('Test right Diff position',10.5,fProfile.RightDiff.ValueX);
AssertEquals('Test right Diff index',47,fProfile.RightDiff.Pos);
end;


procedure TestSingleProfile.TestPeakDiff;
begin
AssertEquals('Test peak value',94.46,fProfile.PeakDiff.ValueY);
AssertEquals('Test peak position',0.50,fProfile.PeakDiff.ValueX);
AssertEquals('Test peak index',27,fProfile.PeakDiff.Pos);
end;


procedure TestSingleProfile.TestHPLeft;
begin
AssertEquals('Test B[0] high limit',4.2034,fProfile.HPLeft[0]);
AssertEquals('Test B[1] low limit',98.5943,fProfile.HPLeft[1]);
AssertEquals('Test B[2] initial inf point',-9.6059,fProfile.HPLeft[2]);
AssertEquals('Test B[3] slope',-47.7425,fProfile.HPLeft[3]);
end;


procedure TestSingleProfile.TestHPRight;
begin
AssertEquals('Test B[0] high limit',97.9828,fProfile.HPRight[0]);
AssertEquals('Test B[1] low limit',5.7595,fProfile.HPRight[1]);
AssertEquals('Test B[2] initial inf point',10.3945,fProfile.HPRight[2]);
AssertEquals('Test B[3] slope',63.1277,fProfile.HPRight[3]);
end;


procedure TestSingleProfile.TestLeftInfl;
begin
AssertEquals('Test left Infl value',52.3874,fProfile.LeftInfl.ValueY);
AssertEquals('Test left Infl position',-9.5975,fProfile.LeftInfl.ValueX);
AssertEquals('Test left Infl index',7,fProfile.LeftInfl.Pos);
end;


procedure TestSingleProfile.TestRightInfl;
begin
AssertEquals('Test Right Infl value',52.6016,fProfile.RightInfl.ValueY);
AssertEquals('Test Right Infl position',10.3892,fProfile.RightInfl.ValueX);
AssertEquals('Test Right Infl index',46,fProfile.RightInfl.Pos);
end;


procedure TestSingleProfile.TestPeakInfl;
begin
AssertEquals('Test peak value',94.46,fProfile.PeakInfl.ValueY);
AssertEquals('Test peak position',0.3959,fProfile.PeakInfl.ValueX);
AssertEquals('Test peak index',27,fProfile.PeakInfl.Pos);
end;


procedure TestSingleProfile.TestGetRelPosValue0_Left;
begin
AssertEquals('Test left 100% FWHM value',94.4627,fProfile.GetRelPosValue(0.0, fProfile.LeftEdge, fProfile.PeakFWHM).ValueY);
AssertEquals('Test left 100% FWHM position',0.3671,fProfile.GetRelPosValue(0.0, fProfile.LeftEdge, fProfile.PeakFWHM).ValueX);
AssertEquals('Test left 100% FWHM index',27,fProfile.GetRelPosValue(0.0, fProfile.LeftEdge, fProfile.PeakFWHM).Pos);
end;


procedure TestSingleProfile.TestGetRelPosValue0_Right;
begin
AssertEquals('Test left 100% FWHM value',94.4627,fProfile.GetRelPosValue(0.0, fProfile.RightEdge, fProfile.PeakFWHM).ValueY);
AssertEquals('Test left 100% FWHM position',0.3671,fProfile.GetRelPosValue(0.0, fProfile.RightEdge, fProfile.PeakFWHM).ValueX);
AssertEquals('Test left 100% FWHM index',27,fProfile.GetRelPosValue(0.0, fProfile.RightEdge, fProfile.PeakFWHM).Pos);
end;


procedure TestSingleProfile.TestGetRelPosValueFWHM_Left;
begin
AssertEquals('Test left 100% FWHM value',47.235,fProfile.GetRelPosValue(1.0, fProfile.LeftEdge, fProfile.PeakFWHM).ValueY);
AssertEquals('Test left 100% FWHM position',-9.6708,fProfile.GetRelPosValue(1.0, fProfile.LeftEdge, fProfile.PeakFWHM).ValueX);
AssertEquals('Test left 100% FWHM index',7,fProfile.GetRelPosValue(1.0, fProfile.LeftEdge, fProfile.PeakFWHM).Pos);
end;


procedure TestSingleProfile.TestGetRelPosValueFWHM_Right;
begin
AssertEquals('Test left 100% FWHM value',47.235,fProfile.GetRelPosValue(1.0, fProfile.RightEdge, fProfile.PeakFWHM).ValueY);
AssertEquals('Test left 100% FWHM position',10.4049,fProfile.GetRelPosValue(1.0, fProfile.RightEdge, fProfile.PeakFWHM).ValueX);
AssertEquals('Test left 100% FWHM index',46,fProfile.GetRelPosValue(1.0, fProfile.RightEdge, fProfile.PeakFWHM).Pos);
end;


procedure TestSingleProfile.TestGetRelPosValueInfl_Left;
begin
AssertEquals('Test left 100% inflection value',54.3128,fProfile.GetRelPosValue(1.0, fProfile.LeftInfl, fProfile.PeakInfl).ValueY);
AssertEquals('Test left 100% inflection position',-9.5975,fProfile.GetRelPosValue(1.0, fProfile.LeftInfl, fProfile.PeakInfl).ValueX);
AssertEquals('Test left 100% inflection index',7,fProfile.GetRelPosValue(1.0, fProfile.LeftInfl, fProfile.PeakInfl).Pos);
end;


procedure TestSingleProfile.TestGetRelPosValueInfl_Right;
begin
AssertEquals('Test left 100% inflection value',48.9789,fProfile.GetRelPosValue(1.0, fProfile.RightInfl, fProfile.PeakInfl).ValueY);
AssertEquals('Test left 100% inflection position',10.3892,fProfile.GetRelPosValue(1.0, fProfile.RightInfl, fProfile.PeakInfl).ValueX);
AssertEquals('Test left 100% inflection index',46,fProfile.GetRelPosValue(1.0, fProfile.RightInfl, fProfile.PeakInfl).Pos);
end;


procedure TestSingleProfile.TestGetRelPosValueDiff_Left;
begin
AssertEquals('Test left 100% max gradient value',63.73,fProfile.GetRelPosValue(1.0, fProfile.LeftDiff, fProfile.PeakDiff).ValueY);
AssertEquals('Test left 100% max gradient position',-9.5,fProfile.GetRelPosValue(1.0, fProfile.LeftDiff, fProfile.PeakDiff).ValueX);
AssertEquals('Test left 100% max gradient index',7,fProfile.GetRelPosValue(1.0, fProfile.LeftDiff, fProfile.PeakDiff).Pos);
end;


procedure TestSingleProfile.TestGetRelPosValueDiff_Right;
begin
AssertEquals('Test left 100% max gradient value',36.68,fProfile.GetRelPosValue(1.0, fProfile.RightDiff, fProfile.PeakDiff).ValueY);
AssertEquals('Test left 100% max gradient position',10.5,fProfile.GetRelPosValue(1.0, fProfile.RightDiff, fProfile.PeakDiff).ValueX);
AssertEquals('Test left 100% max gradient index',47,fProfile.GetRelPosValue(1.0, fProfile.RightDiff, fProfile.PeakDiff).Pos);
end;


procedure TestSingleProfile.TestNormalise_none;
begin
AssertEquals('Test maximum value no normalisation',99.0,fprofile.Normalise(fProfile.Max.ValueY));
end;


procedure TestSingleProfile.TestNormalise_cax;
begin
fProfile.Norm := norm_cax;
AssertEquals('Test maximum value norm cax',104.9084,fprofile.Normalise(fProfile.Max.ValueY));
end;


procedure TestSingleProfile.TestNormalise_max;
begin
fProfile.Norm := norm_max;
AssertEquals('Test maximum value norm max',100.0,fprofile.Normalise(fProfile.Max.ValueY));
end;


procedure TestSingleProfile.TestTop;
begin
AssertEquals('Test parabola peak value',94.3967, fprofile.Top.ValueY);
AssertEquals('Test parabola peak position',0.599,fprofile.Top.ValueX);
AssertEquals('Test parabola peak index',27,fprofile.Top.Pos);
end;


procedure TestSingleProfile.TestPeakLSlope;
begin
AssertEquals('Test peak left slope',-0.2189,fprofile.PeakLSlope);
end;


procedure TestSingleProfile.TestPeakRSlope;
begin
AssertEquals('Test peak left slope',0.5195,fprofile.PeakRSlope);
end;


{-------------------------------------------------------------------------------
TBeam
-------------------------------------------------------------------------------}

procedure TestBeam.SetUp;
begin
fBeam := TBeam.Create;
MapCheckOpen('../TestFiles/2-Sep-2011-A.txt',fBeam);
IFAType := Proportional;
IFAFactor := 0.8;
end;


procedure TestBeam.TearDown;
begin
fBeam.Free;
end;


procedure TestBeam.TestMin;
begin
AssertEquals('Test minimum value', 0, fBeam.Min);
end;


procedure TestBeam.TestMax;
begin
AssertEquals('Test maximum value', 100, fBeam.Max);
end;


procedure TestBeam.TestAve;
begin
AssertEquals('Test average value', 46.9404, fBeam.Ave);
end;


procedure TestBeam.TestCentre_RowOddCollOdd;
begin
AssertEquals('Test centre value, row odd, col odd',94.465155720206312,fBeam.Centre);
end;


procedure TestBeam.TestCentre_RowOddCollEven;
begin
fBeam.Cols := 52;
AssertEquals('Test centre value, row odd, col odd',94.495596,fBeam.Centre);
end;


procedure TestBeam.TestCentre_RowEvenCollOdd;
begin
fBeam.Rows := 64;
AssertEquals('Test centre value, row odd, col odd',94.459332,fBeam.Centre);
end;


procedure TestBeam.TestCentre_RowEvenCollEven;
begin
fBeam.Rows := 64;
fBeam.Cols := 52;
AssertEquals('Test centre value, row odd, col odd',94.482744,fBeam.Centre);
end;


procedure TestBeam.TestCoM;
begin
AssertEquals('Test CoM X row value',31.5244,fBeam.CoM.X);
AssertEquals('Test CoM Y row value',26.5238,fBeam.CoM.Y);
end;


procedure TestBeam.TestInvert;
begin
fBeam.Invert;
AssertEquals('Inverted CAX',5.5348,fBeam.Centre);
AssertEquals('Inverted top left',100,fBeam.Data[0,0]);
AssertEquals('Inverted top right',100,fBeam.Data[0,52]);
AssertEquals('Inverted bottom left',100,fBeam.Data[64,0]);
AssertEquals('Inverted bottom right',100,fBeam.Data[64,52]);
end;


procedure TestBeam.TestReScale;
{Rescale must return values to 100}
var I,J        :integer;
    Z          :double;
begin
for I:=0 to fBeam.Rows - 1 do
  for J:=0 to fBeam.Cols - 1 do
     begin
     Z := fBeam.Data[I,J];
     Z := Z/100;
     fBeam.Data[I,J] := Z;
     end;
fBeam.ResetParams;
fBeam.Rescale;
AssertEquals('Rescaled max',100,fBeam.Max);
end;


procedure TestBeam.TestCentre;
begin
fbeam.CentreData;
AssertEquals('Centered CAX',94.4355,fBeam.Centre);
end;


procedure TestBeam.TestCreateXProfile;
var I          :integer;
    Prof       :TSingleProfile;
begin
Prof := TSingleProfile.Create;
Prof.SetParams(0,0,1);
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
   try
   AssertEquals('Length ',53,Prof.Len);
   AssertEquals('Resolution ',0.5,Prof.Res);
   for I:=0 to Prof.Len - 1 do
      begin
      AssertEquals('Horizontal Profile X value ' + IntToStr(I),ProfileArrX[I],Prof.PArrX[I]);
      AssertEquals('Horizontal Profile Y value ' + IntToStr(I),ProfileArrY[I],Prof.PArrY[I],0.01);
      if not IsNaN(ProfileIFA[I]) or not IsNaN(Prof.IFA.PArrY[I]) then
         AssertEquals('Horizontal Profile IFA value ' + IntToStr(I),ProfileIFA[I],Prof.IFA.PArrY[I],0.01);
      end;
   finally
   Prof.Free;
   end;
end;


procedure TestBeam.TestCreateYProfile;
var I          :integer;
    Prof       :TSingleProfile;
begin
Prof := TSingleProfile.Create;
Prof.SetParams(90,0,1);
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
   try
   AssertEquals('Length ',65,Prof.Len);
   AssertEquals('Resolution ',0.5,Prof.Res);
   for I:=0 to Prof.Len - 1 do
      begin
      AssertEquals('Vertical Profile X value ' + IntToStr(I),ProfileArrX3[I],Prof.PArrX[I]);
      AssertEquals('Vertical Profile Y value ' + IntToStr(I),ProfileArrY3[I],Prof.PArrY[I],0.01);
      if not IsNaN(ProfileIFA3[I]) or not IsNaN(Prof.IFA.PArrY[I]) then
         AssertEquals('Vertical Profile IFA value ' + IntToStr(I),ProfileIFA3[I],Prof.IFA.PArrY[I],0.01);
      end;
   finally
   Prof.Free;
end;
end;


procedure TestBeam.TestCreateOffsetProfile;
var I          :integer;
    Prof       :TSingleProfile;
begin
Prof := TSingleProfile.Create;
Prof.SetParams(0,-20,1);
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
   try
   for I:=0 to Prof.Len - 1 do
      begin
      AssertEquals('Offset Profile X value ' + IntToStr(I),ProfileArrX4[I],Prof.PArrX[I]);
      AssertEquals('Offset Profile Y value ' + IntToStr(I),ProfileArrY4[I],Prof.PArrY[I],0.01);
      AssertTrue(IsNaN(Prof.IFA.PArrY[I]));          {profile lies outside in field area}
      end;
   finally
   Prof.Free;
   end;
end;


procedure TestBeam.TestCreateDiagonalProfile;
var I          :integer;
    Prof       :TSingleProfile;
begin
Prof := TSingleProfile.Create;
Prof.SetParams(45,0,1);
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
   try
   for I:=0 to Prof.Len - 1 do
      begin
      AssertEquals('Diagonal Profile X value ' + IntToStr(I),ProfileArrX5[I],Prof.PArrX[I],0.01);
      AssertEquals('Diagonal Profile Y value ' + IntToStr(I),ProfileArrY5[I],Prof.PArrY[I],0.01);
      if not IsNaN(ProfileIFA5[I]) or not IsNaN(Prof.IFA.PArrY[I]) then
         AssertEquals('Diagonal Profile IFA value ' + IntToStr(I),ProfileIFA5[I],Prof.IFA.PArrY[I],0.01);
      end;
   finally
   Prof.Free;
   end;
end;


procedure TestBeam.TestCreateWideProfile;
var Prof       :TSingleProfile;
begin
Prof := TSingleProfile.Create;
Prof.SetParams(0,0,41);
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
   try
   AssertEquals('Wide profile centre value ',3840.04,Prof.Centre.ValueY,0.01);
   finally
   Prof.Free;
   end;
end;


procedure TestBeam.TestCreateDiagonalOffsetWideProfile;
var I          :integer;
    Prof       :TSingleProfile;
begin
Prof := TSingleProfile.Create;
Prof.SetParams(-20,16,11);
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
   try
   for I:=0 to Prof.Len - 1 do
      begin
      AssertEquals('Diagonal Profile X value ' + IntToStr(I),ProfileArrX6[I],Prof.PArrX[I],0.01);
      AssertEquals('Diagonal Profile Y value ' + IntToStr(I),ProfileArrY6[I],Prof.PArrY[I],0.01);
      if not IsNaN(ProfileIFA6[I]) or not IsNaN(Prof.IFA.PArrY[I]) then
         AssertEquals('Diagonal Profile IFA value ' + IntToStr(I),ProfileIFA6[I],Prof.IFA.PArrY[I],0.01);
      end;
   finally
   Prof.Free;
   end
end;


initialization
   RegisterTest(TestSingleProfile);
   RegisterTest(TestBeam);
end.

