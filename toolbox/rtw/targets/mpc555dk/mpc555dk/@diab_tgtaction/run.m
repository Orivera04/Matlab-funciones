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
% $Revision: 1.8.6.7 $ 
% $Date: 2004/04/19 01:26:41 $
function run(obj,varargin)

% Determine the name of the elf file

if nargin <= 2

    subsystem = varargin{1};

    % Determine the name of the elf file
    if nargin == 1
        subsystem = bdroot;
    end

	 run(obj,'mdl',subsystem, 0);
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

% RUN a tgtaction method to run the compiled target.

% Get the full path to the executable used to start
% SingleStep. This is dependent on what connection is being used,
% we currently use an OCDemon(tm) Macraigor Systems Wiggler(tm),
% which uses SingleStep's bdmp58.exe.
sdsExe = getsdsexe(obj);

% Get the SingleStep WSP (workspace) file for
% loading and running from RAM
sdsRAMwsp  = fullfile(local_dir, 'mpc555.wsp');


% Generate the SingleStep script to debug the model
sdsRAMscr    = fullfile(tempdir,'diab_ram.scr');
flagfile = create_diab_script(obj,sdsRAMscr, elf, debug, breaks, suppress_download);

% Build and execute the necessary command
sdsArgs   = ['-P -r  ' todos(sdsRAMscr) ' -S ' todos(sdsRAMwsp) ];
if ~isempty(elf)
    sdsArgs   = [sdsArgs  ' -a ' todos(elf)];
end
sdsCmd = ['start ' sdsExe ' ' sdsArgs];
disp(['Execute SingleStep as: ' sdsCmd]);
[s,w] = system(sdsCmd);

while(1)
    t = timer('TimerFcn','disp('''')','StartDelay',0.1);
    start(t);wait(t);
    if exist(flagfile,'file')
        disp('found file');
        break;
    end
end


% Function : todos
% 
% Abstract :
%   Converts a directory name with spaces in it into
%   a old dos compatible directory name.
%
function path = todos(path)

% If needs translate into DOS 8.3 format
if (any(isspace(path)) ~= 0)
    % Get the trans2dos utility executable
    trans2dos = fullfile(matlabroot, 'toolbox', 'rtw', 'targets', ...
    'mpc555dk', 'common', 'tools', 'win32', 'trans2dos.exe');

    [status, path ] = dos([trans2dos ' "' path '"']);
    path = strtok(path);
end

% Function : create_diab_script
%
% Abstract :
%
% Create the diab initialization script
%
% Arguments :
%
%   sdsRAMscr     -   The full path the where to write the script file
%   elf           -   The full path to the elf executable
%   debug         -   0 - run immediately
%   				  1 - Stop at main
%   breaks        -   A cell array of filename and line number pairs
%                     indicating places where breakpoints should occur.
%   suppress_download - 0 do not suppress the download of object code
%                       1 suppress the download of object code
function flagfile = create_diab_script(obj, sdsRAMscr, elf, debug, breaks, suppress_download)
    prefs = RTW.TargetPrefs.load('mpc555.prefs');

    debugOpts = prefs.ToolChainOptions.DebuggerSwitches;

    % select MPC555, MPC565 etc.
    switch prefs.TargetBoard.ProcessorVariant
    case '555'
      variant = '-V MPC555';
    case '561'
      variant = '-V MPC561';
    case '562'
      variant = '-V MPC561';
    case '563'
      variant = '-V MPC563';
    case '564'
      variant = '-V MPC563';
    case '565'
      variant = '-V MPC565';
    case '566'
      variant = '-V MPC565';
    otherwise
       error('Unknown variant');
    end;

    % check that debugOpts does not already contain a -V
    % processor option
    index = strfind(debugOpts, '-V');
    if ~isempty(index) 
      warning('SingleStep debugger option, -V, found in debugger options.  The option specified by the user will be kept.');
      % clear variant string
      variant = '';
    end;

	% Choose the config file dependant on the oscilator
	% frequency of the target board.
	oscFreq = prefs.TargetBoard.OscillatorFrequency;
	switch oscFreq 
	case '20'
		cfg_file = fullfile(local_dir,'mpc5xx_osc20.cfg');
	case '4'
		cfg_file = fullfile(local_dir,'mpc5xx_osc4.cfg');
	otherwise
		error(['OscillatorFrequency ' num2str(oscFreq) ' not supported']);
	end

    fH = fopen(sdsRAMscr,'w');
    memcfg_file = fullfile(local_dir,'memcfg.dbg');
    % note: mem config must be re-applied at reset to avoid it being lost!
    fprintf(fH,     'alias _config ''source %s && source %s''\n'     ,todos(cfg_file), memcfg_file);

    if ~isempty(elf)
        % This will debug a specific object file
		  if suppress_download
			  fprintf(fH,     'alias reload debug -N %s %s %s\n'                 ,variant, debugOpts , todos(elf));
		  else
			  fprintf(fH,     'alias reload debug %s %s %s\n'                 ,variant, debugOpts , todos(elf));
		  end
    else
        % This will just be a hardware inspecting session
        % Program Name "-" is used
        fprintf(fH,     'alias reload debug %s %s - \n'                 ,variant, debugOpts );
    end

    % Execute the reload alias
    fprintf(fH,     'reload\n');

    % Display the memory configuration
    fprintf(fH, 'mem\n');
    
    if ~ isempty(elf)
        % Only add breakpoints if we are debugging an executable

        % Add in the breakpoints to the script
        for breakIdx = 1:length(breaks)/2
            currentBreak = { breaks{breakIdx:(breakIdx+1)} };
            name = currentBreak{1};
            line = currentBreak{2};
            fprintf(fH, 'break %s#%d\n', name, line);
        end
        
        fprintf(fH,'echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
        fprintf(fH,'echo Attention Real Time Workshop User\n');
        fprintf(fH,'echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
        fprintf(fH,'echo To reload the executable after rebuilding the model type\n');
        fprintf(fH,'echo "   reload"\n');
        fprintf(fH,'echo in this command window.\n');
        fprintf(fH,'echo " "\n');
        fprintf(fH,'echo To bring the command window to the front click the\n');
        fprintf(fH,'echo "   Command"\n');
        fprintf(fH,'echo toolbar icon\n');
        fprintf(fH,'echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n');
      

        if debug
          fprintf(fH,     'break main\n'                          );
          fprintf(fH,     'break exit\n'                          );
          fprintf(fH,     'reset\n'                          );
			 flagfile = gen_flag_file(fH);
        else
          fprintf(fH,     'break exit\n'                          );
			 flagfile = gen_flag_file(fH);
          fprintf(fH,     'go\n'                          );
        end

	 else
		 flagfile = gen_flag_file(fH);
	 end
    


    fclose(fH);

function flagfile = gen_flag_file(fH)

    flagfile = [ tempname '.txt' ];
        
    if exist(flagfile,'file')
        delete(flagfile);
    end

    fprintf(fH, 'visible -n echo "singlestep started" > %s\n',flagfile);
    
    
function ld = local_dir
    ld = fileparts(which('diab_tgtaction'));
