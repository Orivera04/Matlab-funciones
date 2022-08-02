function arrayobj = DesignDev2Cell(obj)
%DESIGNDEV2CELL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 07:04:02 $

if ~isa(obj,'designdev')
	error('Input must be a DesignDev object');
end

% How many array objects do we have?
cnt = count(obj);
% Preallocate the storage space
arrayobj = cell(1,cnt);

% Inverse direction to make objarray compatable with DesignDev indexing
for i = cnt:-1:1
	% Get next object
	next = obj.next;
	% Set next object empty to save space
	obj.next = [];
	% Place object in array
	arrayobj{i} = obj;
	% Get ready for next object
	obj = next;
end