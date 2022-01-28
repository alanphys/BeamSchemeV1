unit bstypes;

{$mode objfpc}{$H+}

interface

uses
   Classes, Graphics, sysutils, TASeries;

type
  TNorm = (no_norm, norm_cax, norm_max);

  TIFAType = (proportional, circular, square);
  TIFAData = record
     Name      :string;
     DefVal    :double;
     end;

  TBeamData = array of array of double;

  TMaskArr = array of array of boolean;

  TArrayPos = record
     Row,
     Col       :integer;
     Val       :double;
     end;

  TProfilePoint = record
     X:        double;
     Y:        double;
     end;

  TPArr = array of double;

  TValuePos = record
     ValueY,
     ValueX    :double;
     Pos       :integer;
     end;

  TSingleProfile = class
     private
     fLeftEdge,                {value, position and index of field left edge}
     fRightEdge,               {value, position and index of field right edge}
     fMin,                     {profile minimum Y value}
     fMax,                     {profile maximum Y value}
     fCentre   :TValuePos;     {centre Y value and X position}
     fIFA      :TPArr;         {array holding in field values}
     public
     TopRight,                 {top right corner of wide profile}
     TopLeft,                  {top left corner of wide profile}
     BottomRight,              {bottom right corner of wide profile}
     BottomLeft:TPoint;        {bottom left corner of wide profile}
     Angle,                    {Angle of profile}
     Offset,                   {offset from centre of image}
     Width,                    {width of wide profile}
     PrevW,                    {previous width of wide profile}
     Len       :integer;       {number of elements in profile}
     Norm      :TNorm;         {profile normalisation (none, max or cax)}
     sProt,                    {analysis protocol name}
     sExpr     :string;        {name of parameter being evaluated}
     PArrX     :TPArr;         {1D array containing profile X points}
     PArrY     :TPArr;         {1D array containing profile Y points}
     constructor Create;
     destructor Destroy; override;
     procedure ResetAll;       {reset all parameters and zero array}
     procedure ResetParams;    {reset calculated parameters}
     procedure ResetCoords;    {set profile coordinates back to 0}
     procedure SetParams(aAngle,aOffset,aWidth:integer); {set parameters from GUI}
     function GetCentre:TValuePos;{get centre of profile}
     function GetPos(Value:double; D:Integer):TValuePos;
     function GetLeftE:TValuePos; {get left edge of profile}
     function GetRightE:TValuePos;{get right edge of profile}
     function GetMin:TValuePos;   {get minimum value and postion}
     function GetMax:TValuePos;   {get maximum value and position}
     function GetInFieldArea:TPArr;
     procedure ToSeries(ProfileSeries:TLineSeries);
     procedure Show(TheBitMap:Tbitmap);
     procedure Draw(TheBitmap:TBitmap);
     property Centre:TValuePos read GetCentre;
     property LeftEdge:TValuePos read GetLeftE;
     property RightEdge:TValuePos read GetRightE;
     property Min:TValuePos read GetMin;
     property Max:TValuePos read GetMax;
     property InFieldArea:TPArr read GetInFieldArea;
     end;

  TBasicBeam = class
     private
     fMin,                     {beam minimum Y value}
     fMax,                     {beam maximum Y value}
     fAve,                     {beam average}
     fCentre   :double;        {centre Y value}
     fCoM      :TProfilePoint; {centre of mass position}
     public
     Cols,                     {number of columns (X direction)}
     Rows      :integer;       {number of rows (Y direction)}
     Norm      :TNorm;         {Beam normalisation (none, max or cax)}
     Data      :TBeamData;     {2D array containing image data}
     constructor Create;
     destructor Destroy; override;
     procedure Reset;
     procedure ResetParams;
     procedure Display(MBitMap:TBitMap; BMax,BMin:double);
     procedure Invert;
     function GetMin:double;   {get minimum value and postion}
     function GetMax:double;   {get maximum value and position}
     function GetAve:double;   {get average of values}
     function GetCentre:double;{get centre of beam}
     function GetCoM:TProfilePoint;
     property Centre:double read GetCentre;
     property CoM:TProfilePoint read GetCoM;
     property Min:double read GetMin;
     property Max:double read GetMax;
     property Ave:double read GetAve;
     end;

  TBeam = class(TBasicBeam)
     private
     fIFA      :TBasicBeam;     {value within the in field area}
     public
     Width,                    {detector size in X direction}
     Height,                   {detector size in Y direction}
     XRes,                     {detector resolution in X direction}
     YRes      :double;        {detector resolution in Y direction}
     constructor Create;
     destructor Destroy;
     procedure Reset;
     procedure ResetParams;
     procedure DisplayIFA(MBitMap:TBitMap);
     procedure CentreData;
     function GetInFieldArea:TBasicBeam;
     procedure CreateProfile(ProfileArr:TSingleProfile; DTBPU,DTBPL:longint; Normalisation:TNorm);
     property IFA:TBasicBeam read GetInFieldArea;
     end;

  TBeamMask = class            {helper class to define IFA}
     public
     Cols,                     {number of columns (X direction)}
     Rows      :integer;       {number of rows (Y direction)}
     Mask      :TMaskArr;      {2D array holding mask}
     constructor Create;       {create empty mask}
     constructor Create(aRows,aCols:integer);
     constructor CreateFromArray(Arr:TBeamData; LRow,Urow,LCol,UCol:integer; Threshold:double);
     constructor CreateCircle(CRow,CCol,URow,UCol:integer; Radius:double);
     destructor Destroy; override;
     procedure ShrinkMask(CRow,CCol,Factor:double);
     end;

