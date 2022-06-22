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

T1DParams = (field_edge_left_50_1D,
             field_edge_right_50_1D,
             field_centre_50_1D,
             field_size_50_1D,
             pen_8020_left_1D,
             pen_8020_right_1D,
             pen_9010_left_1D,
             pen_9010_right_1D,
             pen_9050_left_1D,
             pen_9050_right_1D,
             cax_val_1D,
             max_val_1D,
             min_val_1D,
             min_ifa_1D,
             ave_ifa_1D,
             flat_ave_1D,
             flat_diff_1D,
             flat_ratio_1D,
             flat_cax_1D,
             uniformity_ave_1D,
             sym_ratio_1D,
             sym_diff_1D,
             sym_ave_1D,
             sym_area_1D,
             dev_ratio_1D,
             dev_diff_1D,
             dev_cax_1D,
             no_func_1D);

T1DParamFuncs = record
   Name      :string;
   Func      :T1DParamFunc;
   end;


function Calc1DParam(ProfileArr:TSingleProfile):string;
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
{field statistics}
function CAXVal1D(ProfileArr:TSingleProfile):string;
function MaxVal1D(ProfileArr:TSingleProfile):string;
function MinVal1D(ProfileArr:TSingleProfile):string;
function MinIFA1D(ProfileArr:TSingleProfile):string;
function AveIFA1D(ProfileArr:TSingleProfile):string;
{flatness and uniformity}
function FlatnessAve1D(ProfileArr:TSingleProfile):string;
function FlatnessDiff1D(ProfileArr:TSingleProfile):string;
function FlatnessRatio1D(ProfileArr:TSingleProfile):string;
function FlatnessCAX1D(ProfileArr:TSingleProfile):string;
function UniformityAve1D(ProfileArr:TSingleProfile):string;
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
Params1D: array[field_edge_left_50_1D..no_func_1D] of T1DParamFuncs = (
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
   (Name:'1D CAX Value'; Func:@CAXVal1D),
   (Name:'1D Max Value'; Func:@MaxVal1D),
   (Name:'1D Min Value'; Func:@MinVal1D),
   (Name:'1D Min IFA'; Func:@MinIFA1D),
   (Name:'1D Average IFA'; Func:@AveIFA1D),
   (Name:'1D Flatness Ave'; Func:@FlatnessAve1D),
   (Name:'1D Flatness Diff'; Func:@FlatnessDiff1D),
   (Name:'1D Flatness Ratio'; Func:@FlatnessRatio1D),
   (Name:'1D Flatness CAX'; Func:@FlatnessCAX1D),
   (Name:'1D Uniformity ICRU'; Func:@UniformityAve1D),
   (Name:'1D Symmetry Ratio'; Func:@SymmetryRatio1D),
   (Name:'1D Symmetry Diff'; Func:@SymmetryDiff1D),
   (Name:'1D Symmetry Ave'; Func:@SymmetryAve1D),
   (Name:'1D Symmetry Area'; Func:@SymmetryArea1D),
   (Name:'1D Deviation Ratio'; Func:@DeviationRatio1D),
   (Name:'1D Deviation Diff'; Func:@DeviationDiff1D),
   (Name:'1D Deviation CAX'; Func:@DeviationCAX1D),
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
with ProfileArr do case Norm of
   no_norm: Result := FloatToStrF(Centre.ValueY,ffFixed,4,Precision);
   norm_cax: Result := '100.0%';
   norm_max: Result := FloatToStrF((Centre.ValueY - Min.ValueY)
      *100/(Max.ValueY - Min.ValueY),ffFixed,4,Precision) + '%';
   end {of case}
end;


function MaxVal1D(ProfileArr:TSingleProfile):string;
{Returns the maximum value of the profile. If the profile is normalised to Max
this is by definition 100%}
begin
with ProfileArr do case Norm of
   no_norm: Result := FloatToStrF(Max.ValueY,ffFixed,4,Precision);
   norm_cax: Result := FloatToStrF((Max.ValueY - Min.ValueY)
      *100/(Centre.ValueY - Min.ValueY),ffFixed,4,Precision) + '%';
   norm_max: Result := '100.00%';
   end {of case}
end;


function MinVal1D(ProfileArr:TSingleProfile):string;
{Returns the minimum value of the profile. For norm_max and norm_cax the profile
is grounded and the min value is 0.}
begin
with ProfileArr do case Norm of
   no_norm: Result := FloatToStrF(Min.ValueY,ffFixed,4,Precision);
   norm_cax: Result := '0.00';
   norm_max: Result := '0.00';
   end; {of case}
end;


function MinIFA1D(ProfileArr:TSingleProfile):string;
{Returns the minimum value of the IFA. For norm_max and norm_cax the profile
is grounded}
begin
with ProfileArr do case Norm of
   no_norm: Result := FloatToStrF(IFA.Min.ValueY,ffFixed,4,Precision);
   norm_cax: Result := FloatToStrF((IFA.Min.ValueY - Min.ValueY)
      *100/(Centre.ValueY - Min.ValueY),ffFixed,4,Precision) + '%';
   norm_max: Result := FloatToStrF((IFA.Min.ValueY - Min.ValueY)
      *100/(Max.ValueY - Min.ValueY),ffFixed,4,Precision) + '%';
   end; {of case}
end;


function AveIFA1D(ProfileArr:TSingleProfile):string;
{Returns the average value of the IFA. For norm_max and norm_cax the profile
is grounded}
begin
with ProfileArr do case Norm of
   no_norm: Result := FloatToStrF(IFA.Ave,ffFixed,4,Precision);
   norm_cax: Result := FloatToStrF((IFA.Ave - Min.ValueY)
      *100/(Centre.ValueY - Min.ValueY),ffFixed,4,Precision) + '%';
   norm_max: Result := FloatToStrF((IFA.Ave - Min.ValueY)
      *100/(Max.ValueY - Min.ValueY),ffFixed,4,Precision) + '%';
   end; {of case}
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
if (ProfileArr.LeftEdge.ValueY > 0) and (ProfileArr.RightEdge.ValueY > 0) then
   begin
   Result := FloatToStrF(ProfileArr.Peak.ValueX,ffFixed,4,Precision) + ' cm'
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
   Penumbra := abs(GetPos(0.2,-1).ValueX - GetPos(0.8,-1).ValueX);
Result := FloatToStrF(Penumbra,ffFixed,4,Precision) + ' cm'
end;


function Penumbra8020Right1D(ProfileArr:TSingleProfile):string;
var Penumbra   :double;
begin
with ProfileArr do
   Penumbra := abs(GetPos(0.2,1).ValueX - GetPos(0.8,1).ValueX);
Result := FloatToStrF(Penumbra,ffFixed,4,Precision) + ' cm'
end;


function Penumbra9010Left1D(ProfileArr:TSingleProfile):string;
var Penumbra   :double;
begin
with ProfileArr do
   Penumbra := abs(GetPos(0.1,-1).ValueX - GetPos(0.9,-1).ValueX);
Result := FloatToStrF(Penumbra,ffFixed,4,Precision) + ' cm'
end;


function Penumbra9010Right1D(ProfileArr:TSingleProfile):string;
var Penumbra   :double;
begin
with ProfileArr do
   Penumbra := abs(GetPos(0.1,1).ValueX - GetPos(0.9,1).ValueX);
Result := FloatToStrF(Penumbra,ffFixed,4,Precision) + ' cm'
end;


function Penumbra9050Left1D(ProfileArr:TSingleProfile):string;
var Penumbra   :double;
begin
with ProfileArr do
   Penumbra := abs(LeftEdge.ValueX - GetPos(0.9,-1).ValueX);
Result := FloatToStrF(Penumbra,ffFixed,4,Precision) + ' cm'
end;


function Penumbra9050Right1D(ProfileArr:TSingleProfile):string;
var Penumbra   :double;
begin
with ProfileArr do
   Penumbra := abs(RightEdge.ValueX - GetPos(0.9,1).ValueX);
Result := FloatToStrF(Penumbra,ffFixed,4,Precision) + ' cm'
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
         AreaM := Peak.ValueY*Peak.ValueX;
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
Param := field_edge_left_50_1D;
while (Params1D[Param].Name <> ProfileArr.sExpr) and (Param <> no_func_1D) do inc(Param);
Result := Params1D[Param].Func(ProfileArr);
end;

end.

