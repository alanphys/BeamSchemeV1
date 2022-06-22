unit settingsunit;
{Load, save and edit programme settings and defaults}

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
   ValEdit;

type

   { TSettingsForm }

   TSettingsForm = class(TForm)
      ImageList: TImageList;
      StatusBar: TStatusBar;
      ToolBarLeft: TToolBar;
      tbAdd: TToolButton;
      ToolBarRight: TToolBar;
      tbExit: TToolButton;
      vleSettings: TValueListEditor;
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

implementation

uses bstypes, laz2_XMLCfg, LazFileUtils;

function LoadSettings(FileName:string):boolean;
var cfg        :TXMLConfig;
    IFAVal     :TIFAType;
    CentreVal  :TCentre;
    CfgPath,
    sTemp      :string;
begin
Result := false;
{$ifdef WINDOWS}
CfgPath := GetAppConfigDir(true);
{$else}
CfgPath := GetAppConfigDir(false);
{$endif}
FileName := AppendPathDelim(CfgPath) + FileName + '.xml';
if FileExists(FileName) then
   try
   cfg := TXMLConfig.Create(FileName);
   DefaultRes := 2.54/cfg.GetValue('DefaultResolution', 75);
   sTemp := cfg.GetValue('IFAType','Proportional');
   for IFAVal in TIFAType do
      if IFAData[IFAVal].Name = sTemp then IFAType := IFAVAl;
   IFAFactor := cfg.GetExtendedValue('IFAFactor',0.8);
   Precision := cfg.GetValue('Precision',Precision);
   sTemp := cfg.GetValue('CentreDefinition','Peak');
   for CentreVal in TCentre do
      if CentreData[CentreVal].Name = sTemp then Centering := CentreVal;
   Result := true;
   finally
   cfg.Free;
   end;
end;


function SaveSettings(FileName:string):boolean;
var cfg        :TXMLConfig;
    CfgPath    :string;
begin
Result := false;
{$ifdef WINDOWS}
CfgPath := GetAppConfigDir(true);
{$else}
CfgPath := GetAppConfigDir(false);
{$endif}
FileName := AppendPathDelim(CfgPath) + FileName + '.xml';
   try
   cfg := TXMLConfig.Create(FileName);
   cfg.SetValue('DefaultResolution',round(2.54/DefaultRes));
   cfg.SetValue('IFAType',IFAData[IFAType].Name);
   cfg.SetExtendedValue('IFAFactor',IFAFactor);
   cfg.SetValue('Precision',Precision);
   cfg.SetValue('CentreDefinition',CentreData[Centering].Name);
   Result := true;
   finally
   cfg.Free;
   end
end;


{ TSettingsForm }

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
   StatusBar.SimpleText := 'Key ' + vleSettings.Keys[ARow] + ' changed to '
      + vleSettings.Strings.ValueFromIndex[ARow-1];
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
   StatusBar.SimpleText := 'Key ' + vleSettings.Keys[ARow] + ' changed to '
      + vleSettings.Strings.ValueFromIndex[ARow-1];
   vleSettings.Modified := false;
   end
  else
   OK := false;

if OK and (vleSettings.FindRow('IFA Factor',ARow)) then
   begin
   IFAFactor := StrToFloat(vleSettings.Values['IFA Factor']);
   StatusBar.SimpleText := 'Key ' + vleSettings.Keys[ARow] + ' changed to '
      + vleSettings.Strings.ValueFromIndex[ARow-1];
   vleSettings.Modified := false;
   end
  else
   OK := false;

if vleSettings.FindRow('Precision',ARow) then
   begin
   Precision := StrToInt(vleSettings.Values['Precision']);
   StatusBar.SimpleText := 'Key ' + vleSettings.Keys[ARow] + ' changed to '
      + vleSettings.Strings.ValueFromIndex[ARow-1];
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
   StatusBar.SimpleText := 'Key ' + vleSettings.Keys[ARow] + ' changed to '
      + vleSettings.Strings.ValueFromIndex[ARow-1];
   vleSettings.Modified := false;
   end
  else
   OK := false;

if not OK then StatusBar.SimpleText := 'Error, could not set key ' + vleSettings.Keys[ARow];
end;


procedure TSettingsForm.FormCreate(Sender: TObject);
var ARow       :integer;
    IFAVal     :TIFAType;
    CentreVal  :TCentre;
begin
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

vleSettings.Modified := false;
StatusBar.SimpleText := 'Keys will not be changed until <Save Settings> is clicked';
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

initialization
   {$I settingsunit.lrs}

end.

