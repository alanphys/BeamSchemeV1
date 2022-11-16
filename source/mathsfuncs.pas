unit mathsfuncs;
{various high level maths functions}

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, bstypes, utypes;

type

T1DValuePos = record
   Pos         :integer;
   Val         :double;
   end;

T2DValuePos = record
   Row,
   Col         :integer;
   Val         :double;
   end;



function LReg(X1,X2,Y1,Y2,X:double):double;
function ILReg(X1,X2,Y1,Y2,Y:double):double;
function MaxPosNaN(BeamArr:TPArr; LRow,URow:integer):T1DValuePos;
function MaxPosNaN(BeamArr:TBeamData; LRow,URow,LCol,UCol:integer):T2DValuePos;
function MinPosNaN(BeamArr:TPArr; LRow,URow:integer):T1DValuePos;
function MinPosNaN(BeamArr:TBeamData; LRow,URow,LCol,UCol:integer):T2DValuePos;
function Diff(BeamArr:TPArr):TPArr;
function Limit(A,B,C,Phi0,R0,MidX,MidY:double):TPoint;
function LimitL(Angle,Phi,TanA,Offset,MidX,MidY:double; LowerX,LowerY,UpperX,UpperY:integer):TRect;
function HillFunc(X:double; B:TVector):double;
function InvHillFunc(Y:double; B:TVector):double;
function DerivHillFunc(X:double; B:TVector): double;
function CoeffHillFunc(X1,X2,Y1,Y2:double; B:TVector): double;
function InflHillFunc(B:TVector): double;
procedure HillFitParams(PArrX,PArrY:TPArr; var B:TPArr);

implementation

uses math, unlfit, uhillfit, uerrors;

const
   MaxIter = 1000;             {maximum number of iterations for optimisation}
   Tol = 1.0E-4;               {required precision}

function LReg(X1,X2,Y1,Y2,X:double):double;
var m,c:       double;
begin
if X1 <> X2 then m := (Y2 - Y1)/(X2 - X1) else m := 1E6;
c := (Y1 + Y2 - m*(X1 + X2))/2;
LReg := X*m + c;
end;


function ILReg(X1,X2,Y1,Y2,Y:double):double;
var m,c:       double;
begin
if X1 <> X2 then m := (Y2 - Y1)/(X2 - X1) else m := 1E6;
c := (Y1 + Y2 - m*(X1 + X2))/2;
if m <> 0 then ILReg := (Y - c)/m else ILREG := 1E6;
end;


function MaxPosNaN(BeamArr:TPArr; LRow,URow:integer):T1DValuePos;
{find the maximum and its location ignoring Nans. Limits are from and including
LRow up to but not including URow. Can search from either end.}
var I,
    Tmp       :integer;
begin
Result.Val := 0;
Result.Pos := 0;
if URow < LRow then     {swap URow and LRow}
   begin
   Tmp := URow;
   URow := LRow;
   LRow := Tmp;
   end;
for I:=LRow to URow - 1 do
   if not IsNan(BeamArr[I]) and (BeamArr[I] > Result.Val) then
      begin
      Result.Val := BeamArr[I];
      Result.Pos := I;
      end;
end;


function MaxPosNaN(BeamArr:TBeamData; LRow,URow,LCol,UCol:integer):T2DValuePos;
{find the maximum and its location ignoring Nans. Limits are from and including
LRow, LCol up to but not including URow and UCol.}
var I,J        :integer;
begin
Result.Val := 0;
Result.Row := 0;
Result.Col := 0;
for I:=LRow to URow - 1 do
   for J:=LCol to UCol - 1 do
      if not IsNan(BeamArr[I,J]) and (BeamArr[I,J] > Result.Val) then
      begin
      Result.Val := BeamArr[I,J];
      Result.Row := I;
      Result.Col := J;
      end;
end;


function MinPosNaN(BeamArr:TPArr; LRow,URow:integer):T1DValuePos;
{find the minimum and its location ignoring Nans. Limits are from and including
low value, up to but not including high value. Can search from either end.}
var I,
    Tmp       :integer;
begin
Result.Val := MaxDouble;
Result.Pos := 0;
if URow < LRow then     {swap URow and LRow}
   begin
   Tmp := URow;
   URow := LRow;
   LRow := Tmp;
   end;
