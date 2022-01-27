unit importunit;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, bstypes;

function TextOpen(sFileName:string; Beam:TBeam):boolean;
function MapCheckOpen(sFileName:string; Beam:TBeam):boolean;
function IBAOpen(sFileName:string; Beam:TBeam):boolean;
function PTWOpen(sFileName:string; Beam:TBeam):boolean;
function DICOMOpen(sFileName:string; Beam:TBeam):boolean;
function XioOpen(sFileName:string; Beam:TBeam):boolean;
function BrainLabOpen(sFileName:string; Beam:TBeam):boolean;
function BMPOpen(sFileName:string; Beam:TBeam):boolean;
function HISOpen(sFileName:string; Beam:TBeam):boolean;
function RAWOpen(sFileName:string; Beam:TBeam):boolean;

implementation

uses DICOM, define_types, StrUtils, GraphType, IntfGraphics, FPImage, LazFileUtils;

function RobustStrToFloat(s:string):extended;
var fs:        TFormatSettings;

begin
fs := DefaultFormatSettings;
Result := 0;
   try
   Result := StrToFloat(s);
   except
   on EConvertError do         {try again using other decimal separator}
      begin
      if fs.DecimalSeparator = ',' then
         fs.DecimalSeparator := '.'
        else
         fs.DecimalSeparator := ',';
      Result := StrToFloat(s,fs);
      end;
   end;
end;


function TextOpen(sFileName:string; Beam:TBeam):boolean;
var Infile:    textfile;
    Dummy:     string;

begin
{look at first row of text file to determine type}
Result := false;
AssignFile(Infile, sFileName);
Reset(Infile);
readln(Infile,Dummy);
CloseFile(Infile);
if LeftStr(Dummy,10) = '** WARNING' then
   Result := MapCheckOpen(sFileName,Beam);
if not Result and (LeftStr(Dummy,8) = '0001108e') then
   Result := XiOOpen(sFileName,Beam);
if not Result and (LeftStr(Dummy,8) = 'BrainLAB') then
   Result := BrainLabOpen(sFileName,Beam);
if not Result and (Length(Dummy) > 4) then                {assume image is matrix of text values}
   Result := RAWOpen(sFileName,Beam);
if not Result then raise EBSError.Create('Text file not recognised!',error);
end;


function MapCheckOpen(sFileName:string; Beam:TBeam):boolean;
{Import Sun Nuclear MapCheck text files}
var I,J        :integer;
    Dummy,
    sCalFile   :string;
    Value      :double;
    RowDet     :TBeamData;     {read first two cols of value matrix}
    Infile     :textfile;

begin
Result := false;
AssignFile(Infile, sFileName);
Reset(Infile);

