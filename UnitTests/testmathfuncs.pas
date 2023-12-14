unit testmathfuncs;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, fpcunit, testutils, testregistry;

type

   TestMathsFuncs= class(TTestCase)
   protected
      procedure SetUp; override;
      procedure TearDown; override;
   published
      procedure TestLReg;
      procedure TestILReg;
      procedure TestLinReg;
      procedure TestMaxPosNan;
      procedure TestMaxPosNanInv;
      procedure TestMinPosNan;
      procedure TestMinPosNanInv;
      procedure TestHillFit;
      procedure TestHillCoeffs;
      procedure TestInvHillFunc;
      procedure TestInflHillFunc;
      procedure TestParabolaFit;
      procedure TestParabolaZero;
   end;

var ArrX :array of double = (20, 40, 60, 80, 100, 120, 140, 160, 180, 200);
    ArrY :array of double = (1.03, 0.99, 0.82, 0.59, 0.48, 0.33, 0.23, 0.17, 0.19, 0.17);


implementation

uses mathsfuncs;

procedure TestMathsFuncs.SetUp;
begin

end;

procedure TestMathsFuncs.TearDown;
begin

end;


procedure TestMathsFuncs.TestLReg;
begin
AssertEquals('Two point linear regression Y value',95.82,LReg(-2.0,-1.5,96.26,95.38,-1.75));
end;


procedure TestMathsFuncs.TestILReg;
begin
AssertEquals('Two point inverse linear regression Y value',-1.75,ILReg(-2.0,-1.5,96.26,95.38,95.82));
end;


procedure TestMathsFuncs.TestLinReg;
var Coeffs: array of double;
begin
SetLength(Coeffs,2);
LinReg(ArrX,ArrY,Coeffs);
AssertEquals('Multi point linear regression intercept',1.094,Coeffs[0]);
AssertEquals('Multi point linear regression slope',-0.0054,Coeffs[1]);
end;


procedure TestMathsFuncs.TestMaxPosNan;
var MaxPos     :T1DValuePos;
begin
MaxPos := MaxPosNan(ArrY,0,Length(ArrY));
AssertEquals('Max value',1.03,MaxPos.Val);
AssertEquals('Max position',0,MaxPos.Pos);
end;


procedure TestMathsFuncs.TestMaxPosNanInv;
{test MaxPosNan with bounds inverted}
var MaxPos     :T1DValuePos;
begin
MaxPos := MaxPosNan(ArrY,Length(ArrY),0);
AssertEquals('Max value',1.03,MaxPos.Val);
AssertEquals('Max position',0,MaxPos.Pos);
end;


procedure TestMathsFuncs.TestMinPosNan;
var MinPos     :T1DValuePos;
begin
MinPos := MinPosNan(ArrY,0,Length(ArrY));
AssertEquals('Min value',0.17,MinPos.Val);
AssertEquals('Min position',7,MinPos.Pos);
end;


procedure TestMathsFuncs.TestMinPosNanInv;
{test MinPosNan with bounds inverted}
var MinPos     :T1DValuePos;
begin
MinPos := MinPosNan(ArrY,Length(ArrY),0);
AssertEquals('Min value',0.17,MinPos.Val);
AssertEquals('Min position',9,MinPos.Pos);
end;


procedure TestMathsFuncs.TestHillCoeffs;
var Coeffs: array of double;
begin
SetLength(Coeffs,4);
Coeffs[0] := ArrY[0];
Coeffs[1] := ArrY[High(ArrY)];
Coeffs[2] := ArrX[MinPosNan(Diff(ArrY),0,Length(ArrY)-1).Pos];
AssertEquals('Estimate Hill Coefficient',3.2093,CoeffHillFunc(60,80,0.82,0.59, Coeffs));
end;


procedure TestMathsFuncs.TestHillFit;
var Coeffs: array of double;
begin
SetLength(Coeffs,4);
HillFitParams(ArrX,ArrY,Coeffs);
AssertEquals('Hill B0',1.04378509,Coeffs[0]);
AssertEquals('Hill B1',0.11102080,Coeffs[1]);
AssertEquals('Hill B2',84.09251151,Coeffs[2]);
AssertEquals('Hill B3',3.44129476,Coeffs[3]);
end;


procedure TestMathsFuncs.TestInvHillFunc;
var Coeffs: array of double;
begin
SetLength(Coeffs,4);
Coeffs[0] := 1.04378509;
Coeffs[1] := 0.11102080;
Coeffs[2] := 84.09251151;
Coeffs[3] := 3.44129476;
AssertEquals('Inverse Hill function',95.117,InvHillFunc(0.48, Coeffs));
end;


procedure TestMathsFuncs.TestInflHillFunc;
var Coeffs: array of double;
begin
SetLength(Coeffs,4);
Coeffs[0] := 1.04378509;
Coeffs[1] := 0.11102080;
Coeffs[2] := 84.09251151;
Coeffs[3] := 3.44129476;
AssertEquals('Inflection point',70.6702,InflHillFunc(Coeffs));
end;


procedure TestMathsFuncs.TestParabolaFit;
var Coeffs: array of double;
begin
SetLength(Coeffs,3);
ParabolaFit(ArrX,ArrY,Coeffs);
AssertEquals('2nd degree polynomial B0',1.3332,Coeffs[0]);
AssertEquals('2nd degree polynomial B1',-0.0114,Coeffs[1]);
AssertEquals('2nd degree polynomial B2',0,Coeffs[2]);
end;


procedure TestMathsFuncs.TestParabolaZero;
var Coeffs: array of double;
begin
SetLength(Coeffs,3);
Coeffs[0] := 3.0;
Coeffs[1] := 2.0;
Coeffs[2] := 1.0;
AssertEquals('Inflection point',-1.0,ParabolaZero(Coeffs));
end;


initialization
   RegisterTest(TestMathsFuncs);
end.

