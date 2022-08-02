% File : run(this, action, target, debug, breaks, suppress_download)
%
% Abstract : 
%  Run the executable associated with the current build
%  of the current model or the model argument.
%
% Arguments :
%  this        -   mpc555_tgtaction object
%  action		-   'mdl' - target is the name of a model or subsystem
%  					 'exe' - target is the full path to an elf executable
%  target		-   Simulink Path | FileSystem Path
%  debug			-   0 - no debug
%  					 1 - debug
%   breaks        -  A cell array of filename and line number pairs
%                    indicating places where breakpoints should occur.
%                    { 'main.c' 98 'init.c' 27 }
%  suppress_download - 0 - Do not download the object code
%							  1 - Do download the object code
%
% Usage :
%
%	run(obj,'mdl',gcb,0)					- Run the block or model
%	run(obj,'mdl',gcb,1)					- Debug the block or model
%  run(obj,'exe',elf,0)	            - Run an elf executable	
%  run(obj,'exe',gcb,1)           	- Debug an eld executable

% Copyright 2002-2004 The MathWorks, Inc.
% $Revision: 1.6.6.5 $ 
% $Date: 2004/04/19 01:26:33 $
function run(obj, varargin)

if nargin <= 2  

    subsystem = varargin{1};

    if nargin == 1
        subsystem = bdroot;
    end

	 run(obj,'mdl',subsystem);
	 return;

else

    action = varargin{1};
	 switch lower(action)
	 case 'exe'
		 % Load an elf file directly
    	 elf    = varargin{2};
	 case 'mdl'
		 % Try to identify an elf file from a model or subsystem reference
    	 elf = getELF(obj,varargin{2});
	 otherwise
        error(['Invalid action ' action]);
    end

	 % Determine if we wish to debug or not
	 if nargin >= 4
		 debug = varargin{3};
	 else
		 debug = 0;
	 end;
     
     if nargin >= 5
         breaks = varargin{4};
     else
         breaks = {};
     end

	  if nargin >=6
		  suppress_download=varargin{5};
	  else
		  suppress_download=0;
	  end
end

% Get the location of the codewarrior_tgtaction directory
local_dir = fileparts(which('codewarrior_tgtaction'));

% Choose the config file dependant on the oscilator
% frequency of the target board.
prefs = RTW.TargetPrefs.load('mpc555.prefs');
oscFreq = prefs.TargetBoard.OscillatorFrequency; 
switch oscFreq 
case '20'
	cfg_file = fullfile(local_dir,'mpc5xx_osc20.cfg');
case '4'
	cfg_file = fullfile(local_dir,'mpc5xx_osc4.cfg');
otherwise
	error(['OscillatorFrequency ' num2str(oscFreq) ' not supported']);
end

% Load the elf file into the debugger and execute it
cw_mpc555_wiggler_elf_load(obj, elf, cfg_file, debug, breaks, suppress_download)
