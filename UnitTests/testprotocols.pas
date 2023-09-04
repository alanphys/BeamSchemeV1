unit testprotocols;
{test formatting and results of the various protocols}

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, fpcunit, testutils, testregistry, grids, bstypes;

type

TestProtocolSNC = class(TTestCase)
   private
   fBeam    :TBeam;
   sgExpr   :TStringGrid;
   Prof     :TSingleProfile;
   protected
   procedure SetUp; override;
   procedure TearDown; override;
   published
   procedure TestProtocolAll;
   procedure TestProtocolVarian;
   end;

TestProtocolPTW = class(TTestCase)
   private
   fBeam    :TBeam;
   sgExpr   :TStringGrid;
   Prof     :TSingleProfile;
   protected
   procedure SetUp; override;
   procedure TearDown; override;
   published
   procedure TestProtocolVarian;
   procedure TestProtocolSiemens;
   procedure TestProtocolElekta;
   procedure TestProtocolAFSSAPS;
   procedure TestProtocolIEC;
   procedure TestProtocolWFF;
   end;

TestProtocolIBA = class(TTestCase)
   private
   fBeam    :TBeam;
   sgExpr   :TStringGrid;
   Prof     :TSingleProfile;
   protected
   procedure SetUp; override;
   procedure TearDown; override;
   published
   procedure TestProtocolVarian;
   procedure TestProtocolSiemens;
   procedure TestProtocolElekta;
   procedure TestProtocolAFSSAPS;
   procedure TestProtocolIEC;
   procedure TestProtocolDIN;
   procedure TestProtocolWFF;
   procedure TestProtocolFFF;
   end;

TestProtocolPylinac = class(TTestCase)
   private
   fBeam    :TBeam;
   sgExpr   :TStringGrid;
   Prof     :TSingleProfile;
   protected
   procedure SetUp; override;
   procedure TearDown; override;
   published
   procedure TestProtocolVarian;
   procedure TestProtocolSiemens;
   procedure TestProtocolElekta;
   procedure TestProtocolWFF;
   procedure TestProtocolFFF;
   end;

TestProtocolBistroMath = class(TTestCase)
   private
   fBeam    :TBeam;
   sgExpr   :TStringGrid;
   Prof     :TSingleProfile;
   protected
   procedure SetUp; override;
   procedure TearDown; override;
   published
   procedure TestProtocolElekta;
   procedure TestProtocolWFF;
   procedure TestProtocolFFF;
   end;

TestProtocolImageJ = class(TTestCase)
   private
   fBeam    :TBeam;
   sgExpr   :TStringGrid;
   Prof     :TSingleProfile;
   protected
   procedure SetUp; override;
   procedure TearDown; override;
   published
   procedure TestProtocolBrachy;
   end;



implementation

uses importunit, param1Dfuncs, param2Dfuncs;

procedure TestProtocolSNC.SetUp;
begin
fBeam := TBeam.Create;
MapCheckOpen('../TestFiles/2-Sep-2011-A.txt',fBeam);
sgExpr := TStringGrid.Create(nil);
sgExpr.Visible := false;
Prof := TSingleProfile.Create;
Prof.SetParams(0,0,1);
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
end;

procedure TestProtocolSNC.TearDown;
begin
fBeam.Free;
sgExpr.Free;
Prof.Free;
end;


{-------------------------------------------------------------------------------
 Sun Nuclear Protocol tests
-------------------------------------------------------------------------------}
procedure TestProtocolSNC.TestProtocolAll;
{These parameters are the same as those in test1Dparams and test2Dparams}
var I          :integer;

