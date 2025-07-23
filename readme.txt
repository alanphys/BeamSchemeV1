BeamScheme Readme file (c) 2008-2025 AC Chamberlain

1) Introduction
Welcome to BeamScheme

BeamScheme is an analysis tool for 2D datasets. It will assist you in extracting 1D profiles from 2D datasets and can calculate over 90 different parameters. BeamScheme can open various image and 2D array file formats such as SNC MapCheck, PTW 720, IBA Matrix and StarTrack, Eclipse, XiO, BrainLab, DICOM, jpg, etc.

Parameters include field size, field centre, penumbra, flatness and symmetry. FFF beams are supported with both maximum slope and sigmoid fit parameters available. Profiles can be taken at any angle, offset or thickness. Profiles can be exported to a text file or clipboard for further processing. Results can be exported to PDF.

BeamScheme is not intended to replace the commercial software available with 2D arrays, but to complement it.

2) Licence
Please read the file Licence.txt. This means that if as a result of using this program you fry your patients, trash your linac, nuke the cat, blow the city power in a ten block radius and generally cause global thermonuclear meltdown! Sorry, you were warned!

3) Installation
BeamScheme V1.00 is not compatible with previous versions of BeamScheme. While it is not necessary to uninstall previous versions all data in the program executable directory and the program configuration directory will be deleted before installing the new version.

To install BeamScheme run the BSSetup.exe file.

From version 1.01 BeamScheme features a USB disk install where the files can be extracted to a directory of your choosing and run.

4) Use
Run the program by double clicking the desktop icon, selecting the "BeamScheme" menu option or double clicking the BeamScheme.exe file in Windows explorer

Open a file by clicking the Open button or selecting "File,Open". If you don't see any files make sure the correct file type is selected.

Use the Offset, Width and Angle boxes to manipulate the profiles.

Windows can be maximised and restored by clicking the arrow in the top right hand corner of the window.

5) Validation
BeamScheme features extensive internal and external validation against commercial and open source software. Please see the unit tests directory for more information.

6) Notes on using 2D Array files
For correct field sizes the detector plane of the 2D array must be at 100cm SSD.

There will be small differences between the flatness and symmetry reported by BeamScheme and your 2D Array. This is due to differences in the algorithms. The differences should not be more than 0.05%.

7) Notes on using EPID images
No correction for SSD is made. You will have to apply corrections yourselves at this stage.

It is recommended that an EPID calibration be done before acquiring images to get the best image quality.

If you have an integrated imaging mode, use this as it will give you a better image.

DICOM images will usually need to be inverted (by clicking the Invert button) and then normalised (by clicking the normalise button).

8) Notes on normalising
The program uses the normalised, corrected 2D array data. No normalisation should be necessary for the 2D arrays if they have been calibrated and zeroed correctly.

There are three normalisation modes. None, CAX or maximum. Normalisation places the minimum of the image at 0 and the CAX or maximum value at 100. If the image contains dead pixels, burn markers or other strange artifacts it is possible for the normalisation to fail and give you strange results. This is not the fault of the program but of the image. See the previous comment about calibration. Normalisation acts on the windowed data and is non-destructive.

9) Release notes
These detail new or changed functionality in BeamScheme. Please see the History for bug fixes.

Version 1.02
Documentation is now listed on ReadTheDocs. High DPI awareness is enabled. Add 2D Integral and Differential uniformity for Nuclear Medicine. Update Help.

Version 1.01
FFF parameters according to NCS-70 have been included. Extensive testing of the maths functions has been added. Additional protocol validation has been added. The help web server has been removed. Help is now served directly from file. This version can be run from a single directory such as a usb disk.

Version 1.00
BeamScheme v1.00 is virtually a complete rewrite of BeamScheme featuring a new parameter calculation engine. The code has been extensively modularised making it easy to add new parameters. New algorithms have been implemented with individual parameter calculation. Extensive unit testing has been implemented. The GUI has been updated. The expression parser has been dropped and all parameters are calculated in the code. Efficiency is achieved by only calculating needed parameters.

Version 0.54
This is a bug fix release.

Version 0.53
Normalisation is now modal, i.e. non destructive. The normalisation modes are none, norm_cax and norm_max. In mode none the dataset is unnormalised and not grounded with the reference value taken at CAX. For norm_cax the data is grounded and normalised to 100% at the CAX value. For norm_max the data is grounded and normalised to 100% at the profile maximum value. The normalisation modes are enabled by the appropriate toolbar button.

Version 0.52
This version adds support for FFF beams. A Hill function is fitted to the penumbra region to determine the inflection point. Clipboard functionality has been added. Profile and results can be exported to the clipboard. The profiles and results now have context menus giving direct access to this functionality. The online help has been updated.

Version 0.51
BeamScheme now uses Form2PDF to render results to PDF. This has several advantages, the image is printed with the results, considerably less mouse clicks are required to save results and the results are printed as the form itself. The hard copy functionality has been removed. The PDF can, of course, still be printed by any PDF viewer.

