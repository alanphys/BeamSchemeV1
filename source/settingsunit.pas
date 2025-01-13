unit settingsunit;
{Load, save and edit programme settings and defaults}

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
   ValEdit, Grids;

type

   { TSettingsForm }

   TSettingsForm = class(TForm)
      ImageList: TImageList;
      StatusBar: TStatusBar;
      StatusMessages: TStringList;
      ToolBarLeft: TToolBar;
      tbAdd: TToolButton;
      ToolBarRight: TToolBar;
      tbExit: TToolButton;
      vleSettings: TValueListEditor;
      procedure StatusBarDrawPanel(SBar: TStatusBar;Panel: TStatusPanel; const Rect: TRect);
      procedure SErrorMsg(sError:string);
      procedure SWarning(sWarning:string);
      procedure SMessage(sMess:string);
      procedure ClearStatus;
      procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
      procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure FormCreate(Sender: TObject);
      procedure tbAddClick(Sender: TObject);
      procedure tbExitClick(Sender: TObject);
   private

   public

   end;

function LoadSettings(FileName:string):boolean;
function SaveSettings(FileName:string):boolean;

var
   SettingsForm: TSettingsForm;
   RowsChanged : array of integer;

implementation

uses bstypes, laz2_XMLCfg, LazFileUtils, FileUtil;

function LoadSettings(FileName:string):boolean;
var cfg        :TXMLConfig;
    IFAVal     :TIFAType;
    CentreVal  :TCentre;
    CfgPath,
    FName,
    sTemp      :string;
begin
Result := false;
{look first for settings file in program dir}
CfgPath := ProgramDirectory;
FName := AppendPathDelim(CfgPath) + FileName + '.xml';
if not FileExists(FName) then
   {if nothing in program dir look in config dir}
   begin
   {$ifdef WINDOWS}
   CfgPath := GetAppConfigDir(true);
   {$else}
   CfgPath := GetAppConfigDir(false);
   {$endif}
   FName := AppendPathDelim(CfgPath) + FileName + '.xml';
   end;
if FileExists(FName) then
   try
   cfg := TXMLConfig.Create(FName);
   DefaultRes := 2.54/cfg.GetValue('DefaultResolution', 75);
   sTemp := cfg.GetValue('IFAType','Proportional');
   for IFAVal in TIFAType do
      if IFAData[IFAVal].Name = sTemp then IFAType := IFAVAl;
   IFAFactor := cfg.GetExtendedValue('IFAFactor',0.8);
   Precision := cfg.GetValue('Precision',Precision);
   sTemp := cfg.GetValue('CentreDefinition','Peak');
   for CentreVal in TCentre do
      if CentreData[CentreVal].Name = sTemp then Centering := CentreVal;
   TopRadius := cfg.GetExtendedValue('TopRadius',2.5);
   Result := true;
   finally
   cfg.Free;
   end;
end;


function SaveSettings(FileName:string):boolean;
var cfg        :TXMLConfig;
    CfgPath,
    FName      :string;
begin
Result := false;
{look first for settings file in program dir}
CfgPath := ProgramDirectory;
FName := AppendPathDelim(CfgPath) + FileName + '.xml';
if not FileExists(FName) then
   {if nothing in program dir look in config dir}
   begin
   {$ifdef WINDOWS}
   CfgPath := GetAppConfigDir(true);
   {$else}
   CfgPath := GetAppConfigDir(false);
   {$endif}
   if not DirectoryExists(CfgPath) then CreateDir(CfgPath);
   FName := AppendPathDelim(CfgPath) + FileName + '.xml';
   end;
try
   cfg := TXMLConfig.Create(FName);
   cfg.SetValue('DefaultResolution',round(2.54/DefaultRes));
   cfg.SetValue('IFAType',IFAData[IFAType].Name);
   cfg.SetExtendedValue('IFAFactor',IFAFactor);
   cfg.SetValue('Precision',Precision);
   cfg.SetValue('CentreDefinition',CentreData[Centering].Name);
   cfg.SetExtendedValue('TopRadius', TopRadius);
   Result := true;
   finally
   cfg.Free;
   end
end;


{ TSettingsForm }

procedure TSettingsForm.StatusBarDrawPanel(SBar: TStatusBar;Panel: TStatusPanel;
   const Rect: TRect);
begin
with SBar.Canvas do
   begin
   Brush.Color := StatusBar.Color;
   FillRect(Rect);
   TextRect(Rect,2 + Rect.Left, 1 + Rect.Top,Panel.Text) ;
   end;
end;


procedure TSettingsForm.SErrorMsg(sError:string);
begin
StatusBar.SimpleText := sError;
StatusBar.Color := FaintRed;
StatusMessages.Add(StatusBar.SimpleText);
StatusBar.Hint := StatusMessages.Text;
end;


procedure TSettingsForm.SWarning(sWarning:string);
begin
StatusBar.SimpleText := sWarning;
StatusBar.Color := FaintYellow;
StatusMessages.Add(StatusBar.SimpleText);
StatusBar.Hint := StatusMessages.Text;
end;


procedure TSettingsForm.SMessage(sMess:string);
begin
StatusBar.SimpleText := sMess;
StatusBar.Color := FaintGreen;
StatusMessages.Add(StatusBar.SimpleText);
StatusBar.Hint := StatusMessages.Text;
end;


procedure TSettingsForm.ClearStatus;
begin
StatusBar.SimpleText := '';
StatusBar.Color := clDefault;
end;


procedure TSettingsForm.tbExitClick(Sender: TObject);
begin
close;
end;


procedure TSettingsForm.tbAddClick(Sender: TObject);
var OK         :boolean;
    ARow       :integer;
    sTemp      :string;
    IFAVal     :TIFAType;
    CentreVal  :TCentre;

