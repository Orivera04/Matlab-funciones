function obj = Log(obj, action, varargin)
%LOG

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:15 $

persistent currentState
persistent logFilename
persistent logServer
persistent logMethod
persistent logProgID

if nargin < 2
	action = 'log';
end

switch lower(action)
case 'clear'
	currentState = [];
	if exist(logFilename) == 2
		delete(logFilename)
	end
	logFilename = '';
	return
case 'release'
	if ~isempty(logServer)
		release(logServer)
		logServer = [];
		logProgID = [];
	end
case 'server'
	progID = varargin{1};
	if ~isempty(logServer)
		if strcmp(logProgID, progID)
			return
		else
			release(logServer)
		end
	end
	logMethod = varargin{2};
	logServer = actxserver(progID);
	logProgID = progID;
case 'file'
	filename = varargin{1};
	[path, name, ext] = fileparts(filename);
	if isempty(ext)
		ext = '.mat';
	end
	filename = fullfile(path, [name ext]);
	logFilename = filename;
	return
case 'restore'
	if ~isempty(logFilename)
		load(logFilename);
		obj = currentState;
	end
	return
case 'log'
	if ~isempty(logFilename)
		lObj = count(obj);
		if lObj > length(currentState)
			currentState = obj;
		else
			S.type = '()';
			S.subs = {1:lObj};
			currentState = subsasgn(currentState, S, obj);
		end
		save(logFilename, 'currentState');
	end
case 'message'
	if ~isempty(logServer)
		message = varargin{1};
		invoke(logServer, logMethod, [datestr(now) ' : ' message]);
	end
otherwise
	error('Unknown action requested');
end