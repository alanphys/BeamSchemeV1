unit bstypes;

{$mode objfpc}{$H+}

interface

uses
   Classes, Graphics, sysutils, TASeries;

type
  TNorm = (no_norm, norm_cax, norm_max);

  TCentre = (peak,detector);
  TCentreData = record
     Name      :string;
  end;

  TIFAType = (proportional, circular, square);
  TIFAData = record
     Name      :string;
     DefVal    :double;
     end;

  TBeamData = array of array of double;

  TMaskArr = array of array of boolean;

  TProfilePoint = record
     X:        double;
     Y:        double;
     end;

  TPArr = array of double;

  TProfilePos = record
     ValueY,
     ValueX    :double;
     Pos       :integer;
     end;

  TBasicProfile = class
     private
     fAve,                     {profile average}
     fMaxDiff  :double;        {maximum profile difference symmetric across centre}
     fMin,                     {profile minimum Y value}
     fMax,                     {profile maximum Y value}
     fCentre   :TProfilePos;   {centre Y value and X position}
     public
     Len       :integer;       {number of elements in profile}
     PArrY     :TPArr;         {1D array containing profile Y points}
     PArrX     :TPArr;         {1D array containing profile X points}
     constructor Create;
     destructor Destroy; override;
     procedure ResetAll;       {reset all parameters and zero array}
     function GetCentre:TProfilePos;{get centre of profile}
     function GetMin:TProfilePos;   {get minimum value and postion}
     function GetMax:TProfilePos;   {get maximum value and position}
     function GetAverage:double;    {get average value}
     function GetMaxDiff:double;    {get maximum symmetric difference}
     property Centre:TProfilePos read GetCentre;
     property Min:TProfilePos read GetMin;
     property Max:TProfilePos read GetMax;
     property Ave:double read GetAverage;
     property MaxDiff:double read GetMaxDiff;
     end;

  TSingleProfile = class(TBasicProfile)
     private
     fPeak,                    {value, position and index of peak centre}
     fLeftEdge,                {value, position and index of field left edge}
     fRightEdge:TProfilePos;   {value, position and index of field right edge}
     public
     TopRight,                 {top right corner of wide profile}
     TopLeft,                  {top left corner of wide profile}
     BottomRight,              {bottom right corner of wide profile}
     BottomLeft:TPoint;        {bottom left corner of wide profile}
     Angle,                    {Angle of profile}
     Offset,                   {offset from centre of image}
     Width,                    {width of wide profile}
     PrevW     :integer;       {previous width of wide profile}
     Norm      :TNorm;         {profile normalisation (none, max or cax)}
     sProt,                    {analysis protocol name}
     sExpr     :string;        {name of parameter being evaluated}
     IFA       :TBasicProfile; {array holding in field values}
     constructor Create;
     destructor Destroy; override;
     procedure ResetAll;       {reset all parameters and zero array}
     procedure ResetParams;    {reset calculated parameters}
     procedure ResetCoords;    {set profile coordinates back to 0}
     procedure SetParams(aAngle,aOffset,aWidth:integer); {set parameters from GUI}
     procedure Show(TheBitMap:Tbitmap);
     procedure Draw(TheBitmap:TBitmap);
     function GetPos(Value:double; D:Integer):TProfilePos;
     function GetLeftE:TProfilePos; {get left edge of profile}
     function GetRightE:TProfilePos;{get right edge of profile}
     function GetPeakPos:TProfilePos;{get centre of profile peak}
     procedure ToSeries(ProfileSeries:TLineSeries);
     function  ToText:string;
     function GetArea(Start,Stop:integer):double;
     property LeftEdge:TProfilePos read GetLeftE;
     property RightEdge:TProfilePos read GetRightE;
     property Peak:TProfilePos read GetPeakPos;
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
     destructor Destroy;override;
     procedure Reset;
     procedure ResetParams;
     procedure DisplayIFA(MBitMap:TBitMap);
     procedure CentreData;
     function GetInFieldArea:TBasicBeam;
     procedure CreateProfile(ProfileArr:TSingleProfile; DTBPU,DTBPL:longint);
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
     constructor CreateCircle(CRow,CCol,Radius:double; URow,UCol:integer);
     constructor CreateSquare(CRow,CCol,Side:double; URow,UCol:integer);
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
      (Name: 'Circular'; DefVal: 0.4),
      (Name: 'Square'; DefVal: 16.0));

   CentreData: array[peak..detector] of TCentreData = (
      (Name: 'Peak'),
      (Name: 'Detector'));

