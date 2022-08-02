function varargout = opctool(fileName)
%OPC Toolbox Graphical User Interface 
%   OPCTOOL opens the OPC Toolbox Graphical User Interface (GUI). The GUI
%   allows you to graphically browse the contents of an OPC server, view
%   server item properties, as well as create and configure OPC Toolbox
%   clients, groups and items. The GUI can also be used to read and write
%   OPC data, configure and start a logging session and export logged data
%   to the workspace. 
%
%   Clients, groups and items configured using the OPC Toolbox GUI can be
%   exported to the workspace, to a MAT-file or as an OPC Session File
%   which can be imported into the GUI at a later stage.
%
%   OPCTOOL(SessionName) opens the OPC Toolbox GUI and loads a previously
%   saved OPC Session File. SessionName is the name of the OPC Session File
%   to load. If an extension is not specified in SessionName, .olf is used.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd 
% $Revision: 1.1.6.3 $  $Date: 2004/03/24 20:44:56 $

try
    opcVer = opcmex('version');
catch
    rethrow(lasterror);
end
if nargin == 1
    % The user specified a session file name
    [pathStr,fName,fExt] = fileparts(fileName);
    if isempty(fExt)
        fileName = [fileName, '.osf'];
        [pathStr,fName,fExt] = fileparts(fileName);
    end
    % Try to get the full path to the file
    aFileName = which(fileName);
    if isempty(aFileName)
        % which cannot find the file
        if isempty(pathStr)
            % The file must be in the current directory
            fileName = fullfile(pwd,fileName);
        else
            % cd to the directory, get the pwd and cd back
            oldDir = cd;
            cd(pathStr);
            fileName = fullfile(pwd,[fName,fExt]);
            cd(oldDir);
        end
    else
        % which returned the file
        fileName = aFileName;
    end
    [pathStr,fName,fExt] = fileparts(fileName);
    if ~exist(fileName,'file')
        error('opc:opctool:nofile', ...
            '%s does not exist or is not on the path.', fileName);
    end
    % Launch the GUI, and open the session file
    h = com.mathworks.toolbox.opc.OPCTool(opcVer, pathStr, fileName);
else
    % No session file, just launch the GUI
    h = com.mathworks.toolbox.opc.OPCTool(opcVer, pwd);
end
% Return output arguments if requested
if nargout == 1
    varargout{1} = h;
end
