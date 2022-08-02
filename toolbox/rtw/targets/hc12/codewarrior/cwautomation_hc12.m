%CWAUTOMATION_HC12  Code Warrior automation for HC12.
%
%   This file uses COM automation and invokes the necessary methods via
%   MATLAB's Activex support to invoke Metrowerks CodeWarrior for:
%       - Invoking CodeWarrior (e.g. start a new CodeWarrior session)
%       - Open a CodeWarrior MCP project file
%       - "Clean up" (e.g. delete) old object files
%       - Build the project to create a binary
%       - Execute the binary on the target board. This includes
%         downloading to the target board.
%
%   Usage:  
%        cwautomation_hc12('C:\mydir\RTW_ICD12_MC9S12DP256.mcp','build')
%
%   Arguments:
%        in_qualifiedMCP -- Path and filename (with extension) for CodeWarrior
%                           project file. 
%                           Example: 'C:\mydir\ICD12_MC9S12DP256.mcp'
%        action          -- Keywork string indicating which project action
%                           to perform. 
%                          
%                           Supported actions:
%                             'none'
%                             'closeall'
%                             'open'
%                             'build'
%                             'run'
%                             'close'
%                             'execute'

%   Copyright 2002-2003 The MathWorks, Inc.
%   $File: $
%   $Revision: 1.1.6.3 $
%   $Date: 2004/04/19 01:23:30 $

% =========================================================================
function varargout = cwautomation_hc12(varargin)
%
% Argument handling
%
switch nargin
  case 1
    in_qualifiedMCP  = char(varargin(1));
    % Default action is to open the project
    action           = 'open';	
  case 2
    in_qualifiedMCP  = varargin{1};
    action           = varargin{2};
  otherwise
    error([mfilename, ' supports either one or two input arguments.']);  
end
  
% Set verbosity for vprint messages
vprint(0) % off
% vprint(1) % on


% Support for the following "Build Actions":
%
%  'none'     -- Ignores CodeWarrior completely. Does not open CodeWarrior or any projects.
%  'closeall' -- Closes all open project files.
%  'open'     -- Opens CodeWarrior, opens the specified MCP project file. 
%  'build'    -- Same as 'open' + deletes object files + builds.
%  'run'      -- Same as 'build' + downloads to the target board + starts
%                execution of the generated code on the target.
%  'close'    -- Closes the CodeWarrior session and exits CodeWarrior.
%  'execute'  -- Build and then execute the generated code on the target.  

switch action
  case 'none'
    vprint('No action requested');
    return

  case 'closeall'
    CloseAll;
    return;

  case 'open'
    ICodeWarriorApp = OpenCW;
    return;

  case 'build'
    ICodeWarriorApp = BuildCW(in_qualifiedMCP);
    return;

  case 'execute'  
    ICodeWarriorApp = BuildCW(in_qualifiedMCP);
    ExecuteCW(ICodeWarriorApp);
    return;

  case 'kill'
    % Create a COM connection to CodeWarrior (This starts codewarrior)
    ICodeWarriorApp = CreateCWComObject;
    try
      invoke(ICodeWarriorApp,'Quit', 1);
    catch
      error(['Error using COM connection to close CodeWarrior']);
    end
    return;

  otherwise
    error([mfilename ' does not provide a method for ' action]);
    return;
end % end switch
 

% =========================================================================
% Function: OpenCW
% Abstract: Opens CodeWarrior without opening a project. Returns the
%           handle ICodeWarriorApp.
%
function ICodeWarriorApp = OpenCW()
  ICodeWarriorApp = CreateCWComObject;
  CloseAll;
  OpenMCP(in_qualifiedMCP);


