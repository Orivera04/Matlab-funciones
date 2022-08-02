function ss = struct2sweepset(oldss, in)
%STRUCT2SWEEPSET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:11:37 $



% The input in is a structure generated from a call to sweepset2struct
fields = fieldnames(in);

% Use required fields to create the sweepset
ss = sweepset('Variable', [], [], in.varNames, [], [], [], double(in.data));

% Check optional fields exist before using
if ismember('varUnits', fields) & ~isempty(in.varUnits)
	set(ss, 'units', in.varUnits(:));
end

if ismember('varDescriptions', fields) & ~isempty(in.varDescriptions)
	set(ss, 'descript', in.varDescriptions(:));
end

if ismember('comment', fields)
	ss.comment = in.comment;
end

if ismember('filename', fields)
	ss.number = in.filename;
end
