
   EzyFit Toolbox for Matlab

   F. Moisy
   Lab. FAST - University Paris-Sud

   version 2.30, 5 Fev 2009
__________________________________________________________________________

See:  www.fast.u-psud.fr/ezyfit

Bug report:  moisy@fast.u-psud.fr
__________________________________________________________________________


The Ezyfit toolbox for Matlab enables you to perform simple curve fitting
of one-dimensional data using arbitrary fitting functions. It provides
command-line functions and a basic graphical user interface for interactive
selection of the data.

Note:
This toolbox was originally called 'EasyFit'. Since Version 2.03
(13 apr 2006), it has been renamed 'EzyFit', to avoid confusion with
other products.

__________________________________________________________________________

Installation and system requirements

EzyFit needs Matlab 7.0 or higher. It has been tested under 7.0 to 7.6
(R2008a), but mainly under Windows XP. The command-line functions (e.g.
ezfit, showfit...) work equally well on all systems. However graphical
operations (e.g. selectfit, getslope...) may not be fully stable,
especially on non-Windows systems, and/or for recent Matlab releases.

1. Download and unzip the EzyFit Toolbox in a directory somewhere in your
system. For instance, in a Windows XP installation, the directory
My Documents/MATLAB/toolbox/ezyfit may be a good location. If you upgrade
from an older version, first empty the previous directory.

2. From the menu 'File > Set Path', click on 'Add Folder' (not 'with
subfolders') and select the ezyfit directory. Click on 'Save' and 'Close'.

3. Restart Matlab. From the Start button, select Toolboxes > EzyFit to
check that the toolbox is correctly recognized by your system.

4. If you upgrade from an earlier version, type rehash toolbox to make sure
that Matlab refreshes the function cache.

5. If you want to always have the Ezyfit menu in your figures, type
efmenu install. This will create or update your 'startup.m' file in the
directory /toolbox/local of your Matlab installation.

Note: If you upgrade Matlab and you want to use your previous Ezyfit
installation, you just have to follow the steps 2-5.

__________________________________________________________________________

What's new?

Once installed, have a look to the Release Notes and the Known Bugs sections
in the help browser (type 'docezyfit').
__________________________________________________________________________

Copyrights

This toolbox is free.
__________________________________________________________________________

The End.
