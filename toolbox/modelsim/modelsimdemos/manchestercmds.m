function tclcmd = manchestercmds
% MANCHESTERCMDS - Creates Tcl commands for Manchester Model
%   The returned cell array can be passed as parameters ('cmd') to
%   VSIMULINK.  This will lauching ModelSim and build the VHDL
%   source files included with the demo.  Also, the model will
%   be loaded for cosimulation with MANCHESTERMODEL.MDL and
%   MANCHESTERMODELCOMMBLKS.MDL
%
% See also VSIM

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.10.6.1 $ $Date: 2004/03/15 22:19:39 $
%

srcfile1 = fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vhdl','manchester','statecnt.vhd');
srcfile2 = fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vhdl','manchester','iqconv.vhd');
srcfile3 = fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vhdl','manchester','decoder.vhd');
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
            'catch { wm geometry . 500x200+0+0 }',... % Try moving ModelSim out of the way
           ['cd ',unixprojdir],...            
            'vlib work',... %create library (if necessary)
           ['vcom -performdefaultbinding ' unixsrcfile1],...
           ['vcom -performdefaultbinding ' unixsrcfile2],...
           ['vcom -performdefaultbinding ' unixsrcfile3],...
           ['vcom -performdefaultbinding ' unixsrcfile4],...           
            'vsimulink work.manchester',...
           % originally done here, but moved to Tcl before 
           % 'force sim:/manchester/enable 1 0',...  
           % 'force sim:/manchester/reset 1 0, 0 1000 ns',...
         };
