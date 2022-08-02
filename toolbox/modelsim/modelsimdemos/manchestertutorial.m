% Manchester Receiver tutorial script
%  This script executes a sequence of tests on the components/entities
%  of a VHDL Manchester receiver
%  vhdl\manchester\decode.vhd   - Combinatorial mapping of computed IQ
%  vhdl\manchester\iqconv.vhd   - Computes IQ convolution (XOR)
%  vhdl\manchester\statecnt.vhd - State counter
%

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.5.6.3 $  $Date: 2004/04/08 20:55:02 $
%------------------------------------------------------------------
% Starting the MATLAB daemon (to accept access from ModelSim)
% Allow the OS to specify the TCP port number
hdldaemon('socket',0)            % Activate MATLAB server to accept foreign VHDL calls
dstat = hdldaemon('status');     % Retrieve OS define port number (for 
portnum = dstat.ipc_id;

global testisdone;
%------------------------------------------------------------------
% Testing of DECODER.VHD
%  First, launch ModelSim with the necessary steps to
%  load, compile and run the model.  The cell array tclcmd
%  does all the necessary preparations on the model
%  for testing by manchester_decoder.m
%
%  Note the application of the TCP port selection by the OS.
testisdone = 0;
disp('=============================================================');
disp('MATLAB testing of Manchester component: ''decoder.vhd''');
disp(' Creates 2 plots of the transfer function of this entity');
disp(' This test is simply a visualization of the decoder behavior');

projectdir = pwd;   % change to a suitable directory to hold ModelSim project (must have write-access)
unixprojectdir = strrep(projectdir,'\','/');  %ModelSim/Tcl always uses unix-style files
unixsrcfile = strrep(fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vhdl','manchester','decoder.vhd'),'\','/');

tclcmd = { ['cd ' unixprojectdir ],...  % convert to unix style directory
            'catch {wm geometry . 500x200+0+0}',...  % Try moving ModelSim out of the way
            'vlib work',... %create library (if necessary)
           ['vcom -performdefaultbinding ' unixsrcfile],...
            'vsimmatlab work.decoder',...
           ['matlabtb decoder -mfunc manchester_decoder -socket ',num2str(portnum)],...
            'run 3000',...
            'quit -f'};
    
vsim('startupfile','decoder.do',...   % Creates a do file (useful for testing)
     'tclstart',tclcmd);

disp('Waiting for testing of ''decoder.vhd'' to complete (flag from manchester_decoder.m indicates completion)');
while testisdone == 0,
    global testisdone;
    pause(0.501);
end
pause(1);
disp('MATLAB test of decoder.vhd s complete!  Check the generated plot for results.');
disp('Next, Hit any key to continue.');
pause;

%------------------------------------------------------------------
% Testing of IQCONV.VHD
%  First, launch ModelSim with the necessary steps to
%  load, compile and run the model.  The cell array tclcmd
%  does all the necessary preparations on the model
%  for testing by manchester_iqconv.m
%  Note the application of the TCP port selection by the OS.
testisdone = 0;
disp('=============================================================');
disp('MATLAB testing of Manchester component: ''iqconv.vhd''');
disp(' Checks isum and qsum outputs for a randomly generated');
disp(' stream of data samples');

projectdir = pwd;   % change a suitable directory to hold ModelSim project (must have write-access)
unixprojectdir = strrep(projectdir,'\','/');  %ModelSim/Tcl always uses unix-style files
unixsrcfile = strrep(fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vhdl','manchester','iqconv.vhd'),'\','/');

tclcmd = { ['cd ' unixprojectdir ],...  % convert to unix style directory
           'catch {wm geometry . 500x200+0+0}',...  % Try moving ModelSim out of the way
            'vlib work',...  %create library (if necessary)
           ['vcom -performdefaultbinding ' unixsrcfile],...
            'vsimmatlab work.iqconv',...
            'force /iqconv/clk 1 0, 0 5 ns -repeat 10 ns ',... 
            'force /iqconv/enable 1',...
            'force /iqconv/reset 1',... % reset before calling MATLAB
            'run 100',...
           ['matlabtb iqconv -rising /iqconv/clk -mfunc manchester_iqconv -socket ',num2str(portnum)],...
            'run 1000',...
            'quit -f'};

vsim('startupfile','iqconv.do',...   % Creates a do file (useful for testing)
     'tclstart',tclcmd);
       
while testisdone == 0,
    global testisdone;
    pause(0.501);
end
pause(1);
disp('Test of iqconv.vhd complete (If it failed, there would be an error message printed above)!');
disp('Next, Hit any key to continue.');
pause;
       
%------------------------------------------------------------------
% Testing of STATECNT.VHD
%  First, launch ModelSim with the necessary steps to
%  load, compile and run the model.  The cell array tclcmd
%  does all the necessary preparations on the model
%  for testing by manchester_statecnt.m

testisdone = 0;
disp('=============================================================');
disp('MATLAB testing of Manchester component: ''statecnt.vhd''');
disp(' Creates checks isum and qsum outputs for a randomly generated');
disp(' stream of data samples');

projectdir = pwd;   % change a suitable directory to hold ModelSim project (must have write-access)
unixprojectdir = strrep(projectdir,'\','/');  %ModelSim/Tcl always uses unix-style files
unixsrcfile = strrep(fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vhdl','manchester','statecnt.vhd'),'\','/');

tclcmd = { ['cd ' unixprojectdir ],...  % convert to unix style directory
            'catch {wm geometry . 500x200+0+0}',...  % Try moving ModelSim out of the way
            'vlib work',...  %create library (if necessary)
           ['vcom -performdefaultbinding ' unixsrcfile],...
            'vsimmatlab -t 1ns work.statecnt ',...
            'force /statecnt/clk 1 0, 0 5 ns -repeat 10 ns ',...             
           ['matlabtb statecnt -mfunc manchester_statecnt -socket ',num2str(portnum)],...
            'run 30000',...
            'quit -f'};          

vsim('startupfile','statecnt.do',...   % Creates a do file (useful for testing)
     'tclstart',tclcmd);
       
while testisdone == 0,
    global testisdone;
    pause(0.501);
end
pause(1);
disp('Test of statecnt.vhd complete (Examine plot produced) .');
disp('This concludes the manchester tutorial demo');
              
% [EOF] manchestertutorial.m