TBSExceptionType = (Message, Warning, Error);
EBSError = class(Exception)
   public
   EType       :TBSExceptionType;
   constructor Create(const AMessage:string; AType:TBSExceptionType);
   end;

const
   pi = 3.14159265359;
   FaintRed    :TColor = $7979ff;
   FaintYellow :TColor = $cffcff;
   FaintGreen  :TColor = $e4ffd3;

   IFAData: array[proportional..square] of TIFAData = (
      (Name: 'Proportional'; DefVal: 0.8),
      (Name: 'Circular'; DefVal: 0.8),
      (Name: 'Square'; DefVal: 16.0));

var Beam         :TBeam;
    XPArr,
    YPArr        :TSingleProfile;
    DefaultRes   :double = 2.54/75; {default to 75dpi for Gafchromic}
    ShowParams   :boolean = False;
    IFAType      :TIFAType;
    IFAFactor    :double;

implementation

uses math, mathsfuncs, uVecUtils, IntfGraphics, FPImage, Graphtype;

{-------------------------------------------------------------------------------
EBSError
-------------------------------------------------------------------------------}
constructor EBSError.Create(const AMessage:string; AType:TBSExceptionType);
begin
inherited Create(AMessage);
EType := AType;
end;

{-------------------------------------------------------------------------------
TBasicBeam
-------------------------------------------------------------------------------}

constructor TBasicBeam.Create;
begin
  Reset;
  Data := nil;
end;


destructor TBasicBeam.Destroy;
begin
Setlength(Data,0);
Data := nil;
inherited;
end;


procedure TBasicBeam.Reset;
begin
  Cols := 0;
  Rows := 0;
  Norm := no_norm;
  ResetParams;
end;


procedure TBasicBeam.ResetParams;
begin
  fCentre := 0.0;
  fCoM.X := 0.0;
  fCoM.Y := 0.0;
  fMax := 0;
  fMin := MaxDouble;
  fAve := 0;
end;


procedure TBasicBeam.Display(MBitMap:TBitMap; BMax,BMin:double);
{Transfers the array data to a bitmap for viewing}
var IntFImage  :TLazIntfImage;
    Description:TRawImageDescription;
    I,J:       integer;
    z:         double;
    Val:       word;
    GreyVal:   TFPColor;

