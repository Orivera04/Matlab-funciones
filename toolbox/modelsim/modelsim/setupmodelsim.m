function setupmodelsim(varargin) 
% SETUPMODELSIM  Configure ModelSim for use with MATLAB and Simulink
%   SETUPMODELSIM - Interactive installation which configures Modelsim
%   to work with MATLAB and Simulink.  After completing this 
%   function, Modelsim will include Tcl commands 'vsimulink' and 
%   'vsimmatlab', which enable the link between the applications.
%
%   SETUPMODELSIM('Property','PropertyValue',...) - Command version of
%   above installation script.  This form in not interactive and 
%   requires all options to be passed as properties.  
%  
% Properties
% 'tclstart' - Allows the user to specify Tcl command(s) to be executed 
%        during ModelSim startup.  These command can be either a string 
%        or a cell array of strings, with each entry a Tcl command.  These 
%        command are appended to the startup file. 
% 'vsimdir' - ModelSim executable directory (location of vsim). If this
%         property is not given, the first vsim on the system path 
%         will be used.  If the vsim program does not reside on the system 
%         path, this property is required.  This property can be used
%         to launch of different versions of Modelsim.  
% 'action' - This property should be either 'install' or 'uninstall':
%        'install'   - This causes modification of the tclIndex file in ModelSim's
%                      tcl directory to auto run the do file on ModelSim startup
%        'uninstall' - This causes modification of the tclIndex file in ModelSim's
%                      tcl directory to comment out the line that causes the auto 
%                      run the do file on ModelSim startup.
%
% Examples:
%  >setupmodelsim
%  >setupmodelsim('action','install')
%  >setupmodelsim('action','uninstall')
%  >setupmodelsim('vsimdir','C:\Modeltech_5.7e\win32')
%  >setupmodelsim('vsimdir','C:\Modeltech_5.7e\win32','action','uninstall')
%  >setupmodelsim('tclstart',{'puts "hello"','puts "world"'},'action','install')
% 
%   
% See also !, VSIM

%  Copyright 2003 The MathWorks, Inc.
%  $Revision: 1.7 $ $Date: 2003/11/11 22:17:28 $

vsimdirectory = [];
vsimoptions = '';
vsimcmdfile = [];
vsimsocket = [];
modelSimExePath = [];
%writeSourceLine = true;

doInstall = true;
somethingSpecified = false;

if(mod(nargin,2)~=0)
    error('Arguments to SETUPMODELSIM must be specified in pairs.');
end

