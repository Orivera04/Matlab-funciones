SND_PC toolbox Version 1.2 for Matlab 5.0 or higher
====================================================

The MEX-files in this toolbox use the Windows Multimedia API for versatile 
access of multiple Windows compatible audio devices from within Matlab. 
The DLLs will work only with Matlab 5.0 or higher and 32-bit Windows systems. 

Features: 1. supports 8, 16, 24 and 32 bits samples
          2. starts up to 64 output and 16 input channels synchroneously 
          3. control of audio mixer devises

The MEX-files have been developed in the ENT department of the Rudolf 
Virchow Clinic Berlin for experiments investigating otoacoustic emissions.
We used a multichannel 24-bit-soundcard "Gina" by Echo. Its 8 output 
channels are treated as 4 single stereo devices. The driver of this 
soundcard starts all audio devices sample synchronously if the devices 
are set in pause mode first and than started. That is the way SND_MULTI.DLL 
works. Other multichannel audio devices or multipe audio devices might not  
start synchroneously, but might improve synchronisation by this method.
Some other usefull DLLs and M-files have been added to form a sound toolbox 
for Win32 compatible systems. See individual help in the M-Files for further 
details.

The "Gina"-driver Version 4 has some bugs we reported to Echo. Both might 
be resolved in Version 5. See individual help in the M-Files for further 
details (SND_MULTI.M, SND_MIXER_INFO.M).

To enable improvements user feedback is highly appreciated! 
Send comments to torsten.marquardt@gmx.net


Files of the SND_PC Toolbox:
----------------------------

copying_GPL.txt     The GNU-General Public Licence
readme.txt          The file you are reading

The MEX-files:

snd_control.dll     Controls parameter of the audio mixer device
snd_mixer_info.dll  Retrieves information about the parameter of the mixer
snd_multi.dll       Multi channel audio input and/or output (8,16,24,32 bit)
snd_read.dll        Reads/averages wav-files (8,16,24,32 bit) into Matlab
snd_stop.dll        Stops audio output and releases the resources 


M-files of the all MEX-files are included for online help:

snd_control.m
snd_mixer_info.m
snd_multi.m
snd_stop.m
snd_read.m

Some Examples of How To Use:
Examples\example.m  Example for sound input and output
Examples\sine.m     Generates matricies containing loopable sine waves
Examples\snd_ini.m  Example of mixer initialisation to a defined state


Directory Sources:

The directory Sources contains all files you need for recompilation. Load the 
project file (*.mdp) into MS Visual C++ compiler 6.0 and make sure all pathes 
are set correctly. 
The online help of the MSVC 4.0 on the multimedia API may be very useful to 
understand the code. See also the "Application Program Interface Guide" by 
The MathWorks Inc. 

Sources\mat.h
Sources\matrix.h
Sources\mex.h
Sources\mex_imp.exp
Sources\mex_imp.lib
Sources\tmwtypes.h

Sources\snd_control\snd_control.c
Sources\snd_control\snd_control.def
Sources\snd_control\snd_control.mak
Sources\snd_control\snd_control.mdp
Sources\snd_control\snd_control.ncb

and so for the other 4 MEX-files.


Installation:
-------------
1. Copy the directory "SND_PC" into the MATLAB\TOOLBOX\LOCAL directory
2. Add a path to this new directory and a path to its subdirectory "Examples".
   (Use the Pathtool of Matlab in the menu "File")
3. Make sure your soundcard driver is installed corectly and activ (check
   this using the Control Panel provided by windows 95 or check by using other 
   sound applications.)

For more details see the M-files (typing "help filename" at the Matlab command
line prompt.

Copyright:
----------
The SND_PC toolbox is written by Torsten Marquardt (torsten.marquardt@gmx.net) 
and is subject to the GNU GENERAL PUBLIC LICENCE (see COPYING_GPL.TXT).
