# Microsoft Developer Studio Generated NMAKE File, Format Version 4.20
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

!IF "$(CFG)" == ""
CFG=snd_read - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to snd_read - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "snd_read - Win32 Release" && "$(CFG)" !=\
 "snd_read - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "snd_read.mak" CFG="snd_read - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "snd_read - Win32 Release" (based on\
 "Win32 (x86) Dynamic-Link Library")
!MESSAGE "snd_read - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
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
# PROP Target_Last_Scanned "snd_read - Win32 Debug"
CPP=cl.exe
RSC=rc.exe
MTL=mktyplib.exe

!IF  "$(CFG)" == "snd_read - Win32 Release"

# PROP BASE Use_MFC 5
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 5
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
OUTDIR=.\Release
INTDIR=.\Release

ALL : "..\..\..\tmp\snd_read.dll"

CLEAN : 
	-@erase "$(INTDIR)\snd_read.obj"
	-@erase "$(OUTDIR)\snd_read.exp"
	-@erase "$(OUTDIR)\snd_read.lib"
	-@erase "..\..\..\tmp\snd_read.dll"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_WINDLL" /D "_MBCS" /Yu"stdafx.h" /c
# ADD CPP /nologo /MT /W3 /GX /O2 /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "MATLAB_MEX_FILE" /D "_WINDLL" /D "_MBCS" /YX /c
CPP_PROJ=/nologo /MT /W3 /GX /O2 /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D\
 "MATLAB_MEX_FILE" /D "_WINDLL" /D "_MBCS" /Fp"$(INTDIR)/snd_read.pch" /YX\
 /Fo"$(INTDIR)/" /c 
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
BSC32_FLAGS=/nologo /o"$(OUTDIR)/snd_read.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /dll /machine:I386
# ADD LINK32 winmm.lib /nologo /subsystem:windows /dll /machine:I386 /out:"c:\home\grobi\tmp\snd_read.dll"
LINK32_FLAGS=winmm.lib /nologo /subsystem:windows /dll /incremental:no\
 /pdb:"$(OUTDIR)/snd_read.pdb" /machine:I386 /def:".\snd_read.def"\
 /out:"c:\home\grobi\tmp\snd_read.dll" /implib:"$(OUTDIR)/snd_read.lib" 
DEF_FILE= \
	".\snd_read.def"
LINK32_OBJS= \
	"$(INTDIR)\snd_read.obj" \
	"..\..\mex_imp.lib"

"..\..\..\tmp\snd_read.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "snd_read - Win32 Debug"

# PROP BASE Use_MFC 5
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 5
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
OUTDIR=.\Debug
INTDIR=.\Debug

ALL : "..\..\..\tmp\snd_read.dll"

CLEAN : 
	-@erase "$(INTDIR)\snd_read.obj"
	-@erase "$(INTDIR)\vc40.idb"
	-@erase "$(INTDIR)\vc40.pdb"
	-@erase "$(OUTDIR)\snd_read.exp"
	-@erase "$(OUTDIR)\snd_read.lib"
	-@erase "$(OUTDIR)\snd_read.pdb"
	-@erase "..\..\..\tmp\snd_read.dll"
	-@erase "..\..\..\tmp\snd_read.ilk"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_WINDLL" /D "_MBCS" /Yu"stdafx.h" /c
# ADD CPP /nologo /MTd /W3 /Gm /GX /Zi /Od /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /D "MATLAB_MEX_FILE" /D "_WINDLL" /D "_MBCS" /YX /c
CPP_PROJ=/nologo /MTd /W3 /Gm /GX /Zi /Od /D "_DEBUG" /D "WIN32" /D "_WINDOWS"\
 /D "MATLAB_MEX_FILE" /D "_WINDLL" /D "_MBCS" /Fp"$(INTDIR)/snd_read.pch" /YX\
 /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 
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
BSC32_FLAGS=/nologo /o"$(OUTDIR)/snd_read.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /dll /debug /machine:I386
# ADD LINK32 winmm.lib /nologo /subsystem:windows /dll /debug /machine:I386 /out:"c:\home\grobi\tmp\snd_read.dll"
LINK32_FLAGS=winmm.lib /nologo /subsystem:windows /dll /incremental:yes\
 /pdb:"$(OUTDIR)/snd_read.pdb" /debug /machine:I386 /def:".\snd_read.def"\
 /out:"c:\home\grobi\tmp\snd_read.dll" /implib:"$(OUTDIR)/snd_read.lib" 
DEF_FILE= \
	".\snd_read.def"
LINK32_OBJS= \
	"$(INTDIR)\snd_read.obj" \
	"..\..\mex_imp.lib"

"..\..\..\tmp\snd_read.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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

# Name "snd_read - Win32 Release"
# Name "snd_read - Win32 Debug"

!IF  "$(CFG)" == "snd_read - Win32 Release"

!ELSEIF  "$(CFG)" == "snd_read - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\snd_read.c
DEP_CPP_SND_R=\
	"..\..\..\..\..\Develope\Matlab52\extern\include\mat.h"\
	"..\..\..\..\..\Develope\Matlab52\extern\include\mex.h"\
	

"$(INTDIR)\snd_read.obj" : $(SOURCE) $(DEP_CPP_SND_R) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\snd_read.def

!IF  "$(CFG)" == "snd_read - Win32 Release"

!ELSEIF  "$(CFG)" == "snd_read - Win32 Debug"

!ENDIF 

# End Source File
################################################################################
# Begin Source File

SOURCE=\Home\Grobi\Projects\mex_imp.lib

!IF  "$(CFG)" == "snd_read - Win32 Release"

!ELSEIF  "$(CFG)" == "snd_read - Win32 Debug"

!ENDIF 

# End Source File
# End Target
# End Project
################################################################################