% Get property / value pairs from argument list
for i = 1:2:nargin-1,
    prop = lower(varargin{i});
    val  = varargin{i+1};    
    % Argument checking
    cmdinx = strmatch(prop,{'vsimdir','tclstart','action'});
    if length(cmdinx) ~= 1,
        if ischar(prop),
            error(['Unrecognized SETUPMODELSIM property : ''' prop '''']);
        else
            error(['SETUPMODELSIM options must be specified in property/value pairs']);            
        end
    end
    switch cmdinx
        case 1  % "vsimdir"
            if ischar(val),
                vsimdirectory = val;
                somethingSpecified = true;
            else
                error(sprintf('Value specified with ''vsimdir'' is not valid.\n Value must be a string that specifies the path to an installed ModelSim executable.'));
            end
        case 2   % "tclstart"
            if ischar(val) || iscell(val),
                vsimoptions = val
                somethingSpecified = true;
            else
                error(sprintf('Value specified with ''tclstart'' is not valid. \nValue must be a Tcl command string or an array of Tcl command strings that is to execute during ModelSim startup.'));
            end 
        case 3 % "action"
            if ischar(val),
                if strcmp( val, 'install' )
                    doInstall = true;
                elseif strcmp( val, 'uninstall' )
                    doInstall = false;
                else
                    error('SETUPMODELSIM property (''action'') must be either ''install'' or ''uninstall''');
                end
            else
                error('SETUPMODELSIM property (''action'') must be either ''install'' or ''uninstall''');
            end
        otherwise
            error(['Unrecognized property: ' prop]);
    end    
end

% writeSourceLine

%if doInstall
if ~isempty(vsimdirectory)
    modelSimExePath = vsimdirectory;
    
    % elseif writeSourceLine
elseif ~somethingSpecified
    if doInstall,
        disp(sprintf('\nIdentify the ModelSim installation to be configured for MATLAB and Simulink'));
    else
        disp(sprintf('\nIdentify the ModelSim installation to be deconfigured for MATLAB and Simulink'));
    end
    installs = '';
    
    flag = false;
    while flag == false
        disp(' ')
        answer = input('Do you want setupmodelsim to locate installed ModelSim executables [y]/n? ','s');
        if isempty(answer) || strcmp(answer,'y') || strcmp(answer,'Y') || strcmp(answer,'n') || strcmp(answer,'N')
            flag = true;
        end
    end
    
    if isempty(answer) || strcmp(answer,'y') || strcmp(answer,'Y')
        answer = true;
        disp(' ')
        disp('Select a ModelSim installation:')
        % later this can maybe change to use isunix and ispc
        if strcmp(computer,'SOL2'),
            foundPaths = search_path('vsim','-all');
            installs = '';   
            
            for i=1:cell_length(foundPaths)
                [PATHSTR,NAME,EXT,VERSN] = fileparts(foundPaths{i});
                installs{ cell_length(installs) + 1, 2 } = PATHSTR;
            end;
        elseif strcmp(computer,'PCWIN'),
            registryKeys = querymodelsimregistry;
            foundPaths = search_path('modelsim','-all');
            installs = registryKeys;   
            
            for i=1:cell_length(foundPaths)
                [PATHSTR,NAME,EXT,VERSN] = fileparts(foundPaths{i});
                found = false;
                for j=1:cell_length(registryKeys)
                    if strcmp(PATHSTR,registryKeys{j,2} )
                        found = true;
                    end;
                end;
                if ~found
                    installs{ cell_length(installs) + 1, 2 } = PATHSTR;
                end;
            end;
            
        else
            error('This platform is not supported by Link for ModelSim');
        end        
                
        disp(' ');
        for i=1:cell_length(installs)
            disp(sprintf('[%i] %s       %s', cell_length(installs) - i + 1, installs{ cell_length(installs) - i + 1, 2 }, installs{ cell_length(installs) - i + 1, 1 }));
        end;
        disp('[0] None');
        flag = false;
        while flag == false
            disp(' ');
            choice = sscanf(input('Selected Modelsim installation: ','s'),'%i');
            if isempty(choice) | choice == 0
                disp(' ')
                disp('  setupmodelsim: No installation selected. No action taken.' )
                return;
            elseif choice > cell_length(installs) || choice < 0
                disp(' ')
                disp('  setupmodelsim: No valid installation selected. No action taken.' )
                % repeat: flag = false;
            else
                modelSimExePath = installs{choice,2};
                flag = true;    
            end;
        end;
        
    else
        answer = false;
        flag = false;
        while flag == false
            disp(' ')
            disp('Please enter the path to your ModelSim executable')
            modelSimExePath = input('file (modelsim.exe or vsim.exe): ','s');
            if exist( modelSimExePath, 'dir' )
                flag = true;
            else 
                disp(' ');
                disp('!!! The path you supplied is not a valid directory.  (To cancel setup, press cntrl-c)');
            end
        end
    end;
else % no dir specified and nothing else specified, take default path
    
    if strcmp(computer,'SOL2'),
        foundPaths = search_path('vsim');
        
        if isempty( foundPaths ) 
            error('No vsim executlable for ModelSim was found in your PATH, can not complete!');
        end
        
        [PATHSTR,NAME,EXT,VERSN] = fileparts(foundPaths);
        modelSimExePath = PATHSTR;
    elseif strcmp(computer,'PCWIN'),
        foundPaths = search_path('modelsim');
        
        if isempty( foundPaths ) 
            error('No modelsim executlable for ModelSim was found in your PATH, can not complete!');
        end
        
        [PATHSTR,NAME,EXT,VERSN] = fileparts(foundPaths);
        modelSimExePath = PATHSTR;
    else
        error('This platform is not supported by Link for ModelSim');
    end        
end

% modelSimExePath

% check for a vsim directory path, or use default
vsimcmdfile = strcat(modelSimExePath, filesep, '..', filesep, 'tcl', filesep, 'ModelSimTclFunctionsForMATLAB.tcl');
modelSimStartupFile = strcat(modelSimExePath, filesep, '..', filesep, 'tcl', filesep, 'vsim/tclIndex');

% vsimcmdfile

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% search for any dofile sourcing
% if exists, rewrite it, otherwise append it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add an entry to the end of the file <modeltech_install_path>/tcl/vsim/tclIndex that looks like:
% Would it be wiser to append to auto_index instead of replacing it? In other words:
% 
% lappend auto_index(_initCommands_tcl) ';' 'source' [file join $dir mathworks.tcl]]

% doInstall
% writeSourceLine
% modelSimStartupFile