% =========================================================================
% Function: BuildCW
% Abstract: Opens CodeWarrior.
%           Opens the specified CodeWarrior project.
%           Deletes objects.
%           Builds. 
%
function ICodeWarriorApp = BuildCW(in_qualifiedMCP)
    % ICodeWarriorApp = BuildCW;
    ICodeWarriorApp = CreateCWComObject;
    CloseAll;
    OpenMCP(in_qualifiedMCP);
    try
      ICodeWarriorApp.DefaultProject.RemoveObjectCode(0,1)  
    catch
      error(['Error using COM connection to remove objects of current project. ' ... 
       'Verify that CodeWarrior is installed correctly. Verify COM access to CodeWarrior outside of MATLAB.']);
    end
    try
      ICodeWarriorApp.DefaultProject.BuildAndWaitToComplete;
    catch
      error(['Error using COM connection to build current project. ' ...
       'Verify that CodeWarrior is installed correctly. Verify COM access to CodeWarrior outside of MATLAB.']);
    end


% =========================================================================
% Function: vprint
% Abstract: Conditionally displays messages depending on whether initially
%           called with the argument '0', or '1'.  
%
function vprint(string)
  persistent verbose;

  if isnumeric(string)
    if string == 0
    verbose = 0;
    else
      verbose = 1;
    end
    return;
  end;
  
  if isstr(string)
    if verbose
      disp(string)
    end
  end
  
  
% =========================================================================
% Function: CreateCWComObject
% Abstract: Creates the COM connection to CodeWarrior 
%
function ICodeWarriorApp = CreateCWComObject
  vprint([mfilename ': creating CW com object']);
  try
    ICodeWarriorApp = actxserver('CodeWarrior.CodeWarriorApp');
  catch
    error(['Error creating COM connection to ' ComObj ...
       '. Verify that CodeWarrior is installed correctly. Verify COM access to CodeWarrior outside of MATLAB.']);
  end
  return;
  

% =========================================================================
% Function: CloseAll
% Abstract: Closes all currently 'open' projects in CodeWarrior. 
%
function CloseAll
  ICodeWarriorApp = CreateCWComObject;
  vprint([mfilename ': Closing DefaultProject']);
  try
    % close projects until there are none and try ends
    while (1 == 1)
      r = ICodeWarriorApp.DefaultProject.Close;
    end
  catch
    lasterr('');
  end
  return;
  
  
% =========================================================================
% Function: OpenMCP
% Abstract: open an MCP project file 
%
function OpenMCP(in_qualifiedMCP)
  % Argument checking. This method requires valid project file. 
  if ~exist(in_qualifiedMCP)
      error([mfilename ': Missing or empty project file argument']);
  end
  if isempty(in_qualifiedMCP)
      error([mfilename ': Missing or empty project file argument']);
  end
  ICodeWarriorApp = CreateCWComObject;
  vprint([mfilename ': Importing']);
  try
    ICodeWarriorProject = ...
      invoke(ICodeWarriorApp.Application,...
      'OpenProject', in_qualifiedMCP,...
      1,0,0); 
  catch
    error(['Error using COM connection to import project. ' ...
       ' Verify that CodeWarrior is installed correctly. Verify COM access to CodeWarrior outside of MATLAB.']);
  end  
  

% =========================================================================
% Function: CleanCW
% Abstract: Delete object files.
%
function status = CleanCW
  vprint([mfilename ': cleaning']);
  ICodeWarriorApp = CreateCWComObject;
  try
    ICodeWarriorApp.DefaultProject.RemoveObjectCode(0,1);
  catch
    error(['Error using COM connection to remove objects of current project. ' ... 
       'Verify that CodeWarrior is installed correctly. Verify COM access to CodeWarrior outside of MATLAB.']);
  end
  return;
 
  
% =========================================================================
% Function: ExecuteCW
% Abstract: Execute generated code in the specified project.
%  
function ExecuteCW(ICodeWarriorApp)
  try
    r = ICodeWarriorApp.DefaultProject.BuildWithOptions(0,2);
  catch
    error(['Error using COM connection to build current project. ' ...
       'Verify that CodeWarrior is installed correctly. Verify COM access to CodeWarrior outside of MATLAB.']);
  end

% EOF