begin
if (Rows>0) and (Cols>0) then
   begin
   IntFImage := TLazIntFImage.Create(0,0);
   Description.Init_BPP32_B8G8R8A8_BIO_TTB(Cols,Rows);
   IntFImage.DataDescription := Description;

   if BMax <> BMin then
      for I:=0 to Rows - 1 do
        for J:=0 to Cols - 1 do
           begin
           Z := Data[I,J];
           if Z < BMin then Z := BMin;
           if Z > BMax then Z := BMax;
           Val := Round((Z - BMin)*65535/(BMax - BMin));
           GreyVal := FPColor(Val,Val,Val);
           IntFImage.Colors[J,I] := GreyVal;
           end;
      MBitMap.LoadFromIntfImage(IntFImage);
      IntFImage.Free;
   end;
end;


procedure TBasicBeam.Invert;
var I,J        :integer;
    Z          :double;
begin
if Max <> Min then
   begin
   for I:=0 to Rows - 1 do
     for J:=0 to Cols - 1 do
        begin
        Z := Data[I,J];
        Z := Max - Z + Min;
        Data[I,J] := Z;
        end;
   ResetParams;
   end;
end;


function TBasicBeam.GetMax:double;
begin
if fMax = 0 then
   fMax:= MaxPosNan(Data,0,Rows,0,Cols).Val;
Result := fMax;
end;


function TBasicBeam.GetMin:double;
begin
if SameValue(fMin,MaxDouble) then
   fMin:= MinPosNan(Data,0,Rows,0,Cols).Val;
Result := fMin;
end;


function TBasicBeam.GetAve:double;
var I,J,K,
    EndRow,
    EndCol     :integer;
    Sum        :double;
begin
if fAve = 0 then
   begin
   Sum := 0;
   EndRow := Rows - 1;
   EndCol := Cols - 3;
   K := 0;
   for I:=0 to EndRow do
      for J:=0 to EndCol do
         if not IsNaN(Data[I,J]) then
            begin
            Sum := Sum + Data[I,J];
            Inc(K);
            end;
   fAve := Sum/K;
   end;
Result := fAve;
end;


function TBasicBeam.GetCentre:double;
{Returns the geometric centre of the detector}
var Row,
    Col    :integer;
begin
fCentre := 0.0;
Row := (Rows - 1) div 2;
Col := (Cols - 1) div 2;
if odd(Rows) then
   begin
   if odd(Cols) then
      fCentre := Data[Row,Col]
     else
      fCentre := (Data[Row,Col] + Data[Row,Col + 1])/2
   end
  else
   begin
     if odd(Cols) then
        fCentre := (Data[Row,Col] + Data[Row + 1,Col])/2
       else
        fCentre := (Data[Row,Col] + Data[Row,Col + 1] +
           Data[Row + 1,Col] + Data[Row + 1,Col + 1])/4
   end;
Result := fCentre
end;


function TBasicBeam.GetCoM:TProfilePoint;
{Returns the indices of the unweighted centre of mass of the distribution in
the form (row,col)}
var I,J,K      :integer;
    Value      :double = 0.5;
begin
case Norm of
   no_norm : Value := Centre*Value;
   norm_cax: Value := (Centre - Min)*Value + Min;
   norm_max: Value := (Max - Min)*Value + Min;
   end; {of case}

if (fCoM.X = 0) and (fCoM.Y = 0) then
   begin
   fCoM.X := 0.0;
   fCoM.Y := 0.0;
   K := 0;
   for I:=0 to Rows - 1 do
      for J:=0 to Cols - 1 do
         if Data[I,J] >= Value then
            begin
            fCoM.X := fCom.X + I;
            fCoM.Y := fCom.Y + J;
            inc(K);
            end;
   fCom.X := fCom.X/K;
   fCom.Y := fCom.Y/K;
   end;
Result := fCoM;
end;


{-------------------------------------------------------------------------------
TBeam
-------------------------------------------------------------------------------}

constructor TBeam.Create;
begin
inherited Create;
fIFA := TBasicBeam.Create;
end;