begin
OK := true;
ARow := -1;
if vleSettings.FindRow('Default Resolution',ARow) then
   begin
   DefaultRes := 2.54/(StrToFloat(vleSettings.Values['Default Resolution']));
   SMessage('Key ' + vleSettings.Keys[ARow] + ' changed to '
      + vleSettings.Strings.ValueFromIndex[ARow-1]);
   vleSettings.Modified := false;
   end
  else
   OK := false;

if OK and (vleSettings.FindRow('IFA Type',ARow)) then
   begin
   sTemp := vleSettings.Values['IFA Type'];
   OK := false;
   for IFAVal in TIFAType do
      if IFAData[IFAVal].Name = sTemp then
         begin
         IFAType := IFAVAl;
         OK := true;
         end;
   SMessage('Key ' + vleSettings.Keys[ARow] + ' changed to '
      + vleSettings.Strings.ValueFromIndex[ARow-1]);
   vleSettings.Modified := false;
   end
  else
   OK := false;

if OK and (vleSettings.FindRow('IFA Factor',ARow)) then
   begin
   IFAFactor := StrToFloat(vleSettings.Values['IFA Factor']);
   SMessage('Key ' + vleSettings.Keys[ARow] + ' changed to '
      + vleSettings.Strings.ValueFromIndex[ARow-1]);
   vleSettings.Modified := false;
   end
  else
   OK := false;

if vleSettings.FindRow('Precision',ARow) then
   begin
   Precision := StrToInt(vleSettings.Values['Precision']);
   SMessage('Key ' + vleSettings.Keys[ARow] + ' changed to '
      + vleSettings.Strings.ValueFromIndex[ARow-1]);
   vleSettings.Modified := false;
   end
  else
   OK := false;

if OK and (vleSettings.FindRow('Centre definition',ARow)) then
   begin
   sTemp := vleSettings.Values['Centre definition'];
   OK := false;
   for CentreVal in TCentre do
      if CentreData[CentreVal].Name = sTemp then
         begin
         Centering := CentreVal;
         OK := true;
         end;
   SMessage('Key ' + vleSettings.Keys[ARow] + ' changed to '
      + vleSettings.Strings.ValueFromIndex[ARow-1]);
   vleSettings.Modified := false;
   end
  else
   OK := false;

if OK and (vleSettings.FindRow('Top Radius',ARow)) then
   begin
   TopRadius := StrToFloat(vleSettings.Values['Top Radius']);
   SMessage('Key ' + vleSettings.Keys[ARow] + ' changed to '
      + vleSettings.Strings.ValueFromIndex[ARow-1]);
   vleSettings.Modified := false;
   end
  else
   OK := false;

if not OK then SErrorMsg('Error, could not set key ' + vleSettings.Keys[ARow]);
end;


procedure TSettingsForm.FormCreate(Sender: TObject);
var ARow       :integer;
    IFAVal     :TIFAType;
    CentreVal  :TCentre;
begin
StatusMessages := TStringList.Create;
if vleSettings.FindRow('Default Resolution',ARow) then
   vleSettings.Values[vleSettings.Keys[Arow]] := IntToStr(round(2.54/DefaultRes))
  else
   vleSettings.InsertRow('Default Resolution',IntToStr(round(2.54/DefaultRes)),True);

if vleSettings.FindRow('IFA Type',ARow) then
   vleSettings.Values[vleSettings.Keys[Arow]] := IFAData[IFAType].Name
  else
   vleSettings.InsertRow('IFA Type',IFAData[IFAType].Name,True);
with vleSettings.ItemProps['IFA Type'] do
   begin
   KeyDesc := 'IFA Type: PickList';  //optional description
   EditStyle := esPickList;
   ReadOnly := True;  //user cannot add options to dropdownlist
   for IFAVal in TIFAType do
      PickList.Add(IFAData[IFAVal].Name);
   end;

if vleSettings.FindRow('IFA Factor',ARow) then
   vleSettings.Values[vleSettings.Keys[Arow]] := FloatToStr(IFAFactor)
  else
   vleSettings.InsertRow('IFA Factor',FloatToStr(IFAFactor),True);

if vleSettings.FindRow('Precision',ARow) then
   vleSettings.Values[vleSettings.Keys[Arow]] := IntToStr(Precision)
  else
   vleSettings.InsertRow('Precision',IntToStr(Precision),True);

if vleSettings.FindRow('Centre definition',ARow) then
   vleSettings.Values[vleSettings.Keys[Arow]] := CentreData[Centering].Name
  else
   vleSettings.InsertRow('Centre definition',CentreData[Centering].Name,True);
with vleSettings.ItemProps['Centre definition'] do
   begin
   KeyDesc := 'Centre definition: PickList';  //optional description
   EditStyle := esPickList;
   ReadOnly := True;  //user cannot add options to dropdownlist
   for CentreVal in TCentre do
      PickList.Add(CentreData[CentreVal].Name);
   end;

if vleSettings.FindRow('Top Radius',ARow) then
   vleSettings.Values[vleSettings.Keys[Arow]] := FloatToStr(TopRadius)
  else
   vleSettings.InsertRow('Top Radius',FloatToStr(TopRadius),True);

vleSettings.Modified := false;
SWarning('Keys will not be changed until <Save Settings> is clicked');
end;


procedure TSettingsForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
CanClose := False;
if vleSettings.Modified then
   begin
   if MessageDlg('Settings have been modified.' + LineEnding + ' Do you want to exit without saving?',
      mtConfirmation, [mbyes,mbNo],0) = mrYes then
         CanClose := true;
   end
   else Canclose := true;
end;


procedure TSettingsForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
StatusMessages.Free;
end;


initialization
   {$I settingsunit.lrs}

finalization
SetLength(RowsChanged,0);
end.