var Beam         :TBeam;
    XPArr,
    YPArr        :TSingleProfile;
    DefaultRes   :double = 2.54/75; {default to 75dpi for Gafchromic}
    ShowPoints   :boolean = False;
    ShowParams   :boolean = False;
    IFAType      :TIFAType = proportional;
    IFAFactor    :double;
    Precision    :integer = 2;
    Centering    :TCentre = detector;

implementation

uses math, mathsfuncs, IntfGraphics, FPImage, Graphtype;

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
   EndCol := Cols - 1;
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
{Returns the geometric centre value of the detector}
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
{Returns the indices of the top left corner of the unweighted centre of mass of
the distribution in the form (row,col)}
var I,J        :integer;
    Value      :double = 0.5;
    Sum        :integer;
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
   Sum := 0;
   for I:=0 to Rows - 1 do
      for J:=0 to Cols - 1 do
         if Data[I,J] >= Value then
            begin
            fCoM.X := fCom.X + I;
            fCoM.Y := fCom.Y + J;
            Inc(Sum);
            end;
   fCom.X := fCom.X/Sum;       {row centre}
   fCom.Y := fCom.Y/Sum;       {column centre}
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
    CRow,                      {row to centre IFA on}
    CCol       :double;        {column to centre IFA on}
begin
BeamMask := nil;
if Length(fIFA.Data) = 0 then
   begin
   if Centering = peak then
      begin
      CRow := Com.X;
      CCol := Com.Y;
      end
     else
      begin
      CRow := (Rows - 1)/2.0;
      CCol := (Cols - 1)/2.0;
      end;
   case IFAType of
      proportional:begin
         BeamMask := TBeamMask.CreateFromArray(Data,0,Rows,0,Cols, Max/2);
         BeamMask.ShrinkMask(CRow,CCol,IFAFactor);
         end;
      circular: begin
         BeamMask := TBeamMask.CreateCircle(CRow,CCol,IFAFactor/XRes,Rows,Cols);
         end;
      square: begin
         BeamMask := TBeamMask.CreateSquare(CRow,CCol,IFAFactor/XRes,Rows,Cols);
         end;
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


procedure TBeam.CreateProfile(ProfileArr:TSingleProfile; DTBPU,DTBPL:longint);
{Given the profile coords calculate the profile from the beam data.

Parameters
----------
Beam           Image data to extract profile from
ProfileArr     Class to store profile
DTBPU          Upper bound for profile windowing
DTBPL          Lower bound for profile windowing
Normalisation  Normalisation mode of profile (none, cax_norm, max_norm)
}
var I,J,K,                     {loop iterators}
    PLen,
    LimX,
    LimY       :longint;
    X,Y,
    MidX,
    MidY,
    XInc,
    YInc,
    MidP,
    TanA,
    Phi,
    rAngle     :double;
    Start,
    Stop       :TPoint;
    DLine      :TRect;

procedure AddPoint(var P,pIFA:double; X,Y:double; LimX,LimY,DTBPL,DTBPU:longint);
var I,J        :longint;
    Z          :double;
begin
I := round(Y);
J := round(X);
if (J >= 0) and (J < LimX) and (I >= 0) and (I < LimY) then
   begin
   Z := Data[I,J];
   if Z < DTBPL then Z := DTBPL;
   if Z > DTBPU then Z := DTBPU;
   P := P + Z;
   if not IsNaN(IFA.Data[I,J]) then
      begin
      if IsNaN(pIFA) then pIFA := Z
         else pIFA := pIFA + Z;
      end
     else
      if pIFA = 0 then pIFA := NaN;
   end;
 end;

procedure AddWideProfile(var ProfY,pIFA:double; aX,aY,aXInc,aYInc:double; pWidth:integer);
var L          :longint;
    WNX,
    WNY,
    WPX,
    WPY        :double;

