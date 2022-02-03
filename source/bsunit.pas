unit bsunit;
{Revision History
 Version 0.2 released 1/8/2011
 22/8/2011  Fix field centre error,
            Fix Y resolution error for MapCheck 2
 28/09/2011 removed MultiDoc
            added invert
            added normalise
            added windowing
            fixed profile display
            fixed symmetry calculation
            cleaned up printout
 15/2/2012  Fix CAX normalisation error,
 2/4/2013   Add read for XiO Dose plane file
 20/6/2014  Removed redundant DICOM read code causing memory bug
 24/6/2014  Fixed XiO read offset by 1
            Fixed MapCheck read if dose cal file not present
            Included Min/Max as part of beam class
            Fixed panel maximise to form area
 21/5/2015  Combine open dialog and DICOM dialog
 20/7/2015  Add messaging system
 Version 0.3 released 20/7/2015
 28/6/2016  Support PTW 729 mcc
 26/8/2016  Add normalise to max
 29/9/2016  Fix PTW 729 memory error
 21/10/2016 Add PowerPDF for output
 24/10/2016 Fix Profile event misfire
 15/8/2017  Fix image integer conversion
 13/10/2017 Support IBA Matrix and StartTrack opg
 16/10/2017 Fix Diff divide by zero error
            Fix profile offset limit error
 7/12/2017  Fix even number of detectors offset
 15/12/2017 Support Brainlab iPlan Dose plane format
            Add text file format identification
 8/1/2018   Add help system
            Fix windowing error on normalise to CAX
 26/1/2018  Fix panel maximise under QT5
            Fix window level control size under max/min
 30/1/2018  Fix area symmetry off by 1
            Fix CAX for even no of detectors
            Fix image autoscale
 1/2/2018   Add mouse control for profiles
 2/2/2018   Fix off by 1 error profile limits
 Version 0.4 released 2/2/2018
 27/3/2018  Fix regional settings decimal separator
 3/4/2018   Add mean and standard deviation
            Fix profile increment
 30/4/2019  Fix DTrackbar if image max = maxlongint
 3/5/2019   Fix DICOM off by one and pointer conversion
 17/7/2019  Update about unit
 18/7/2019  Update status bar
 23/7/2019  Add expression parser
 30/7/2019  Add multipage output
 31/7/2019  Fix profile export dirs
 1/8/2019   Add expression editor
 14/8/2019  Remove auto normalisation of profile values.
            Fix previous image and profile display on open image cancel
 11/9/2019  Fix prompt for overwrite results
            Fix protocol list unsorted on reload
            Add Quit Edit menu item
 16/9/2019  Fix Y axis swapped for IBA files
 10/10/2019 Change BitButtons to SpeedButtons on protocol edit toolbar
            Fix cancel on protocol save
            Fix edit flag on protocol edit exit
            Correct result window title on edit
 23/10/2019 Updated help
            Fix click on empty Image pane crash
 25/10/2019 Fix user protocol path
 Version 0.5 released 25/10/2019
 16/4/2020  Fix various memory leaks
 6/8/2020   use Form2PDf for printing PDF
            fix SaveDialog titles
            remove results unit and PowerPDF
 24/8/2020  add get correct resolution for tiff images
 18/9/2020  fix range check error in calcparams
            add inflection points
            neaten filename display
 22/9/2020  support raw text file
 29/9/2020  shift maths routines to unit mathsfuncs
 30/9/2020  shift types and constants to unit bstypes
            use Hill function non linear regression to determine inflection points
            add copy profiles to clipboard
 1/10/2020  use parser.SetVariable for performance enhancement
            fix status warning display
            add FFF params inflection point, 0.4*InfP (20%) and 1.6*InfP (80%)
 7/10/2020  add copy results to clipboard
            make Protocol read only while not in edit mode
            add context menus for X Y profiles and results
 8/10/2020  fix duplicate text file open
            fix RAWOpen range check error
            add sigmoid slope for penumbra
            add position of max
            fix protocol name change on edit
            add profile points for FFF
 14/10/2020 add app version
 20/10/2020 fix file extensions
 5/11/2020  update help
 17/11/2020 fix resolution for tiff files
 7/12/2020  add normalisation to max for calcs
 11/12/2020 make normalisation modal, i.e. non destructive
            change toolbar panel to TToolBar
 14/12/2020 select default protocol on startup
 3/3/2021   fix FFF penumbra slope
 11/9/2021  fix recognise files with tiff extension
 4/10/2021  fix initialise vars
            profile draw on trackbar change
 14/10/2021 create paramfuncs unit
 15/10/2021 move profile array into class TSingleProfile
 20/10/2020 shifted GetAppVersionString to about unit
 21/10/2021 created EBSError exception class with error type
 22/10/2021 move DisplayBeam into Beam class
            create drawfuncs unit
            create import unit
            shift toolbar to form, resize form
            fix profile position on mouse click
 29/10/2021 redesign GUI with new icons
 2/11/2021  add settings unit
            add return error code from form2pdf to status bar
 3/11/2021  add paramfuncs test unit
 4/11/2021  add bstypes test unit
 5/11/2021  refactor drawprofile
 17/11/2021 rename paramfuncs unit to param1Dfuncs
 18/11/2021 implement param2Dfuncs unit
 19/11/2021 split PArr array of TProfilePoint into two arrays of double
 22/11/2021 move beam min max into TBeam class and refactor
            change XiO distance units to cm for consistency
            fix windows bitmap default resolution
            add import unit tests
            add 2D param unit tests
 25/11/2021 fix Beam Min initialisation
            fix profile left edge find
 2/12/2021  change Beam.Display to procedure
            add show parameters
            fix bug in DTrackbar.UpdateTicks integer overflow causing infinite loop
            add scale display on normalisation
 10/12/2021 add MaxPosNan and MinPosNan to mathsfuncs as LMath does not handle Nans
            fix profile bug in MaxNorm and CAXNorm
 17/1/2022  create IFA data types and add to settings unit
 19/1/2022  create circular IFA
            create TBasicBeam data class, derive TBeam and define IFA as TBasicBeam
 20/1/2022  fix SingeProfile IFA if edges not found
            move Invert to TBasicbeam and create test
            finally remove 2x col offset in Data from legacy MapCheck
            move Centre to TBeam and create test
            fix invert and centre crash with no file open
 24/1/2022  show full file name in cImage hint
            fix display file name correctly on image maximise
 27/1/2022  set profile angle limits to corners of image
            create TSingleProfile.ToSeries and refactor
 28/1/2022  shift Limit and LimitL to mathsfuncs
            split calcprofile into drawing and calculation routines
            shift to bstypes and refactor, delete drawfuncs
 31/1/2022  remove overlimit compensation in CreateProfile
 1/2/2022   fix profile grounding bug in param1Dfuncs
            add TSingleProfile.ToString and refactor
 2/2/2022   fix rounding error on profile increment
            create TBasicProfile, derive TSingleProfile and define IFA as TBasicProfile}