const Params: array of string = (
'2D Image Stats	',
'     CAX value	94.47',
'     Max value	100.00',
'     Min value	0.00',
'     Average	46.94',
'     Min IFA	94.32',
'     CoM (row,col)	(31.52,26.52)',
'     CoM (X,Y)	(13.26,15.76)',
'     Resolution	',
'          X	5.08 dpi',
'          Y	5.08 dpi',
'     Detectors/Pixels	',
'          X	53',
'          Y	65',
'     Size	',
'          X	26.00 cm',
'          Y	32.00 cm',
'	',
'2D Uniformity	',
'     Uniformity NCS	5.86%',
'     Uniformity ICRU	5.80%',
'	',
'2D Symmetry	',
'     Symmetry	2.59%',
'	',
'Profile stats	',
'     CAX value	94.47',
'     Max value	99.00',
'     Max pos	-6.50cm',
'     Min value	2.18',
'     Min IFA	94.46',
'     Average IFA	97.12',
'	',
'Interpolated params	',
'     Left edge	-9.67 cm',
'     Right edge	10.40 cm',
'     Centre	0.37 cm',
'     Size	20.08 cm',
'     Penumbra	',
'          80-20%	',
'               Left	0.65 cm',
'               Right	0.71 cm',
'          90-10%	',
'               Left	1.31 cm',
'               Right	1.26 cm',
'          90-50%	',
'               Left	0.51 cm',
'               Right	0.34 cm',
'	',
'Differential params	',
'     Left edge	-9.50 cm',
'     Right edge	10.50 cm',
'     Centre	0.50 cm',
'     Size	20.00 cm',
'	',
'Inflection params	',
'     Left edge	-9.60 cm',
'     Right edge	10.39 cm',
'     Centre	0.40 cm',
'     Size	19.99 cm',
'     Penumbra	',
'          Left	0.65 cm',
'          Right	0.55 cm',
'	',
'Dose point values	',
'     Left 20% FW	96.12',
'     Right 20% FW	94.78',
'     Left 50% FW	98.86',
'     Right 50% FW	97.97',
'     Left 60% FW	98.93',
'     Right 60% FW	98.08',
'     Left 80% FW	98.64',
'     Right 80% FW	98.19',
'	',
'Flatness	',
'     Average	102.40%',
'     Difference	2.35%',
'     Ratio	104.80%',
'     CAX	2.40%',
'     ICRU 72	4.67%',
'     90/50	95.76%',
'	',
'Symmetry	',
'     Ratio	102.66%',
'     Difference	2.69%',
'     NCS-70	2.61%',
'     Area	0.28%',
'	',
'Deviation	',
'     Ratio	104.80%',
'     Difference	4.80%',
'     MAX/CAX	4.80%',
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/All.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolSNC.TestProtocolVarian;
{Verified from MapCheck 5.02.01. This version of MapCheck does not have definable
protocols and only give flatness and symmetry values. The Varian protocol corresponds
most closely to what it gives.}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-9.67 cm',
'     Right edge	10.40 cm',
'     Centre	0.37 cm',
'     Size	20.08 cm',
'Penumbra 80-20%	',
'     Left	0.65 cm',
'     Right	0.71 cm',
'Flatness	2.35%', {note MapCheck actually reports 2.29% but does not use interpolated data}
'Symmetry	2.69%',
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/Varian.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


{-------------------------------------------------------------------------------
 PTW Protocol tests
-------------------------------------------------------------------------------}

procedure TestProtocolPTW.SetUp;
begin
fBeam := TBeam.Create;
PTWOpen('../TestFiles/X06 NONE 20X20 CR 00 BEA 140724 12''23.mcc',fBeam);
sgExpr := TStringGrid.Create(nil);
sgExpr.Visible := false;
Prof := TSingleProfile.Create;
Prof.SetParams(0,0,1);
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
end;

procedure TestProtocolPTW.TearDown;
begin
fBeam.Free;
sgExpr.Free;
Prof.Free;
end;


procedure TestProtocolPTW.TestProtocolVarian;
{Verified from PTW-DataAnalyze file X06 NONE 20X20 CR 00 BEA 140724 12'23.mcc}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-10.23 cm',
'     Right edge	10.32 cm',
'     Centre	0.04 cm',
'     Size	20.55 cm',
'Penumbra 80-20%	',
'     Left	1.29 cm',
'     Right	1.21 cm',
'Flatness	1.15%', {DataAnalyze reports 1.16%}
'Symmetry	0.55%', {DataAnalyze reports 0.55%}
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/Varian.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolPTW.TestProtocolSiemens;
{Verified from PTW-DataAnalyze file X06 NONE 20X20 CR 00 BEA 140724 12'23.mcc}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-10.23 cm',
'     Right edge	10.32 cm',
'     Centre	0.04 cm',
'     Size	20.55 cm',
'Penumbra 80-20%	',
'     Left	1.29 cm',
'     Right	1.21 cm',
'Flatness	1.15%',
'Symmetry	0.34%', {DataAnalyze reports 0.22%, but spreadsheet gives 0.34%}
'Deviation	102.33%',
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/Siemens.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolPTW.TestProtocolElekta;
{Verified from PTW-DataAnalyze file X06 NONE 20X20 CR 00 BEA 140724 12'23.mcc}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-10.23 cm',
'     Right edge	10.32 cm',
'     Centre	0.04 cm',
'     Size	20.55 cm',
'Penumbra 80-20%	',
'     Left	1.29 cm',
'     Right	1.21 cm',
'Flatness	102.33%',
'Symmetry	100.54%', {DataAnalyze reports 102.55%}
'Deviation	2.33%',   {DataAnalyze does not give deviation}
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/ElektaPhoton.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolPTW.TestProtocolAFSSAPS;
{Verified from PTW-DataAnalyze file X06 NONE 20X20 CR 00 BEA 140724 12'23.mcc}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-10.23 cm',
'     Right edge	10.32 cm',
'     Centre	0.04 cm',
'     Size	20.55 cm',
'Penumbra 80-20%	',
'     Left	1.29 cm',
'     Right	1.21 cm',
'Flatness	1.15%',
'Symmetry	100.54%', {DataAnalyze reports 102.55%}
'Deviation	102.33%', {DataAnalyze does not x 100}
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/AFSSAPS-JORFPhoton.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolPTW.TestProtocolIEC;
{Verified from PTW-DataAnalyze file X06 NONE 20X20 CR 00 BEA 140724 12'23.mcc}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-10.23 cm',
'     Right edge	10.32 cm',
'     Centre	0.04 cm',
'     Size	20.55 cm',
'Penumbra 80-20%	',
'     Left	1.29 cm',
'     Right	1.21 cm',
'Flatness	102.33%',
'Symmetry	100.54%', {DataAnalyze reports 102.55%}
'Deviation	2.33%',   {DataAnalyze gives Dmax/Dcax}
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/ElektaPhoton.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolPTW.TestProtocolWFF;
{Verified from PTW-DataAnalyze file X06 NONE 20X20 CR 00 BEA 140724 12'23.mcc}
{Note: PTW-DataAnalyze uses the method of Fogliata}

var I          :integer;

const Params: array of string = (
'Differential params	',
'     Left edge	-10.00 cm',
'     Right edge	10.00 cm',
'     Centre	0.00 cm',
'     Size	20.00 cm',
'	',
'Inflection params	',
'     Left edge	-10.06 cm',        {DataAnalyze reports 10.50}
'     Right edge	10.13 cm', {DataAnalyze reports 10.54}
'     Centre	0.03 cm',
'     Size	20.20 cm',         {DataAnalyze reports 21.04}
'     Penumbra	',
'          Left	0.96 cm',          {DataAnalyze reports 8.73}
'          Right	0.92 cm',  {DataAnalyze reports 7.85}
'	',
'Symmetry	',
'     Difference	0.55%',
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/FFF.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


{-------------------------------------------------------------------------------
 IBA Protocol tests
-------------------------------------------------------------------------------}
{Note IBA FastTrack interpolates between detectors. Position of profile can lead
to differing results.}
procedure TestProtocolIBA.SetUp;
begin
fBeam := TBeam.Create;
IBAOpen('../TestFiles/6MV.opg',fBeam);
sgExpr := TStringGrid.Create(nil);
sgExpr.Visible := false;
Prof := TSingleProfile.Create;
Prof.SetParams(0,0,1);
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
end;

procedure TestProtocolIBA.TearDown;
begin
fBeam.Free;
sgExpr.Free;
Prof.Free;
end;


procedure TestProtocolIBA.TestProtocolVarian;
{Verified from IBA-FastTrack file 6MV.opg}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-7.68 cm',
'     Right edge	7.67 cm',
'     Centre	-0.01 cm',
'     Size	15.35 cm',
'Penumbra 80-20%	',
'     Left	0.60 cm',
'     Right	0.59 cm',
'Flatness	1.04%',
'Symmetry	0.44%',
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/Varian.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolIBA.TestProtocolSiemens;
{Verified from IBA-FastTrack file 6MV.opg}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-7.68 cm',
'     Right edge	7.67 cm',
'     Centre	-0.01 cm',
'     Size	15.35 cm',
'Penumbra 80-20%	',
'     Left	0.60 cm',
'     Right	0.59 cm',
'Flatness	1.04%',
'Symmetry	0.10%',    {FastTrack reports 0.02%, spreadsheet gives 0.11%}
'Deviation	102.01%',
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/Siemens.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolIBA.TestProtocolElekta;
{Verified from IBA-FastTrack file 6MV.opg}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-7.68 cm',
'     Right edge	7.67 cm',
'     Centre	-0.01 cm',
'     Size	15.35 cm',
'Penumbra 80-20%	',
'     Left	0.60 cm',
'     Right	0.59 cm',
'Flatness	102.11%',
'Symmetry	100.43%',
'Deviation	2.10%',    {FastTrack reports 2.01%}
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/ElektaPhoton.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolIBA.TestProtocolAFSSAPS;
{Verified from IBA-FastTrack file 6MV.opg}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-7.68 cm',
'     Right edge	7.67 cm',
'     Centre	-0.01 cm',
'     Size	15.35 cm',
'Penumbra 80-20%	',
'     Left	0.60 cm',
'     Right	0.59 cm',
'Flatness	1.04%',    {FastTrack calculates 100*(Dmax + Dmin)/2*CAX}
'Symmetry	100.43%',
'Deviation	102.01%',  {FastTrack reports 101.98%}
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/AFSSAPS-JORFPhoton.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolIBA.TestProtocolIEC;
{Verified from IBA-FastTrack file 6MV.opg}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-7.68 cm',
'     Right edge	7.67 cm',
'     Centre	-0.01 cm',
'     Size	15.35 cm',
'Penumbra 80-20%	',
'     Left	0.60 cm',
'     Right	0.59 cm',
'Flatness	102.11%',
'Symmetry	100.43%',
'Deviation	2.10%',    {FastTrack reports 2.01%}
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/IEC976Photon.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolIBA.TestProtocolDIN;
{Verified from IBA-FastTrack file 6MV.opg}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-7.68 cm',
'     Right edge	7.67 cm',
'     Centre	-0.01 cm',
'     Size	15.35 cm',
'Penumbra 80-20%	',
'     Left	0.60 cm',
'     Right	0.59 cm',
'Flatness	102.11%',
'Symmetry	100.43%',
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/DIN.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolIBA.TestProtocolWFF;
{Verified from IBA-FastTrack file 6MV.opg}
{Note: FastTrack uses centre point of maximum gradient for inflection point}

var I          :integer;

const Params: array of string = (
'Differential params	',
'     Left edge	-8.00 cm',         {FastTrack reports 7.69}
'     Right edge	8.00 cm',  {FastTrack reports 7.66}
'     Centre	0.00 cm',          {FastTrack reports -0.01}
'     Size	16.00 cm',         {FastTrack reports 15.34}
'	',
'Inflection params	',
'     Left edge	-7.68 cm',         {FastTrack reports 7.69}
'     Right edge	7.65 cm',  {FastTrack reports 7.66}
'     Centre	-0.01 cm',
'     Size	15.33 cm',         {FastTrack reports 15.34}
'     Penumbra	',
'          Left	0.56 cm',          {FastTrack reports 0.59}
'          Right	0.55 cm',  {FastTrack reports 0.60}
'	',
'Symmetry	',
'     Difference	0.44%',    {FastTrack reports 0.49}
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/FFF.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolIBA.TestProtocolFFF;
{Verified from IBA-FastTrack file 6FFF.opg}
{Note: FastTrack uses centre point of maximum gradient for inflection point}

var I          :integer;

const Params: array of string = (
'Differential params	',
'     Left edge	-10.00 cm',        {FastTrack reports 10.31}
'     Right edge	10.00 cm', {FastTrack reports 10.04}
'     Centre	0.00 cm',          {FastTrack reports -1.4}
'     Size	20.00 cm',         {FastTrack reports 20.36}
'	',
'Inflection params	',
'     Left edge	-10.02 cm',
'     Right edge	9.97 cm',
'     Centre	-0.02 cm',
'     Size	19.99 cm',
'     Penumbra	',
'          Left	0.79 cm',
'          Right	0.88 cm',
'	',
'Symmetry	',
'     Difference	0.68%',
'	');

begin
fBeam.Free;
fBeam := TBeam.Create;
IBAOpen('../TestFiles/6FFF.opg',fBeam);
fBeam.Norm := norm_cax;
Prof.Free;
Prof := TSingleProfile.Create;
Prof.SetParams(0,0,1);
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
sgExpr.LoadFromCSVFile('../Protocols/FFF.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


{-------------------------------------------------------------------------------
 Pylinac Protocol tests
-------------------------------------------------------------------------------}
{Note: Pylinac run with the following options:
centering=Centering.GEOMETRIC_CENTER,
normalization_method=Normalization.GEOMETRIC_CENTER,
interpolation_resolution_mm=0.01,
edge_detection_method=Edge.FWHM}

procedure TestProtocolPylinac.SetUp;
begin
fBeam := TBeam.Create;
DICOMOpen('../TestFiles/6MV-20x20.dcm',fBeam);
fBeam.Norm := norm_cax;
sgExpr := TStringGrid.Create(nil);
sgExpr.Visible := false;
Prof := TSingleProfile.Create;
Prof.SetParams(0,0,1);
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
end;

procedure TestProtocolPylinac.TearDown;
begin
fBeam.Free;
sgExpr.Free;
Prof.Free;
end;


procedure TestProtocolPylinac.TestProtocolVarian;
{Verified from Pylinac file 6MV-20x20.dcm}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-10.04 cm',
'     Right edge	9.98 cm', {Pylinac reports 9.97}
'     Centre	-0.03 cm',
'     Size	20.03 cm',        {Pylinac reports 20.01}
'Penumbra 80-20%	',
'     Left	0.29 cm',
'     Right	0.30 cm',
'Flatness	2.14%',
'Symmetry	0.67%',           {Pylinac reports 0.61%}
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/Varian.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolPylinac.TestProtocolSiemens;
{Verified from Pylinac file 6MV-20x20.dcm}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-10.04 cm',
'     Right edge	9.98 cm', {Pylinac reports 9.97}
'     Centre	-0.03 cm',
'     Size	20.03 cm',        {Pylinac reports 20.01}
'Penumbra 80-20%	',
'     Left	0.29 cm',
'     Right	0.30 cm',
'Flatness	2.14%',
'Symmetry	0.01%',
'Deviation	104.02%',          {Pylinac does not give deviation}
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/Siemens.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolPylinac.TestProtocolElekta;
{Verified from Pylinac v3.1 file 6MV-20x20.dcm}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-10.04 cm',
'     Right edge	9.98 cm', {Pylinac reports 9.97}
'     Centre	-0.03 cm',
'     Size	20.03 cm',        {Pylinac reports 20.01}
'Penumbra 80-20%	',
'     Left	0.29 cm',
'     Right	0.30 cm',
'Flatness	104.37%',         {Pylinac reports 104.387}
'Symmetry	100.67%',         {Pylinac does not x 100}
'Deviation	4.36%',           {Pylinac does not give deviation}
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/ElektaPhoton.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolPylinac.TestProtocolWFF;
{Verified from Pylinac 3.10 file 6FFF.dcm}
{Note: Pylinac run with the following options:
centering=Centering.GEOMETRIC_CENTER,
normalization_method=Normalization.BEAM_CENTER
interpolation_resolution_mm=0.01,
edge_detection_method=Edge.Edge.INFLECTION_HILL}
var I          :integer;

const Params: array of string = (
'Differential params	',
'     Left edge	-10.03 cm',
'     Right edge	9.96 cm',
'     Centre	-0.03 cm',
'     Size	19.99 cm',         {Pylinac reports 19.98}
'	',
'Inflection params	',
'     Left edge	-10.03 cm',
'     Right edge	9.97 cm',  {Pylinac reports 19.96}
'     Centre	-0.03 cm',
'     Size	20.00 cm',         {Pylinac reports 19.98}
'     Penumbra	',
'          Left	0.38 cm',          {Pylinac reports 0.35}
'          Right	0.39 cm',  {Pylinac reports 0.36}
'	',
'Symmetry	',
'     Difference	0.67%',    {Pylinac reports 0.62}
'	');

begin
sgExpr.LoadFromCSVFile('../Protocols/FFF.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolPylinac.TestProtocolFFF;
{Verified from Pylinac 3.10 file 6FFF.dcm}
{Note: Pylinac run with the following options:
centering=Centering.GEOMETRIC_CENTER,
normalization_method=Normalization.BEAM_CENTER
interpolation_resolution_mm=0.01,
edge_detection_method=Edge.Edge.INFLECTION_HILL}
var I          :integer;

const Params: array of string = (
'Differential params	',
'     Left edge	-10.00 cm',        {Pylinac reports 10.02}
'     Right edge	10.06 cm', {Pylinac reports 10.05}
'     Centre	0.03 cm',
'     Size	20.06 cm',         {Pylinac reports 20.07}
'	',
'Inflection params	',
'     Left edge	-10.02 cm',        {Pylinac reports 10.03}
'     Right edge	10.04 cm',
'     Centre	0.01 cm',
'     Size	20.07 cm',         {Pylinac reports 20.06}
'     Penumbra	',
'          Left	0.36 cm',          {Pylinac reports 0.38}
'          Right	0.35 cm',  {Pylinac reports 0.38}
'	',
'Symmetry	',
'     Difference	0.41%',    {Pylinac reports 0.36}
'	');

begin
DICOMOpen('../TestFiles/6FFF.dcm',fBeam);
fBeam.Norm := norm_cax;
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
sgExpr.LoadFromCSVFile('../Protocols/FFF.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


{-------------------------------------------------------------------------------
 BistroMath Protocol tests
-------------------------------------------------------------------------------}

procedure TestProtocolBistroMath.SetUp;
begin
fBeam := TBeam.Create;
sgExpr := TStringGrid.Create(nil);
sgExpr.Visible := false;
Prof := TSingleProfile.Create;
Prof.SetParams(0,0,1);
end;

procedure TestProtocolBistroMath.TearDown;
begin
fBeam.Free;
sgExpr.Free;
Prof.Free;
end;


procedure TestProtocolBistroMath.TestProtocolElekta;
{Verified from BistroMath 4.30.1 file 2-Sep-2011-A.txt}
{Note: Bistromath run with the following options:
Field types tab, Center of Field definition: Border/Edge}
var I          :integer;

const Params: array of string = (
'Field	',
'     Left edge	-9.67 cm',
'     Right edge	10.40 cm',
'     Centre	0.37 cm',
'     Size	20.08 cm',
'Penumbra 80-20%	',
'     Left	0.65 cm',
'     Right	0.71 cm',
'Flatness	104.80%',
'Symmetry	102.66%',            {Bistromath reports 101.4 but is calculated on a filtered curve}
'Deviation	4.80%',
'	');

begin
MapCheckOpen('../TestFiles/2-Sep-2011-A.txt',fBeam);
fBeam.Norm := no_norm;
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
sgExpr.LoadFromCSVFile('../Protocols/ElektaPhoton.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolBistroMath.TestProtocolWFF;
{Verified from BistroMath 4.30.1 file 6FFF.opg}
{Note: Bistromath run with the following options:
Field types tab:
   Center of Field definition: Border/Edge
   Primary border/edge definition: Sigmoid50}
var I          :integer;

const Params: array of string = (
'Differential params	',
'     Left edge	-9.50 cm',         {BistroMath reports -9.55}
'     Right edge	10.50 cm', {BistroMath reports 10.46}
'     Centre	0.50 cm',          {BistroMath reports 0.45}
'     Size	20.00 cm',         {BistroMath reports 20.01}
'	',
'Inflection params	',
'     Left edge	-9.60 cm',         {BistroMath reports -9.62}
'     Right edge	10.39 cm', {BistroMath reports 10.42}
'     Centre	0.40 cm',          {BistroMath reports 0.40}
'     Size	19.99 cm',         {BistroMath reports 20.04}
'     Penumbra	',
'          Left	0.65 cm',          {BistroMath reports 0.64}
'          Right	0.55 cm',  {BistroMath reports 0.68}
'	',
'Symmetry	',
'     Difference	2.69%',
'	');

begin
MapCheckOpen('../TestFiles/2-Sep-2011-A.txt',fBeam);
fBeam.Norm := no_norm;
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
sgExpr.LoadFromCSVFile('../Protocols/FFF.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;


procedure TestProtocolBistroMath.TestProtocolFFF;
{Verified from BistroMath 4.30.1 file 6FFF.opg}
{Note: Bistromath run with the following options:
Field types tab, Center of Field definition: Border/Edge}
var I          :integer;

const Params: array of string = (
'Differential params	',
'     Left edge	-10.00 cm',
'     Right edge	10.00 cm',
'     Centre	0.00 cm',
'     Size	20.00 cm',
'	',
'Inflection params	',
'     Left edge	-10.02 cm',        {BistroMath reports 10.05}
'     Right edge	9.97 cm',  {BistroMath reports 10.03}
'     Centre	-0.02 cm',         {BistroMath reports -0.05}
'     Size	19.99 cm',         {BistroMath reports 20.08}
'     Penumbra	',
'          Left	0.79 cm',          {BistroMath reports 0.82}
'          Right	0.88 cm',  {BistroMath reports 0.82}
'	',
'Symmetry	',
'     Difference	0.68%',    {BistroMath reports 0.4}
'	');

begin
IBAOpen('../TestFiles/6FFF.opg',fBeam);
fBeam.Norm := no_norm;
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
sgExpr.LoadFromCSVFile('../Protocols/FFF.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;

{-------------------------------------------------------------------------------
 ImageJ Protocol tests
-------------------------------------------------------------------------------}
{Validated against ImageJ macro BestWorstProfileV1.0.0.ijm, UniformityV1.0.0.ijm
and SymmetryV1.0.0.ijm proprietary RadianceTx. ImageJ ver 1.52k}

procedure TestProtocolImageJ.SetUp;
begin
fBeam := TBeam.Create;
Centering := detector;
IFAType := Circular;
IFAFactor := 0.4;
RAWOpen('../TestFiles/75dpi_49x49.txt',fBeam);
sgExpr := TStringGrid.Create(nil);
sgExpr.Visible := false;
Prof := TSingleProfile.Create;
Prof.SetParams(0,0,1);
fBeam.CreateProfile(Prof,round(fBeam.Max),0);
end;


procedure TestProtocolImageJ.TearDown;
begin
fBeam.Free;
sgExpr.Free;
Prof.Free;
end;


procedure TestProtocolImageJ.TestProtocolBrachy;
{Verified from 75dpi_49x49.txt. ImageJ macros centre on profile length. ImageJ
adds 1/2 pixel to CoM to give geometric centre of image. BeamScheme reports top
left corner of pixel containing CoM}
var I          :integer;

const Params: array of string = (
'2D Image Stats	',
'     CAX value	609.70',
'     Max value	758.50',
'     Average	205.44',
'     Min IFA	470.80',              {ImageJ reports 476.8}
'     CoM pos	(24.35,23.51)',       {ImageJ adds 0.5 and reports (24.8,24.0)}
'2D Uniformity	',
'     Uniformity NCS	24.41%',
'     Uniformity ICRU	47.28%',      {ImageJ reports 46.1%}
'2D Symmetry	',
'     Symmetry	40.05%',              {ImageJ reports 39.8%}
'	',
'Profile stats	',
'     CAX value	609.70',
'     Max value	734.40',
'     Min IFA	541.60',
'Interpolated params	',
'     Left edge	-0.54 cm',
'     Right edge	0.50 cm',
'     Centre	-0.02 cm',
'     Size	1.04 cm',
'Uniformity	',
'     NCS-70	15.81%',
'     ICRU 72	30.49%',
'Symmetry	',
'     NCS-70	28.72%',
'	'
);

begin
sgExpr.LoadFromCSVFile('../Protocols/Brachy.csv');
for I:=0 to sgExpr.RowCount - 1 do
   begin
   Prof.sExpr := sgExpr.Cells[1,I];
   if Prof.sExpr <> '' then
      begin
      if LeftStr(Prof.sExpr,2) = '1D' then
         sgExpr.Cells[2,I] := Calc1DParam(Prof);
      if LeftStr(Prof.sExpr,2) = '2D' then
         sgExpr.Cells[2,I] := Calc2DParam(fBeam,Prof.sExpr);
      end
     else
      sgExpr.Cells[2,I] := '';
   AssertEquals('Line ' + InttoStr(I) + ' ' + sgExpr.Cells[0,I] + ' should be: ',Params[I],
      sgExpr.Cells[0,I] + #9 + sgExpr.Cells[2,I]);
   end;
end;



initialization
   RegisterTest(TestProtocolSNC);
   RegisterTest(TestProtocolPTW);
   RegisterTest(TestProtocolIBA);
   RegisterTest(TestProtocolPylinac);
   RegisterTest(TestProtocolBistroMath);
   RegisterTest(TestProtocolImageJ);
end.