begin
WNX := aX;
WNY := aY;
WPX := aX;
WPY := aY;
for L:=1 to pWidth do
   begin
   WNX := WNX + aYInc;     {increments are inverted because slope is}
   WNY := WNY - aXInc;     {perpendicular to profile}
   WPX := WPX - aYInc;
   WPY := WPY + aXInc;
   {add negative profile}
   AddPoint(ProfY,pIFA,WNX,WNY,LimX,LimY,DTBPL,DTBPU);

   {add positive profile}
   AddPoint(ProfY,pIFA,WPX,WPY,LimX,LimY,DTBPL,DTBPU);
   end;
end;

begin
{Set limits}
rAngle := ProfileArr.Angle*2*pi/360;       {convert angle to radians}
TanA := arctan(Rows/Cols);                 {get limit of corners}
Phi := rAngle + pi/2;                      {add 90 degrees to get perpendicular}
LimX := Cols;
LimY := Rows;
MidX := (LimX - 1)/2;
MidY := (LimY - 1)/2;
ProfileArr.ResetParams;
ProfileArr.PrevW := ProfileArr.Width div 2;

{Set up limits and increments}
DLine := LimitL(rAngle,Phi,TanA,ProfileArr.Offset,MidX,MidY,0,0,LimX,LimY);
Start := DLine.TopLeft;
Stop := DLine.BottomRight;
Plen := round(sqrt(sqr(Stop.X - Start.X)+ sqr(Stop.Y - Start.Y)));
ProfileArr.Len := PLen + 1;
ProfileArr.IFA.Len := ProfileArr.Len;
Setlength(ProfileArr.PArrX,ProfileArr.Len);
Setlength(ProfileArr.PArrY,ProfileArr.Len);
SetLength(ProfileArr.IFA.PArrY,ProfileArr.Len);
X := Start.X;
Y := Start.Y;
I := Start.Y;
J := Start.X;
XInc := (Stop.X - Start.X)/PLen;
YInc := (Stop.Y - Start.Y)/PLen;
MidP := sqrt(sqr((Stop.X - Start.X)*XRes) + sqr((Stop.Y - Start.Y)*YRes))/2;
K:= 0;

{Add first point}
ProfileArr.PArrX[K] := sqrt(sqr((X - Start.X)*XRes) + sqr((Y - Start.Y)*YRes)) - MidP;
AddPoint(ProfileArr.PArrY[K],ProfileArr.IFA.PArrY[K],X,Y,LimX,LimY,DTBPL,DTBPU);

{add wide profile}
if ProfileArr.PrevW > 0 then
   AddWideProfile(ProfileArr.ParrY[K],ProfileArr.IFA.PArrY[K],X,Y,XInc,YInc,ProfileArr.PrevW);

{add rest of points}
repeat
   X := X + XInc;
   Y := Y + YInc;
   I := Round(Y);
   J := Round(X);
   Inc(K);
   ProfileArr.PArrX[K] := sqrt(sqr((X - Start.X)*XRes) + sqr((Y - Start.Y)*YRes)) - MidP;
   AddPoint(ProfileArr.PArrY[K],ProfileArr.IFA.PArrY[K],X,Y,LimX,LimY,DTBPL,DTBPU);

   {add wide profiles}
   if ProfileArr.PrevW > 0 then
      AddWideProfile(ProfileArr.PArrY[K],ProfileArr.IFA.PArrY[K],X,Y,XInc,YInc,ProfileArr.PrevW);
   until (I = Stop.Y) and (J = Stop.X);
ProfileArr.Norm := Norm;
ProfileArr.IFA.PArrX := ProfileArr.PArrX;
end;


{-------------------------------------------------------------------------------
TBasicProfile
-------------------------------------------------------------------------------}

constructor TBasicProfile.Create;
begin
ResetAll;
end;


destructor TBasicProfile.Destroy;
begin
SetLength(PArrY,0);
SetLength(PArrX,0);
inherited;
end;


procedure TBasicProfile.ResetAll;
{set all profile values back to default}
begin
fAve := 0.0;
fMaxDiff := 0.0;
SetLength(PArrY,0);
PArrY := nil;
SetLength(PArrX,0);
PArrX := nil;
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
end;


