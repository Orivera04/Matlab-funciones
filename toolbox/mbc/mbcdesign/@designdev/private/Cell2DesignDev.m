function obj = Cell2DesignDev(arrayobj)
%CELL2DESIGNDEV

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:04:01 $

% Are we ar the end of the array
if ~isempty(arrayobj)
	% Ensure the object is a DesignDev object
	if ~isa(arrayobj{end},'designdev')
		error('Input must be an array of DesignDev objects');
	end
	% Create this object and it's next property
	obj = arrayobj{end};
	
	obj.next = Cell2DesignDev(arrayobj(1:end-1));
else
	obj = [];
end