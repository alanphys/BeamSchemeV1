unit TestBSTypes;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, fpcunit, testutils, testregistry, bstypes;

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
      procedure TestIFA;
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

implementation

uses importunit;

{-------------------------------------------------------------------------------
TSingleProfile
-------------------------------------------------------------------------------}

procedure TestSingleProfile.SetUp;
begin
fProfile := TSingleProfile.Create;
fProfile.PArrX := ProfileArrX;
fProfile.PArrY := ProfileArrY;
fProfile.Len := 53;
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
AssertEquals('Test left edge index',6,fProfile.LeftEdge.Pos);
end;


procedure TestSingleProfile.TestRightEdge;
begin
AssertEquals('Test right edge value',47.235,fProfile.RightEdge.ValueY);
AssertEquals('Test right edge position',10.4049,fProfile.RightEdge.ValueX);
AssertEquals('Test right edge index',47,fProfile.RightEdge.Pos);
end;


procedure TestSingleProfile.TestLeftEdge_Limits;
begin
fProfile.ResetAll;
fProfile.PArrX := ProfileArrX2;
fProfile.PArrY := ProfileArrY2;
fProfile.Len := 45;
AssertEquals('Test extreme left edge value',43.205,fProfile.LeftEdge.ValueY);
AssertEquals('Test extreme left edge position',-10.6185,fProfile.LeftEdge.ValueX);
AssertEquals('Test extreme left edge index',0,fProfile.LeftEdge.Pos);
end;


procedure TestSingleProfile.TestRightEdge_Limits;
begin
fProfile.ResetAll;
fProfile.PArrX := ProfileArrX2;
fProfile.PArrY := ProfileArrY2;
fProfile.Len := 45;
AssertEquals('Test extreme right edge value',43.205,fProfile.RightEdge.ValueY);
AssertEquals('Test extreme right edge position',10.6289,fProfile.RightEdge.ValueX);
AssertEquals('Test extreme right edge index',44,fProfile.RightEdge.Pos);
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


procedure TestSingleProfile.TestIFA;
begin
AssertEquals('Test IFA start index',98.38,fProfile.InFieldArea[0]);
AssertEquals('Test IFA end index',98.33,fProfile.InFieldArea[Length(fProfile.InFieldArea)-1]);
end;

{-------------------------------------------------------------------------------
TBeam
-------------------------------------------------------------------------------}

procedure TestBeam.SetUp;
begin
fBeam := TBeam.Create;
MapCheckOpen('../TestFiles/2-Sep-2011-A.txt',fBeam);
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


procedure TestBeam.TestCentre_RowOddCollOdd;
begin
AssertEquals('Test centre value, row odd, col odd',94.465155720206312,fBeam.Centre);
end;


procedure TestBeam.TestCentre_RowOddCollEven;
begin
fBeam.Cols := 54;
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
fBeam.Cols := 54;
AssertEquals('Test centre value, row odd, col odd',94.482744,fBeam.Centre);
end;


procedure TestBeam.TestCoM;
begin
AssertEquals('Test CoM X row value',31.5244,fBeam.CoM.X);
AssertEquals('Test CoM Y row value',26.5238,fBeam.CoM.Y);
end;


initialization
   RegisterTest(TestSingleProfile);
   RegisterTest(TestBeam);
end.

