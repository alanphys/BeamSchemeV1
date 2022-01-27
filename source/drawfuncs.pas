unit drawfuncs;
{various high level drawing functions}

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, Graphics, bstypes, TASeries;

procedure ShowProfile(ThebitMap:Tbitmap; Profile:TSingleProfile);
procedure DrawProfile(TheBitmap:TBitmap; Beam:TBeam; Angle,Offset,Width:double;
   ProfileSeries:TLineSeries; var ProfileArr:TSingleProfile; DTBPU,DTBPL:longint;
   Normalisation:TNorm);

implementation

function Limit(A,B,C,Phi0,R0,MidX,MidY:double):TPoint;
{Calculates intersection of profile in polar coords with array limits in cartesian coords}
var X,Y        :integer;
begin
X := Round((C*sin(Phi0) - B*R0)/(A*sin(Phi0) - B*cos(Phi0)) + MidX + 0.1);
Y := Round((C*cos(Phi0) - A*R0)/(B*cos(Phi0) - A*sin(Phi0)) + MidY + 0.1);
Result.X := X;
Result.Y := Y;
end;


function LimitL(Angle,Phi,TanA,Offset,MidX,MidY:double; LowerX,LowerY,UpperX,UpperY:integer):TRect;
{Determines the intersect of the line in Polar Coordinates with the bounding rectangle}
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


procedure ShowProfile(TheBitMap:Tbitmap; Profile:TSingleProfile);
{Draw the profile on the bitmap.}
begin
TheBitmap.Canvas.Pen.Color := clRed xor clWhite;
TheBitmap.Canvas.Pen.Mode := pmXor;
with Profile do if PrevW > 0 then
   TheBitmap.Canvas.Polygon([TopLeft,TopRight,BottomRight,BottomLeft])
  else
   TheBitmap.Canvas.Line(TopLeft,BottomRight);
end;


procedure DrawProfile(TheBitmap:TBitmap; Beam:TBeam; Angle,Offset,Width:double;
   ProfileSeries:TLineSeries; var ProfileArr:TSingleProfile; DTBPU,DTBPL:longint;
   Normalisation:TNorm);
{Draw a profile on the bitmap at any angle, store the profile and display it

Parameters
----------
TheBitmap      Bitmap to erase old profile and draw new profile on
Beam           Image data to extract profile from
Angle          Angle from horizontal of profile
Offset         Offset from centre of image of profile
Width          Width of profile (odd values only)
ProfileSeries  Associated TAChart series to show profile on
ProfileArr     Class to store profile
DTBPL          Upper bound for profile windowing
DTBPU          Lower bound for profile windowing
Normalisation  Normalisation mode of profile (none, cax_norm, max_norm)
}
var I,J,K,L,                   {loop iterators}
    LimX,
    LimY,
    OLP,OLN   :longint;
    WNX,
    WNY,
    WPX,
    WPY,
    MidX,
    MidY,
    X,Y,
    XInc,
    YInc,
    MidP,
    PLen,
    TanA,
    Phi,
    Z          :double;
    Start,
    Stop:      TPoint;
    DLine:     TRect;
    OverLimit: Boolean;

function AddPoint(var P:double; X,Y:double; LimX,LimY,DTBPL,DTBPU:longint; var OL:longint):boolean;
var I,J        :longint;
begin
Result := false;
I := round(Y);
J := round(X);
if (J >= 0) and (J < LimX) and (I >= 0) and (I < LimY) then
   begin
   Z := Beam.Data[I,J];
   if Z < DTBPL then Z := DTBPL;
   if Z > DTBPU then Z := DTBPU;
   P := P + Z;
   inc(OL);
   end
  else
   Result := true;
end;

begin
{clear previous profile if it exists}
ProfileSeries.Clear;
with ProfileArr do if (TopLeft.x or TopRight.x or BottomLeft.x or BottomRight.x or
   TopLeft.y or TopRight.y or BottomLeft.y or BottomRight.y <> 0) then
   ShowProfile(TheBitMap,ProfileArr);

{Draw new profile}
Angle := Angle*2*pi/360;                       //convert angle to radians
TanA := arctan(TheBitMap.Height/TheBitmap.Width); // get limit of corners
Phi := Angle + pi/2;    {add 90 degrees to get perpendicular}
LimX := TheBitmap.Width;
LimY := TheBitmap.Height;
MidX := LimX/2 - 0.5;
MidY := LimY/2 - 0.5;
ProfileArr.ResetAll;
ProfileArr.PrevW := trunc((Width)/2);

{get coords of wide profile}
if (Angle > -TanA) and (Angle <= TanA) then {Profile is X profile}
   begin
   ProfileArr.TopLeft := Limit(1,0,-MidX,Phi,Offset + ProfileArr.PrevW,MidX,MidY);
   ProfileArr.TopRight := Limit(1,0,MidX,Phi,Offset + ProfileArr.PrevW,MidX,MidY);
   ProfileArr.BottomRight := Limit(1,0,MidX,Phi,Offset - ProfileArr.PrevW,MidX,MidY);
   ProfileArr.BottomLeft := Limit(1,0,-MidX,Phi,Offset - ProfileArr.PrevW,MidX,MidY);
   end
  else {Profile is Y profile}
   begin
   ProfileArr.TopLeft := Limit(0,1,-MidY,Phi,Offset + ProfileArr.PrevW,MidX,MidY);
   ProfileArr.TopRight := Limit(0,1,MidY,Phi,Offset + ProfileArr.PrevW,MidX,MidY);
   ProfileArr.BottomRight := Limit(0,1,MidY,Phi,Offset - ProfileArr.PrevW,MidX,MidY);
   ProfileArr.BottomLeft := Limit(0,1,-MidY,Phi,Offset - ProfileArr.PrevW,MidX,MidY);
   end;

