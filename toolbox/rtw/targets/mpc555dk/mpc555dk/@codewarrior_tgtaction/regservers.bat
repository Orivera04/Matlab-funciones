@echo off
REM
REM To unregister these dll's change the "/c" option in the command
REM "MWRegSvr /c" to a "/u" making it "MWRegSvr /u" and to unregister
REM the IDE.exe itself you will need to overwrite ".\IDE.exe /RegServer"
REM with ".\IDE.exe /UnregServer"
REM
echo Registering core DLLs and IDE

REM *** Change dir to CodeWarrior bin dir (first batch file argument) ***
echo Change drive to: %1
%1
echo Change dir to: %2
cd %2

echo Current dir is:
pwd

REM *** the following DLL's are required ***
MWRegSvr /c .\Plugins\Support\MWComHelpers.dll
MWRegSvr /c .\Plugins\Support\MWRadModel.dll
MWRegSvr /c .\Plugins\Support\CPlusSourceGen.dll

REM *** the following ones are optional ***
if exist .\Plugins\Support\Catalog.dll		MWRegSvr /c .\Plugins\Support\Catalog.dll
if exist .\Plugins\Support\JavaSourceGen.dll	MWRegSvr /c .\Plugins\Support\JavaSourceGen.dll
if exist .\Plugins\Support\ObjectWireWizard.dll	MWRegSvr /c .\Plugins\Support\ObjectWireWizard.dll
if exist .\Plugins\COM\LayoutEditor.dll		MWRegSvr /c .\Plugins\COM\LayoutEditor.dll
if exist .\Plugins\COM\ObjectInspector.dll	MWRegSvr /c .\Plugins\COM\ObjectInspector.dll
if exist .\Plugins\COM\MenuEditor.dll		MWRegSvr /c .\Plugins\COM\MenuEditor.dll
if exist .\Plugins\COM\CatalogPlugIn.dll	MWRegSvr /c .\Plugins\COM\CatalogPlugIn.dll
echo     IDE.exe
.\IDE.exe /RegServer

REM Registering Java RAD DLLs
if exist .\Plugins\Support\JavaRADServer.dll	MWRegSvr /c .\Plugins\Support\JavaRADServer.dll
if exist .\Plugins\Support\JavaWizards.dll	MWRegSvr /c .\Plugins\Support\JavaWizards.dll

REM Registering PowerParts RAD DLLs
if exist .\Plugins\Support\PowerPartsCOM.dll	MWRegSvr /c .\Plugins\Support\PowerPartsCOM.dll

echo Done.

IF NOT "%3"=="/s" PAUSE