destructor TBeam.Destroy;
begin
fIFA.Destroy;
inherited Destroy;
end;


procedure TBeam.Reset;
begin
inherited Reset;
Width :=0 ;
Height := 0;
XRes := 0;
YRes := 0;
fIFA.Reset;
Setlength(fIFA.Data,0);
end;


procedure TBeam.ResetParams;
begin
inherited ResetParams;
fIFA.ResetParams;
SetLength(fIFA.Data,0);
end;


procedure TBeam.DisplayIFA(MBitMap:TBitMap);
{Transfers the array data to a bitmap for viewing. Image is autoscaled}
var IntFImage  :TLazIntfImage;
    I,J:       integer;
    Red,
    Green,
    Blue       :word;
    GreyVal    :TFPColor;
    aIFA       :TBeamData;

begin
if (Rows>0) and (Cols>0) then
   begin
   IntFImage := MBitmap.CreateIntfImage;
   aIFA := IFA.Data;
   for I:=0 to Rows - 1 do
     for J:=0 to Cols - 1 do
        if not IsNaN(aIFA[I,J]) then
           begin
           Red := IntFImage.Colors[J,I].Red;
           Green := IntFImage.Colors[J,I].Green;
           Blue := IntFImage.Colors[J,I].Blue;
           GreyVal := FPColor(32767,Green,Blue);
           IntFImage.Colors[J,I] := GreyVal;
           end;
   MBitMap.LoadFromIntfImage(IntFImage);
   IntFImage.Free;
   end;
end;


procedure TBeam.CentreData;
{Moves the CoM to the centre of the array. Warning! Resamples the data using
bi-linear interpolation}
var I,J,
    NI,NJ,                     {new x and y coords}
    MaxI,MaxJ  :integer;
    ShiftData  :TBeamData;
    SX,SY,
    NX,NY,
    RemX,
    RemY:double;

begin
MaxI := Cols - 1;
MaxJ := Rows - 1;
SX := CoM.Y - MaxI/2;
SY := Com.X - MaxJ/2;
SetLength(ShiftData,Rows);

for J:= 0 to MaxJ do
   begin
   SetLength(ShiftData[J],Cols);
   ShiftData[J,0] := Data[J,0];
   ShiftData[J,1] := Data[J,1];
   NY := J + SY;
   NJ := Trunc(NY);
   RemY := NY - NJ;
   if NJ < 0 then NJ := 0
     else
      if NJ > MaxJ - 1 then NJ := MaxJ - 1;
   for I:=0 to MaxI do
      begin
      NX := I + SX;
      NI := Trunc(NX);
      RemX := NX - NI;
      if NI < 0 then NI := 0
         else
         if NI > MaxI - 1 then NI := MaxI - 1;
      ShiftData[J,I] := Data[NJ,NI]*(1-RemX)*(1-RemY) + Data[NJ,NI+1]*RemX*(1-RemY)
         + Data[NJ+1,NI]*(1-RemX)*RemY + Data[NJ+1,NI+1]*RemX*RemY;
      end;
   end;
Data := ShiftData;
ResetParams;
end;


function TBeam.GetInFieldArea:TBasicBeam;
{Returns the array elements within the In Field Area (IFA) as defined by the
protocol.}
var I,J        :integer;
    BeamMask   :TBeamMask;
