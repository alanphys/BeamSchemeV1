unit param2dfuncs;
{This unit contains the functions to calculate 2D beam parameters. Functions
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
T2DParamFunc = function(BeamArr:TBeam):string;

T2DParams = (cax_val_2D,
             max_val_2D,
             min_val_2D,
             ave_2D,
             min_ifa_2D,
             com_val_2D,
             com_scaled_2D,
             x_res_2D,
             y_res_2D,
             x_pixels_2D,
             y_pixels_2D,
             x_size_2D,
             y_size_2D,
             uniformity_ncs_2D,
             uniformity_icru_2D,
             symmetry_2D,
             no_func_2D);

T2DParamFuncs = record
   Name      :string;
   Func      :T2DParamFunc;
   end;


function Calc2DParam(BeamArr:TBeam; sParam:string):string;
{field statistics}
function CaxVal2D(BeamArr:TBeam):string;
function MaxVal2D(BeamArr:TBeam):string;
function MinVal2D(BeamArr:TBeam):string;
function Ave2D(BeamArr:TBeam):string;
function MinIFA2D(BeamArr:TBeam):string;
function CoMVal2D(BeamArr:Tbeam):string;
function CoMScaled2D(BeamArr:Tbeam):string;
function XRes2D(BeamArr:Tbeam):string;
function YRes2D(BeamArr:Tbeam):string;
function XPixels2D(BeamArr:Tbeam):string;
function YPixels2D(BeamArr:Tbeam):string;
function XSize2D(BeamArr:Tbeam):string;
function YSize2D(BeamArr:Tbeam):string;
{flatness and uniformity parameters}
function UniformityCAX2D(BeamArr:TBeam):string;
function UniformityAve2D(BeamArr:TBeam):string;
{symmetry parameters}
function SymmetryAve2D(BeamArr:TBeam):string;
function NoFunc2D(BeamArr:TBeam):string;


const
Params2D: array[cax_val_2D..no_func_2D] of T2DParamFuncs = (
   (Name:'2D CAX Value'; Func:@CaxVal2D),
   (Name:'2D Max Value'; Func:@MaxVal2D),
   (Name:'2D Min Value'; Func:@MinVal2D),
   (Name:'2D Ave Value'; Func:@Ave2D),
   (Name:'2D Min IFA'; Func:@MinIFA2D),
   (Name:'2D CoM Value'; Func:@CoMVal2D),
   (Name:'2D CoM Scaled'; Func:@CoMScaled2D),
   (Name:'2D XRes'; Func:@XRes2D),
   (Name:'2D YRes'; Func:@YRes2D),
   (Name:'2D XPixels'; Func:@XPixels2D),
   (Name:'2D YPixels'; Func:@YPixels2D),
   (Name:'2D XSize'; Func:@XSize2D),
   (Name:'2D YSize'; Func:@YSize2D),
   (Name:'2D Uniformity NCS-70'; Func:@UniformityCAX2D),
   (Name:'2D Uniformity ICRU 72'; Func:@UniformityAve2D),
   (Name:'2D Symmetry NCS-70'; Func:@SymmetryAve2D),
   (Name:'2D No Function'; Func:@NoFunc2D));

implementation

uses math;

{-------------------------------------------------------------------------------
 Parameter calculation functions
 Field statistics
-------------------------------------------------------------------------------}

function CaxVal2D(BeamArr:TBeam):string;
{Return the centre value, position and index of the beam. If the number of
points in the beam are even the average of the two or four centre values is returned}
begin
case BeamArr.Norm of
   no_norm: Result := FloatToStrF(BeamArr.Centre,ffFixed,4,Precision);
   norm_cax: Result := '100.0%';
   norm_max: Result := FloatToStrF(BeamArr.Centre*100/BeamArr.Max,ffFixed,4,Precision) + '%';
   end;
end;


function MaxVal2D(BeamArr:TBeam):string;
{Returns the maximum of the array}
begin
case BeamArr.Norm of
   no_norm: Result := FloatToStrF(BeamArr.Max,ffFixed,4,Precision);
   norm_cax: Result := FloatToStrF(BeamArr.Max*100/BeamArr.Centre,ffFixed,4,Precision) + '%';
   norm_max: Result := '100.0%';
   end {of case}
end;


function MinVal2D(BeamArr:TBeam):string;
{Returns the minimum of the array}
begin
case BeamArr.Norm of
   no_norm: Result := FloatToStrF(BeamArr.Min,ffFixed,4,Precision);
   norm_cax: Result := '0.00';
   norm_max: Result := '0.00';
   end; {of case}
end;


function Ave2D(BeamArr:TBeam):string;
{Returns the maximum of the array}
begin
case BeamArr.Norm of
   no_norm: Result := FloatToStrF(BeamArr.Ave,ffFixed,4,Precision);
   norm_cax: Result := FloatToStrF(BeamArr.Ave*100/BeamArr.Centre,ffFixed,4,Precision) + '%';
   norm_max: Result := FloatToStrF(BeamArr.Ave*100/BeamArr.Max,ffFixed,4,Precision) + '%';
   end {of case}
end;


function MinIFA2D(BeamArr:TBeam):string;
{Returns the min value in the in field area}
begin
Result := FloatToStrF(BeamArr.IFA.Min,ffFixed,4,Precision);
end;


function CoMVal2D(BeamArr:Tbeam):string;
{Returns the row,col coordinates of the Centre of Mass}
begin
Result := '(' + FloatToStrF(BeamArr.CoM.X,ffFixed,4,Precision) + ',' +
   FloatToStrF(BeamArr.CoM.Y,ffFixed,4,Precision) + ')';
end;


function CoMScaled2D(BeamArr:Tbeam):string;
{Returns the scaled x,y coordinates of the Centre of Mass}
begin
Result := '(' + FloatToStrF(BeamArr.CoM.Y*BeamArr.XRes,ffFixed,4,Precision) + ',' +
   FloatToStrF(BeamArr.CoM.X*BeamArr.YRes,ffFixed,4,Precision) + ')';
end;


function XRes2D(BeamArr:Tbeam):string;
{Returns the X resolution of the image}
begin
Result := FloatToStrF(2.54/BeamArr.XRes,ffFixed,4,Precision) + ' dpi';
end;


function YRes2D(BeamArr:Tbeam):string;
{Returns the Y resolution of the image}
begin
Result := FloatToStrF(2.54/BeamArr.YRes,ffFixed,4,Precision) + ' dpi';
end;


function XPixels2D(BeamArr:Tbeam):string;
{Returns the number of pixels/detectors of the image in the X direction}
begin
Result := IntToStr(BeamArr.Cols);
end;


function YPixels2D(BeamArr:Tbeam):string;
{Returns the number of pixels/detectors of the image in the Y direction}
begin
Result := IntToStr(BeamArr.Rows);
end;


function XSize2D(BeamArr:Tbeam):string;
{Returns the size of the image in the X direction}
begin
Result := FloatToStrF(BeamArr.Width,ffFixed,4,Precision) + ' cm';
end;


function YSize2D(BeamArr:Tbeam):string;
{Returns the size of the image in the Y direction}
begin
Result := FloatToStrF(BeamArr.Height,ffFixed,4,Precision) + ' cm';
end;


{-------------------------------------------------------------------------------
 Flatness and uniformity parameters
-------------------------------------------------------------------------------}
function UniformityCAX2D(BeamArr:TBeam):string;
{Returns the maximum difference between the max and CAX value and the min
and CAX value of the IFA normalised to CAX according to NCS-70 eq 3-5.
max(Dmax - CAX, Dmin - CAX)*100/CAX}
var BMax,
    BMin,
    CAX        :double;
begin
BMax := BeamArr.IFA.Max;
BMin := BeamArr.IFA.Min;
CAX := BeamArr.Centre;
Result := FloatToStrF(max(abs(BMax-CAX),abs(BMin-CAX))*100/CAX,ffFixed,4,Precision) + '%';
end;


function UniformityAve2D(BeamArr:TBeam):string;
{Returns the maximum difference between the max and the min
of the IFA normalised to the average of the IFA according to ICRU 72 eq 3.2.
(Dmax - Dmin)*100/Ave}
var BMax,
    BMin,
    Ave        :double;
begin
BMax := BeamArr.IFA.Max;
BMin := BeamArr.IFA.Min;
Ave := BeamArr.IFA.Ave;
Result := FloatToStrF((BMax - BMin)*100/Ave,ffFixed,4,Precision) + '%';
end;


{-------------------------------------------------------------------------------
 Symmetry parameters
-------------------------------------------------------------------------------}
function SymmetryAve2D(BeamArr:TBeam):string;
{Returns the maximum difference between the IFA and the IFA rotated 180 degrees,
normalised to the average of the IFA according to NCS-70 eq 3-6.
max(abs(D(x,y) - D(-x,-y)))*100/Dave}
var I,J,
    EndRow,
    EndCol     :integer;
    Diff,
    MaxDiff    :double;
    aIFA       :TBeamData;

begin
Diff := 0;
MaxDiff := 0;
EndRow := BeamArr.Rows - 1;
EndCol := BeamArr.Cols - 1;
aIFA := BeamArr.IFA.Data;
for I:=0 to EndRow do
   for J:=0 to EndCol do
      if not IsNaN(aIFA[I,J]) and not IsNaN(aIFA[EndRow - I, EndCol - J]) then
         begin
         Diff := abs(aIFA[I,J] - aIFA[EndRow - I, EndCol - J]);
         if Diff > MaxDiff then MaxDiff := Diff;
         end;
Result := FloatToStrF(MaxDiff*100/BeamArr.IFA.Ave,ffFixed,4,Precision) + '%';
end;


{interpolated parameters}
function NoFunc2D(BeamArr:TBeam):string;
{Returns error. Executed if no other function found.}
begin
Result := 'Parameter not found';
end;

{-------------------------------------------------------------------------------
 End of parameter calculation functions
-------------------------------------------------------------------------------}

function Calc2DParam(BeamArr:TBeam; sParam:string):string;
{Invokes the function corresponding to the Param string and returns the result
as a string}
var Param:T2DParams;

begin
Result := '';
Param := cax_val_2D;
while (Params2D[Param].Name <> sParam) and (Param <> no_func_2D) do inc(Param);
Result := Params2D[Param].Func(BeamArr);
end;

end.

