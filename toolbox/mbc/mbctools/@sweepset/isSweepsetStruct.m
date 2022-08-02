function OK = isSweepsetStruct(ss, in)
%SWEEPSET/ISSWEEPSETSTRUCT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:06:27 $



OK = 0;
if ~isstruct(in)
	return
end
fields = fieldnames(in);
requiredFields = {'varNames' 'data'};
% Are all the required fields there
if ~all(ismember(requiredFields, fields))
	return
end
% Is data double and of the correct size & is varNames a cell array of strings
if ~isnumeric(in.data) | size(in.data, 2) ~= length(in.varNames)
	return
end
if ~iscell(in.varNames) | ~all(cellfun('isclass', in.varNames, 'char'))
	return
end
OK = 1;