begin
BeamMask := nil;
if Length(fIFA.Data) = 0 then
   begin
   case IFAType of
      proportional:begin
         BeamMask := TBeamMask.CreateFromArray(Data,0,Rows,0,Cols, Max/2);
         BeamMask.ShrinkMask(CoM.X,CoM.Y,IFAFactor);
         end;
      circular: begin
         BeamMask := TBeamMask.CreateCircle(round(CoM.X),round(CoM.Y),
            Rows,Cols,IFAFactor/XRes);
         end;
      square: begin end;
      end; {of case}

   if BeamMask <> nil then
      begin
      SetLength(fIFA.Data,Rows);
      for I:=0 to Rows - 1 do
         begin
         SetLength(fIFA.Data[I], Cols);
         for J:=0 to Cols - 1 do
            if BeamMask.Mask[I,J] then
               fIFA.Data[I,J] := Data[I,J]
              else
               fIFA.Data[I,J] := NaN;
         end;
      BeamMask.Free;
      end
     else
      {if the mask doesn't exist take all the data}
      fIFA.Data := Data;
   fIFA.Rows := Rows;
   fIFA.Cols := Cols;
   fIFA.Norm := Norm;
   end;
Result := fIFA;
end;


procedure TBeam.CreateProfile(ProfileArr:TSingleProfile; DTBPU,DTBPL:longint; Normalisation:TNorm);
{Given the profile coords calculate the profile from the beam data.

Parameters
----------
Beam           Image data to extract profile from
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
    X,Y,
    MidX,
    MidY,
    XInc,
    YInc,
    MidP,
    PLen,
    TanA,
    Phi,
    rAngle,
    Z          :double;
    Start,
    Stop:      TPoint;
    DLine:     TRect;
    OverLimit: Boolean;

function AddPoint(var P:double; X,Y:double; LimX,LimY,DTBPL,DTBPU:longint; var OL:longint):boolean;
var I,J        :longint;
    Z          :double;
begin
Result := false;
I := round(Y);
J := round(X);
if (J >= 0) and (J < LimX) and (I >= 0) and (I < LimY) then
   begin
   Z := Data[I,J];
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

{Set limits}
rAngle := ProfileArr.Angle*2*pi/360;       {convert angle to radians}
TanA := arctan(Rows/Cols);                 {get limit of corners}
Phi := rAngle + pi/2;                      {add 90 degrees to get perpendicular}
LimX := Cols;
LimY := Rows;
MidX := LimX/2 - 0.5;
MidY := LimY/2 - 0.5;
ProfileArr.ResetParams;
ProfileArr.PrevW := ProfileArr.Width div 2;

{Add points to profile array}
DLine := LimitL(rAngle,Phi,TanA,ProfileArr.Offset,MidX,MidY,0,0,LimX,LimY);
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
ProfileArr.PArrX[K] := sqrt(sqr((X - Start.X)*XRes) + sqr((Y - Start.Y)*YRes)) - MidP;
Z := Data[I,J];
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
   if OverLimit then ProfileArr.PArrY[K] := ProfileArr.PArrY[K]*ProfileArr.Width/(OLN+1+OLP);
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
      if OverLimit then ProfileArr.PArrY[K] := ProfileArr.PArrY[K]*ProfileArr.Width/(OLN+1+OLP);
      end;
   until (I = Stop.Y) and (J = Stop.X);
ProfileArr.Norm := Norm;
end;


{-------------------------------------------------------------------------------
TSingleProfile
-------------------------------------------------------------------------------}

constructor TSingleProfile.Create;
begin
ResetAll;
end;


destructor TSingleProfile.Destroy;
begin
SetLength(PArrX,0);
SetLength(PArrY,0);
inherited;
end;


procedure TSingleProfile.ResetAll;
{set all profile values back to default}
begin
SetLength(PArrX,0);
SetLength(PArrY,0);
SetLength(fIFA,0);
PArrX := nil;
PArrY := nil;
Len := 0;
Angle := 0;
Offset := 0;
Width := 1;
PrevW := 1;
fMin.ValueY := MaxDouble;
fMin.ValueX := 0.0;
fMin.Pos := 0;
fMax.ValueY := 0.0;
fMax.ValueX := 0.0;
fMax.Pos := 0;
fCentre.ValueY := 0.0;
fCentre.ValueX := 0.0;
fCentre.Pos := 0;
fLeftEdge.ValueY := 0.0;
fLeftEdge.ValueX := 0.0;
fLeftEdge.Pos := 0;
fRightEdge.ValueY := 0.0;
fRightEdge.ValueX := 0.0;
fRightEdge.Pos := 0;
ResetCoords;
sProt := '';
sExpr := '';
end;


procedure TSingleProfile.ResetParams;
{set all calculated profile values back to default}
begin
SetLength(PArrX,0);
SetLength(PArrY,0);
SetLength(fIFA,0);
PArrX := nil;
PArrY := nil;
Len := 0;
fMin.ValueY := MaxDouble;
fMin.ValueX := 0.0;
fMin.Pos := 0;
fMax.ValueY := 0.0;
fMax.ValueX := 0.0;
fMax.Pos := 0;
fCentre.ValueY := 0.0;
fCentre.ValueX := 0.0;
fCentre.Pos := 0;
fLeftEdge.ValueY := 0.0;
fLeftEdge.ValueX := 0.0;
fLeftEdge.Pos := 0;
fRightEdge.ValueY := 0.0;
fRightEdge.ValueX := 0.0;
fRightEdge.Pos := 0;
sProt := '';
sExpr := '';
end;


procedure TSingleProfile.ResetCoords;
{zero coordinates only}
begin
TopLeft := Point(0,0);
TopRight := Point(0,0);
BottomLeft := Point(0,0);
BottomRight := Point(0,0);
end;


procedure TSingleProfile.SetParams(aAngle,aOffset,aWidth:integer);
begin
Angle := aAngle;
Offset := aOffset;
Width := aWidth;
end;


function TSingleProfile.GetCentre:TValuePos;
{Return the centre value, position and index of the profile. If the number of
points in the profile are even the average of the two centre values is returned}
begin
{for performance only calculate if not previously calculated}
if fCentre.ValueY = 0 then
   begin
   if odd (Len) then
      begin
      fCentre.Pos := (Len - 1) div 2;
      fCentre.ValueX := PArrX[fCentre.Pos];
      fCentre.ValueY := PArrY[fCentre.Pos];
      end
     else
      begin
      fCentre.Pos := (Len - 1) div 2;
      fCentre.ValueX := (PArrX[fCentre.Pos] + PArrX[fCentre.Pos + 1])/2;
      fCentre.ValueY := (PArrY[fCentre.Pos] + PArrY[fCentre.Pos + 1])/2;
      end;
   end;
Result := fCentre
end;


function TSingleProfile.GetPos(Value:double; D:Integer):TValuePos;
{Return the first point from the centre where the profile becomes less than
Max or Cax times Value. D gives direction Up (increment) or Down (decrement)}
var I          :integer;

begin
I := Centre.Pos;
case Norm of
   no_norm : Value := Centre.ValueY*Value;
   norm_cax: Value := (Centre.ValueY - Min.ValueY)*Value + Min.ValueY;  //fix! potentially uninitialised
   norm_max: Value := (Max.ValueY - Min.ValueY)*Value + Min.ValueY;
   end; {of case}

while (PArrY[I] > Value) and (I >= 0) and (I < Len) do inc(I,D);
if (I >= 0) and (I < Len) then
   begin
   Result.ValueY := Value;
   Result.ValueX := ILReg(PArrX[I],PArrX[I-D],PArrY[I],PArrY[I-D],Value);
   Result.Pos := I;
   end
  else
   begin
   Result.ValueY := 0;
   Result.ValueX := 0;
   Result.Pos := 0;
   end;
end;


function TSingleProfile.GetLeftE:TValuePos;
{Return the value, position and index of the field left edge. The index is the
first integer index after the field edge.}
begin
{for performance only calculate if not previously calculated}
if fLeftEdge.ValueY = 0 then
   fLeftEdge := GetPos(0.5,-1);
Result := fLeftEdge;
end;


function TSingleProfile.GetRightE:TValuePos;
{Return the value, position and index of the field right edge. The index is the
first integer index after the field edge.}
begin
{for performance only calculate if not previously calculated}
if fRightEdge.ValueY = 0 then
   fRightEdge := GetPos(0.5,1);
Result := fRightEdge;
end;


function TSingleProfile.GetMax:TValuePos;
begin
if fMax.ValueY = 0 then
   begin
   fMax.Pos:= MaxLoc(PArrY,0,Len);
   fMax.ValueX := PArrX[fMax.Pos];
   fMax.ValueY := PArrY[fMax.Pos];
   end;
Result := fMax;
end;


function TSingleProfile.GetMin:TValuePos;
begin
if SameValue(fMin.ValueY,MaxDouble) then
   begin
   fMin.Pos:= MinLoc(PArrY,0,Len);
   fMin.ValueX := PArrX[fMin.Pos];
   fMin.ValueY := PArrY[fMin.Pos];
   end;
Result := fMin;
end;


function TSingleProfile.GetInFieldArea:TPArr;
{Returns the array elements within the In Field Area (IFA) as defined by the
IFA type.}
var LE,                        {index left edge}
    RE         :integer;       {index right edge}
    Delta      :double;        {inc/decrement for IFA}
begin
if Length(fIFA) = 0 then
   begin
   case IFAType of
      proportional: begin
         Delta := (1 - IFAFactor)*(RightEdge.Pos - LeftEdge.Pos)/2.0;
         end;
      circular: begin end;
      square: begin end;
      end;
   LE := round(LeftEdge.Pos + Delta);
   RE := round(RightEdge.Pos - Delta);
   if RE > LE then
     begin
     SetLength(fIFA,RE - LE + 1);
     fIFA := copy(PArrY,LE,RE - LE);
     end;
   end;
Result := fIFA;
end;


procedure TSingleProfile.ToSeries(ProfileSeries:TLineSeries);
var K          :integer;
    X,Y        :double;
begin
{write normalised array to chart}
ProfileSeries.Clear;
for K := 0 to Len - 1 do
   begin
   X := PArrX[K];
   case Norm of
      no_norm : Y := PArrY[K];
      norm_cax: Y := (PArrY[K] - Min.ValueY)*100/(Centre.ValueY - Min.ValueY);
      norm_max: Y := (PArrY[K] - Min.ValueY)
         *100/(Max.ValueY - Min.ValueY);
      end; {of case}
   if (X <> 0) or (Y <> 0) then
      ProfileSeries.AddXY(X,Y,'',clRed);
   end;
end;


procedure TSingleProfile.Show(TheBitMap:Tbitmap);
{Draw the profile on the bitmap.}
begin
TheBitmap.Canvas.Pen.Color := clRed xor clWhite;
TheBitmap.Canvas.Pen.Mode := pmXor;
if PrevW > 0 then
   TheBitmap.Canvas.Polygon([TopLeft,TopRight,BottomRight,BottomLeft])
  else
   TheBitmap.Canvas.Line(TopLeft,BottomRight);
end;


procedure TSingleProfile.Draw(TheBitmap:TBitmap);
{Returns a bitmap with the profile drawn on it}
var MidX,                      {X centre of image}
    MidY,                      {Y centre of image}
    rAngle,                    {angle in radians}
    Phi,                       {perpendicular angle to rAngle}
    TanA       :double;        {image corner limits}

begin
{clear previous profile if it exists}
if (TopLeft.x or TopRight.x or BottomLeft.x or BottomRight.x or
   TopLeft.y or TopRight.y or BottomLeft.y or BottomRight.y <> 0) then
   Show(TheBitMap);
ResetCoords;

{Draw new profile}
rAngle := Angle*2*pi/360;              {convert angle to radians}
TanA := arctan(TheBitMap.Height/TheBitmap.Width); {get limit of corners}
Phi := rAngle + pi/2;                             {add 90 degrees to get perpendicular}
MidX := TheBitmap.Width/2 - 0.5;
MidY := TheBitmap.Height/2 - 0.5;
PrevW := Width div 2;

{get coords of wide profile}
if (rAngle > -TanA) and (rAngle <= TanA) then {Profile is X profile}
   begin
   TopLeft := Limit(1,0,-MidX,Phi,Offset + PrevW,MidX,MidY);
   TopRight := Limit(1,0,MidX,Phi,Offset + PrevW,MidX,MidY);
   BottomRight := Limit(1,0,MidX,Phi,Offset - PrevW,MidX,MidY);
   BottomLeft := Limit(1,0,-MidX,Phi,Offset - PrevW,MidX,MidY);
   end
  else {Profile is Y profile}
   begin
   TopLeft := Limit(0,1,-MidY,Phi,Offset + PrevW,MidX,MidY);
   TopRight := Limit(0,1,MidY,Phi,Offset + PrevW,MidX,MidY);
   BottomRight := Limit(0,1,MidY,Phi,Offset - PrevW,MidX,MidY);
   BottomLeft := Limit(0,1,-MidY,Phi,Offset - PrevW,MidX,MidY);
   end;

{Draw profile on array}
Show(TheBitMap);
end;


{-------------------------------------------------------------------------------
TBeamMask
-------------------------------------------------------------------------------}

constructor TBeamMask.Create;
{Create empty mask}
begin
Rows := 0;
Cols := 0;
SetLength(Mask,0);
end;


constructor TBeamMask.Create(aRows,aCols:integer);
{Create zeroed mask Rows X Cols}
var I,J        :integer;
begin
Rows := aRows;
Cols := aCols;
SetLength(Mask,Rows);
for I:=0 to Rows - 1 do
   begin
   SetLength(Mask[I],Cols);
   for J:=0 to Cols - 1 do
      Mask[I,J] := False;
   end;
end;


constructor TBeamMask.CreateFromArray(Arr:TBeamData; LRow,Urow,LCol,UCol:integer;
   Threshold:double);
{Returns a binary array with elements >= Threshold = 1
Parameters:
   Arr:2D array to be binarised
   LRow: Row index from including
   URow: Row index to excluding
   LCol: Column index from including
   UCol: Column index to excluding
   Threshold: value to threshold at}
var I,J        :integer;
begin
Rows := URow - LRow;
Cols := UCol - LCol;
SetLength(Mask,Rows);
for I:= LRow to URow - 1 do
   begin
   SetLength(Mask[I],Cols);
   for J:=LCol to UCol - 1 do
      begin
      if Arr[I,J] >= Threshold then
         Mask[I - LRow,J - LCol] := True
        else
         Mask[I - LRow,J - LCol] := False;
      end;
   end;
end;


constructor TBeamMask.CreateCircle(CRow,CCol,URow,UCol:integer; Radius:double);
{Creates a circular mask centered on CRow and CCol with radius Radius
Parameters:
   CRow: centre row
   CCol: centre column
   URow: number of rows
   UCol: number of columns
   Radius: half width of the circle in pixels}
var I,J        :integer;
begin
Rows := URow;
Cols := UCol;
SetLength(Mask,Rows);
for I:= 0 to URow - 1 do
   begin
   SetLength(Mask[I],Cols);
   for J:=0 to UCol - 1 do
      begin
      if sqr(I - CRow) + sqr(J - CCol) < sqr(Radius) then
         Mask[I,J] := True
        else
         Mask[I,J] := False;
      end;
   end;
end;


destructor TBeamMask.Destroy;
begin
SetLength(Mask,0);
inherited;
end;


procedure TBeamMask.ShrinkMask(CRow,CCol,Factor:double);
{Shrinks the mask around CRow, CCol by the amount Factor}
var I,J        :integer;
    NewMask    :TBeamMask;
begin
NewMask := TBeamMask.Create(Rows,Cols);
for I:=0 to Rows - 1 do
   for J:=0 to Cols - 1 do
      if Mask[I,J] then
         NewMask.Mask[round((I - CRow)*Factor + CRow),round((J - CCol)*Factor + CCol)] := True;
Mask := copy(NewMask.Mask);
NewMask.Free;
end;


initialization
Beam := TBeam.Create;
XPArr := TSingleProfile.Create;
YPArr := TSingleProfile.Create;
IFAType := proportional;
IFAFactor := IFAData[IFAType].defval;

finalization
if Beam <> nil then Beam.Free;
if XPArr <> nil then XPArr.Free;
if YPArr <> nil then YPArr.Free;

end.