if doInstall
    %     if writeSourceLine
    fidcmd = fopen(modelSimStartupFile,'at');
    if fidcmd == -1
        error('Could not open file for writing: %s',modelSimStartupFile);
    end
    % disp(sprintf('Opened file:  %s',modelSimStartupFile));
    fprintf(fidcmd,'# Do NOT edit this line or the line below\nlappend auto_index(_initCommands_tcl); if { [catch {source %s}]} {\n puts stderr "Failed to load MATLAB configuration file"\n}\n', strrep(vsimcmdfile,filesep,sprintf('%s%s',filesep, filesep))); 
    
    fclose(fidcmd);
    %     else
    %         disp('No ModelSim startup files were modified.');
    %         disp(sprintf('To use this setup, you must use:  vsim(''startupfile'',''%s'')',vsimcmdfile));
    %     end;
else
    %  Uninstall - replace startup file with stub
end

% edit( modelSimStartupFile )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% write out dofile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% doInstall
% writeSourceLine
% vsimoptions

if doInstall %| ~writeSourceLine
    if exist( vsimcmdfile, 'file' ) && ~somethingSpecified,
        disp(' ')
        disp(sprintf('Previous MATLAB startup file found in this installation of ModelSim:\n %s', vsimcmdfile));
        answer = input(sprintf('Do you want to replace this file [y]/n? '),'s');
        if isempty(answer) || strcmp(answer,'n') || strcmp(answer,'N'),
            disp('Modelsim configuration not updated for MATLAB and Simulink');
            return;
        end
    end
    
    % write_dofile(vsimcmdfile,vsimoptions,vsimsocket);
    vsim('tclstart',vsimoptions,'startupfile',vsimcmdfile,'startgui','no')
    disp('Modelsim successfully configured for MATLAB and Simulink');
    
else    
    %  Uninstall - replace startup file with stub
   if exist( vsimcmdfile, 'file' ) && ~somethingSpecified,
         disp(sprintf('Previous MATLAB startup file found in this installation of ModelSim:\n %s', vsimcmdfile));
        answer = input(sprintf('Do you want to replace this file (required for deconfiguration) [y]/n? '),'s');
        if isempty(answer) || strcmp(answer,'n') || strcmp(answer,'N'),
            disp('Modelsim configuration not updated for MATLAB and Simulink');
            return;
        end
   end
   fidcmd = fopen(vsimcmdfile,'wt');
   if fidcmd == -1
        error('Could not open file for writing: %s',vsimcmdfile);
   end
    % disp(sprintf('Opened file:  %s',modelSimStartupFile));
   fprintf(fidcmd,'# MATLAB and Simulink option was deconfigured\n'); 
   fclose(fidcmd);
   disp('Modelsim successfully deconfigured');
   
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function where = search_path(what,switches)

%SEARCH_PATH Searches the system path for executables
%   SEARCH_PATH S1 returns the path to the executable S1 if
%   it exist anywhere in the system path.
%
%   S = SEARCH_PATH(S1) returns the results of SEARCH_PATH in 
%   the string S instead of printing it to the screen.  S will 
%   be the string of the executable S1.  You must use the 
%   functional form of SEARCH_PATH when there is an output argument.
%
%   W = SEARCH_PATH(S1,'-all') returns the results of the multiple 
%   search version of SEARCH_PATH in the cell array W.  W will 
%   contain the path strings normally printed to the screen.
%
%   SEARCH_PATH S1 -ALL displays the paths to all executables with 
%   the name S1. The -ALL flag can be used withs all forms of SEARCH_PATH.
%
%   Windows executables must end in .EXE

%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 2003/11/11 22:17:28 $

% this belongs in here if we use the found variable, but I've removed that
%function [where, found ] = search_path(what,switches)
%   [where, found] = SEARCH_PATH(S1) returns the path to the executable if
%   it exist anywhere in the system path, and a boolean value for whether 
%   it was found or not.

if nargin < 2
    switches = '';
end;

% this is something I think all of our functions should have, at least for
% nargin == 0
if nargin == 0 | nargin > 2 | ( nargin == 2 & ~strcmp(switches,'-all') )
    help search_path
    return;
end;

all = strcmp(switches,'-all');
where = {};
%found = false;
token = '';
ext = '';

if ispc
    token = ';';
    ext = '.exe';
elseif isunix
    token = ':';
else
    error('SEARCH_PATH only works on UNIX or Windows');
end;

rem = getenv('PATH');
i=1;
while ~isempty(rem);
    [a_path,rem]=strtok(rem,token);
    % if you want to debug, uncomment this
    % sprintf('Searching for %s', strcat(a_path,filesep,what,ext) )
    if exist(strcat(a_path,filesep,what,ext));
        %found = true;
        if ~all
            where = strcat(a_path,filesep,what,ext);
            rem = '';
        else
            where{i,1} = strcat(a_path,filesep,what,ext);
            i = i + 1;
        end;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x = cell_length( cellarray )
sizeOfCell = size(cellarray);
x = sizeOfCell(1);