{Draw profile on array}
with ProfileArr do ShowProfile(TheBitMap,ProfileArr);

{Add points to profile array}
DLine := LimitL(Angle,Phi,TanA,Offset,MidX,MidY,0,0,LimX,LimY);
Start := DLine.TopLeft;
Stop := DLine.BottomRight;
Plen := sqrt(sqr(Stop.X - Start.X)+ sqr(Stop.Y - Start.Y));
ProfileArr.Len := Round(PLen) + 1;
Setlength(ProfileArr.PArrX,ProfileArr.Len);
Setlength(ProfileArr.PArrY,ProfileArr.Len);
X := Start.X;
Y := Start.Y;
I := Start.Y;
J := Start.X;
XInc := (Stop.X - Start.X)/PLen;
YInc := (Stop.Y - Start.Y)/PLen;
K:= 0;
MidP := sqrt(sqr((Stop.X - Start.X)*Beam.XRes) + sqr((Stop.Y - Start.Y)*Beam.YRes))/2;

{Add first point}
OverLimit := false;
ProfileArr.PArrX[K] := sqrt(sqr((X - Start.X)*Beam.XRes) + sqr((Y - Start.Y)*Beam.YRes)) - MidP;
Z := Beam.Data[I,J];
if Z < DTBPL then Z := DTBPL;
if Z > DTBPU then Z := DTBPU;
ProfileArr.PArrY[K] := Z;

{add wide profile}
if ProfileArr.PrevW > 0 then
   begin
   WNX := X;
   WNY := Y;
   WPX := X;
   WPY := Y;
   OLP := 0;
   OLN := 0;
   for L:=1 to round(ProfileArr.PrevW) do
      begin
      WNX := WNX + YInc;     {increments are inverted because slope is}
      WNY := WNY - XInc;     {perpendicular to profile}
      WPX := WPX - YInc;
      WPY := WPY + XInc;
      {add negative profile}
      OverLimit := AddPoint(ProfileArr.PArrY[K],WNX,WNY,LimX,LimY,DTBPL,DTBPU,OLN);

      {add positive profile}
      OverLimit := AddPoint(ProfileArr.PArrY[K],WPX,WPY,LimX,LimY,DTBPL,DTBPU,OLP);
      end;
   if OverLimit then ProfileArr.PArrY[K] := ProfileArr.PArrY[K]*Width/(OLN+1+OLP);
   end;

{add rest of points}
repeat
   X := X + XInc;
   Y := Y + YInc;
   I := Round(Y);
   J := Round(X);
   Inc(K);
   OverLimit := false;
   ProfileArr.PArrX[K] := sqrt(sqr((X - Start.X)*Beam.XRes) + sqr((Y - Start.Y)*Beam.YRes)) - MidP;
   Z := Beam.Data[I,J];
   if Z < DTBPL then Z := DTBPL;
   if Z > DTBPU then Z := DTBPU;
   ProfileArr.PArrY[K] := Z;

   {add wide profiles}
   if ProfileArr.PrevW > 0 then
      begin
      WNX := X;
      WNY := Y;
      WPX := X;
      WPY := Y;
      OLP := 0;
      OLN := 0;
      for L:=1 to round(ProfileArr.PrevW) do
         begin
         WNX := WNX + YInc;     {increments are inverted because slope is}
         WNY := WNY - XInc;     {perpendicular to profile}
         WPX := WPX - YInc;
         WPY := WPY + XInc;
         {add negative profile}
         OverLimit := AddPoint(ProfileArr.PArrY[K],WNX,WNY,LimX,LimY,DTBPL,DTBPU,OLN);
         {add positive profile}
         OverLimit := AddPoint(ProfileArr.PArrY[K],WPX,WPY,LimX,LimY,DTBPL,DTBPU,OLP);
         end;
      if OverLimit then ProfileArr.PArrY[K] := ProfileArr.PArrY[K]*Width/(OLN+1+OLP);
      end;
   until (I = Stop.Y) and (J = Stop.X);

{write normalised array to chart}
ProfileArr.Norm := Normalisation;
for K := 0 to ProfileArr.Len - 1 do
   begin
   X := ProfileArr.PArrX[K];
   case Normalisation of
      no_norm : Y := ProfileArr.PArrY[K];
      norm_cax: Y := (ProfileArr.PArrY[K] - ProfileArr.Min.ValueY)
         *100/(ProfileArr.Centre.ValueY - ProfileArr.Min.ValueY);
      norm_max: Y := (ProfileArr.PArrY[K] - ProfileArr.Min.ValueY)
         *100/(ProfileArr.Max.ValueY - ProfileArr.Min.ValueY);
      end; {of case}
   if (X <> 0) or (Y <> 0) then
      ProfileSeries.AddXY(X,Y,'',clRed)
   end;
end;


end.