readln(Infile,Dummy);
if Dummy[1] = '*' then {file is MapCheck}
   begin
   {get dimensions and scan down to interpolated data}
   sCalFile := 'Dose Interpolated';
   while (Dummy <> sCalFile) and (not eof(Infile)) do
      begin
      readln(Infile,Dummy);
      if LeftStr(Dummy,4) = 'Rows' then
         Beam.Rows := StrToInt(copy(Dummy,6,3));
      if LeftStr(Dummy,4) = 'Cols' then
         Beam.Cols := StrToInt(copy(Dummy,6,3));
      if LeftStr(Dummy,9) = 'Dose Info' then
         if Copy(Dummy,12,4) = 'None' then
            sCalFile := 'Interpolated';
      end;
   readln(Infile);                                {skip row header}

   if (not eof(Infile)) and (Beam.Rows <> 0) and (Beam.Cols <> 0) then
      begin
      SetLength(Beam.Data,Beam.Rows);
      SetLength(RowDet,Beam.Rows);
      for I := 0 to Beam.Rows - 1 do
         begin
         SetLength(Beam.Data[I],Beam.Cols);
         SetLength(RowDet[I],2);
         {read row and detector no}
         Read(Infile, Value);
         RowDet[I,0] := Value;
         Read(Infile, Value);
         RowDet[I,1] := Value;
         for J := 0 to Beam.Cols - 1 do
            begin
            Read(Infile, Value);
            Beam.Data[I,J] := Value;
            end;
         end;

      readln(Infile);
      readln(Infile);                                       {skip column numbers}
      read(Infile,Dummy);
      Dummy := RightStr(Dummy,Length(Dummy) - LastDelimiter(#9,Dummy));
      {set dimensions}
      with Beam do
         begin
         Height := RowDet[0,0]*2;
         Width := RobustStrToFloat(Dummy)*2;
         XRes := Height/(Rows - 1);             //number of spaces are detectors - 1
         YRes := Width/(Cols - 1)
         end;
      Result := true;
      end
     else
      begin
      raise EBSError.Create('Not a recognised MapCheck text file!',error);
      end;
   end
  else
   begin
   raise EBSError.Create('Not a recognised MapCheck text file!',error);
   end;
CloseFile(Infile);
end;


function IBAOpen(sFileName:string; Beam:TBeam):boolean;
{Import IBA Matrix and StarTrack text opg files}
var I,J,K,
    NumSets    :integer;
    Dummy,
    sPart,
    sCalFile   :string;
    Value      :double;
    RowDet     :array of double;
    Infile     :textfile;

begin
Result := false;
NumSets := 0;
AssignFile(Infile, sFileName);
Reset(Infile);

readln(Infile,Dummy);
if Dummy = '<opimrtascii>' then {file is IBA}
   begin
   {get dimensions and scan down to interpolated data}
   sCalFile := '<asciibody>';
   while (Dummy <> sCalFile) and (not eof(Infile)) do
      begin
      readln(Infile,Dummy);
      sPart := ExtractDelimited(1,Dummy,[':']);
      if sPart = 'No. of Rows' then
         begin
         sPart:= ExtractDelimited(2,Dummy,[':']);
         Beam.Rows := StrToInt(sPart);
         end;
      if sPart = 'No. of Columns' then
         begin
         sPart:= ExtractDelimited(2,Dummy,[':']);
         Beam.Cols := StrToInt(sPart);
         end;
      if sPart = 'Number of Bodies' then
         begin
         sPart:= ExtractDelimited(2,Dummy,[':']);
         NumSets := StrToInt(sPart);
         end;
      end;
   readln(Infile);                                {skip plane position}
   readln(Infile);                                {skip blank row}
   readln(Infile,Dummy);                          {get col headers}
   sPart:= ExtractDelimited(2,Dummy,[#9]);
   readln(Infile);                                {skip Y[mm]}

   {Sum data sets}
   if (not eof(Infile)) and (Beam.Rows <> 0) and (Beam.Cols <> 0) then
      begin
      SetLength(Beam.Data,Beam.Rows);
      SetLength(RowDet,Beam.Rows);
      for K:=1 to NumSets do
         begin
         for I := Beam.Rows - 1 downto 0 do
            begin
            if K = 1 then SetLength(Beam.Data[I],Beam.Cols);
            {read row no}
            Read(Infile, Value);
            if K = 1 then RowDet[I] := Value;
            for J := 0 to Beam.Cols - 1 do
               begin
               read(Infile, Value);
               if (K = 1) then Beam.Data[I,J] := Value
                  else Beam.Data[I,J] := Beam.Data[I,J] + Value;
               end;
            end;


         while (Dummy <> sCalFile) and (not eof(Infile)) do
            readln(Infile,Dummy);                 {scan to next <asciibody>}
         readln(Infile,Dummy);                    {skip plane position}
         readln(Infile,Dummy);                    {skip blank row}
         readln(Infile,Dummy);                    {get col headers}
         readln(Infile,Dummy);                    {skip Y[mm]}
         end;
      end;

   {average and get Min/Max}
   if (Beam.Rows <> 0) and (Beam.Cols <> 0) then
      begin
      for I := 0 to Beam.Rows - 1 do
         begin
         for J := 0 to Beam.Cols - 1 do
            begin
            Beam.Data[I,J] := Beam.Data[I,J]/NumSets;
            end;
         end;
      end;

   {set dimensions}
   with Beam do
      begin
      Height := RowDet[0]*0.2;
      Width := abs(RobustStrToFloat(Trim(sPart))*0.2);
      XRes := Height/(Rows - 1);             //number of spaces are detectors - 1
      YRes := Width/(Cols - 1)
      end;
   Result := true;
   end
  else
   begin
   raise EBSError.Create('Not a recognised IBA opg file!',error);
   end;
CloseFile(Infile);
end;


function PTWOpen(sFileName:string; Beam:TBeam):boolean;
{Import PTW MCC text files. PTW data is organised into a series of profile scans}
var I,J        :integer;
    Dummy      :string;
    Value      :double;
    RowDet     :array of double;
    Infile     :textfile;
    Counting   :boolean;

begin
Result := false;
AssignFile(Infile, sFileName);
Reset(Infile);

readln(Infile,Dummy);
Dummy := DelChars(Dummy,#9);
if Dummy = 'BEGIN_SCAN_DATA' then {file is PTW}
   begin
   {scan through file and get dimensions}
   I := 0;
   J := 0;
   Counting := false;
   while (not eof(infile)) and (Dummy <> 'END_SCAN_DATA') do
      begin
      if (leftstr(Dummy,11) = 'BEGIN_SCAN ') then inc(I);
      if (Dummy = 'BEGIN_DATA') then Counting := true;
      if (Dummy = 'END_DATA') then Counting := false;
      if Counting then inc(J);
      readln(Infile,Dummy);
      Dummy := DelChars(Dummy,#9);
      end;
   Beam.Rows := I;
   Beam.Cols := Round(J/I - 1);

   Reset(Infile);
   if(not eof(Infile)) and (Beam.Rows <> 0) and (Beam.Cols <> 0) then
      begin
      SetLength(Beam.Data,Beam.Rows);
      SetLength(RowDet,Beam.Rows);
      I := 0;
      Counting := false;
      readln(Infile,Dummy);
      Dummy := TrimLeftSet(Dummy,StdWordDelims);
      while (not eof(infile)) and (Dummy <> 'END_SCAN_DATA') do
         begin
         if (DelChars(Dummy,#9) = 'END_DATA') then Counting := false;
         if Counting then
            begin
            Dummy := ExtractDelimited(3,Dummy,[#9]);
            Value := RobustStrToFloat(Dummy);
            Value := Value*100;                                {convert to cGy}
            Beam.Data[Beam.Rows - I,J] := Value;
            inc(J);
            end;
         if (DelChars(Dummy,#9) = 'BEGIN_DATA') then
            begin
            Counting := true;
            J := 0;
            end;
         if (LeftStr(Dummy,11) = 'BEGIN_SCAN ') then
            begin
            inc(I);
            SetLength(Beam.Data[Beam.Rows - I],Beam.Cols);
            end;
         if LeftStr(Dummy,20) = 'SCAN_OFFAXIS_INPLANE' then
            begin
            Copy2SymbDel(Dummy,'=');
            RowDet[Beam.Rows - I] := RobustStrToFloat(Dummy);
            end;
         readln(Infile,Dummy);
         Dummy := TrimLeftSet(Dummy,StdWordDelims);
         end;
      end;

      {set dimensions}
      with Beam do
         begin
         Height := RowDet[0]/5;
         Width := Height;                      {assume square for now}
         XRes := Height/(Rows - 1);             //number of spaces are detectors - 1
         YRes := Width/(Cols - 1)
         end;
      Result := true;
   end
  else
   begin
   raise EBSError.Create('Not a recognised PTW mcc file!',error);
   end;
CloseFile(Infile);
end;


function DICOMOpen(sFileName:string; Beam:TBeam):boolean;
{Import DICOM RI and RD files}

type  IntRA = array [0..0] of integer;
      IntP0 = ^IntRA;


var Infile     :file;
    sDICOMhdr  :string;
    I,J,K,
    I12,
    ImageStart,
    AllocSliceSz,
    StoreSliceSz,
    StoreSliceVox,
    size       :integer;
    Value      :double;
    bImgOK     :boolean = false;
    bHdrOK     :boolean = false;
    gDICOMData :DiCOMDATA;
    lBuff,
    TmpBuff    :bYTEp0;
    lBuff16    :WordP0;
    lBuff32    :DWordP0;

begin
Beam.Rows := 0;
Beam.Cols := 0;
Result := false;
   try

      {procedure read_dicom_data(lVerboseRead,lAutoDECAT7,lReadECAToffsetTables,
         lAutodetectInterfile,lAutoDetectGenesis,lReadColorTables: boolean;
         var lDICOMdata: DICOMdata; var lHdrOK, lImageFormatOK: boolean;
         var lDynStr: string;var lFileName: string);}

      read_dicom_data(false,true,false,false,true,true,false,gDICOMdata,bHdrOK,
         bImgOK,sDICOMhdr,sFileName {infp});
      if (bImgOK) and ((gDicomData.CompressSz > 0) or
         (gDICOMdata.SamplesPerPixel > 1)) then
         begin
         raise EBSError.Create('This software can not read compressed or 24-bit color files!',error);
         bImgOK := false;
         end;
      if not bHdrOK then
         begin
         raise EBSError.Create('Unable to load DICOM header segment. Is this really a DICOM compliant file?',error);
         sDICOMhdr := '';
         end;

      if bImgOK and bHdrOK then
         begin

         {get dimensions}
         AllocSLiceSz := (gDICOMdata.XYZdim[1]*gDICOMdata.XYZdim[2]{height * width} *
            gDICOMdata.Allocbits_per_pixel+7) div 8 ;
         if (AllocSLiceSz) < 1 then exit;
         Beam.Cols := gDICOMData.XYZdim[1];
         Beam.Rows := gDICOMData.XYZdim[2];
         Beam.XRes := gDICOMData.XYZmm[1]/10;
         Beam.YRes := gDICOMData.XYZmm[2]/10;
         Beam.Width := gDICOMData.XYZdim[1]*gDICOMData.XYZmm[1]/10;
         Beam.Height := gDICOMData.XYZdim[2]*gDICOMData.XYZmm[2]/10;

         AssignFile(Infile, sFileName);
         FileMode := 0; //Read only
         Reset(Infile,1);

         ImageStart := gDicomData.ImageStart;
         if (ImageStart + AllocSliceSz) > (FileSize(Infile)) then
            begin
            raise EBSError.Create('This file does not have enough data for the image size!',error);
            closefile(Infile);
            FileMode := 2; //read/write
            exit;
            end;

         Seek(Infile, ImageStart);

         case gDICOMdata.Allocbits_per_pixel of
            8:begin
              GetMem( lbuff, AllocSliceSz);
              BlockRead(Infile, lbuff^, AllocSliceSz{, n});
              CloseFile(Infile);
              FileMode := 2; //read/write
              end;

           16:begin
              GetMem( lbuff16, AllocSliceSz);
              BlockRead(Infile, lbuff16^, AllocSliceSz{, n});
              CloseFile(Infile);
              FileMode := 2; //read/write
              end;

           12:begin
              GetMem( tmpbuff, AllocSliceSz);
              BlockRead(Infile, tmpbuff^, AllocSliceSz{, n});
              CloseFile(Infile);
              FileMode := 2; //read/write
              StoreSliceVox := gDICOMdata.XYZdim[1]*gDICOMdata.XYZdim[2];
              StoreSLiceSz := StoreSliceVox * 2;
              GetMem( lbuff16, StoreSLiceSz);
              I12 := 0;
              I := 0;
              repeat
                 lbuff16^[I] := (((tmpbuff^[I12]) shr 4) shl 8) + (((tmpbuff^[I12+1]) and 15)
                    + (((tmpbuff^[I12]) and 15) shl 4) );
                 inc(I);
                 if I < StoreSliceVox then
                    //char (((integer(tmpbuff[I12+2]) and 16) shl 4)+ (integer(tmpbuff[I12+1]) shr 4));
                    lbuff16^[i] :=  (((tmpbuff^[I12+2]) and 15) shl 8) +((((tmpbuff^[I12+1]) shr 4 )
                       shl 4)+((tmpbuff^[I12+2]) shr 4)  );
                 inc(I);
                 I12 := I12 + 3;
              until I >= StoreSliceVox;
              FreeMem( tmpbuff);
              end;
          32: begin
              GetMem( lbuff32, AllocSliceSz);
              BlockRead(Infile, lbuff32^, AllocSliceSz{, n});
              CloseFile(Infile);
              FileMode := 2; //read/write
              end;
            else exit;
            end;

         if  (gDICOMdata.Storedbits_per_pixel)  > 16 then
            begin
            size := gDicomData.XYZdim[1]*gDicomData.XYZdim[2] {2*width*height};
            if gDicomdata.little_endian <> 1 then  //convert big-endian data to Intel friendly little endian
               for i := (Size-1) downto 0 do
                   lbuff32^[i] := swap(lbuff32^[i]);

            Value := lbuff32^[0];
            I:=0;
            SetLength(Beam.Data,Beam.Rows);
            for J:= 0 to gDicomData.XYZdim[2] - 1 do
               begin
               SetLength(Beam.Data[J],Beam.Cols);
               for K:=0 to gDicomData.XYZdim[1] - 1 do
                  begin
                  Value := lbuff32^[i];
                  Beam.Data[J,K] := Value;
                  inc(I);
                  end;
               end;

            FreeMem( lbuff32 );
            end
          else
         {rescale and convert to 8 bit}
         if  (gDICOMdata.Storedbits_per_pixel)  > 8 then
            begin
            size := gDicomData.XYZdim[1]*gDicomData.XYZdim[2] {2*width*height};
            if gDicomdata.little_endian <> 1 then  //convert big-endian data to Intel friendly little endian
               for i := (Size-1) downto 0 do
                  lbuff16^[i] := swap(lbuff16^[i]);

            Value := lbuff16^[0];
            I := 0;
            SetLength(Beam.Data,Beam.Rows);
            for J:= 0 to gDicomData.XYZdim[2] - 1 do
               begin
               SetLength(Beam.Data[J],Beam.Cols);
               for K:=0 to gDicomData.XYZdim[1] - 1 do
                  begin
                  Value := lbuff16^[i];
                  Beam.Data[J,K] := Value;
                  inc(I);
                  end;
               end;
            FreeMem(lbuff16);
            end
           else
            {rescale}
            begin
            size := gDicomData.XYZdim[1]*gDicomData.XYZdim[2] {2*width*height};
            value := lbuff^[0];
            I := 0;
            SetLength(Beam.Data,Beam.Rows);
            for J:= 0 to gDicomData.XYZdim[2] - 1 do
               begin
               SetLength(Beam.Data[J],Beam.Cols);
               for K:=0 to gDicomData.XYZdim[1] - 1 do
                  begin
                  value := lbuff^[i];
                  Beam.Data[J,K] := Value;
                  inc(I);
                  end;
               end;
            FreeMem(lBuff);
            end;
         Result := true;
         end
        else
         begin
         raise EBSError.Create('DICOM file error, no data found!',error);
         end;
     except
     raise EBSError.Create('DICOM file error, corrupt file!',error);
     end;
end;


function HISOpen(sFileName:string; Beam:TBeam):boolean;
{Import generic HIS files}
var Infile     :file of word;
    I,J,K,
    size       :integer;
    FileXDim,
    FileYDim,
    ImageStart :word;
    Value      :double;
    lBuff16    :WordP0;

begin
Beam.Rows := 0;
Beam.Cols := 0;
Result := false;
   try
   AssignFile(Infile,SFileName);
   FileMode := 0; //Read only
   Reset(Infile);

   {get dimensions}
   Seek(Infile,3);
   Read(Infile,ImageStart);
   ImageStart := ImageStart div 2; {no of 16 bit words}
   Seek(Infile,8);
   Read(Infile,FileXDim);
   Read(Infile,FileYDim);
   Beam.Cols := FileXDim;
   Beam.Rows := FileYDim;
   Beam.Width := FileXDim;
   Beam.Height := FileYDim;

   Seek(Infile, ImageStart);
   Size := FileXDim*FileYDim*2;
   GetMem(lbuff16, Size);
   BlockRead(Infile, lbuff16^, Size div 2);
   CloseFile(Infile);

   Value := lbuff16^[0];
   I := 0;
   SetLength(Beam.Data,Beam.Rows);
   for J:= 0 to FileYDim - 1 do
      begin
      SetLength(Beam.Data[J],Beam.Cols);
      for K:=0 to FileXDim - 1 do
         begin
         Value := lbuff16^[i];
         Beam.Data[J,K] := Value;
         inc(I);
         end;
      end;
   FreeMem(lbuff16);
   Result := true;
   except
   raise EBSError.Create('HIS file error, corrupt file!',error);
   end;
end;


function XiOOpen(sFileName:string; Beam:TBeam):boolean;
{Import XiO and Monaco dose plane text files}
var I,J        :integer;
    Dummy      :string;
    cGy,                       {if dose is in Gy convert to cGy}
    Value      :double;
    Infile     :textfile;

begin
Result := false;
AssignFile(Infile, sFileName);
Reset(Infile);
cGy := 1;
for I:=1 to 16 do
   begin
   readln(Infile,Dummy);
   if LeftStr(Dummy,9) = 'DosePtsxy' then
      begin
      Beam.Cols := StrToInt(copy(Dummy,11,3));
      Beam.Rows := StrToInt(copy(Dummy,15,3));
      end;
   if LeftStr(Dummy,9) = 'DoseResmm' then
      begin
      Beam.XRes := RobustStrToFloat(RightStr(Dummy,3))/10;
      Beam.YRes := Beam.XRes;
      end;
   if LeftStr(Dummy,19) = 'OutputWidLenQAplane' then
      begin
      Beam.Width := RobustStrToFloat(ExtractDelimited(2,Dummy,[',']))/10;
      Beam.Height := RobustStrToFloat(ExtractDelimited(3,Dummy,[',']))/10;
      end;
   if LeftStr(Dummy,9) = 'DoseUnits' then
      begin
      Dummy := TrimLeft(ExtractDelimited(2,Dummy,[',']));
      if LeftStr(Dummy,2) = 'Gy' then cGy := 100;
      end;
   end;

if (not eof(Infile)) and (Beam.Rows <> 0) and (Beam.Cols <> 0) then
   begin
   SetLength(Beam.Data,Beam.Rows);
   for I := 0 to Beam.Rows - 1 do
      begin
      SetLength(Beam.Data[I],Beam.Cols);
      readln(Infile,Dummy);
      for J := 0 to Beam.Cols - 1 do
         begin
         Value := RobustStrToFloat(ExtractDelimited(J+1,Dummy,[',']))*cGy;
         Beam.Data[I,J] := Value;
         end;
      end;
   Result := true;
   end
  else
   begin
   raise EBSError.Create('Not a recognised XIO text file!',error);
   end;
CloseFile(Infile);
end;


function RAWOpen(sFileName:string; Beam:TBeam):boolean;
{Import raw text values, tab delimited}
var I,J        :integer;
    Dummy,
    sValue     :string;
    Value      :double;
    Infile     :textfile;

begin
Result := true;
   try
   AssignFile(Infile, sFileName);
   Reset(Infile);

   I := 0;
   while not eof(Infile) and Result do
      begin
      SetLength(Beam.Data,I+1);
      readln(Infile,Dummy);
      Dummy := Tab2Space(Dummy,1);
      J := 0;
      while Result and (Dummy <> '') do
         begin
         SetLength(Beam.Data[I],J+1);
         sValue := Copy2SpaceDel(Dummy);
            try
            Value := RobustStrToFloat(sValue);
            except
            Result := false;
            end;
         Beam.Data[I,J] := Value;
         inc(J);
         end;
      inc(I);
      end;
   if Result then
      begin
      Beam.Rows := I;
      Beam.Cols := J;
      Beam.XRes := DefaultRes;
      Beam.YRes := DefaultRes;
      Beam.Width := J*DefaultRes;
      Beam.Height := I*DefaultRes;
      end
     else
      raise EBSError.Create('Could not read RAW text file',error);
   finally
   CloseFile(Infile);
   end;
end;


function BrainLabOpen(sFileName:string; Beam:TBeam):boolean;
{Import BrainLab dose plane export text files}
var I,J,K,
    NumSets    :integer;
    Dummy,sPart,
    sCalFile,
    sColHead   :string;
    cGy,                       {if dose is in Gy convert to cGy}
    Value,
    LDet,                      {position of left most value}
    RDet       :double;        {position of right most value}
    RowDet     :array of double;
    Infile     :textfile;

begin
Result := false;
NumSets := 0;
RDet := 0;
AssignFile(Infile, sFileName);
Reset(Infile);
cGy := 1;

readln(Infile,Dummy);
if LeftStr(Dummy,8) = 'BrainLAB' then {file is BrainLab}
   begin
   {get dimensions and scan down to interpolated data}
   sCalFile := '-----------------------------------------------------';
   while (Dummy <> sCalFile) and (not eof(Infile)) do
      begin
      readln(Infile,Dummy);
      sPart := ExtractDelimited(1,Dummy,[':']);
      if sPart = 'Number of Rows' then
         begin
         sPart:= ExtractDelimited(2,Dummy,[':']);
         Beam.Rows := StrToInt(sPart);
         end;
      if sPart = 'Number of Columns' then
         begin
         sPart:= ExtractDelimited(2,Dummy,[':']);
         Beam.Cols := StrToInt(sPart);  {include row and detector no}
         end;
      if sPart = 'Number of Planes' then
         begin
         sPart:= ExtractDelimited(2,Dummy,[':']);
         NumSets := StrToInt(sPart);
         end;
      if Dummy = 'Table Entries in Gy' then cGy := 100;
      end;
   readln(Infile,sColHead);                          {get col headers}

   {Sum data sets}
   if (not eof(Infile)) and (Beam.Rows <> 0) and (Beam.Cols <> 0) then
      begin
      for K:=1 to NumSets do
         begin
         if K = 1 then
            begin
            SetLength(Beam.Data,Beam.Rows);
            SetLength(RowDet,Beam.Rows);
            end;
         for I := 0 to Beam.Rows - 1 do
            begin
            if K = 1 then SetLength(Beam.Data[I],Beam.Cols);
            {read row no}
            Read(Infile, Value);
            if K = 1 then RowDet[I] := Value;
            for J := 0 to Beam.Cols - 1 do
               begin
               read(Infile, Value);
               if (K = 1) then
                  Beam.Data[I,J] := Value*cGy
                 else
                  Beam.Data[I,J] := Beam.Data[I,J] + Value*cGy;
               end;
            end;

         while (Dummy <> sCalFile) and (not eof(Infile)) do
            readln(Infile,Dummy);                       {scan to next ------}
         readln(Infile,Dummy);                          {get col headers}
         end;
      end;

   {average and get Min/Max}
   if (Beam.Rows <> 0) and (Beam.Cols <> 0) then
      begin
      for I := 0 to Beam.Rows - 1 do
         begin
         for J := 0 to Beam.Cols - 1 do
            begin
            Beam.Data[I,J] := Beam.Data[I,J]/NumSets;
            end;
         end;
      end;

   {set dimensions}
   with Beam do
      begin
      LDet:= RobustStrToFloat(ExtractDelimited(2,sColHead,[#9]));
      sPart := sColHead;
      I := 3;
      while sPart <> '' do
         begin
         sPart := ExtractDelimited(I,sColHead,[#9]);
         if sPart <> '' then RDet := RobustStrToFloat(sPart);
         Inc(I);
         end;
      Width := abs(LDet - RDet)/10;
      Height := abs(RowDet[0] - RowDet[Beam.Rows-1])/10;
      XRes := Height/(Rows - 1);             //number of spaces are detectors - 1
      YRes := Width/(Cols - 1);
      end;
   Result := true;
   end
  else
   begin
   raise EBSError.Create('File error, no data found!',error);
   end;
CloseFile(Infile);
end;


function BMPOpen(sFileName:string; Beam:TBeam):boolean;
{Import BM, TIFF and JPEG images. Compressed TIFF is not supported}
var I,J,
    ResUnit    :integer;
    Value,
    Res        :double;
    SrcIntfImage:TLazIntfImage;
    lRawImage  :TRawImage;
    Curcolor   :TFPColor;
    sRes,
    sResUnit   :string;

begin
Res := DefaultRes;
Result := false;
lRawImage.Init;
lRawImage.Description.Init_BPP24_B8G8R8_BIO_TTB(0,0);
lRawImage.CreateData(false);
SrcIntfImage := TLazIntfImage.Create(0,0);
SrcIntfImage.SetRawImage(lRawImage);
SrcIntfImage.LoadFromFile(sFileName);
Beam.Cols := SrcIntfImage.Width;
Beam.Rows := SrcIntfImage.Height;
if SrcIntfImage.ExtraCount>0 then
   try
   sResUnit := SrcIntfImage.Extra['TiffResolutionUnit'];
   ResUnit := StrToInt(sResUnit);
   sRes := SrcIntfImage.Extra['TiffXResolution'];
   case ResUnit of
      2: Res := 2.54/StrToFloat(Copy2Symb(sRes,'/'));      {res is in dpi}
      3: Res := 1/StrToFloat(Copy2Symb(sRes,'/'));         {res is in dpcm}
      end;
   except
   raise EBSError.Create('Image resolution not found, using default resolution!',warning);
   end;
if (Beam.Rows > 0) and (Beam.Cols > 0) then
   begin
   SetLength(Beam.Data,Beam.Rows);
   for I := 0 to Beam.Rows - 1 do
      begin
      SetLength(Beam.Data[I],Beam.Cols);
      for J := 0 to Beam.Cols - 1 do
         begin
         CurColor := SrcIntfImage.Colors[J,I];
         Value := byte(CurColor.Red);
         Beam.Data[I,J] := Value;
         end;
      end;
   Beam.XRes := Res;
   Beam.YRes := Res;
   Beam.Width := Beam.Rows*Res;
   Beam.Height := Beam.Cols*Res;
   Result := true;
   end
  else
   begin
   raise EBSError.Create('Not a recognised Windows bitmap file!',error);
   end;
SrcIntfImage.Free;
end;


end.

