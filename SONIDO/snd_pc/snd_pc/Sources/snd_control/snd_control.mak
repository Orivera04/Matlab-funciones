# Microsoft Developer Studio Generated NMAKE File, Format Version 4.20
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

!IF "$(CFG)" == ""
CFG=snd_control - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to snd_control - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "snd_control - Win32 Release" && "$(CFG)" !=\
 "snd_control - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "snd_control.mak" CFG="snd_control - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "snd_control - Win32 Release" (based on\
 "Win32 (x86) Dynamic-Link Library")
!MESSAGE "snd_control - Win32 Debug" (based on\
 "Win32 (x86) Dynamic-Link Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 
################################################################################
# Begin Project
# PROP Target_Last_Scanned "snd_control - Win32 Debug"
CPP=cl.exe
RSC=rc.exe
MTL=mktyplib.exe

!IF  "$(CFG)" == "snd_control - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
OUTDIR=.\Release
INTDIR=.\Release

ALL : "..\..\..\dpoae\snd_control.dll"

CLEAN : 
	-@erase "$(INTDIR)\snd_control.obj"
	-@erase "$(OUTDIR)\snd_control.exp"
	-@erase "$(OUTDIR)\snd_control.lib"
	-@erase "..\..\..\dpoae\snd_control.dll"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /YX /c
# ADD CPP /nologo /MT /W3 /GX /O2 /I "c:\develop\matlab5.1\extern\include" /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "MATLAB_MEX_FILE" /YX /c
CPP_PROJ=/nologo /MT /W3 /GX /O2 /I "c:\develop\matlab5.1\extern\include" /D\
 "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "MATLAB_MEX_FILE"\
 /Fp"$(INTDIR)/snd_control.pch" /YX /Fo"$(INTDIR)/" /c 
CPP_OBJS=.\Release/
CPP_SBRS=.\.
# ADD BASE MTL /nologo /D "NDEBUG" /win32
# ADD MTL /nologo /D "NDEBUG" /win32
MTL_PROJ=/nologo /D "NDEBUG" /win32 
# ADD BASE RSC /l 0x809 /d "NDEBUG"
# ADD RSC /l 0x809 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/snd_control.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /machine:I386
# ADD LINK32 winmm.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /machine:I386 /out:"c:\home\grobi\dpoae\snd_control.dll"
LINK32_FLAGS=winmm.lib kernel32.lib user32.lib gdi32.lib winspool.lib\
 comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib\
 odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /incremental:no\
 /pdb:"$(OUTDIR)/snd_control.pdb" /machine:I386 /def:".\snd_control.def"\
 /out:"c:\home\grobi\dpoae\snd_control.dll" /implib:"$(OUTDIR)/snd_control.lib" 
DEF_FILE= \
	".\snd_control.def"
LINK32_OBJS= \
	"$(INTDIR)\snd_control.obj" \
	"..\..\mex_imp.lib"

"..\..\..\dpoae\snd_control.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "snd_control - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
OUTDIR=.\Debug
INTDIR=.\Debug

ALL : "..\..\..\dpoae\snd_control.dll"

CLEAN : 
	-@erase "$(INTDIR)\snd_control.obj"
	-@erase "$(INTDIR)\vc40.idb"
	-@erase "$(INTDIR)\vc40.pdb"
	-@erase "$(OUTDIR)\snd_control.exp"
	-@erase "$(OUTDIR)\snd_control.lib"
	-@erase "$(OUTDIR)\snd_control.pdb"
	-@erase "..\..\..\dpoae\snd_control.dll"
	-@erase "..\..\..\dpoae\snd_control.ilk"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /YX /c
# ADD CPP /nologo /MTd /W3 /Gm /GX /Zi /Od /I "c:\develop\matlab5.1\extern\include" /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /D "MATLAB_MEX_FILE" /YX /c
CPP_PROJ=/nologo /MTd /W3 /Gm /GX /Zi /Od /I\
 "c:\develop\matlab5.1\extern\include" /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /D\
 "MATLAB_MEX_FILE" /Fp"$(INTDIR)/snd_control.pch" /YX /Fo"$(INTDIR)/"\
 /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.\.
# ADD BASE MTL /nologo /D "_DEBUG" /win32
# ADD MTL /nologo /D "_DEBUG" /win32
MTL_PROJ=/nologo /D "_DEBUG" /win32 
# ADD BASE RSC /l 0x809 /d "_DEBUG"
# ADD RSC /l 0x809 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/snd_control.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /debug /machine:I386
# ADD LINK32 winmm.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /debug /machine:I386 /out:"c:\home\grobi\dpoae\snd_control.dll"
LINK32_FLAGS=winmm.lib kernel32.lib user32.lib gdi32.lib winspool.lib\
 comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib\
 odbc32.lib odbccp32.lib /nologo /subsystem:windows /dll /incremental:yes\
 /pdb:"$(OUTDIR)/snd_control.pdb" /debug /machine:I386 /def:".\snd_control.def"\
 /out:"c:\home\grobi\dpoae\snd_control.dll" /implib:"$(OUTDIR)/snd_control.lib" 
DEF_FILE= \
	".\snd_control.def"
LINK32_OBJS= \
	"$(INTDIR)\snd_control.obj" \
	"..\..\mex_imp.lib"

"..\..\..\dpoae\snd_control.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 

.c{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.c{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

################################################################################
# Begin Target

# Name "snd_control - Win32 Release"
# Name "snd_control - Win32 Debug"

!IF  "$(CFG)" == "snd_control - Win32 Release"

!ELSEIF  "$(CFG)" == "snd_control - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\snd_control.def

!IF  "$(CFG)" == "snd_control - Win32 Release"

!ELSEIF  "$(CFG)" == "snd_control - Win32 Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=.\snd_control.c
DEP_CPP_SND_C=\
	"..\..\..\..\..\Develop\Matlab5.1\extern\include\mat.h"\
	"..\..\..\..\..\Develop\Matlab5.1\extern\include\mex.h"\
	

"$(INTDIR)\snd_control.obj" : $(SOURCE) $(DEP_CPP_SND_C) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=\home\Grobi\Projects\mex_imp.lib

!IF  "$(CFG)" == "snd_control - Win32 Release"

!ELSEIF  "$(CFG)" == "snd_control - Win32 Debug"

!ENDIF 

# End Source File
# End Target
# End Project
################################################################################