for I:=LRow to URow - 1 do
   if not IsNan(BeamArr[I]) and (BeamArr[I] < Result.Val) then
      begin
      Result.Val := BeamArr[I];
      Result.Pos := I;
      end;
end;


function MinPosNaN(BeamArr:TBeamData; LRow,URow,LCol,UCol:integer):T2DValuePos;
{find the minimum and its location ignoring Nans. Limits are from and including
LRow, LCol up to but not including URow and UCol.}
var I,J        :integer;
begin
Result.Val := MaxDouble;
Result.Row := 0;
Result.Col := 0;
for I:=LRow to URow - 1 do
   for J:=LCol to UCol - 1 do
      if not IsNan(BeamArr[I,J]) and (BeamArr[I,J] < Result.Val) then
      begin
      Result.Val := BeamArr[I,J];
      Result.Row := I;
      Result.col := J;
      end;
end;


function Diff(BeamArr:TPArr):TPArr;
{Differentiate the array using the central point difference function}
var I,
    N          :integer;
    DiffArr    :TPArr;
begin
N := Length(BeamArr);
SetLength(DiffArr,N);
DiffArr[0] := 0;
for I := 1 to N - 2 do
   DiffArr[I] := BeamArr[I+1] - BeamArr[I-1];
DiffArr[N-1] := 0;
Result := DiffArr;
end;


function Limit(A,B,C,Phi0,R0,MidX,MidY:double):TPoint;
{Calculates intersection of profile in polar coords with array limits in cartesian coords
ax + by + c = aρcosθ + bρsinθ + c = 0

Parameters
----------
A      X axis
B      Y axis
C      Intercept
Phi0   Angle of straight line
R0     Radius of nearest point on straight line to image centre
MidX   Offset to image centre X
MidY   Offset to image centre Y

Returns: point of intersection as TPoint}

var X,Y        :integer;
begin
X := Round((C*sin(Phi0) - B*R0)/(A*sin(Phi0) - B*cos(Phi0)) + MidX + 0.1);
Y := Round((C*cos(Phi0) - A*R0)/(B*cos(Phi0) - A*sin(Phi0)) + MidY + 0.1);
Result.X := X;
Result.Y := Y;
end;


function LimitL(Angle,Phi,TanA,Offset,MidX,MidY:double; LowerX,LowerY,UpperX,UpperY:integer):TRect;
{Determines the intersection of the line in Polar Coordinates with the array bounding rectangle

Parameters
----------
Angle
Phi
TanA
Offset
MidX,
MidY
LowerX,
LowerY
UpperX,
UpperY

Returns: two points on the line intersecting the bounding rectangle}

var TL,                        {top left of line}
    BR:        TPoint;         {bottom right of line}

begin
if (Angle > -TanA) and (Angle <= TanA) then {Profile is X profile}
   begin
   {Start with left axis}
   TL := Limit(1,0,-MidX,Phi,Offset,MidX,MidY);
   if TL.Y < LowerY then
      begin {must intersect top axis}
      TL := Limit(0,1,-MidY,Phi,Offset,MidX,MidY);
      end
     else
      if TL.Y >= UpperY then
         begin {must intersect bottom axis}
         TL := Limit(0,1,MidY,Phi,Offset,MidX,MidY);
         end;

   {Now do right axis}
   BR := Limit(1,0,MidX,Phi,Offset,MidX,MidY);
   if BR.Y < LowerY then
      begin {must intersect top axis}
      BR := Limit(0,1,-MidY,Phi,Offset,MidX,MidY);
      end
     else
      if BR.Y >= UpperY then
         begin {must intersect bottom axis}
         BR := Limit(0,1,MidY,Phi,Offset,MidX,MidY);
         end;
   end
  else
   begin {profile is y profile}
   {Start with top axis}
   TL := Limit(0,1,-MidY,Phi,Offset,MidX,MidY);
   if TL.X < LowerX then
      begin {must intersect left axis}
      TL := Limit(1,0,-MidX,Phi,Offset,MidX,MidY);
      end
     else
      if TL.X >= UpperX then
         begin {must intersect right axis}
         TL := Limit(1,0,MidX,Phi,Offset,MidX,MidY);
         end;

   {Now do bottom axis}
   BR := Limit(0,1,MidY,Phi,Offset,MidX,MidY);
   if BR.X < LowerX then
      begin {must intersect left axis}
      BR := Limit(1,0,-MidX,Phi,Offset,MidX,MidY);
      end
     else
      if BR.X >= UpperX then
         begin {must intersect right axis}
         BR := Limit(1,0,MidX,Phi,Offset,MidX,MidY);
         end;
   end;
