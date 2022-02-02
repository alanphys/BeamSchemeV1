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
           cax_val_1D,
           max_val_1D,
           min_val_1D,
           min_ifa_1D,
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
function NoFunc1D(ProfileArr:TSingleProfile):string;
{field statistics}
function CAXVal1D(ProfileArr:TSingleProfile):string;
function MaxVal1D(ProfileArr:TSingleProfile):string;
function MinVal1D(ProfileArr:TSingleProfile):string;
function MinIFA1D(ProfileArr:TSingleProfile):string;


const
Params1D: array[field_edge_left_50_1D..no_func_1D] of T1DParamFuncs = (
   (Name:'1D Field Edge Left 50'; Func:@FieldEdgeLeft501D),
   (Name:'1D Field Edge Right 50'; Func:@FieldEdgeRight501D),
   (Name:'1D Field Centre 50'; Func:@FieldCentre501D),
   (Name:'1D Field Size 50'; Func:@FieldSize501D),
   (Name:'1D CAX Value'; Func:@CAXVal1D),
   (Name:'1D Max Value'; Func:@MaxVal1D),
   (Name:'1D Min Value'; Func:@MinVal1D),
   (Name:'1D Min IFA'; Func:@MinIFA1D),
   (Name:'1D No Function'; Func:@NoFunc1D));

implementation

uses mathsfuncs;

{-------------------------------------------------------------------------------
 Parameter calculation functions
-------------------------------------------------------------------------------}
{field statistics}
function CAXVal1D(ProfileArr:TSingleProfile):string;
{Returns the value of the centre of the profile. If the profile is normalised
to CAX this is by definition 100%.}
begin
with ProfileArr do case Norm of
   no_norm: Result := FloatToStrF(Centre.ValueY,ffFixed,4,1);
   norm_cax: Result := '100.0%';
   norm_max: Result := FloatToStrF((Centre.ValueY - Min.ValueY)
      *100/(Max.ValueY - Min.ValueY),ffFixed,4,1) + '%';
   end {of case}
end;


function MaxVal1D(ProfileArr:TSingleProfile):string;
{Returns the maximum value of the profile. If the profile is normalised to Max
this is by definition 100%}
begin
with ProfileArr do case Norm of
   no_norm: Result := FloatToStrF(Max.ValueY,ffFixed,4,1);
   norm_cax: Result := FloatToStrF((Max.ValueY - Min.ValueY)
      *100/(Centre.ValueY - Min.ValueY),ffFixed,4,1) + '%';
   norm_max: Result := '100.0%';
   end {of case}
end;


function MinVal1D(ProfileArr:TSingleProfile):string;
{Returns the minimum value of the profile. For norm_max and norm_cax the profile
is grounded and the min value is 0.}
begin
with ProfileArr do case Norm of
   no_norm: Result := FloatToStrF(Min.ValueY,ffFixed,4,1);
   norm_cax: Result := '0.00';
   norm_max: Result := '0.00';
   end; {of case}
end;


function MinIFA1D(ProfileArr:TSingleProfile):string;
{Returns the minimum value of the IFA. For norm_max and norm_cax the profile
is grounded}
begin
with ProfileArr do case Norm of
   no_norm: Result := FloatToStrF(IFA.Min.ValueY,ffFixed,4,1);
   norm_cax: Result := FloatToStrF((IFA.Min.ValueY - Min.ValueY)
      *100/(Centre.ValueY - Min.ValueY),ffFixed,4,1) + '%';
   norm_max: Result := FloatToStrF((IFA.Min.ValueY - Min.ValueY)
      *100/(Max.ValueY - Min.ValueY),ffFixed,4,1) + '%';
   end; {of case}
end;


{interpolated parameters}
function FieldEdgeLeft501D(ProfileArr:TSingleProfile):string;
{Returns the position of the left field edge at 50% of max or cax value.}
begin
if ProfileArr.LeftEdge.ValueY > 0 then
   Result := FloatToStrF(ProfileArr.LeftEdge.ValueX,ffFixed,4,2) + ' cm'
  else
   Result := 'No edge';
end;


function FieldEdgeRight501D(ProfileArr:TSingleProfile):string;
{Returns the position of the right field edge at 50% of max or cax value.}
begin
if ProfileArr.RightEdge.ValueY > 0 then
   Result := FloatToStrF(ProfileArr.RightEdge.ValueX,ffFixed,4,2) + ' cm'
  else
   Result := 'No edge';
end;


function FieldCentre501D(ProfileArr:TSingleProfile):string;
{Returns the field centre as given by the 50% field edges}
var FieldCentre:double;
begin
if (ProfileArr.LeftEdge.ValueY > 0) and (ProfileArr.RightEdge.ValueY > 0) then
   begin
   FieldCentre := (ProfileArr.RightEdge.ValueX + ProfileArr.LeftEdge.ValueX)/2;
   Result := FloatToStrF(FieldCentre,ffFixed,4,2) + ' cm'
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
   Result := FloatToStrF(FieldSize,ffFixed,4,2) + ' cm'
   end
  else
   Result := 'No edge';
end;


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