Version 0.50
Help has been updated

Parameters are no longer auto normalised. Eg. the field edge or 50% value was calculated on the 50% value between the maximum and minimum of the profile. Now it is calculated on 50% of the maximum of the profile only. The user must explictly normalise the data if the normalised value is required. This is to bring BeamScheme in line with other programs.

Added an expression parser. This allows different parameter sets to be defined. The user can also define parameter sets. Expression editing has been included. Output has been updated to provide for mulitpage output.

Version 0.42
Added new About unit detailing readme, licence and credits.

Version 0.41
Added Average and Standard Deviation parameters over the flattened region of the profiles

Version 0.40
Profiles can now be positioned by clicking on the image with the mouse.

10) Known issues
Windows does not automatically focus the control under the mouse cursor therefore the context sensitive help may return the wrong help page.

11) History
22/07/2008 version 0.1
3/09/2009  added DICOM unit
22/8/2011  Fix field centre error,
           Fix Y resolution error for MapCheck 2
28/09/2011 removed MultiDoc
           added invert
           added normalise
           added windowing
           fixed profile display
           fixed symmetry calculation
           cleaned up printout 
Version 0.2 released 1/8/2011
22/8/2011  Fix field centre error,
           Fix Y resolution error for MapCheck 2
15/2/2012  Fix CAX normalisation error,
2/4/2013   Add read for XiO Dose plane file
20/6/2014  Removed redundant DICOM read code causing memory bug
24/6/2014  Fixed XiO read offset by 1
           Fixed MapCheck read if dose cal file not present
           Included Min/Max as part of beam class
           Fixed panel maximise to form area
21/5/2015  combine open dialog and DICOM dialog
20/7/2015  add messaging system
Version 0.3 released 20/7/2015
26/8/2016  Add normalise to max
28/6/2016  Support PTW 729 mcc
29/9/2016  Fix PTW 729 memory error
21/10/2016 Add PowerPDF for output
24/10/2016 Fix Profile event misfire
15/8/2017  Fix image integer conversion
13/10/2017 Support IBA Matrix and StartTrack opg
16/10/2017 Fix Diff divide by zero error
           Fix profile offset limit error
18/11/2017 Fix even number of detectors offset
15/12/2017 Support Brainlab iPlan Dose plane format
           Add text file format identification
8/1/2018   Add help system
           Fix windowing error on normalise to CAX
25/1/2018  QT5 version must be compiled on Lazarus 1.9 r57132 for correct image display
26/1/2018  Fix panel maximise under QT5
           Fix window level control size under max/min
30/1/2018  Fix area symmetry off by 1
           Fix CAX for even no of detectors
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
4/10/2021  fix ShowProfile and refactor
           fix initialise vars
           profile draw on trackbar change
14/10/2021 Remove sExePath in file Open
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
           create TBasicProfile, derive TSingleProfile and define IFA as TBasicProfile
14/2/2022  add definable precision
9/3/2022   add show/hide profile points
           add peak params to TSingleProfile, refactor
14/3/2022  fix window limit on normalise to centre
2/6/2022   add relative centering to peak and absolute to detector to IFA
24/6/2022  make maxposnan bidirectional, add differential params
20/7/2022  add sigmoid function and params
16/8/2022  fix infinite loop error with small floats, add rescale
4/11/2022  add field centre and size for sigmoid and derivative functions
7/11/2022  fix infinite loop for small dynamic range images
8/11/2022  add penumbra for sigmoid function
15/11/2022 add normalise function to TSingleProfile and refactor
16/11/2022 fix TSingleProfile.Res initalisation and range check errors
           add dose points
13/1/2023  add ShowPoints to View menu
           fix dangling ShowParameters in View menu
           fix Invert toggle
3/2/2023   update help
6/2/2023   fix config directory creation
           fix formatting issues in Windows
7/2/2023   fix protocol save path under Windows
           change protocol dir from exe or program config to both
           fix protocol save errors
           fix memory leak in buildprotocol
           fix crash on protocol edit exit
Version 1.00 released 7/2/2023
22/9/2023  add status history to settings unit
28/9/2023  add test unit for maths funcs
14/12/2023 add top and peak slope to FFF params
18/12/2023 look for config file in program dir as well
           remove web server for help
5/1/2024   fix max pos 1D param
           fix behaviour on invalid protocol
Version 1.01 released 8/1/2024
11/4/2024  fix profile move on image click
2/5/2024   refactor about unit
           enable high dpi awareness
13/1/2025  fix windows floating point exception
           fix exit crash if settings dir does not exist
Version 1.02 released 14/1/2024
19/3/2025  fix protocol display on exit
4/6/2025   fix FPU exception bug
23/7/2025  fix various divide by zero
           fix integer overflow in DTrackBar