function TBasicProfile.GetCentre:TProfilePos;
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


function TBasicProfile.GetMax:TProfilePos;
begin
if fMax.ValueY = 0 then
   begin
   fMax.Pos:= MaxPosNaN(PArrY,0,Len).Pos;
   fMax.ValueX := PArrX[fMax.Pos];
   fMax.ValueY := PArrY[fMax.Pos];
   end;
Result := fMax;
end;


function TBasicProfile.GetMin:TProfilePos;
begin
if SameValue(fMin.ValueY,MaxDouble) then
   begin
   fMin.Pos:= MinPosNaN(PArrY,0,Len).Pos;
   fMin.ValueX := PArrX[fMin.Pos];
   fMin.ValueY := PArrY[fMin.Pos];
   end;
Result := fMin;
end;


function TBasicProfile.GetAverage:double;
var I,K        :integer;
    Sum        :double;
begin
if fAve = 0 then
   begin
   Sum := 0;
   K := 0;
   for I:=0 to Len - 1 do
      if not IsNaN(PArrY[I]) then
         begin
         Sum := Sum + PArrY[I];
         Inc(K);
         end;
   fAve := Sum/K;
   end;
Result := fAve;
end;


function TBasicProfile.GetMaxDiff:double;
{max symmetric difference over profile}
var I          :integer;
    Diff       :double;
begin
if fMaxDiff = 0 then
   for I:= 0 to Len - 1 do
      if (not IsNan(PArrY[I])) and (not IsNaN(PArrY[Len - I - 1])) then
         begin
         Diff := abs(PArrY[I] - PArrY[Len - I - 1]);
         if Diff > fMaxDiff then fMaxDiff := Diff;
         end;
Result := fMaxDiff;
end;


{-------------------------------------------------------------------------------
TSingleProfile
-------------------------------------------------------------------------------}

constructor TSingleProfile.Create;
begin
IFA := TBasicProfile.Create;
ResetAll;
end;


destructor TSingleProfile.Destroy;
begin
IFA.Free;
inherited;
end;


procedure TSingleProfile.ResetAll;
{set all profile values back to default}
begin
inherited;
IFA.ResetAll;
Angle := 0;
Offset := 0;
Width := 1;
PrevW := 1;
fLeftEdge.ValueY := 0.0;
fLeftEdge.ValueX := 0.0;
fLeftEdge.Pos := 0;
fRightEdge.ValueY := 0.0;
fRightEdge.ValueX := 0.0;
fRightEdge.Pos := 0;
fPeak.ValueY := 0.0;
fPeak.ValueX := 0.0;
fPeak.Pos := 0;
ResetCoords;
sProt := '';
sExpr := '';
Norm := no_norm;
end;


procedure TSingleProfile.ResetParams;
{set all calculated profile values back to default}
begin
inherited ResetAll;
IFA.ResetAll;
fLeftEdge.ValueY := 0.0;
fLeftEdge.ValueX := 0.0;
fLeftEdge.Pos := 0;
fRightEdge.ValueY := 0.0;
fRightEdge.ValueX := 0.0;
fRightEdge.Pos := 0;
fPeak.ValueY := 0.0;
fPeak.ValueX := 0.0;
fPeak.Pos := 0;
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


function TSingleProfile.GetPos(Value:double; D:Integer):TProfilePos;
{Return the first point from the centre where the profile becomes less than
Max or Cax times Value. D gives direction Up (increment) or Down (decrement)}
var I          :integer;

begin
I := Centre.Pos;
case Norm of
   no_norm : Value := Centre.ValueY*Value;
   norm_cax: Value := (Centre.ValueY - Min.ValueY)*Value + Min.ValueY;
   norm_max: Value := (Max.ValueY - Min.ValueY)*Value + Min.ValueY;
   end; {of case}

while (PArrY[I] > Value) and (I >= 0) and (I < Len) do inc(I,D);
if (I >= 0) and (I < Len) then
   begin
   Result.ValueY := Value;
   Result.ValueX := ILReg(PArrX[I],PArrX[I-D],PArrY[I],PArrY[I-D],Value);
   Result.Pos := I - D;
   end
  else
   begin
   Result.ValueY := 0;
   Result.ValueX := 0;
   Result.Pos := 0;
   end;