Result.TopLeft := TL;
Result.BottomRight := BR;
end;


function HillFunc(X:double; B:TVector):double;
{calculates the value of the Hill function at x
parameters:
   B[0] high limit
   B[1] low limit
   B[2] initial inf point
   B[3] slope}
begin
if X <> 0 then
   Result := B[0] + (B[1] - B[0])/(1.0 + Power(B[2]/X, B[3]))
  else
   Result := B[0];
end;


function InvHillFunc(Y:double; B:TVector):double;
{calculates the inverse Hill function at y
parameters:
   B[0] high limit
   B[1] low limit
   B[2] initial inf point
   B[3] slope}
begin
if (Y > min(B[0],B[1])) and (Y < max(B[0],B[1])) and (B[3] <> 0) then
   Result := B[2]*power((Y - B[0])/(B[1] - Y),1/B[3])
  else
   Result := 0;
end;


function DerivHillFunc(X:double; B:TVector): double;
{calculates the tangent of the Hill function at X
parameters:
   B[0] high limit
   B[1] low limit
   B[2] initial inf point
   B[3] slope}
var cxd        :double;
begin
Result := 0;
if X <> 0 then
   begin
   cxd := power(B[2]/X,B[3]);
   Result := (B[1] - B[0])*B[3]*cxd/(sqr(cxd + 1)*X)
   end;
end;


function InflHillFunc(B:TVector): double;
{calculates the inflection point of the Hill function
parameters:
   B[0] high limit
   B[1] low limit
   B[2] initial inf point
   B[3] slope}
begin
Result := 0;
if B[3] <> 0 then
   begin
   Result := B[2]*power((B[3]-1)/(B[3]+1),1/B[3]);
   end;
end;


function CoeffHillFunc(X1,X2,Y1,Y2:double; B:TVector): double;
{calculates Hill coefficient using given X and Y.
parameters:
   B[0] high limit
   B[1] low limit
   B[2] initial inf point
   B[3] slope}
var Slope      :double;
begin
Result := 0;
if (X1 <> X2) and (B[0] <> B[1]) then
   begin
   Slope := (Y1 - Y2)/(X1 - X2);
   Result := 4*B[2]*Slope/(B[1] - B[0]);
   Result := EnsureRange(Result,-50,50);
   end;
end;


procedure HillFitParams(PArrX,PArrY:TPArr; var B:TPArr);
{Perform non-linear regression on Hill function to get inflection point. Builtin
function of LMath is not used as it only caters for positive x values. Initial
estimate for B is passed.
parameters:
   PArrX array of X values
   PArrY array of Y values
   B[0] high limit
   B[1] low limit
   B[2] initial inf point
   B[3] slope}
var I,
    N          :integer;       {number of points}
    V          :TMatrix;       {variance-covariance matrix}
    XMax,                      {max of X values}
    XMin,
    YMax       :double;        {max of Y values}
    ErrMsg     :string;

begin
N := length(PArrX);

if N > 0 then
   begin
   DimMatrix(V,4,4);

   {Get min max to set bounds and normalise x axis to 0}
   YMax := math.max(B[0],B[1]);
   XMin := PArrX[0];
   XMax := PArrX[N-1];

   {Ymax and K are assumed to be positive but n can be negative}
   SetParamBounds(0, 0, Ymax*1.5);           {high and low level must be in Y range}
   SetParamBounds(1, 0, Ymax*1.5);
   SetParamBounds(2, XMin, Xmax);            {inflection point can't be outside X range}
   SetParamBounds(3, -100,100);              {slope should not exceed 100}

   {Set algorithm}
   SetOptAlgo(NL_SIMP);

   HillFit(PArrX,PArrY,0,N-1,True,MaxIter,Tol,B,V);

   if MathErr <> MatOk then
      begin
      ErrMsg := MathErrMessage;
      B[0] := 0;
      B[1] := 0;
      B[2] := 0;
      B[3] := 0;
      end;
   end;
end;
end.

