function [names, units] = channelNames(obj, affectedObjects, newNames, newUnits)
%CHANNELNAMES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:59 $

ALL_OBJECTS  = nargin == 1;
RETURN_NAMES = nargin <= 2;
NO_UNITS     = nargin <  4;

% Have they specified the affectedObjects, and if not it's all objects
if ALL_OBJECTS
	affectedObjects = 1:length(obj);
end

SINGLE_LEVEL = length(affectedObjects) == 1;

if RETURN_NAMES
	[allNames, allUnits] = i_getChannelNames(obj, affectedObjects);
	% Get the requested names from all the names. Note that this might reorder
	% the outputs as requested
	names = allNames(affectedObjects);
	units = allUnits(affectedObjects);
	% If only one level is selected then unwrap one cell layer to 
	% return a 1 x nFactors cell array
	if SINGLE_LEVEL
		names = names{1};
		units = units{1};
	end
else
	WRAP_CELL = SINGLE_LEVEL & ~iscell(newNames{1});
	if NO_UNITS
		if WRAP_CELL
			newUnits = [];
		else
			newUnits = cell(size(newNames));
		end
	end
	% If only one level is being changed then ensure thst newNames and newUnits
	% have 2 cell layers by suitable wrapping
	if WRAP_CELL
		newNames = {newNames};
		newUnits = {newUnits};
	end    
	obj = i_setChannelNames(obj, affectedObjects, newNames, newUnits);
	% Copy to output argument
	names = obj;
end


%----------------------------------------------
% Subfunction i_getChannelNames
% 
% A recursive function which returns the channel names
% and units from a designdev object
%----------------------------------------------
function [names, units] = i_getChannelNames(obj, affectedObjects)

% Get the level of this DesignDev oject
level = count(obj);
% Are there any below this one
if ~isempty(obj.next)
	[names, units] = i_getChannelNames(obj.next, affectedObjects);
end
% Set the output to an empty matrix
name = [];
unit = [];
% If this level has been requested then get the info
if any(level == affectedObjects)
	info = xinfo(model(obj.design));
	name = info.Names;
	unit = info.Units;
end
% Append the data to the output
names{level,1} = name;
units{level,1} = unit;

%----------------------------------------------
% Subfunction i_setChannelNames
%
% A recursive function which sets the appropriate names
% and units of a designdev object
%----------------------------------------------
function obj = i_setChannelNames(obj, affectedObjects, newNames, newUnits)

% Get the level of this DesignDev oject
level = count(obj);
% Get index into affected objects
index = find(affectedObjects == level);
% Are the more than two indicies that match
if length(index) > 1
	error(['Multiple assignment of channel names to DesignDev level ' num2str(level)]);
elseif length(index) == 1
	% Get the current model and info
	m = model(obj.design);
	info = xinfo(m);
	% Set the new names and units if there are some
	info.Names = newNames{index};
	if ~isempty(newUnits{index})
		info.Units = newUnits{index};
	end
	% Update the model in the design
	obj.design = model(obj.design, xinfo(m, info));
end

if ~isempty(obj.next)
	obj.next = i_setChannelNames(obj.next, affectedObjects, newNames, newUnits);
end