end;


function TSingleProfile.GetLeftE:TProfilePos;
{Return the value, position and index of the field left edge. The index is the
first integer index after the field edge.}
begin
{for performance only calculate if not previously calculated}
if fLeftEdge.ValueY = 0 then
   fLeftEdge := GetPos(0.5,-1);
Result := fLeftEdge;
end;


function TSingleProfile.GetRightE:TProfilePos;
{Return the value, position and index of the field right edge. The index is the
first integer index after the field edge.}
begin
{for performance only calculate if not previously calculated}
if fRightEdge.ValueY = 0 then
   fRightEdge := GetPos(0.5,1);
Result := fRightEdge;
end;


function TSingleProfile.GetPeakPos:TProfilePos;
{Returns the centre of the profile peak}
begin
if fPeak.ValueY = 0 then
   begin
   fPeak.ValueX := (RightEdge.ValueX + LeftEdge.ValueX)/2;
   fPeak.Pos := (RightEdge.Pos + LeftEdge.Pos) div 2;
   fPeak.ValueY := PArrY[fPeak.Pos];
   end;
Result := fPeak;
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
      norm_max: Y := (PArrY[K] - Min.ValueY)*100/(Max.ValueY - Min.ValueY);
      end; {of case}
   if (X <> 0) or (Y <> 0) then
      ProfileSeries.AddXY(X,Y,'',clRed);
   end;
end;


function TSingleProfile.ToText:string;
{writes the array data out to a string}
var K          :integer;
    X,Y        :double;
begin
Result :='';
for K := 0 to Len - 1 do
   begin
   X := PArrX[K];
   case Norm of
      no_norm : Y := PArrY[K];
      norm_cax: Y := (PArrY[K] - Min.ValueY)*100/(Centre.ValueY - Min.ValueY);
      norm_max: Y := (PArrY[K] - Min.ValueY)*100/(Max.ValueY - Min.ValueY);
      end; {of case}
   Result := Result + FloatToStrF(X,ffFixed,5,Precision) + ', ' + FloatToStrF(Y,ffFixed,5,Precision);
   if ShowParams and not IsNaN(IFA.PArrY[K]) then Result := Result + ', ' +
      FloatToStrF(IFA.PArrY[K],ffFixed,5,Precision);
   Result := Result + LineEnding;
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


function TSingleProfile.GetArea(Start,Stop:integer):double;
{Return the area between start and stop indices}
var I          :integer;
begin
Result := 0;
for I := Start to Stop do
   Result := Result + PArrY[I];
Result := Result*abs(PArrX[Stop] - PArrX[Start]);
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


constructor TBeamMask.CreateCircle(CRow,CCol,Radius:double; URow,UCol:integer);
{Creates a circular mask centered on CRow and CCol with radius Radius
Parameters:
   CRow: centre row
   CCol: centre column
   Radius: half width of the circle in pixels
   URow: number of rows
   UCol: number of columns}
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
      if sqr(I - CRow) + sqr(J - CCol) <= sqr(Radius) then
         Mask[I,J] := True
        else
         Mask[I,J] := False;
      end;
   end;
end;


constructor TBeamMask.CreateSquare(CRow,CCol,Side:double; URow,UCol:integer);
{Creates a square mask centered on CRow and CCol with side Radius
Parameters:
   CRow: centre row
   CCol: centre column
   Radius: half width of the circle in pixels
   URow: number of rows
   UCol: number of columns}
var I,J        :integer;
begin
Rows := URow;
Cols := UCol;
Side := Side/2;
SetLength(Mask,Rows);
for I:= 0 to URow - 1 do
   begin
   SetLength(Mask[I],Cols);
   for J:=0 to UCol - 1 do
      begin
      if (abs(I - CRow) <= Side) and (abs(J - CCol) <= Side) then
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
IFAFactor := IFAData[IFAType].defval;

finalization
if Beam <> nil then Beam.Free;
if XPArr <> nil then XPArr.Free;
if YPArr <> nil then YPArr.Free;

end.

