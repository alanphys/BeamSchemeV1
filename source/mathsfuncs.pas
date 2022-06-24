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
function InflHillFunc(B:TVector): double;

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
    Direc  :integer;
begin
Result.Val := 0;
Result.Pos := 0;
if URow >= LRow then Direc := 1 else Direc := -1;
begin
  I := LRow;
  while I <> URow do
     begin
     if not IsNan(BeamArr[I]) and (BeamArr[I] > Result.Val) then
       begin
       Result.Val := BeamArr[I];
       Result.Pos := I;
       end;
     inc(I,Direc);
     end;
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
LRow, up to but not including URow.}
var I          :integer;
begin
Result.Val := MaxDouble;
Result.Pos := 0;
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
   DiffArr[I] := BeamArr[I-1] - BeamArr[I+1];
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
if X > 0 then
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
if X > 0 then
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
if B[3] > 0 then
   begin
   Result := B[2]*power((B[3]-1)/(B[3]+1),1/B[3]);
   end;
end;


procedure CalcInfPoints(PArrX,PArrY:TPArr; var InfP,InfS,Inf20,Inf50,Inf80:double; var ErrMsg:string);
{Perform non-linear regression on Hill function to get inflection point}
var I,
    N          :integer;       {number of points}
    B,                         {parameters: B[0] high limit, B[1] low limit, B[2] initial inf point, B[3] slope}
    X,                         {X values}
    Y          :TVector;       {Y values}
    V          :TMatrix;       {variance-covariance matrix}
    IPDose,                    {dose value at inflection point}
    XMax,                      {max of X values}
    YMax,                      {max of Y values}
    Xsign      :double;        {sign of x values}

begin
N := length(PArrX);
DimVector(X,N);
DimVector(Y,N);
DimVector(B,4);
DimMatrix(V,4,4);
InfP := 0;
InfS := 0;
Inf20 := 0;
Inf50 := 0;
Inf80 := 0;

{transfer values to X,Y. LMath derived from Fortran lower array index starts at 1}
YMax := PArrY[0];
XMax := abs(PArrX[0]);
for I:=0 to N-1 do
   begin
   X[I+1] := abs(PArrX[I]);                {can't have negative axis for Hill func}
   Y[I+1] := PArrY[I];
   if X[I+1] > XMax then XMax := X[I+1];
   if Y[I+1] > YMax then YMax := Y[I+1];
   end;

{Ymax and K are assumed to be positive but n can be negative}
SetParamBounds(0, 0, Ymax*1.5);           {high and low level must be in Y range}
SetParamBounds(1, 0, Ymax*1.5);
SetParamBounds(2, 0, Xmax*1.5);           {inflection point can't be outside X range}
SetParamBounds(3, -100, 100);             {slope should not exceed 100}

{Set algorithm}
SetOptAlgo(NL_SIMP);

HillFit(X, Y, 1, N, True, MaxIter, Tol, B, V);

if MathErr = MatOk then
   begin
   Xsign := sign(PArrX[0]);
   InfP := B[2]*power((B[3]-1)/(B[3]+1),1/B[3]);
   IPDose := HillFunc(InfP,B);
   InfS := XSign*DerivHillFunc(InfP,B);
   InfP := InfP*XSign;
   Inf50 := InvHillFunc(abs(B[1] - B[0])*0.5,B)*Xsign;
   Inf20 := InvHillFunc(IPDose*0.4,B)*XSign;
   Inf80 := InvHillFunc(IPDose*1.6,B)*XSign;
   end
  else
    ErrMsg := ErrMsg + 'Unable to fit curve! ' + MathErrMessage + '. ';
end;


end.

