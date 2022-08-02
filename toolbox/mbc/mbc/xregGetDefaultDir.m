function dir = xregGetDefaultDir(type)
%XREGGETDEFAULTDIR returns a default directory for a given type of object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.9.4.2 $  $Date: 2004/02/09 06:49:12 $




% Get the defaults from mbcprefs
fileDefaults = getpref(mbcprefs('mbc'), 'FileDefaults');
% Is therequested type in the fileDefaults structure
if isfield(fileDefaults, type)
	% Get the requested type
	typeDir = fileDefaults.(type);
	% Does typeDir represent a valid directory
	if isequal(exist(typeDir), 7)
		dir = typeDir;
		return
	end
end

% Return an acceptable file default of pwd
dir = pwd;