{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, Buttons, TAGraph, TASeries, TATools, StdCtrls, Clipbrd,
  IntfGraphics, Spin, ComCtrls, LazHelpHTML, Grids, Tracker2, lNetComponents,
  lwebserver, bstypes;

  { TBSForm }

type
   TBSForm = class(TForm)
   ChartToolsetY: TChartToolset;
   ChartToolsetX: TChartToolset;
   ChartToolsetXDataPointHintTool: TDataPointHintTool;
   ChartToolsetYDataPointHintTool: TDataPointHintTool;
   cbProtocol: TComboBox;
   cXProfile: TChart;
   cXprof: TLabel;
   HTMLBrowserHelpViewer: THTMLBrowserHelpViewer;
   HTMLHelpDatabase: THTMLHelpDatabase;
   HelpServer: TLHTTPServerComponent;
   ImageList: TImageList;
   Label7: TLabel;
   miView: TMenuItem;
   miShowP: TMenuItem;
   miInvert: TMenuItem;
   miPrint: TMenuItem;
   miSettings: TMenuItem;
   miResClip: TMenuItem;
   miResExp: TMenuItem;
   miYToFile: TMenuItem;
   miYToClip: TMenuItem;
   miXToFile: TMenuItem;
   miXToClip: TMenuItem;
   pmiCopytoFile: TMenuItem;
   pmiCopyClip: TMenuItem;
   miQuitEdit: TMenuItem;
   miProtocol: TMenuItem;
   miSaveP: TMenuItem;
   miEditP: TMenuItem;
   miContents: TMenuItem;
   miAbout: TMenuItem;
   miHelp: TMenuItem;
   miExportY: TMenuItem;
   miExportX: TMenuItem;
   miExport: TMenuItem;
   Panel8: TPanel;
   pmContext: TPopupMenu;
   SaveDialog: TSaveDialog;
   sbSaveP: TSpeedButton;
   sbAddP: TSpeedButton;
   sbDelP: TSpeedButton;
   sbExitP: TSpeedButton;
   StatusBar: TStatusBar;
   StatusMessages: TStringList;
   sgResults: TStringGrid;
   ToolBar: TToolBar;
   tbOpen: TToolButton;
   ToolBarExit: TToolBar;
   ToolButton1: TToolButton;
   tbInvert: TToolButton;
   tbNormCax: TToolButton;
   tbNormMax: TToolButton;
   tbCentre: TToolButton;
   ToolButton2: TToolButton;
   tbPDF: TToolButton;
   tbExit: TToolButton;
   tbSettings: TToolButton;
   tbShowParams: TToolButton;
   ToolButton3: TToolButton;
   YProfile: TLineSeries;
   XProfile: TLineSeries;
   cYProf: TLabel;
   cResults: TLabel;
   cYProfile: TChart;
   DTrackBar: TDTrackBar;
   iBeam: TImage;
   Label1: TLabel;
   Label2: TLabel;
   Label3: TLabel;
   Label4: TLabel;
   Label5: TLabel;
   Label6: TLabel;
   cImage: TLabel;
   lMin: TLabel;
   Label8: TLabel;
   MainMenu: TMainMenu;
   miRestore: TMenuItem;
   miResults: TMenuItem;
   miYProfile: TMenuItem;
   miXProfile: TMenuItem;
   miImage: TMenuItem;
   Panel4: TPanel;
   Panel5: TPanel;
   Panel6: TPanel;
   Panel7: TPanel;
   pMaxMin: TPanel;
   pResults: TPanel;
   pYProfile: TPanel;
   Panel2: TPanel;
   pBeam: TPanel;
   pXProfile: TPanel;
   Panel3: TPanel;
   sbXMax: TSpeedButton;
   sbYMax: TSpeedButton;
   sbIMin: TSpeedButton;
   sbRMax: TSpeedButton;
   sbYMin: TSpeedButton;
   sbXMin: TSpeedButton;
   sbRMin: TSpeedButton;
   seXAngle: TSpinEdit;
   seXOffset: TSpinEdit;
   seXWidth: TSpinEdit;
   seYAngle: TSpinEdit;
   seYOffset: TSpinEdit;
   seYWidth: TSpinEdit;
   sbIMax: TSpeedButton;
   Window: TMenuItem;
   miExit: TMenuItem;
   miOpen: TMenuItem;
   miFile: TMenuItem;
   OpenDialog: TOpenDialog;
   procedure bbAddLClick(Sender: TObject);
   procedure bbDelLClick(Sender: TObject);
   procedure bbExitPClick(Sender: TObject);
   procedure bbSavePClick(Sender: TObject);
   procedure cbProtocolChange(Sender: TObject);
   procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
   procedure miInvertClick(Sender: TObject);
   procedure miResClipClick(Sender: TObject);
   procedure pmContextPopup(Sender: TObject);
   procedure pmiCopyClipClick(Sender: TObject);
   procedure pmiCopytoFileClick(Sender: TObject);
   procedure sbPDFClick(Sender: TObject);
   procedure StatusBarDrawPanel(SBar: TStatusBar;Panel: TStatusPanel; const Rect: TRect);
   procedure HandleBSError(BSError:EBSError);
   procedure BSErrorMsg(sError:string);
   procedure BSWarning(sWarning:string);
   procedure BSMessage(sMess:string);
   procedure ClearStatus;
   procedure Display(BMax,Bmin:integer);
   procedure ChartToolsetXDataPointHintToolHint(ATool: TDataPointHintTool;
      const APoint: TPoint; var AHint: String);
   procedure ChartToolsetYDataPointHintToolHint(ATool: TDataPointHintTool;
      const APoint: TPoint; var AHint: String);
   procedure DTrackBarChange(Sender: TObject);
   procedure DTrackBarClick(Sender: TObject);
   procedure BuildProtocolList;
   procedure LoadProtocol;
   procedure FormCreate(Sender: TObject);
   function FormHelp(Command: Word; Data: PtrInt; var CallHelp: Boolean): Boolean;
   procedure FormResize(Sender: TObject);
   procedure iBeamClick(Sender: TObject);
   procedure miEditPClick(Sender: TObject);
   procedure sbCentreClick(Sender: TObject);
   procedure sbMaxNormClick(Sender: TObject);
   procedure miExitClick(Sender: TObject);
   procedure miExportXClick(Sender: TObject);
   procedure miExportYClick(Sender: TObject);
   procedure miXClipBClick(Sender: TObject);
   procedure miYClipBClick(Sender: TObject);
   procedure SaveAs(Sender:TObject; ProfileArr:TSingleProfile);
   procedure miOpenClick(Sender: TObject);
   procedure miRestoreClick(Sender: TObject);
   procedure miAboutClick(Sender: TObject);
   procedure miContentsClick(Sender: TObject);
   procedure sbIMinClick(Sender: TObject);
   procedure sbInvertClick(Sender: TObject);
   procedure sbNormClick(Sender: TObject);
   procedure sbRMaxClick(Sender: TObject);
   procedure sbRMinClick(Sender: TObject);
   procedure sbXMaxClick(Sender: TObject);
   procedure sbXMinClick(Sender: TObject);
   procedure sbYMaxClick(Sender: TObject);
   procedure sbYMinClick(Sender: TObject);
   procedure seYAngleChange(Sender: TObject);
   procedure seXAngleChange(Sender: TObject);
   procedure sbIMaxClick(Sender: TObject);
   procedure Show1DResults(ProfileArr:TSingleProfile; Col:integer);
   procedure Show2DResults(BeamArr:TBeam);
   procedure tbSettingsClick(Sender: TObject);
   procedure tbShowParamsClick(Sender: TObject);
 private
    { private declarations }
 public
    { public declarations }
   FileHandler: TFileHandler;
   CGIHandler: TCGIHandler;
   PHPCGIHandler: TPHPFastCGIHandler;
   end;

var
    BSForm       :TBSForm;
    sProtPath    :string;
    Safe,
    Editing      :boolean;
    Normalisation:TNorm;

implementation

uses math, StrUtils, helpintfs, aboutunit, importunit, settingsunit,
     LazFileUtils, form2pdf, param1Dfuncs, param2Dfuncs;

{ TBSForm }

procedure TBSForm.StatusBarDrawPanel(SBar: TStatusBar;Panel: TStatusPanel;
   const Rect: TRect);
begin
with SBar.Canvas do
   begin
   Brush.Color := StatusBar.Color;
   FillRect(Rect);
   TextRect(Rect,2 + Rect.Left, 1 + Rect.Top,Panel.Text) ;
   end;
end;


procedure TBSForm.HandleBSError(BSError:EBSError);
begin
case BSError.EType of
   Message:BSMEssage(BSError.Message);
   Warning:BSWarning(BSError.Message);
   Error  :BSErrorMsg(BSError.Message);
   end; {of case}
end;


procedure TBSForm.BSErrorMsg(sError:string);
begin
StatusBar.SimpleText := sError;
StatusBar.Color := FaintRed;
StatusMessages.Add(StatusBar.SimpleText);
StatusBar.Hint := StatusMessages.Text;
end;


procedure TBSForm.BSWarning(sWarning:string);
begin
StatusBar.SimpleText := sWarning;
StatusBar.Color := FaintYellow;
StatusMessages.Add(StatusBar.SimpleText);
StatusBar.Hint := StatusMessages.Text;
end;


procedure TBSForm.BSMessage(sMess:string);
begin
StatusBar.SimpleText := sMess;
StatusBar.Color := FaintGreen;
StatusMessages.Add(StatusBar.SimpleText);
StatusBar.Hint := StatusMessages.Text;
end;


procedure TBSForm.ClearStatus;
begin
StatusBar.SimpleText := '';
StatusBar.Color := clDefault;
end;


procedure TBSForm.miExitClick(Sender: TObject);
begin
Close;
end;


procedure TBSForm.SaveAs(Sender:TObject; ProfileArr:TSingleProfile);
{Saves the profile data as a comma delimited text file}
var Outfile:   textfile;
begin
SaveDialog.Title := 'Export profile as';
{$ifdef WINDOWS}
SaveDialog.Filter := 'Text files|*.txt|All files|*.*';
{$else}
SaveDialog.Filter := 'Text files|*.txt|All files|*';
{$endif}
SaveDialog.InitialDir := OpenDialog.InitialDir;
SaveDialog.DefaultExt := '.txt';
SaveDialog.FileName := ExtractFileNameOnly(OpenDialog.FileName);
if ProfileArr <> nil then
   if SaveDialog.Execute then
      begin
      AssignFile(Outfile,SaveDialog.FileName);
      Rewrite(Outfile);
      write(Outfile,ProfileArr.ToText);
      CloseFile(Outfile);
      end;
end;


procedure TBSForm.miExportXClick(Sender: TObject);
{Saves the file as a comma delimited string}
begin
SaveAs(Sender,XPArr);
end;


procedure TBSForm.miExportYClick(Sender: TObject);
{Saves the file as a comma delimited string}
begin
SaveAs(Sender,YPArr);
end;


procedure TBSForm.miXClipBClick(Sender: TObject);
{put the array in a comma delimited string on the clipboard}
begin
if XPArr <> nil then Clipboard.AsText := XPArr.ToText;
end;


procedure TBSForm.miYClipBClick(Sender: TObject);
{put the array in a comma delimited string on the clipboard}
begin
if YPArr <> nil then Clipboard.AsText := YPArr.ToText;
end;


procedure TBSForm.miResClipClick(Sender: TObject);
begin
sgResults.CopyToClipboard(false);
end;


procedure TBSForm.pmContextPopup(Sender: TObject);
begin
if pmContext.PopupComponent = pResults then
   begin
   pmiCopyToFile.Enabled := false;
   pmicopyToFile.Visible := false;
   end
  else
   begin
   pmiCopyToFile.Enabled := true;
   pmicopyToFile.Visible := true;
   end;
end;


procedure TBSForm.pmiCopyClipClick(Sender: TObject);
begin
if pmContext.PopupComponent = pXProfile then miXClipBClick(Sender);
if pmContext.PopupComponent = pYProfile then miYClipBClick(Sender);
if pmContext.PopupComponent = pResults then miResClipClick(Sender);
end;


procedure TBSForm.pmiCopytoFileClick(Sender: TObject);
begin
if pmContext.PopupComponent = pXProfile then miExportXClick(Sender);
if pmContext.PopupComponent = pYProfile then miExportYClick(Sender);
end;


procedure TBSForm.bbSavePClick(Sender: TObject);
var I          :integer;
    ProtName,                  {protocol name}
    ProtPath   :string;        {protocol file path}

begin
ClearStatus;
ProtName := cbProtocol.Text;
if ProtName <> '' then
   begin
   SaveDialog.Title := 'Save parameters';
   {$ifdef WINDOWS}
   ProtPath := GetAppConfigDir(true);
   SaveDialog.Filter := 'Comma delimited files|*.csv|All files|*.*';
   {$else}
   ProtPath := GetAppConfigDir(false);
   SaveDialog.Filter := 'Comma delimited files|*.csv|All files|*';
   {$endif}
   if not DirectoryExists(ProtPath) then CreateDir(ProtPath);
   SaveDialog.DefaultExt := '.csv';
   SaveDialog.FileName := AppendPathDelim(ProtPath) + DelSpace(ProtName) + '.csv';

   for I:=1 to sgResults.Rowcount-1 do
      begin
      sgResults.Cells[2,I] := '';
      sgResults.Cells[3,I] := '';
      end;

   if SaveDialog.Execute then
      begin
         try;
         sgResults.SaveToCSVFile(SaveDialog.FileName,',',false);
         except
         on E:Exception do
            BSErrorMsg('Could not save protocol.');
         end;
      cbProtocol.Style := csDropDownList;
      sbSaveP.Enabled := false;
      sbSaveP.Visible := false;
      miSaveP.Enabled := false;
      miEditP.Enabled := true;
      miQuitEdit.Enabled := false;
      sbAddP.Enabled := false;
      sbAddP.Visible := false;
      sbDelP.Enabled := false;
      sbDelP.Visible := false;
      sbExitP.Enabled := false;
      sbExitP.Visible := false;
      CResults.Caption := 'Results';
      sgResults.Columns.Items[1].Visible := false;
      sgResults.Columns.Items[2].Visible := true;
      sgResults.Columns.Items[3].Visible := true;
      sgResults.Options := sgResults.Options - [goEditing];
      BuildProtocolList;
      if cbProtocol.Items.IndexOf(ProtName) >= 0 then
            cbProtocol.ItemIndex := cbProtocol.Items.IndexOf(ProtName);
      LoadProtocol;
      Show2DResults(Beam);
      seXAngleChange(Self);
      seYAngleChange(Self);
      Editing := false;
      end;
   end
  else
   BSWarning('Please define a protocol name.');
end;


procedure TBSForm.cbProtocolChange(Sender: TObject);
begin
ClearStatus;
LoadProtocol;
Show2DResults(Beam);
seXAngleChange(Self);
seYAngleChange(Self);
end;


procedure TBSForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
SaveSettings('BSSettings');
FileHandler.Free;
CGIHandler.Free;
PHPCGIHandler.Free;
StatusMessages.Free;
end;


procedure TBSForm.miInvertClick(Sender: TObject);
begin
tbInvert.Down := miInvert.Checked;
sbInvertClick(Sender)
end;


procedure TBSForm.sbPDFClick(Sender: TObject);
begin
SaveDialog.Title := 'Save PDF as';
{$ifdef WINDOWS}
SaveDialog.Filter := 'PDF files|*.pdf|All files|*.*';
{$else}
SaveDialog.Filter := 'PDF files|*.pdf|All files|*';
{$endif}
SaveDialog.InitialDir := OpenDialog.InitialDir;
SaveDialog.DefaultExt := '.pdf';
SaveDialog.FileName := ExtractFileNameOnly(OpenDialog.FileName) + '.pdf';
if SaveDialog.Execute then
   BSMessage(IntToStr(FormToPDF(BSForm,SaveDialog.FileName)) + ' objects printed to PDF');
end;


procedure TBSForm.bbExitPClick(Sender: TObject);
begin
ClearStatus;
cbProtocol.Style := csDropDownList;
sbSaveP.Enabled := false;
sbSaveP.Visible := false;
miSaveP.Enabled := false;
miEditP.Enabled := true;
miQuitEdit.Enabled := false;
sbAddP.Enabled := false;
sbAddP.Visible := false;
sbDelP.Enabled := false;
sbDelP.Visible := false;
sbExitP.Enabled := false;
sbExitP.Visible := false;
cResults.Caption := 'Results';
sgResults.Columns.Items[1].Visible := false;
sgResults.Columns.Items[2].Visible := true;
sgResults.Columns.Items[3].Visible := true;
sgResults.Options := sgResults.Options - [goEditing];
Editing := false;
LoadProtocol;                  {reload to wipe changes}
Show2DResults(Beam);
seXAngleChange(Self);
seYAngleChange(Self);
end;


procedure TBSForm.bbAddLClick(Sender: TObject);
begin
if sgResults.Row >= 0 then sgResults.InsertRowWithValues(sgResults.Row,['','','','']);
end;


procedure TBSForm.bbDelLClick(Sender: TObject);
begin
if sgResults.Row >= 0 then sgResults.DeleteRow(sgResults.Row);
end;


procedure TBSForm.BuildProtocolList;
var sExePath,
    sSearchPath,
    FileName   :string;
    ProtList   :TStringList;
    SearchRec  :TSearchRec;

begin
{look for parameter definition files and make list}
sExePath := ExtractFilePath(Application.ExeName);
sProtPath := AppendPathDelim(sExePath) + 'Protocols';
sSearchPath := AppendPathDelim(sProtPath) + '*.csv';
cbProtocol.Clear;
ProtList := TStringList.Create;
if FindFirst(sSearchPath,0,SearchRec) = 0 then
   begin
      repeat
      FileName := ExtractFileNameOnly(SearchRec.Name);
      ProtList.Add(Filename);
      until FindNext(Searchrec) <> 0;
   ProtList.Sort;
   cbProtocol.Items.Assign(ProtList);
   cbProtocol.ItemIndex := 0;
   end
  else
   begin
   {$ifdef WINDOWS}
   sProtPath := GetAppConfigDir(true);
   {$else}
   sProtPath := GetAppConfigDir(false);
   {$endif}
   sProtPath := AppendPathDelim(sProtPath) + 'Protocols';
   sSearchPath := AppendPathDelim(sProtPath) + '*.csv';
   if FindFirst(sSearchPath,0,SearchRec) = 0 then
      begin
        repeat
         FileName := ExtractFileNameOnly(SearchRec.Name);
         ProtList.Add(Filename);
         until FindNext(Searchrec) <> 0;
      ProtList.Sort;
      cbProtocol.Items.Assign(ProtList);
      cbProtocol.ItemIndex := 0;
      end
     else BSErrorMsg('No protocol definition files found. Please create a file.');
   end;
   Findclose(SearchRec);
ProtList.Free;
if cbProtocol.Items.Count > 0 then
   cbProtocol.ItemIndex := cbProtocol.Items.IndexOf('Default');
end;


procedure TBSForm.LoadProtocol;
var FileName   :string;
begin
if (cbProtocol.Items.Count > 0) and not Editing then
   begin
   FileName := AppendPathDelim(sProtPath) + cbProtocol.Items[cbProtocol.ItemIndex] + '.csv';
   try
      sgResults.LoadFromCSVFile(FileName,',',false);
   except
      on E:Exception do
         BSErrorMsg('Could not load protocol file');
      end;
   sgResults.Columns.Items[1].Width := 190;
   end;
end;


procedure TBSForm.FormCreate(Sender: TObject);
var sExePath   :string;

begin
BSForm.Caption := 'Beam Scheme v' + GetAppVersionString(false,2);
LoadSettings('BSSettings');
StatusMessages := TStringList.Create;

{Set directory path to program files}
sExePath := ExtractFilePath(Application.ExeName);
SetCurrentDir(sExePath);

{start web server for online help}
FileHandler := TFileHandler.Create;
FileHandler.MimeTypeFile := sExePath + 'html' + DirectorySeparator + 'mime.types';
FileHandler.DocumentRoot := sExePath + 'html';

CGIHandler := TCGIHandler.Create;
CGIHandler.FCGIRoot := sExePath + 'html' + DirectorySeparator + 'cgi-bin';
CGIHandler.FDocumentRoot := sExePath + 'html' + DirectorySeparator + 'cgi-bin';
CGIHandler.FEnvPath := sExePath + 'html' + DirectorySeparator + 'cgi-bin';
CGIHandler.FScriptPathPrefix := 'cgi-bin' + DirectorySeparator;

PHPCGIHandler := TPHPFastCGIHandler.Create;
PHPCGIHandler.Host := 'localhost';
PHPCGIHandler.Port := 4665;
PHPCGIHandler.AppEnv := 'PHP_FCGI_CHILDREN=5:PHP_FCGI_MAX_REQUESTS=10000';
PHPCGIHandler.AppName := 'php-cgi.exe';
PHPCGIHandler.EnvPath := sExePath + 'html' + DirectorySeparator + 'cgi-bin';

HelpServer.RegisterHandler(FileHandler);
HelpServer.RegisterHandler(CGIHandler);

FileHandler.DirIndexList.Add('BSHelp.html');
FileHandler.DirIndexList.Add('index.htm');
FileHandler.DirIndexList.Add('index.php');
FileHandler.DirIndexList.Add('index.cgi');
FileHandler.RegisterHandler(PHPCGIHandler);

BuildProtocolList;
LoadProtocol;

if not HelpServer.Listen(3880) then
   begin
   BSMessage('Error starting help server. Online help may not be available. ');
   end;
end;


function TBSForm.FormHelp(Command: Word; Data: PtrInt; var CallHelp: Boolean): Boolean;
var Ctrl:      TControl;
begin
Ctrl := Application.GetControlAtMouse;
if Ctrl.HelpKeyword <> '' then
   ShowHelpOrErrorForKeyword('',Ctrl.HelpKeyword)
  else
   ShowHelpOrErrorForKeyword('','HTML/BSHelp.html');
Result := true;
end;


procedure TBSForm.DTrackBarChange(Sender: TObject);
begin
if Safe then
   begin
   DTrackBar.Invalidate;
   Beam.Display(iBeam.Picture.BitMap,DTrackBar.PositionU,DTrackBar.PositionL);
   XPArr.Show(iBeam.Picture.Bitmap);
   YPArr.Show(iBeam.Picture.Bitmap);
   end;
end;

procedure TBSForm.DTrackBarClick(Sender: TObject);
begin
if Safe then
   begin
   seXAngleChange(Self);
   seYAngleChange(Self);
   end;
end;


procedure TBSForm.ChartToolsetXDataPointHintToolHint(ATool: TDataPointHintTool;
   const APoint: TPoint; var AHint: String);
begin
AHint := '(' +
   FloatToStrF(TLineSeries(ATool.Series).Source.Item[ATool.PointIndex]^.X,ffFixed,7,1) + ',' +
   FloatToStrF(TLineSeries(ATool.Series).Source.Item[ATool.PointIndex]^.Y,ffFixed,7,1) + ')';
end;

procedure TBSForm.ChartToolsetYDataPointHintToolHint(ATool: TDataPointHintTool;
   const APoint: TPoint; var AHint: String);
begin
AHint := '(' +
   FloatToStrF(TLineSeries(ATool.Series).Source.Item[ATool.PointIndex]^.X,ffFixed,7,1) + ',' +
   FloatToStrF(TLineSeries(ATool.Series).Source.Item[ATool.PointIndex]^.Y,ffFixed,7,1) + ')';
end;


procedure TBSForm.Display(BMax,BMin:integer);
begin
if Length(Beam.Data) > 0 then
   begin
   Beam.Display(iBeam.Picture.Bitmap,BMax,BMin);
   if ShowParams and (Length(Beam.IFA.Data) > 0) then Beam.DisplayIFA(iBeam.Picture.Bitmap);
   Show2DResults(Beam);
   seXAngleChange(Self);
   seYAngleChange(Self);
   end
  else
   BSErrorMsg('No file open!');
end;


procedure TBSForm.miOpenClick(Sender: TObject);
var I,
    BMax,                      {integer version of beam max}
    BMin       :integer;       {integer version of beam min}
    Dummy      :string;
    DataOK     :boolean;

begin
Safe := false;
Dummy := '';
Beam.Reset;
XPArr.ResetCoords;
YPArr.ResetCoords;
iBeam.Picture.Clear;
XProfile.Clear;
YProfile.Clear;
for I:=1 to sgResults.Rowcount-1 do
   begin
   sgResults.Cells[2,I] := '';
   sgResults.Cells[3,I] := '';
   end;
DataOK := false;

with OpenDialog do
   begin
   DefaultExt := '.dcm';
   {$IFDEF WINDOWS}
   Filter := 'DICOM Image|*.dcm|MapCheck Text Files|*.txt|PTW|*.mcc|IBA|*.opg|Windows bitmap|*.bmp|Tiff bitmap|*.tif|JPEG image|*.jpg|HIS image|*.his|All Files|*.*';
   {$ELSE}
   Filter := 'DICOM Image|*.dcm|MapCheck, XIO, RAW Text Files|*.txt|PTW|*.mcc|IBA|*.opg|Windows bitmap|*.bmp|Tiff bitmap|*.tif;*.tiff|JPEG image|*.jpg;*jpeg|HIS image|*.his|All Files|*';
   {$ENDIF}
   Title := 'Open image file';
   end;
if OpenDialog.Execute then
   begin
   try
   Dummy := Upcase(ExtractFileExt(OpenDialog.Filename));
   if Dummy = '.DCM' then
      DataOK := DICOMOpen(OpenDialog.Filename,Beam);
   if (not DataOK) and (Dummy = '.OPG') then
      DataOK := IBAOpen(OpenDialog.Filename,Beam);
   if (not DataOK) and (Dummy = '.MCC') then
      DataOK := PTWOpen(OpenDialog.Filename,Beam);
   if (not DataOK) and (Dummy = '.HIS') then
      DataOK := HISOpen(OpenDialog.Filename,Beam);
   if (not DataOK) and (Dummy = '.BMP') then
      DataOK := BMPOpen(OpenDialog.Filename,Beam);
   if (not DataOK) and ((Dummy = '.TIF') or (Dummy = '.TIFF')) then
      DataOK := BMPOpen(OpenDialog.Filename,Beam);
   if (not DataOK) and ((Dummy = '.JPG') or (Dummy = '.JPEG')) then
      DataOK := BMPOpen(OpenDialog.Filename,Beam);
   if (not DataOK) and (Dummy = '.ALL') then
      DataOK := XiOOpen(OpenDialog.Filename,Beam);
   if not DataOK and ((Dummy = '.TXT') or (Dummy = '')) then {assume file is text}
      DataOK := TextOpen(OpenDialog.Filename,Beam);

   {set limits}
   if DataOK then
      begin
      if Beam.XRes = 0 then Beam.XRes := DefaultRes;
      if Beam.YRes = 0 then Beam.YRes := DefaultRes;
      seXAngle.MaxValue := round(arctan(Beam.Rows/Beam.Cols)*180/pi);
      seXAngle.MinValue := -seXAngle.MaxValue;
      seXAngle.Value := 0;
      seXOffset.MaxValue := Beam.Rows div 2;
      if odd(Beam.Rows) then
         seXOffset.MinValue := -(Beam.Rows div 2)
        else
         seXOffset.MinValue := -(Beam.Rows div 2) + 1;
      seXOffset.Value := 0;
      seXWidth.MaxValue := (Beam.Rows);
      seXWidth.Value := 1;
      seYAngle.MaxValue := 180 - seXAngle.MaxValue;
      seYAngle.MinValue := seXAngle.MaxValue + 1;
      seYAngle.Value := 90;
      if odd(Beam.Cols) then
         seYOffset.MaxValue := (Beam.Cols) div 2
        else
        seYOffset.MaxValue := (Beam.Cols) div 2 - 1;
      seYOffset.MinValue := -((Beam.Cols) div 2);
      seYOffset.Value := 0;
      seYWidth.MaxValue := Beam.Cols;
      seYWidth.Value := 1;
      BMin := round(Beam.Min);
      BMax := round(Beam.Max);
      DTrackBar.Max := BMax;
      DTrackBar.Min := BMin;
      DTrackBar.PositionU:= BMax;
      DTrackBar.PositionL := BMin;
      DTrackBar.LargeChange := (BMax - BMin) div 20;
      DTrackBar.SmallChange := (BMax - BMin) div 100;
      DTrackBar.TickInterval := (BMax - BMin) div 20;
      Beam.Norm := Normalisation;

      {display beam}
      Safe := true;
      ClearStatus;
      Display(BMax,BMin);
      Dummy := OpenDialog.FileName;
      cImage.Hint := Dummy;
      cImage.ShowHint := True;
      I := cImage.Canvas.TextWidth(Dummy);
      if I >= cImage.Width then
         Dummy := leftStr(Dummy, round(Length(Dummy)*cImage.Width/(2*I) - 1)) + '...'
            + RightStr(Dummy, round(Length(Dummy)*cImage.Width/(2*I) - 1));
      cImage.Caption := Dummy;
      end
   except
      on BSError:EBSError do HandleBSError(BSError);
      end;
   end;
end;


procedure TBSForm.FormResize(Sender: TObject);
begin
miRestoreClick(Sender);
end;


procedure TBSForm.iBeamClick(Sender: TObject);
var MouseXY:   TPoint;
    BMPH,                      {Bitmap height}
    BMPW:      integer;        {Bitmap width}
    PX,
    PY,
    R,
    Theta,
    Phi,
    Scale,
    AR:        double;         {Aspect ratio}

begin
if iBeam.Picture.Bitmap.Height > 0 then
   begin
   MouseXY := iBeam.ScreenToControl(Mouse.CursorPos);
   BMPH := iBeam.Picture.Bitmap.Height;
   BMPW := iBeam.Picture.Bitmap.Width;
   AR := BMPW/BMPH;
   if iBeam.Height <= iBeam.Width then
      Scale := iBeam.Height
     else
      Scale := iBeam.Width;

   if AR >= 1 then
      begin
      PY := (Beam.Rows div 2) - MouseXY.Y*(Beam.Rows/Scale)*AR;
      PX := MouseXY.X*((Beam.Cols)/Scale) - ((Beam.Cols) div 2);
      end
     else
      begin
      PY := (Beam.Rows div 2) - MouseXY.Y*(Beam.Rows/Scale);
      PX := MouseXY.X*((Beam.Cols)/Scale)/AR - ((Beam.Cols) div 2);
      end;

   R := sqrt(PX*PX + PY*PY);
   Theta := arctan2(PX,PY);

   Phi := seXAngle.Value*2*PI/360;
   seXOffset.Value := R*cos(Theta - Phi);

   Phi := seYAngle.Value*2*PI/360;
   seYOffset.Value := R*cos(Theta - Phi);
   end;
end;


procedure TBSForm.miEditPClick(Sender: TObject);
begin
Editing := true;
cbProtocol.Style := csDropDown;
cbProtocol.Text := cbProtocol.Items[cbProtocol.ItemIndex];
sbSaveP.Enabled := true;
sbSaveP.Visible := true;
miSaveP.Enabled := true;
miEditP.Enabled := false;
miQuitEdit.Enabled := true;
sbAddP.Enabled := true;
sbAddP.Visible := true;
sbDelP.Enabled := true;
sbDelP.Visible := true;
sbExitP.Enabled := true;
sbExitP.Visible := true;
cResults.Caption := 'Edit protocol';
sgResults.Columns.Items[1].Visible := true;
sgResults.Columns.Items[2].Visible := false;
sgResults.Columns.Items[3].Visible := false;
sgResults.Options := sgResults.Options + [goEditing];
end;


procedure TBSForm.miAboutClick(Sender: TObject);
begin
AboutForm := TAboutForm.Create(Self);
AboutForm.ShowModal;
AboutForm.Free;
end;


procedure TBSForm.miContentsClick(Sender: TObject);
begin
ShowHelpOrErrorForKeyword('','HTML/BSHelp.html');
end;


procedure TBSForm.miRestoreClick(Sender: TObject);
begin
ToolbarExit.Left := Width - 86;
sbIMinClick(Sender);
sbXMinClick(Sender);
sbYMinClick(Sender);
sbRMinClick(Sender);
end;


procedure TBSForm.sbInvertClick(Sender: TObject);
{Invert and rescale}
begin
miInvert.Checked := tbInvert.Down;
XPArr.ResetCoords;
YPArr.ResetCoords;
Beam.Invert;
Display(DTrackBar.PositionU,DTrackBar.PositionL);
end;


procedure TBSForm.sbNormClick(Sender: TObject);
begin
XPArr.ResetCoords;
YPArr.ResetCoords;
if tbNormCax.Down then
   begin
   Normalisation := norm_cax;
   DTrackBar.Max := round(Beam.Centre);
   DTrackBar.PositionU := round(Beam.Centre);
   end
  else
   begin
   Normalisation := no_norm;
   DTrackBar.Max := round(Beam.Max);
   DTrackBar.PositionU := round(Beam.Max);
   end;
Beam.Norm := Normalisation;
Display(DTrackBar.PositionU,DTrackBar.PositionL);
end;


procedure TBSForm.sbMaxNormClick(Sender: TObject);
begin
XPArr.ResetCoords;
YPArr.ResetCoords;
if tbNormMax.Down then
   begin
   Normalisation := norm_max;
   DTrackBar.Max := round(Beam.Max);
   DTrackBar.PositionU := round(Beam.Max);
   end
else
   begin
   Normalisation := no_norm;
   DTrackBar.Max := round(Beam.Max);
   DTrackBar.PositionU := round(Beam.Max);
   end;
Beam.Norm := Normalisation;
Display(DTrackBar.PositionU,DTrackBar.PositionL);
end;


procedure TBSForm.sbCentreClick(Sender: TObject);
{Put CoM at centre of image. Resamples the data using bi-linear interpolation}
begin
XPArr.ResetCoords;
YPArr.ResetCoords;
if Length(Beam.Data) > 0 then Beam.CentreData
   else BSErrorMsg('No file open!');
Display(DTrackBar.PositionU,DTrackBar.PositionL);
end;


procedure TBSForm.sbIMaxClick(Sender: TObject);
var I          :integer;
    Dummy      :string;
begin
pBeam.Height := ClientHeight - 65;
pBeam.Width := ClientWidth;
pBeam.BringToFront;
sbIMax.Enabled := False;
sbIMax.Visible := False;
sbIMin.Left := pBeam.Width - 30;
cImage.Width := pBeam.Width - 32;
sbIMin.Enabled := True;
sbIMin.Visible := True;
lMin.Top := pMaxMin.Height - 20;
DTrackbar.Height := pMaxMin.Height - 40;
Dummy := cImage.Hint;
I := cImage.Canvas.TextWidth(Dummy);
if I >= cImage.Width then
   Dummy := leftStr(Dummy, round(Length(Dummy)*cImage.Width/(2*I) - 1)) + '...'
      + RightStr(Dummy, round(Length(Dummy)*cImage.Width/(2*I) - 1));
cImage.Caption := Dummy;
pXProfile.Hide;
pYProfile.Hide;
PResults.Hide;
end;


procedure TBSForm.sbIMinClick(Sender: TObject);
var I          :integer;
    Dummy      :string;
begin
pBeam.Height := (BSForm.ClientHeight - 65) div 2 - 1;
pBeam.Width := BSForm.ClientWidth div 2 - 1;
pBeam.SendToBack;
sbIMax.Left := pBeam.Width - 30;
sbIMax.Enabled := true;
sbIMax.Visible := true;
sbIMin.Left := pBeam.Width - 30;
cImage.Width := pBeam.Width - 32;
sbIMin.Enabled := false;
sbIMin.Visible := false;
pMaxMin.Height := pBeam.Height - 20;
lMin.Top := pMaxMin.Height - 20;
DTrackbar.Height := pMaxMin.Height - 40;
Dummy := cImage.Hint;
I := cImage.Canvas.TextWidth(Dummy);
if I >= cImage.Width then
   Dummy := leftStr(Dummy, round(Length(Dummy)*cImage.Width/(2*I) - 1)) + '...'
      + RightStr(Dummy, round(Length(Dummy)*cImage.Width/(2*I) - 1));
cImage.Caption := Dummy;
pXProfile.Show;
pYProfile.Show;
pResults.Show;
end;


procedure TBSForm.sbRMaxClick(Sender: TObject);
begin
pResults.Height := ClientHeight - 65;
pResults.Width := ClientWidth;
pResults.Left := 0;
pResults.Top := 42;
pResults.BringToFront;
sbRMax.Enabled := false;
sbRMax.Visible := false;
sbRMin.Left := pResults.Width - 30;
sbRMin.Enabled := true;
sbRMin.Visible := true;
pBeam.Hide;
pXProfile.Hide;
pYProfile.Hide;
end;

procedure TBSForm.sbRMinClick(Sender: TObject);
begin
pResults.Height := (ClientHeight - 65) div 2 - 1;
pResults.Width := ClientWidth div 2 - 1;
pResults.Left := ClientWidth div 2 - 1;
pResults.Top := (ClientHeight - 65) div 2 + 42;
pResults.SendToBack;
sbRMax.Left := pResults.Width - 30;
sbRMax.Enabled := true;
sbRMax.Visible := true;
sbRMin.Left := pResults.Width - 30;
sbRMin.Enabled := false;
sbRMin.Visible := false;
pBeam.Show;
pXProfile.Show;
pYProfile.Show;
end;


procedure TBSForm.sbXMaxClick(Sender: TObject);
begin
pXProfile.Height := ClientHeight - 65;
pXProfile.Width := ClientWidth;
pXProfile.Left := 0;
pXProfile.Top := 42;
pXProfile.BringToFront;
sbXMax.Enabled := false;
sbXMax.Visible := false;
sbXMin.Left := pXProfile.Width - 30;
sbXMin.Enabled := true;
sbXMin.Visible := true;
pBeam.Hide;
pYProfile.Hide;
pResults.Hide;
end;


procedure TBSForm.sbXMinClick(Sender: TObject);
begin
pXProfile.Height := (BSForm.ClientHeight - 65) div 2 - 1;
pXProfile.Width := BSForm.ClientWidth div 2 - 1;
pXProfile.Left := BSForm.ClientWidth div 2 - 1;
pXProfile.Top := 42;
pXProfile.SendToBack;
sbXMax.Left := pXProfile.Width - 30;
sbXMax.Enabled := true;
sbXMax.Visible := true;
sbXMin.Left := pXProfile.Width - 30;
sbXMin.Enabled := false;
sbXMin.Visible := false;
pBeam.Show;
pYProfile.Show;
PResults.Show;
end;

procedure TBSForm.sbYMaxClick(Sender: TObject);
begin
pYProfile.Height := ClientHeight - 65;
pYProfile.Width := ClientWidth;
pYProfile.Top := 42;
pYProfile.BringToFront;
sbYMax.Enabled := false;
sbYMax.Visible := false;
sbYMin.Left := pYProfile.Width - 30;
sbYMin.Enabled := true;
sbYMin.Visible := true;
pBeam.Hide;
pXProfile.Hide;
pResults.Hide;
end;


procedure TBSForm.sbYMinClick(Sender: TObject);
begin
pYProfile.Height := (BSForm.ClientHeight - 65) div 2 - 1;
pYProfile.Width := BSForm.ClientWidth div 2 - 1;
pYProfile.Top := (BSForm.ClientHeight - 65) div 2 + 42;
pYProfile.SendToBack;
sbYMax.Left := pYProfile.Width - 30;
sbYMax.Enabled := true;
sbYMax.Visible := true;
sbYMin.Left := pYProfile.Width - 30;
sbYMin.Enabled := false;
sbYMin.Visible := false;
pBeam.Show;
pXProfile.Show;
pResults.Show;
end;


procedure TBSForm.seYAngleChange(Sender: TObject);
begin
if Safe then
   begin
   Safe := false;
   ClearStatus;
   YPArr.sProt := cbProtocol.Text;
   if (iBeam.Picture.Bitmap <> nil) and (length(Beam.Data) <> 0) then
      begin
      YPArr.SetParams(seYAngle.Value,-seYOffset.Value,seYWidth.Value);
      YPArr.Draw(iBeam.Picture.Bitmap);
      Beam.CreateProfile(YPArr,DTrackBar.PositionU,DTrackBar.PositionL);
      YPArr.ToSeries(YProfile);
      Show1DResults(YPArr,3);
      end;
   Safe := true;
   end;
end;


procedure TBSForm.seXAngleChange(Sender: TObject);
var StartTime,
    EndTime    :integer;

begin
if Safe then
   begin
   Safe := false;
   ClearStatus;
   XPArr.sProt := cbProtocol.Text;
   if (iBeam.Picture.Bitmap <> nil) and (length(Beam.Data) <> 0) then
      begin
      StartTime := GetTickCount64;
      XPArr.SetParams(seXAngle.Value,-seXOffset.Value,seXWidth.Value);
      XPArr.Draw(iBeam.Picture.Bitmap);
      Beam.CreateProfile(XPArr,DTrackBar.PositionU,DTrackBar.PositionL);
      XPArr.ToSeries(XProfile);
      Show1DResults(XPArr,2);
      EndTime := GetTickCount64 - StartTime;
      StatusBar.SimpleText := 'Parameters calculated in ' + IntToStr(EndTime) + ' ms.';
      end;
   Safe := true;
   end;
end;


procedure TBSForm.Show1DResults(ProfileArr:TSingleProfile; Col:integer);
var I          :integer;
begin
{calc values and write to string grid}
if ProfileArr <> nil then
   for I:=1 to sgResults.RowCount-1 do
      begin
      ProfileArr.sExpr := sgResults.Cells[1,I];
      if ProfileArr.sExpr <> '' then
         begin
         if Leftstr(ProfileArr.sExpr,2) = '1D' then
            try
            sgResults.Cells[Col,I] := Calc1DParam(ProfileArr)
            except
            on E:Exception do BSErrorMsg('Could not evaluate expression, ' + ProfileArr.sExpr);
            end;
         end
        else sgResults.Cells[Col,I] := '';
      end;
   end;


procedure TBSForm.Show2DResults(BeamArr:TBeam);
var I          :integer;
    sExpr      :string;        {expression to calculate}

begin
{calc values and write to string grid}
if Length(BeamArr.Data) > 0 then
   for I:=1 to sgResults.RowCount-1 do
      begin
      sExpr := sgResults.Cells[1,I];
      if sExpr <> '' then
         begin
         if Leftstr(sExpr,2) = '2D' then
            try
            sgResults.Cells[2,I] := Calc2DParam(BeamArr,sExpr)
            except
            on E:Exception do BSErrorMsg('Could not evaluate expression, ' + sExpr);
            end;
         end
        else sgResults.Cells[2,I] := '';
      end;
end;


procedure TBSForm.tbSettingsClick(Sender: TObject);
begin
SettingsForm := TSettingsForm.Create(Self);
SettingsForm.ShowModal;
SettingsForm.Free;
BSWarning('Reload data to apply changed settings');
end;


procedure TBSForm.tbShowParamsClick(Sender: TObject);
begin
XPArr.ResetCoords;
YPArr.ResetCoords;
if tbShowParams.Down then
   ShowParams := True
  else
   ShowParams := False;
Display(DTrackBar.PositionU,DTrackBar.PositionL);
end;


initialization
  {$I bsunit.lrs}
Safe := true;
Editing := false;
Normalisation := no_norm;

end.

