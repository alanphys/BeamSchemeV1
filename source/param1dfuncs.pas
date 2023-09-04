unit param1Dfuncs;
{This unit contains the functions to calculate 1D profile parameters. Functions
are organized as a constant enumerated array each element of which consists of
the name of the function and the associated function definition.

Licence: Modified MIT, please see the file licence.txt

To add a parameter:
1) Write the function calculating the parameter and add it to the appropriate
   section. Function identifiers should be written in camel hump and contain
   only two parameters, the profile class and the normalisation. Functions
   return a string containing the formatted result and units.
2) Add the function identifier to the interface function list.
3) Add the parameter name and function to the constant array Params. The
   parameter name is the string used in the protocol.
4) Insert the enumerated type name in the parameter list (T1DParams) before the
   no_func entry. Make sure the position of the enumerated type name and entry
   in the constant array correspond.
5) Remember to add a help entry

See existing parameters for examples.

Nomenclature:
1) Function identifiers are in camel hump, eg. FieldEdgeLeft501D.
2) Parameter names are in space separated, capitalised strings, eg. '1D Field Edge Left 50'.
3) Enumerated type is in underscore separated, lower case, eg. field_edge_left_50_1D.}


{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, bstypes;

type
T1DParamFunc = function(ProfileArr:TSingleProfile):string;

T1DParams = ({field statistics}
             cax_val_1D,
             max_val_1D,
             max_pos_1D,
             min_val_1D,
             min_ifa_1D,
             ave_ifa_1D,
             {interpolated params}
             field_edge_left_50_1D,
             field_edge_right_50_1D,
             field_centre_50_1D,
             field_size_50_1D,
             pen_8020_left_1D,
             pen_8020_right_1D,
             pen_9010_left_1D,
             pen_9010_right_1D,
             pen_9050_left_1D,
             pen_9050_right_1D,
             {differential params}
             field_diff_left_1D,
             field_diff_right_1D,
             field_centre_diff_1D,
             field_size_diff_1D,
             {inflection point params}
             field_infl_left_1D,
             field_infl_right_1D,
             field_centre_infl_1D,
             field_size_infl_1D,
             pen_infl_left_1D,
             pen_infl_right_1D,
             {dose point values}
             dose_20_left_1D,
             dose_20_right_1D,
             dose_50_left_1D,
             dose_50_right_1D,
             dose_60_left_1D,
             dose_60_right_1D,
             dose_80_left_1D,
             dose_80_right_1D,
             {flatness and uniformity}
             flat_ave_1D,
             flat_diff_1D,
             flat_ratio_1D,
             flat_cax_1D,
             uniformity_ave_1D,
             flat_9050_1D,
             {symmetry}
             sym_ratio_1D,
             sym_diff_1D,
             sym_ave_1D,
             sym_area_1D,
             {deviation}
             dev_ratio_1D,
             dev_diff_1D,
             dev_cax_1D,
             {miscellaneous}
             no_func_1D);

T1DParamFuncs = record
   Name      :string;
   Func      :T1DParamFunc;
   end;


function Calc1DParam(ProfileArr:TSingleProfile):string;
{field statistics}
function CAXVal1D(ProfileArr:TSingleProfile):string;
function MaxVal1D(ProfileArr:TSingleProfile):string;
function MaxPos1D(ProfileArr:TSingleProfile):string;
function MinVal1D(ProfileArr:TSingleProfile):string;
function MinIFA1D(ProfileArr:TSingleProfile):string;
function AveIFA1D(ProfileArr:TSingleProfile):string;
{interpolated params}
function FieldEdgeLeft501D(ProfileArr:TSingleProfile):string;
function FieldEdgeRight501D(ProfileArr:TSingleProfile):string;
function FieldCentre501D(ProfileArr:TSingleProfile):string;
function FieldSize501D(ProfileArr:TSingleProfile):string;
function Penumbra8020Left1D(ProfileArr:TSingleProfile):string;
function Penumbra8020Right1D(ProfileArr:TSingleProfile):string;
function Penumbra9010Left1D(ProfileArr:TSingleProfile):string;
function Penumbra9010Right1D(ProfileArr:TSingleProfile):string;
function Penumbra9050Left1D(ProfileArr:TSingleProfile):string;
function Penumbra9050Right1D(ProfileArr:TSingleProfile):string;
{differential params}
function FieldDiffLeft1D(ProfileArr:TSingleProfile):string;
function FieldDiffRight1D(ProfileArr:TSingleProfile):string;
function FieldCentreDiff1D(ProfileArr:TSingleProfile):string;
function FieldSizeDiff1D(ProfileArr:TSingleProfile):string;
{inflection point params}
function FieldInflLeft1D(ProfileArr:TSingleProfile):string;
function FieldInflRight1D(ProfileArr:TSingleProfile):string;
function FieldCentreInfl1D(ProfileArr:TSingleProfile):string;
function FieldSizeInfl1D(ProfileArr:TSingleProfile):string;
function PenumbraInflLeft1D(ProfileArr:TSingleProfile):string;
function PenumbraInflRight1D(ProfileArr:TSingleProfile):string;
{Dose point values}
function Dose20Left1D(ProfileArr:TSingleProfile):string;
function Dose20Right1D(ProfileArr:TSingleProfile):string;
function Dose50Left1D(ProfileArr:TSingleProfile):string;
function Dose50Right1D(ProfileArr:TSingleProfile):string;
function Dose60Left1D(ProfileArr:TSingleProfile):string;
function Dose60Right1D(ProfileArr:TSingleProfile):string;
function Dose80Left1D(ProfileArr:TSingleProfile):string;
function Dose80Right1D(ProfileArr:TSingleProfile):string;
{flatness and uniformity}
function FlatnessAve1D(ProfileArr:TSingleProfile):string;
function FlatnessDiff1D(ProfileArr:TSingleProfile):string;
function FlatnessRatio1D(ProfileArr:TSingleProfile):string;
function FlatnessCAX1D(ProfileArr:TSingleProfile):string;
function UniformityAve1D(ProfileArr:TSingleProfile):string;
function Flatness90501D(ProfileArr:TSingleProfile):string;
{symmetry}
function SymmetryRatio1D(ProfileArr:TSingleProfile):string;
function SymmetryDiff1D(ProfileArr:TSingleProfile):string;
function SymmetryAve1D(ProfileArr:TSingleProfile):string;
function SymmetryArea1D(ProfileArr:TSingleProfile):string;
{deviation}
function DeviationRatio1D(ProfileArr:TSingleProfile):string;
function DeviationDiff1D(ProfileArr:TSingleProfile):string;
function DeviationCAX1D(ProfileArr:TSingleProfile):string;
{miscellaneous}
function NoFunc1D(ProfileArr:TSingleProfile):string;


const
Params1D: array[cax_val_1D..no_func_1D] of T1DParamFuncs = (
   {field statistics}
   (Name:'1D CAX Value'; Func:@CAXVal1D),
   (Name:'1D Max Value'; Func:@MaxVal1D),
   (Name:'1D Max Pos'; Func:@MaxPos1D),
   (Name:'1D Min Value'; Func:@MinVal1D),
   (Name:'1D Min IFA'; Func:@MinIFA1D),
   (Name:'1D Average IFA'; Func:@AveIFA1D),
   {interpolated params}
   (Name:'1D Field Edge Left 50'; Func:@FieldEdgeLeft501D),
   (Name:'1D Field Edge Right 50'; Func:@FieldEdgeRight501D),
   (Name:'1D Field Centre 50'; Func:@FieldCentre501D),
   (Name:'1D Field Size 50'; Func:@FieldSize501D),
   (Name:'1D Penumbra 8020 Left'; Func:@Penumbra8020Left1D),
   (Name:'1D Penumbra 8020 Right'; Func:@Penumbra8020Right1D),
   (Name:'1D Penumbra 9010 Left'; Func:@Penumbra9010Left1D),
   (Name:'1D Penumbra 9010 Right'; Func:@Penumbra9010Right1D),
   (Name:'1D Penumbra 9050 Left'; Func:@Penumbra9050Left1D),
   (Name:'1D Penumbra 9050 Right'; Func:@Penumbra9050Right1D),
   {differential params}
   (Name:'1D Left Diff'; Func:@FieldDiffLeft1D),
   (Name:'1D Right Diff'; Func:@FieldDiffRight1D),
   (Name:'1D Field Centre Diff'; Func:@FieldCentreDiff1D),
   (Name:'1D Field Size Diff'; Func:@FieldSizeDiff1D),
   {inflection point params}
   (Name:'1D Left Infl'; Func:@FieldInflLeft1D),
   (Name:'1D Right Infl'; Func:@FieldInflRight1D),
   (Name:'1D Field Centre Infl'; Func:@FieldCentreInfl1D),
   (Name:'1D Field Size Infl'; Func:@FieldSizeInfl1D),
   (Name:'1D Penumbra Infl Left'; Func:@PenumbraInflLeft1D),
   (Name:'1D Penumbra Infl Right'; Func:@PenumbraInflRight1D),
   (Name:'1D Dose 20% FW Left'; Func:@Dose20Left1D),
   (Name:'1D Dose 20% FW Right'; Func:@Dose20Right1D),
   (Name:'1D Dose 50% FW Left'; Func:@Dose50Left1D),
   (Name:'1D Dose 50% FW Right'; Func:@Dose50Right1D),
   (Name:'1D Dose 60% FW Left'; Func:@Dose60Left1D),
   (Name:'1D Dose 60% FW Right'; Func:@Dose60Right1D),
   (Name:'1D Dose 80% FW Left'; Func:@Dose80Left1D),
   (Name:'1D Dose 80% FW Right'; Func:@Dose80Right1D),
   {flatness and uniformity}
   (Name:'1D Flatness Ave'; Func:@FlatnessAve1D),
   (Name:'1D Flatness Diff'; Func:@FlatnessDiff1D),
   (Name:'1D Flatness Ratio'; Func:@FlatnessRatio1D),
   (Name:'1D Flatness CAX'; Func:@FlatnessCAX1D),
   (Name:'1D Uniformity ICRU'; Func:@UniformityAve1D),
   (Name:'1D Flatness 9050'; Func:@Flatness90501D),
   {symmetry}
   (Name:'1D Symmetry Ratio'; Func:@SymmetryRatio1D),
   (Name:'1D Symmetry Diff'; Func:@SymmetryDiff1D),
   (Name:'1D Symmetry Ave'; Func:@SymmetryAve1D),
   (Name:'1D Symmetry Area'; Func:@SymmetryArea1D),
   {deviation}
   (Name:'1D Deviation Ratio'; Func:@DeviationRatio1D),
   (Name:'1D Deviation Diff'; Func:@DeviationDiff1D),
   (Name:'1D Deviation CAX'; Func:@DeviationCAX1D),
   {miscellaneous}
   (Name:'1D No Function'; Func:@NoFunc1D));

implementation

uses math, mathsfuncs;

{-------------------------------------------------------------------------------
 Field statistics
-------------------------------------------------------------------------------}

function CAXVal1D(ProfileArr:TSingleProfile):string;
{Returns the value of the centre of the profile. If the profile is normalised
to CAX this is by definition 100%.}
begin
with ProfileArr do
   begin
   Result := FloatToStrF(Normalise(Centre.ValueY),ffFixed,4,Precision);
   if Norm <> no_norm then Result := Result + '%'
   end;
end;


function MaxVal1D(ProfileArr:TSingleProfile):string;
{Returns the maximum value of the profile. If the profile is normalised to Max
this is by definition 100%}
begin
with ProfileArr do
   begin
   Result := FloatToStrF(Normalise(Max.ValueY),ffFixed,4,Precision);
   if Norm <> no_norm then Result := Result + '%'
   end;
end;


function MaxPos1D(ProfileArr:TSingleProfile):string;
{Returns the maximum value of the profile. If the profile is normalised to Max
this is by definition 100%}
begin
with ProfileArr do
   begin
   Result := FloatToStrF(Normalise(Max.ValueX),ffFixed,4,Precision) +'cm';
   end;
end;


function MinVal1D(ProfileArr:TSingleProfile):string;
{Returns the minimum value of the profile. For norm_max and norm_cax the profile
is grounded and the min value is 0.}
begin
with ProfileArr do
   begin
   Result := FloatToStrF(Normalise(Min.ValueY),ffFixed,4,Precision);
   if Norm <> no_norm then Result := Result + '%'
   end;
end;


function MinIFA1D(ProfileArr:TSingleProfile):string;
{Returns the minimum value of the IFA. For norm_max and norm_cax the profile
is grounded}
begin
with ProfileArr do
   begin
   Result := FloatToStrF(Normalise(IFA.Min.ValueY),ffFixed,4,Precision);
   if Norm <> no_norm then Result := Result + '%'
   end;
end;


function AveIFA1D(ProfileArr:TSingleProfile):string;
{Returns the average value of the IFA. For norm_max and norm_cax the profile
is grounded}
begin
with ProfileArr do
   begin
   Result := FloatToStrF(Normalise(IFA.Ave),ffFixed,4,Precision);
   if Norm <> no_norm then Result := Result + '%'
   end;
end;


{-------------------------------------------------------------------------------
 Interpolated parameters
-------------------------------------------------------------------------------}

function FieldEdgeLeft501D(ProfileArr:TSingleProfile):string;
{Returns the position of the left field edge at 50% of max or cax value.}
begin
if ProfileArr.LeftEdge.ValueY > 0 then
   Result := FloatToStrF(ProfileArr.LeftEdge.ValueX,ffFixed,4,Precision) + ' cm'
  else
   Result := 'No edge';
end;


function FieldEdgeRight501D(ProfileArr:TSingleProfile):string;
{Returns the position of the right field edge at 50% of max or cax value.}
begin
if ProfileArr.RightEdge.ValueY > 0 then
   Result := FloatToStrF(ProfileArr.RightEdge.ValueX,ffFixed,4,Precision) + ' cm'
  else
   Result := 'No edge';
end;


function FieldCentre501D(ProfileArr:TSingleProfile):string;
{Returns the field centre as given by the 50% field edges}
begin
if (ProfileArr.PeakFWHM.ValueY > 0) then
   begin
   Result := FloatToStrF(ProfileArr.PeakFWHM.ValueX,ffFixed,4,Precision) + ' cm'
   end
  else
   Result := 'No edge';
end;


function FieldSize501D(ProfileArr:TSingleProfile):string;
{Returns the full width half maximum.}
var FieldSize :double;
begin
if (ProfileArr.LeftEdge.ValueY > 0) and (ProfileArr.RightEdge.ValueY > 0) then
   begin
   FieldSize := abs(ProfileArr.RightEdge.ValueX - ProfileArr.LeftEdge.ValueX);
   Result := FloatToStrF(FieldSize,ffFixed,4,Precision) + ' cm'
   end
  else
   Result := 'No edge';
end;


function Penumbra8020Left1D(ProfileArr:TSingleProfile):string;
var Penumbra   :double;
begin
with ProfileArr do
   Penumbra := abs(GetFWXMPos(0.2,-1).ValueX - GetFWXMPos(0.8,-1).ValueX);
Result := FloatToStrF(Penumbra,ffFixed,4,Precision) + ' cm'
end;


function Penumbra8020Right1D(ProfileArr:TSingleProfile):string;
var Penumbra   :double;
begin
with ProfileArr do
   Penumbra := abs(GetFWXMPos(0.2,1).ValueX - GetFWXMPos(0.8,1).ValueX);
Result := FloatToStrF(Penumbra,ffFixed,4,Precision) + ' cm'
end;


function Penumbra9010Left1D(ProfileArr:TSingleProfile):string;
var Penumbra   :double;
begin
with ProfileArr do
   Penumbra := abs(GetFWXMPos(0.1,-1).ValueX - GetFWXMPos(0.9,-1).ValueX);
Result := FloatToStrF(Penumbra,ffFixed,4,Precision) + ' cm'
end;


function Penumbra9010Right1D(ProfileArr:TSingleProfile):string;
var Penumbra   :double;
begin
with ProfileArr do
   Penumbra := abs(GetFWXMPos(0.1,1).ValueX - GetFWXMPos(0.9,1).ValueX);
Result := FloatToStrF(Penumbra,ffFixed,4,Precision) + ' cm'
end;


function Penumbra9050Left1D(ProfileArr:TSingleProfile):string;
var Penumbra   :double;
begin
with ProfileArr do
   Penumbra := abs(LeftEdge.ValueX - GetFWXMPos(0.9,-1).ValueX);
Result := FloatToStrF(Penumbra,ffFixed,4,Precision) + ' cm'
end;


function Penumbra9050Right1D(ProfileArr:TSingleProfile):string;
var Penumbra   :double;
begin
with ProfileArr do
   Penumbra := abs(RightEdge.ValueX - GetFWXMPos(0.9,1).ValueX);
Result := FloatToStrF(Penumbra,ffFixed,4,Precision) + ' cm'
end;


{-------------------------------------------------------------------------------
 Differential parameters
-------------------------------------------------------------------------------}

function FieldDiffLeft1D(ProfileArr:TSingleProfile):string;
{Returns the position of the left maximum slope}
begin
if ProfileArr.LeftDiff.ValueX <> 0 then
   Result := FloatToStrF(ProfileArr.LeftDiff.ValueX,ffFixed,4,Precision) + ' cm'
  else
   Result := 'No edge';
end;


function FieldDiffRight1D(ProfileArr:TSingleProfile):string;
{Returns the position of the right maximum slope}
begin
if ProfileArr.RightDiff.ValueX <> 0 then
   Result := FloatToStrF(ProfileArr.RightDiff.ValueX,ffFixed,4,Precision) + ' cm'
  else
   Result := 'No edge';
end;


function FieldCentreDiff1D(ProfileArr:TSingleProfile):string;
{Returns the field centre as given by the max differential field edges}
begin
if (ProfileArr.PeakDiff.ValueY > 0) then
   begin
   Result := FloatToStrF(ProfileArr.PeakDiff.ValueX,ffFixed,4,Precision) + ' cm'
   end
  else
   Result := 'No edge';
end;


function FieldSizeDiff1D(ProfileArr:TSingleProfile):string;
{Returns the full width half maximum.}
var FieldSize :double;
begin
if (ProfileArr.LeftDiff.ValueY > 0) and (ProfileArr.RightDiff.ValueY < 0) then
   begin
   FieldSize := abs(ProfileArr.RightDiff.ValueX - ProfileArr.LeftDiff.ValueX);
   Result := FloatToStrF(FieldSize,ffFixed,4,Precision) + ' cm'
   end
  else
   Result := 'No edge';
end;


{-------------------------------------------------------------------------------
 Inflection point parameters
-------------------------------------------------------------------------------}
function FieldInflLeft1D(ProfileArr:TSingleProfile):string;
{Returns the position of the left inflection point}
begin
if ProfileArr.LeftInfl.ValueX <> 0 then
   Result := FloatToStrF(ProfileArr.LeftInfl.ValueX,ffFixed,4,Precision) + ' cm'
  else
   Result := 'No edge';
end;


function FieldInflRight1D(ProfileArr:TSingleProfile):string;
{Returns the position of the right inflection point slope}
begin
if ProfileArr.RightInfl.ValueX <> 0 then
   Result := FloatToStrF(ProfileArr.RightInfl.ValueX,ffFixed,4,Precision) + ' cm'
  else
   Result := 'No edge';
end;


function FieldCentreInfl1D(ProfileArr:TSingleProfile):string;
{Returns the field centre as given by the inflection point field edges}
begin
if (ProfileArr.PeakInfl.ValueY > 0) then
   begin
   Result := FloatToStrF(ProfileArr.PeakInfl.ValueX,ffFixed,4,Precision) + ' cm'
   end
  else
   Result := 'No edge';
end;


function FieldSizeInfl1D(ProfileArr:TSingleProfile):string;
{Returns the full width half maximum.}
var FieldSize :double;
begin
if (ProfileArr.LeftInfl.ValueY > 0) and (ProfileArr.RightInfl.ValueY > 0) then
   begin
   FieldSize := abs(ProfileArr.RightInfl.ValueX - ProfileArr.LeftInfl.ValueX);
   Result := FloatToStrF(FieldSize,ffFixed,4,Precision) + ' cm'
   end
  else
   Result := 'No edge';
end;


function PenumbraInflLeft1D(ProfileArr:TSingleProfile):string;
{Return the distance between 0.4 and 1.6 of the inflection point. This
corresponds to the 80%-20% conventional penumbra}
var Penumbra   :double;
begin
with ProfileArr do
   Penumbra := abs(InvHillFunc(ProfileArr.LeftInfl.ValueY*0.4, ProfileArr.HPLeft)
      - InvHillFunc(ProfileArr.LeftInfl.ValueY*1.6, ProfileArr.HPLeft));
Result := FloatToStrF(Penumbra,ffFixed,4,Precision) + ' cm'
end;


function PenumbraInflRight1D(ProfileArr:TSingleProfile):string;
{Return the distance between 0.4 and 1.6 of the inflection point. This
corresponds to the 80%-20% conventional penumbra}
var Penumbra   :double;
begin
with ProfileArr do
   Penumbra := abs(InvHillFunc(ProfileArr.RightInfl.ValueY*1.6, ProfileArr.HPRight)
      - InvHillFunc(ProfileArr.RightInfl.ValueY*0.4, ProfileArr.HPRight));
Result := FloatToStrF(Penumbra,ffFixed,4,Precision) + ' cm'
end;


{-------------------------------------------------------------------------------
 Dose point values
-------------------------------------------------------------------------------}
function Dose20Left1D(ProfileArr:TSingleProfile):string;
{Returns the dose at 20% of the inflection point field size on the profile left}
var Y:         double;
begin
with ProfileArr do
   begin
   Result := FloatToStrF(Normalise(GetRelativePosValue(-0.2).ValueY),ffFixed,4,Precision);
   if Norm <> no_norm then Result := Result + '%'
   end;
end;


function Dose20Right1D(ProfileArr:TSingleProfile):string;
{Returns the dose at 20% of the inflection point field size on the profile left}
var Y:         double;
begin
with ProfileArr do
   begin
   Result := FloatToStrF(Normalise(GetRelativePosValue(0.2).ValueY),ffFixed,4,Precision);
   if Norm <> no_norm then Result := Result + '%'
   end;
end;


function Dose50Left1D(ProfileArr:TSingleProfile):string;
{Returns the dose at 50% of the inflection point field size on the profile left}
var Y:         double;
begin
with ProfileArr do
   begin
   Result := FloatToStrF(Normalise(GetRelativePosValue(-0.5).ValueY),ffFixed,4,Precision);
   if Norm <> no_norm then Result := Result + '%'
   end;
end;


function Dose50Right1D(ProfileArr:TSingleProfile):string;
{Returns the dose at 50% of the inflection point field size on the profile left}
var Y:         double;
begin
with ProfileArr do
   begin
   Result := FloatToStrF(Normalise(GetRelativePosValue(0.5).ValueY),ffFixed,4,Precision);
   if Norm <> no_norm then Result := Result + '%'
   end;
end;


function Dose60Left1D(ProfileArr:TSingleProfile):string;
{Returns the dose at 60% of the inflection point field size on the profile left}
var Y:         double;
begin
with ProfileArr do
   begin
   Result := FloatToStrF(Normalise(GetRelativePosValue(-0.6).ValueY),ffFixed,4,Precision);
   if Norm <> no_norm then Result := Result + '%'
   end;
end;


function Dose60Right1D(ProfileArr:TSingleProfile):string;
{Returns the dose at 60% of the inflection point field size on the profile left}
var Y:         double;
begin
with ProfileArr do
   begin
   Result := FloatToStrF(Normalise(GetRelativePosValue(0.6).ValueY),ffFixed,4,Precision);
   if Norm <> no_norm then Result := Result + '%'
   end;
end;


function Dose80Left1D(ProfileArr:TSingleProfile):string;
{Returns the dose at 80% of the inflection point field size on the profile left}
var Y:         double;
begin
with ProfileArr do
   begin
   Result := FloatToStrF(Normalise(GetRelativePosValue(-0.8).ValueY),ffFixed,4,Precision);
   if Norm <> no_norm then Result := Result + '%'
   end;
end;


function Dose80Right1D(ProfileArr:TSingleProfile):string;
{Returns the dose at 80% of the inflection point field size on the profile left}
var Y:         double;
begin
with ProfileArr do
   begin
   Result := FloatToStrF(Normalise(GetRelativePosValue(0.8).ValueY),ffFixed,4,Precision);
   if Norm <> no_norm then Result := Result + '%'
   end;
end;


{-------------------------------------------------------------------------------
 Flatness and uniformity parameters
-------------------------------------------------------------------------------}

function FlatnessAve1D(ProfileArr:TSingleProfile):string;
begin
with ProfileArr do
Result := FloatToStrF(100*(IFA.Max.ValueY + IFA.Min.ValueY)/
   (2*Centre.ValueY),ffFixed,4,Precision) + '%';
end;


function FlatnessDiff1D(ProfileArr:TSingleProfile):string;
begin
with ProfileArr do
Result := FloatToStrF(100*(IFA.Max.ValueY - IFA.Min.ValueY)/
   (IFA.Max.ValueY + IFA.Min.ValueY),ffFixed,4,Precision) + '%';
end;


function FlatnessRatio1D(ProfileArr:TSingleProfile):string;
begin
with ProfileArr do
Result := FloatToStrF(100*IFA.Max.ValueY/IFA.Min.ValueY,ffFixed,4,Precision) + '%';
end;


function FlatnessCAX1D(ProfileArr:TSingleProfile):string;
begin
with ProfileArr do
Result := FloatToStrF(100*(IFA.Max.ValueY - IFA.Min.ValueY)/
   (2*Centre.ValueY),ffFixed,4,Precision) + '%';
end;


function UniformityAve1D(ProfileArr:TSingleProfile):string;
{Returns the maximum difference between the max and the min
of the IFA normalised to the average of the IFA according to ICRU 72 eq 3.2.
(Dmax - Dmin)*100/Ave}
begin
with ProfileArr do
Result := FloatToStrF(100*(IFA.Max.ValueY - IFA.Min.ValueY)/
   IFA.Ave,ffFixed,4,Precision) + '%';
end;


function Flatness90501D(ProfileArr:TSingleProfile):string;
{Returns the ratio of the length of the 90% isodose over the length of the 50% isodose,
with the dose normalized at 100% at beam center.}
var Flat9050   :double;
begin
with ProfileArr do
   Flat9050 := 100*(GetFWXMPos(0.9,1).ValueX - GetFWXMPos(0.9,-1).ValueX)/
      (RightEdge.ValueX - LeftEdge.ValueX);
Result := FloatToStrF(Flat9050,ffFixed,4,Precision) + '%';
end;


{-------------------------------------------------------------------------------
 Symmetry parameters
-------------------------------------------------------------------------------}

function SymmetryRatio1D(ProfileArr:TSingleProfile):string;
{max symmetric difference over IFA}
var I          :integer;
    Ratio,
    MaxRatio   :double;
begin
MaxRatio := 0;
with ProfileArr do
   for I:= 0 to Len - 1 do
      if (not IsNaN(IFA.PArrY[I])) and (not IsNaN(IFA.PArrY[Len - I - 1])) then
         begin
         Ratio := IFA.PArrY[I]/IFA.PArrY[Len - I - 1];
         if Ratio > MaxRatio then MaxRatio := Ratio;
         end;
Result := FloatToStrF(100*MaxRatio,ffFixed,4,Precision) + '%';
end;


function SymmetryDiff1D(ProfileArr:TSingleProfile):string;
{max symmetric difference over IFA}
begin
Result := FloatToStrF(100*ProfileArr.IFA.MaxDiff/ProfileArr.Centre.ValueY,ffFixed,4,Precision) + '%';
end;


function SymmetryAve1D(ProfileArr:TSingleProfile):string;
{max symmetric difference over IFA according to NCS-70 eq 3-6.
max(abs(D(x,y) - D(-x,-y)))*100/Dave}
begin
Result := FloatToStrF(100*ProfileArr.IFA.MaxDiff/ProfileArr.IFA.Ave,ffFixed,4,Precision) + '%';
end;


function SymmetryArea1D(ProfileArr:TSingleProfile):string;
{calculates the difference of the areas from the centre of the peak to the
field edge. A correction is made for offcentre peaks.}
var AreaL,
    AreaR,
    AreaM      :double;
    Region,
    HalfR      :integer;
begin
with ProfileArr do
   if (LeftEdge.Pos > 0) and (RightEdge.Pos < Len) then
      begin
         begin
         Region := (RightEdge.Pos - LeftEdge.Pos);
         HalfR := Region div 2;
         AreaM := PeakFWHM.ValueY*PeakFWHM.ValueX;
         AreaL := GetArea(LeftEdge.Pos,LeftEdge.Pos + HalfR);
         {correct for area between last index and edge}
         AreaL := AreaL + PArrY[LeftEdge.Pos - 1]*abs(LeftEdge.ValueX - PArrX[LeftEdge.Pos]);
         {correct for offcentre peak}
         if odd(Region) then               {if number of points are odd left and right regions overlap}
            AreaL := AreaL + AreaM
           else
            AreaL := AreaL + AreaM - 0.5*AreaM;

         AreaR := GetArea(RightEdge.Pos - HalfR, RightEdge.Pos);
         {correct for area between last index and edge}
         AreaR := AreaR + PArrY[RightEdge.Pos + 1]*abs(PArrX[RightEdge.Pos] - RightEdge.ValueX);
         {correct for offcentre peak}
         if odd(REgion) then
            AreaR := AreaR - AreaM
           else
            AreaR := AreaR - AreaM  - 0.5*AreaM;
         end;
      Result := FloatToStrF(100*abs(AreaL - AreaR)/(AreaL + AreaR),ffFixed,4,Precision) + '%';
      end
     else
      Result := 'No edge';
end;


{-------------------------------------------------------------------------------
 Deviation parameters
-------------------------------------------------------------------------------}

function DeviationRatio1D(ProfileArr:TSingleProfile):string;
begin
with ProfileArr do
Result := FloatToStrF(100*IFA.Max.ValueY/Centre.ValueY,ffFixed,4,Precision) + '%';
end;


function DeviationDiff1D(ProfileArr:TSingleProfile):string;
var Dev        :double;
begin
with ProfileArr do
   begin
   Dev := math.max(abs(IFA.Min.ValueY - Centre.ValueY),abs(IFA.Max.ValueY - Centre.ValueY));
   Result := FloatToStrF(100*Dev/Centre.ValueY,ffFixed,4,Precision) + '%';
   end;
end;


function DeviationCAX1D(ProfileArr:TSingleProfile):string;
begin
with ProfileArr do
Result := FloatToStrF(100*(IFA.Max.ValueY - IFA.Min.ValueY)/
   Centre.ValueY,ffFixed,4,Precision) + '%';
end;


{-------------------------------------------------------------------------------
 Miscellaneous parameters
-------------------------------------------------------------------------------}

function NoFunc1D(ProfileArr:TSingleProfile):string;
{Returns error. Executed if no other function found.}
begin
Result := 'Parameter not found';
end;

{-------------------------------------------------------------------------------
 End of parameter calculation functions
-------------------------------------------------------------------------------}

function Calc1DParam(ProfileArr:TSingleProfile):string;
{Invokes the function corresponding to the Param string and returns the result
as a string}
var Param:T1DParams;

begin
Result := '';
Param := cax_val_1D;
while (Params1D[Param].Name <> ProfileArr.sExpr) and (Param <> no_func_1D) do inc(Param);
Result := Params1D[Param].Func(ProfileArr);
end;

end.

