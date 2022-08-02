function opcregister(option, confirm)
%OPCREGISTER Install and register OPC Foundation Core Components
%   OPCREGISTER installs the OPC Foundation Core Components so that the OPC
%   Toolbox is able to communicate with OPC Servers.
%
%   OPCREGISTER('repair') repairs an existing OPC Foundation Core Components
%   installation. Use this option if you are experiencing problems querying
%   hosts with the OPCSERVERINFO function.
%
%   OPCREGISTER('remove') removes all OPC Foundation Core Components from
%   your workstation. Use this option if you no longer wish to access any
%   servers using OPC.
%
%   NOTE: You must clear any OPC Toolbox objects that you have previously
%         created in this MATLAB session before you can run OPCREGISTER. If
%         you attempt to run OPCREGISTER and OPC Toolbox objects exist, an
%         error will be generated. Use OPCRESET to clear objects from the
%         MATLAB session.
%
%   OPC Foundation Core Components are redistributed under license from
%   the OPC Foundation, http://www.opcfoundation.org.
%
%   See Also OPCRESET

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd
% $Revision: 1.1.6.1 $ $Date: 2004/03/24 20:43:38 $

if nargin<2,
    confirm = false;
else
    if ischar(confirm),
        confirm = any(strcmpi(confirm, {'true','-true'}));
    end
end
if nargin<1,
    option = 'install';
end
if ~ischar(option) || length(option)<2,
    rethrow(mkerrstruct('opc:opcregister:invalidarg'));
end
option(option=='-')=[];

fName = 'OPCCoreComponents2p00Redistributable1.04.msi';
dirName = 'private';
myDir = fileparts(which(mfilename));
fullName = fullfile(myDir, dirName, fName);

if ~strcmpi(option,'install')
    % If there are any objects in memory, error.
    existingObj = opcfind;
    if ~isempty(existingObj),
        rethrow(mkerrstruct('opc:opcregister:objectsexist'));
    end
    % Make sure our mex file isn't accessing the Core Components.
    opcreset; clear opcmex
end

% Locate the MSI Installer
installFullPath = fullfile(getenv('SystemRoot'), 'system32', 'msiexec.exe');
if ~exist(installFullPath, 'file')
    rethrow(mkerrstruct('opc:opcsupport:installernotfound'));
end
switch lower(option)
    case 'repair'
        opt = '/f';
    case 'remove'
        opt = '/x';
    case 'install'
        opt = '/i';
    otherwise
        rethrow(mkerrstruct('opc:opcregister:actioninvalid'));
end

if ~confirm,
    s = input(sprintf([...
        '\nContinuing this operation will modify any OPC Foundation files already installed.\n', ...
        'Type ''Yes'' (exactly as shown) to %s the OPC Foundation files\n\n', ...
        'Confirmation string: '], lower(option)), 's');
    confirm = strcmp(s, 'Yes');
end

if ~confirm
    errMsg = sprintf('Operation not confirmed by the user.\n Expected ''Yes'', got ''%s''', s);
    rethrow(mkerrstruct('opc:opcregister:cancelled', errMsg));
end

% Do not create a log file, since MATLAB cannot read it!
% logFile = fullfile(tempdir, sprintf('OPCRegister%s.log', datestr(now,'YYYYMMDD')))
% dosCmd = sprintf('%s /qb! /liwe %s %s %s', installFullPath, logFile, opt, fullName);
dosCmd = sprintf('%s /qb! %s %s', installFullPath, opt, fullName);
status = system(dosCmd);

errMsg = '';
warnMsg = '';
switch status
    case 0
        warnMsg = '';
    case {3010, 3011}
        warnMsg = sprintf('Changes will not be effective until the system is rebooted.');
    case 1601
        errMsg = sprintf('Microsoft Installer does not support this Install Package.\nPlease contact Microsoft for an updated version.');
    case 1602
        warnMsg = sprintf('Operation cancelled by the user.');
    case 1605
        errMsg = sprintf('OPC Foundation Core Components are not installed.\nPlease run OPCREGISTER with the ''install'' option.');
    otherwise
        % TODO: Add to this warning message.
        warnMsg = sprintf('Installation was not successful. Exit code was %d', status);
end
if ~isempty(errMsg),
    rethrow(mkerrstruct('opc:opcregister:installfailed', errMsg));
end
if ~isempty(warnMsg),
    warning('opc:opcregister:install', warnMsg);
end
