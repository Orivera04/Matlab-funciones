function whatsnew(arg)
%WHATSNEW Display Readme files for MATLAB and toolboxes.
%	WHATSNEW <toolboxpath> displays the Readme file for the toolbox
%	with the specified toolbox path.  For example,
%
%	whatsnew matlab    - Display MATLAB's Readme file.
%	whatsnew signal    - Display Signal Processing Toolbox Readme file.
%	whatsnew control   - Display Control Toolbox Readme file.
%
%	The Readme files, if they exist for each product, contain descriptions
%	of new functionality that is not described in the documentation.
%
%	See also VER, HELP, WHICH, PATH, LOOKFOR.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if (nargin == 0 & (isunix | isvms))	% display some help
	disp(' ')
	disp('The following documents from the MATLAB 4.0 documentation set are')
	disp('available in compressed PostScript form in the event you don''t have')
	disp('your own printed copy. They provide information on what''s new in ')
	disp('this release of MATLAB and on converting from MATLAB 3.5 to MATLAB 4.0.')
        disp(' ')
        disp('The online versions of the New Features Guide and Release Notes')
        disp('may contain information not found in the hardcopy versions.')
        disp(' ')
	if isvms
	    disp('   MATLAB 4.0 New Features Guide:')
	    disp('      TOOLBOX:[MATLAB]NEWFEATURES-PS.Z')
	    disp(' ')
	    disp('   MATLAB 4.0a Release Notes:')
	    disp('      TOOLBOX:[MATLAB]RELNOTES-PS.Z')
	    disp(' ')
	    disp('   SIMULINK 1.2b Release Notes:')
	    disp('      TOOLBOX:[SIMULINK]RELNOTES-1-2B-PS.Z')
	    disp(' ')
            disp('They are in Unix COMPRESS format.  To uncompress them use GZIP in the')
	    disp('MATLAB:[ETC] directory as follows:')
	    disp('  $ GZIP :== $ MATLAB:[ETC]GZIP')
	    disp('  $ GZIP -D TOOLBOX:[MATLAB]NEWFEATURES-PS.Z');
	    disp('  $ GZIP -D TOOLBOX:[MATLAB]RELNOTES-PS.Z');
	    disp('  $ GZIP -D TOOLBOX:[SIMULINK]RELNOTES-1-2B-PS.Z');
	    disp('You can then print them to a PostScript printer using the VMS PRINT command.')
	else
	    disp('   MATLAB 4.0 New Features Guide:')
	    disp(['      ', getenv('MATLAB'),'/toolbox/matlab/newfeatures.ps.Z'])
	    disp(' ')
	    disp('   MATLAB 4.2 Release Notes:')
	    disp(['      ', getenv('MATLAB'),'/toolbox/matlab/relnotes4.2.ps.Z'])
	    disp(' ')
	    disp('   SIMULINK 1.3 Release Notes:')
	    disp(['      ', getenv('MATLAB'),'/toolbox/simulink/relnotes1.3.ps.Z'])
	    disp(' ')
	    disp('For example, to print the New Features Guide, use MATLAB commands like:')
	    disp(' ')
	    disp('    >> cd toolbox/matlab')
	    disp('    >> !zcat newfeatures.ps.Z > ~/newfeatures.ps')
	    disp('    >> !lpr -s -r ~/newfeatures.ps')
	end
	disp(' ')
	disp('To find out about undocumented features, use WHATSNEW with an argument:')
	help whatsnew
    	return
elseif nargin == 0
   help whatsnew
    	return
end
info(arg);
