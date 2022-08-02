function tclcmd = manchestercmds
% MANCHESTERCMDS - Creates Tcl commands for Multimanchester Model
%   The returned cell array can be passed as parameters ('cmd') to
%   VSIM.  This will lauching ModelSim and build the VHDL
%   source files included with the demo.  Also, the model will
%   be loaded for cosimulation with MULTIMANCHESTER.MDL.
%
% See also VSIM

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 2003/11/05 17:29:17 $
%   $Revision $ $Date: 2003/11/05 17:29:17 $
%

srcfile1 = fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vhdl','manchester','statecnt.vhd');
srcfile2 = fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vhdl','manchester','iqconv.vhd');
srcfile3 = fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vhdl','manchester','decoder.vhd');
srcfile4 = fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vhdl','manchester','multimanchester.vhd');

unixsrcfile1 = strrep(srcfile1,'\','/'); 
unixsrcfile2 = strrep(srcfile2,'\','/'); 
unixsrcfile3 = strrep(srcfile3,'\','/'); 
unixsrcfile4 = strrep(srcfile4,'\','/'); 

projdir = tempdir;  % Change to writable directory of your choosing
unixprojdir = strrep(projdir,'\','/'); 
tclcmd = { 
            'switch -glob -- [vsimAuth] {',...
            '  SE* { wm geometry . 500x200+0+0 }',...
            '}',...  % Try moving ModelSim out of the way
           ['cd ',unixprojdir],...            
            'vlib work',... %create library (if necessary)
           ['vcom -performdefaultbinding ' unixsrcfile1],...
           ['vcom -performdefaultbinding ' unixsrcfile2],...
           ['vcom -performdefaultbinding ' unixsrcfile3],...
           ['vcom -performdefaultbinding ' unixsrcfile4],...           
            'vsimulink work.multimanchester',...
         };
