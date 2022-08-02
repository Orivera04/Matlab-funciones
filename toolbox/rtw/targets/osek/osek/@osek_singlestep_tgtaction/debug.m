%% File : debug(object, varargin)
%%
%% Abstract :
%%  debugs a generated model on the target hardware.
%%
%%  Brad Phelan

% Copyright 2002-2003 The MathWorks, Inc.
% $Revision: 1.4.6.2 $ 
% $Date: 2004/04/19 01:30:40 $

function debug(obj,varargin)
  
% Determine the name of the elf file

  switch nargin
   case 1
    subsystem = bdroot;
    userScript = [];
   case 2
    subsystem = varargin{1};
    userScript = [];
   otherwise
    subsystem = varargin{1};
    userScript = varargin{2};
  end

  if subsystem == '-'
    elf = subsystem;
    modelName = 'default';
  else
    if exist(subsystem) == 2
      elf = subsystem;
      [path, modelName,EXT,VERSN] = fileparts(elf);    
    else  
      elf = getELF(obj,subsystem);
      modelName = bdroot(subsystem);
    end
  end
  
  local_dir = fileparts(mfilename('fullpath'));

% RUN a tgtaction method to run the compiled target.

% Get the full path to the executable used to start
% SingleStep. This is dependent on what connection is being used,
% we currently use an OCDemon(tm) Macraigor Systems Wiggler(tm),
% which uses SingleStep's bdmp58.exe, or the visionPROBE, which
% uses visppc.exe.
sdsExe = getsdsexe(obj);

% Get the SingleStep WSP (workspace) file for
% loading and running from RAM
sdsRAMwsp  = fullfile(local_dir, 'phycore-555.wsp');


% Generate the SingleStep script to debug the model
ModelScript    = [modelName '_ram.scr'];
sdsRAMscr      = fullfile(pwd, ModelScript);
create_script(obj,ModelScript,elf,local_dir,userScript);

% Build and execute the necessary command

%
% NOTE: As Some BDM configurations can exit SingleStep leaving the
% board running. Some can not. To take advantage of an environment
% that can continue to run after exiting SingleStep, comment out
% the addition of ' -r ' to sdsArgs below.
%
% Use of the '-r' switch executes the script and remains in
% SingleStep without exiting. Without '-r' SingleStep exits after
% completing execution of the script. 
%
sdsArgs   = [];
sdsArgs   = [sdsArgs ' -r ' ];
sdsArgs   = [sdsArgs ' ' todos(sdsRAMscr) ];

sdsCmd = ['start ' sdsExe ' ' sdsArgs];
disp(['Execute SingleStep as: ' sdsCmd]);
[s,w] = system(sdsCmd);

% Function : create_script
%
% Abstract :
%
% Create the diab initialization script
%
% Arguments :
%
%   obj           -   the object for which this method is being invoked.
%   sdsRAMscr     -   The full path the where to write the script file
%   elf           -   The full path to the elf executable
function create_script(obj, sdsRAMscr, varargin)

  switch nargin
    % nargin is the total number of arguments coming in. varagin
    % consumes all those not explicitly declared as function
    % arguments. 
   case 4
    elf = varargin{1};
    local_dir = varargin{2};
   case 5
    elf = varargin{1};
    local_dir = varargin{2};
    userScript = varargin{3};
   otherwise
    error('Wrong number of arguments.');
  end

    sdsPort = getdebugswitches;
    cfg_file = fullfile(local_dir,'mpc555.cfg');

    fH = fopen(sdsRAMscr,'w');

    fprintf(fH,     'alias _config source %s\n'     ,todos(cfg_file));
    sdsExe = getsdsexe(obj);
    if (~isempty(regexpi(sdsExe,'visppc.exe')))
      % This is a work-around for SingleStep with vision 7.7.3 that
      % is being used for all visppc.exe's. 
      fprintf(fH,     'debug %s -R -N %s -r -\n'           ,sdsPort, todos(elf));
      fprintf(fH,     '_config\n');
      fprintf(fH,     '_load\n');
      fprintf(fH,     '_reset\n');
    else
      fprintf(fH,     'debug %s %s\n'              ,sdsPort, todos(elf));
    end
    if ~isempty(userScript)
      fprintf(fH,   'source %s\n'                   ,todos(userScript));
    end
    fclose(fH);
