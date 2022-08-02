function varargout = modsimosc(varargin)
% MODSIMOSC - Demonstrate ModelSim Link component modeling.
%   MODSIMOSC compiles a VHDL oscillator, defines a filter component
%   that is modeled using MATLAB, and runs the ModelSim simulation.
%   This demo requires a temporary directory to generate a working 
%   ModelSim VHDL project.  After creating the VHDL project, this demo
%   starts ModelSim (this requires access to ModelSim from the command
%   line).  This demo uses shared memory to complete the link and 
%   therefore requires ModelSim to be on the same computer as MATLAB.
%   Futhermore, the project is compiled and the hardware simulation 
%   is run for 10 microseconds (Resolution limit is set to 1 nsec).  
%
%
% See also: HDLDAEMON

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.3.6.3 $  $Date: 2004/04/08 20:55:04 $


  disp('The modsimosc demo shows one way to do component modeling');
  disp('in MATLAB.  In this demo, a VHDL oscillator has been designed');
  disp('and our job is to find a cleanup filter for the oscillator that');
  disp('meets our needs. This demo shows three FIR filters modeled in MATLAB.');
  disp(' ');
  disp('This demo requires a temporary directory to generate a VHDL working');
  disp('directory in ModelSim.  After creating the VHDL work directory,');
  disp('ModelSim is started (this requires access to ModelSim from the command');
  disp('line).  This demo uses shared memory to complete the link and ');
  disp('therefore requires ModelSim to be on the same computer as MATLAB.');
  disp(' ');
  disp('The first FIR filter is a 31st order (32-tap) filter with no');
  disp('oversampling. The second filter is a 127th order (128-tap) filter');
  disp('with 4X oversampling. The third filter is a 255th order (256-tap)');
  disp('filter with 8X oversampling. All three filters share the same delay');
  disp('line and the oversampling is implemented using the polyphase technique.');
  disp(' ');
  disp('Hit any key to continue.');
  pause;
  disp('See these files for details:');
  disp(['    ', ...
        fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vhdl','osc','simple_osc.vhd')]);
  disp(['    ',...
        fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vhdl','osc','osc_filter.vhd')]);
  disp(['    ',...
        fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','vhdl','osc','osc_top.vhd')]);
  disp(['    ',...
        fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','oscfilter.m')]);
  disp(['    ',...
        fullfile(matlabroot,'toolbox','modelsim','modelsimdemos','osccmds.m')]);
  disp(' ');
  disp('The file simple_osc.vhd contains the simple oscillator designed in VHDL.');
  disp(' ');
  disp('The file osc_filter.vhd contains the MATLAB component that we are modeling.');
  disp('This is file is the heart of the modeling technique since the matlabtb');
  disp('command always drives VHDL entity inputs and checks entity outputs, we must');
  disp('build a cross-over block in VHDL to model a component where each input');
  disp('we want to use and each output we want to drive from MATLAB is connected');
  disp('to a corresponding output or input of the VHDL entity. In the MATLAB code,');
  disp('we simply drive the entity inputs that are connected to the desired outputs');
  disp('and read the entity outputs that are connected to the desired inputs.');
  disp(' ');
  disp('The file osc_top.vhd contains the top-level wiring between the oscillator');
  disp('and the MATLAB component. The file oscfilter.m contains the actual ');
  disp('component behaviorial model. The file osccmd.m contains the ModelSim');
  disp('commands to compile and run the simulation.');
  disp(' ');
  disp('First we ensure that the hdldaemon is running in shared-memory mode.');  
  disp(' ');
  disp('Hit any key to continue.');
  pause;
  dstatus = hdldaemon('status');
  % Use shared memory
  if isempty(dstatus)
    % not running - start it
    dstatus = hdldaemon;    % tell user what's happening
  elseif strcmp(dstatus.comm,'shared memory')
    % already running
    % user knows what's happening from previous hdldaemon('status')
  elseif strcmp(dstatus.comm,'sockets')
    % running with different comm - stop and restart it
    disp('Shutting down HDLDaemon to restart it with shared memory');
    hdldaemon('kill');
    dstatus = hdldaemon;
  else
    error('unexpected return value from hdldaemon(''status'')');
  end
  disp(' ');
  disp('Then we start ModelSim via the vsim command:');
  disp('    vsim(''tclstart'',osccmds)');
  vsim('tclstart',osccmds);
  disp(' ');
  disp('Now check results in the ModelSim plot window.  You will see the');
  disp('non-oversampled filter does little good, but the 4X and 8X oversampled');
  disp('filters look much better.');
  disp(' ');
  disp('Be sure to quit ModelSim once you are done with this demo as each');
  disp('time the demo is run, a new ModelSim is started.');
  disp(' ');
  global testisdone;
  testisdone = 0;
  while 1
      global testisdone;
      if testisdone == 1
          break;
      end
      pause(0.501);
  end;
  disp('test is done');
  pause(0.5);
  disp('This concludes this demo.');
  disp(' ');
