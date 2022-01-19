unit aboutunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    mAbout: TMemo;
    mLicence: TMemo;
    mCredits: TMemo;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

function GetAppVersionString(IncludeBuildInfo:Boolean=True; MinorDigits:Byte=2;
   IncludePosRelease:Boolean=False; IncludeAnyRelease:Boolean=False): String;

var
  AboutForm: TAboutForm;

implementation

uses FileInfo;

function GetAppVersionString(IncludeBuildInfo:Boolean=True; MinorDigits:Byte=2;
   IncludePosRelease:Boolean=False; IncludeAnyRelease:Boolean=False): String;
var VersionInfo: TVersionInfo;
begin
Result:= '';
try
  VersionInfo:= TVersionInfo.Create;
  VersionInfo.Load(HINSTANCE);
  Result:= IntToStr(VersionInfo.FixedInfo.FileVersion[0]) + '.' +
     Format('%0.*d',[MinorDigits,VersionInfo.FixedInfo.FileVersion[1]]);
  if (IncludeAnyRelease or (IncludePosRelease and (VersionInfo.FixedInfo.FileVersion[2]<>0))) then
     Result:= Result + '.' + IntToStr(VersionInfo.FixedInfo.FileVersion[2]);
  if IncludeBuildInfo then
     Result:= Result + '.' + IntToStr(VersionInfo.FixedInfo.FileVersion[3]);
 finally
   if assigned(VersionInfo) then
     VersionInfo.Free;
 end;
end; {getappversionstring}


{ TAboutForm }

procedure TAboutForm.FormCreate(Sender: TObject);
begin
Caption := 'BeamScheme version ' + GetAppVersionString(True,2,True,True);
try
   {$IF Defined(LINUX)}
   mAbout.Font.Name := 'Monospace';
   {$ELSEIF Defined(WINDOWS)}
   mAbout.Font.Name := 'Courier New';
   {$ELSE}
   mAbout.Font.Name := 'Courier';
   {$ENDIF}
   mAbout.Lines.LoadFromFile('readme.txt');
   except
   on E:Exception do
      mAbout.Lines.Text := 'Sorry readme not available';
   end;

try
   {$IF Defined(LINUX)}
   mLicence.Font.Name := 'Monospace';
   {$ELSEIF Defined(WINDOWS)}
   mLicence.Font.Name := 'Courier New';
   {$ELSE}
   mLicence.Font.Name := 'Courier';
   {$ENDIF}
   mLicence.Lines.LoadFromFile('licence.txt');
   except
   on E:Exception do
      mLicence.Lines.Text := 'Sorry licence not available';
   end;

try
   {$IF Defined(LINUX)}
   mCredits.Font.Name := 'Monospace';
   {$ELSEIF Defined(WINDOWS)}
   mCredits.Font.Name := 'Courier New';
   {$ELSE}
   mCredits.Font.Name := 'Courier';
   {$ENDIF}
   mCredits.Lines.LoadFromFile('credits.txt');
   except
   on E:Exception do
      mCredits.Lines.Text := 'Sorry credits not available';
   end;
end;

initialization
  {$I aboutunit.lrs}

end.

