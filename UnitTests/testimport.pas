unit TestImport;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, fpcunit, testutils, testregistry, bstypes;

type

   TTestImport= class(TTestCase)
   private
      fBeam    :TBeam;
   protected
      procedure SetUp; override;
      procedure TearDown; override;
   published
      procedure TestMapCheckOpen;
      procedure TestMapCheckOpen_14_Feb_2008_A;
      procedure TestDICOMOpen;
      procedure TestDICOMOpen_RD;
      procedure TestIBAOpen;
      procedure TestPTWOpen;
      procedure TestXIOOpen;
      procedure TestBrainLabOpen;
      procedure TestBMPOpen;
      procedure TestRAWOpen;
   end;

implementation

uses importunit;

procedure TTestImport.SetUp;
begin
fBeam := TBeam.Create;
end;

procedure TTestImport.TearDown;
begin
fBeam.Free;
end;


procedure TTestImport.TestMapCheckOpen;
begin
MapCheckOpen('../TestFiles/2-Sep-2011-A.txt',fBeam);
AssertEquals('Detector Width',26,fBeam.Width);
AssertEquals('Detector Height',32,fBeam.Height);
AssertEquals('Detector XRes',0.5,fBeam.XRes);
AssertEquals('Detector YRes',0.5,fBeam.YRes);
AssertEquals('Detector Cols',55,fBeam.Cols);
AssertEquals('Detector Rows',65,fBeam.Rows);
AssertEquals('Detector Centre',94.465155720206312,fBeam.Centre);
AssertEquals('Detector Max',100,fBeam.Max);
AssertEquals('Detector Min',0,fBeam.Min);
end;


procedure TTestImport.TestMapCheckOpen_14_Feb_2008_A;
begin
MapCheckOpen('../TestFiles/14-Feb-2008-A.txt',fBeam);
AssertEquals('Detector Width',22,fBeam.Width);
AssertEquals('Detector Height',22,fBeam.Height);
AssertEquals('Detector XRes',0.5,fBeam.XRes);
AssertEquals('Detector YRes',0.5,fBeam.YRes);
AssertEquals('Detector Cols',47,fBeam.Cols);
AssertEquals('Detector Rows',45,fBeam.Rows);
AssertEquals('Detector Centre',86.41283592,fBeam.Centre);
AssertEquals('Detector Max',100,fBeam.Max);
AssertEquals('Detector Min',0,fBeam.Min);
end;


procedure TTestImport.TestIBAOpen;
begin
IBAOpen('../TestFiles/6MV.opg',fBeam);
AssertEquals('Detector Width',23.6189,fBeam.Width);
AssertEquals('Detector Height',23.6189,fBeam.Height);
AssertEquals('Detector XRes',0.7619,fBeam.XRes);
AssertEquals('Detector YRes',0.7619,fBeam.YRes);
AssertEquals('Detector Cols',34,fBeam.Cols);
AssertEquals('Detector Rows',32,fBeam.Rows);
AssertEquals('Detector Centre',53879.115,fBeam.Centre);
AssertEquals('Detector Max',55278.93,fBeam.Max);
AssertEquals('Detector Min',496.3,fBeam.Min);
end;


procedure TTestImport.TestPTWOpen;
begin
PTWOpen('../TestFiles/X06 NONE 20X20 CR 00 BEA 140724 12''23.mcc',fBeam);
AssertEquals('Detector Width',26,fBeam.Width);
AssertEquals('Detector Height',26,fBeam.Height);
AssertEquals('Detector XRes',1.0,fBeam.XRes);
AssertEquals('Detector YRes',1.0,fBeam.YRes);
AssertEquals('Detector Cols',29,fBeam.Cols);
AssertEquals('Detector Rows',27,fBeam.Rows);
AssertEquals('Detector Centre',80.597,fBeam.Centre);
AssertEquals('Detector Max',83.856,fBeam.Max);
AssertEquals('Detector Min',2.3012,fBeam.Min);
end;


