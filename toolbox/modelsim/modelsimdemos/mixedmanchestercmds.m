function tclcmd = mixedmanchestercmds
% MIXEDMANCHESTERCMDS - Creates Tcl commands for Manchester Model
%   The returned cell array can be passed as parameters ('cmd') to
%   VSIMULINK.  This will lauching ModelSim and build the mixed
%   source files included with the demo.  Also, the model will
%   be loaded for cosimulation with MIXEDMANCHESTERMODEL.MDL
%
% See also VSIMULINK

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ $Date: 2004/04/08 20:55:03 $
%

srcfile1 = fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vlog','manchester','statecnt.v');
srcfile2 = fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vlog','manchester','iqconv.v');
srcfile3 = fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vlog','manchester','decoder.v');
srcfile4 = fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vhdl','manchester','manchester.vhd');

unixsrcfile1 = strrep(srcfile1,'\','/'); 
unixsrcfile2 = strrep(srcfile2,'\','/'); 
unixsrcfile3 = strrep(srcfile3,'\','/'); 
unixsrcfile4 = strrep(srcfile4,'\','/'); 

if strcmp(computer,'PCWIN'),
    projdir = tempdir;  % Change to writable directory of your choosing
else
    projdir = tempname;
    mkdir(tempdir,strrep(projdir,tempdir,''));
end

unixprojdir = strrep(projdir,'\','/'); 
tclcmd = { 
            'switch -glob -- [vsimAuth] {',...
            '  SE* { wm geometry . 500x200+0+0 }',...
            '}',...  % Try moving ModelSim out of the way
           ['cd ',unixprojdir],...            
            'vlib work',... %create library (if necessary)
           ['vlog ' unixsrcfile1],...
           ['vlog ' unixsrcfile2],...
           ['vlog ' unixsrcfile3],...           
           ['vcom -performdefaultbinding ' unixsrcfile4],...           
            'vsimulink work.manchester',...
           % originally done here, but moved to Tcl before 
           % 'force sim:/manchester/enable 1 0',...  
           % 'force sim:/manchester/reset 1 0, 0 1000 ns',...
         };
