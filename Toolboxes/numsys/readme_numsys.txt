Numeral Systems Toolbox Ver. 1.1
================================
Date: 2003-10-03.
Author: B. Rasmus Anthin.



WHAT IS IT
----------

This toolbox contains functions for converting numerals back and forth
between different numeral systems.
The toolbox is a good complement to the base converting function CHB
(change base) written by Giampiero Campa
and is available from http://www.mathworks.com/matlabcentral .


INSTALLATION
------------
>> Go directly to step 3 if this is the first time you install this toolbox!<<

0. When in matlab; go to the .../numsys/ directory and run UNINSTALL.
   (If any directories in connection to this toolbox remain in the matlab
    path, then remove them from the path manually by using EDITPATH).

1. Next, you have to backup any files you've added to the toolbox or changes
   made to existing files (must not be redistributed without my
   approval!).

2. After this is done, completely delete the existing toolbox directory.

3. Place the numsys.#.#.zip archive file in the directory where you want
   to keep this toolbox. If you place it under "c:/matlab/" then the toolbox
   will appear in the directory "c:/matlab/numsys/". According to the example
   in step 0, you should place it in the directory given by
      » fullfile(matlabroot,'toolbox')
   but it is up to you where you wish to keep this toolbox (however consistency
   is a good thing).

4.1. Linux/Unix: Install by writing "unzip numsys.#.#.zip" (you can use
   "gunzip" as well).

4.2. Windows: Copy the entire archive to the directory using
   Total Commander available from "http://www.ghisler.com" (you can use
   WinZip as well).

4.3. Other systems: Use some pack program for zip-files to extract
   the toolbox dir-tree where you want to keep it. If you can't do this
   then please mail me about it "e8rasmus@etek.chalmers.se" and I'll try
   to help you.

5. Update your matlab path by going to the numsys toolbox base directory.
   This could for example be:
      » cd(fullfile(matlabroot,'toolbox','numsys'))
   Then simply type:
      » install
   If this doesn't work, see the help for INSTALL for further details.

If you would encounter any problems in any the above steps, the please
contact me "e8rasmus@etek.chalmers.se" and I'll do my best to help you
through.



GETTING STARTED
---------------

This toolbox contains routines for converting between different anctient 
numeral systems such as the roman numeral system, from or to the arabic
(ie hindu-arabic aka european) numerals.
To get started, look through the contents list and check the help for each
function to get familiarized with them.


IMPORTANT NOTES
---------------



UPDATES AND VERSIONS
--------------------

This toolbox is in a very early stage of development, so more numeral systems
converters will be added in due time. The following are planned
additions to this toolbox:

1.  Babylonian.
2.  Egyptian.
3.  Negaternary.
4.  Negabinary.
5.  Golden ratio base.
6.  Quater-imaginary base.
7.  Binary square-root-2 times i base.
8.  Binary i-1 base.
9.  Fibonacci coding.
10. Mixed radix.
11. Negative values.
12. Fractions.

I think that would be all for now...



Ver 1.0:
The first version: Seems to work.

Ver 1.1:
Added BABYLONIAN.

EOF.