procedure TTestImport.TestDICOMOpen;
begin
DICOMOpen('../TestFiles/6MV-20x20.dcm',fBeam);
AssertEquals('Detector Width',39.984,fBeam.Width);
AssertEquals('Detector Height',39.984,fBeam.Height);
AssertEquals('Detector XRes',0.0336,fBeam.XRes);
AssertEquals('Detector YRes',0.0336,fBeam.YRes);
AssertEquals('Detector Cols',1192,fBeam.Cols);
AssertEquals('Detector Rows',1190,fBeam.Rows);
AssertEquals('Detector Centre',50481.75,fBeam.Centre,0.01);
AssertEquals('Detector Max',57351.0,fBeam.Max,0.01);
AssertEquals('Detector Min',0,fBeam.Min);
end;


procedure TTestImport.TestDICOMOpen_RD;
{Tests DICOM dose plane import}
begin
DICOMOpen('../TestFiles/RD.1.2.246.352.71.7.733585388216.30143.20190502111658.dcm',fBeam);
AssertEquals('Detector Width',26,fBeam.Width);
AssertEquals('Detector Height',26,fBeam.Height);
AssertEquals('Detector XRes',0.5,fBeam.XRes);
AssertEquals('Detector YRes',0.5,fBeam.YRes);
AssertEquals('Detector Cols',54,fBeam.Cols);
AssertEquals('Detector Rows',52,fBeam.Rows);
AssertEquals('Detector Centre',1020226.50,fBeam.Centre,0.01);
AssertEquals('Detector Max',2147483647.0,fBeam.Max,0.01);
AssertEquals('Detector Min',0,fBeam.Min);
end;


procedure TTestImport.TestXIOOpen;
begin
XioOpen('../TestFiles/XiO-Patient-0.txt',fBeam);
AssertEquals('Detector Width',30.5,fBeam.Width);
AssertEquals('Detector Height',36.0,fBeam.Height);
AssertEquals('Detector XRes',0.1,fBeam.XRes);
AssertEquals('Detector YRes',0.1,fBeam.YRes);
AssertEquals('Detector Cols',308,fBeam.Cols);
AssertEquals('Detector Rows',361,fBeam.Rows);
AssertEquals('Detector Centre',51.5,fBeam.Centre);
AssertEquals('Detector Max',62.7,fBeam.Max);
AssertEquals('Detector Min',0,fBeam.Min);
end;


procedure TTestImport.TestBrainLabOpen;
begin
BrainLabOpen('../TestFiles/MadMaxDynConfAxial',fBeam);
AssertEquals('Detector Width',17.7,fBeam.Width);
AssertEquals('Detector Height',21.9,fBeam.Height);
AssertEquals('Detector XRes',0.1,fBeam.XRes);
AssertEquals('Detector YRes',0.1,fBeam.YRes);
AssertEquals('Detector Cols',180,fBeam.Cols);
AssertEquals('Detector Rows',220,fBeam.Rows);
AssertEquals('Detector Centre',553.7,fBeam.Centre);
AssertEquals('Detector Max',585.7,fBeam.Max);
AssertEquals('Detector Min',0,fBeam.Min);
end;


procedure TTestImport.TestBMPOpen;
begin
BMPOpen('../TestFiles/Test.bmp',fBeam);
AssertEquals('Detector Width',17.3397,fBeam.Width);
AssertEquals('Detector Height',17.3397,fBeam.Height);
AssertEquals('Detector XRes',0.0339,fBeam.XRes);
AssertEquals('Detector YRes',0.0339,fBeam.YRes);
AssertEquals('Detector Cols',514,fBeam.Cols);
AssertEquals('Detector Rows',512,fBeam.Rows);
AssertEquals('Detector Centre',128,fBeam.Centre);
AssertEquals('Detector Max',192,fBeam.Max);
AssertEquals('Detector Min',0,fBeam.Min);
end;


procedure TTestImport.TestRAWOpen;
begin
RAWOpen('../TestFiles/Set1-A1.txt',fBeam);
AssertEquals('Detector Width',1.6933,fBeam.Width);
AssertEquals('Detector Height',1.6933,fBeam.Height);
AssertEquals('Detector XRes',0.0339,fBeam.XRes);
AssertEquals('Detector YRes',0.0339,fBeam.YRes);
AssertEquals('Detector Cols',52,fBeam.Cols);
AssertEquals('Detector Rows',50,fBeam.Rows);
AssertEquals('Detector Centre',415.50,fBeam.Centre);
AssertEquals('Detector Max',463.0,fBeam.Max);
AssertEquals('Detector Min',0,fBeam.Min);
end;


initialization

   RegisterTest(TTestImport);
end.

