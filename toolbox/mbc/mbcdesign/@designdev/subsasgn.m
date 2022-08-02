function newobj = subsasgn(obj, S, data)
% DESIGNDEV/SUBSASGN overloaded subsasign operator

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:04:12 $


% Get the cell array of DesignDev objects
objs = DesignDev2Cell(obj);

% Initially assume we are operating on all the objects unless some
% are specifically mentioned
affectedObjects = 1:count(obj);

% Are some objects specifically mentioned? If so, they are the numeric values
% in S(1).subs{1}. Note '(:)' would fail the isnumeric and so affect all objs 
if S(1).type == '()' 
	if isnumeric(S(1).subs{1})
		affectedObjects = S(1).subs{1};
	end
	% Remove S(1) from the input
	S = S(2:end);
else
	% Here we have come in with something like obj.getConstraints
	% which has the meaning obj(end).getConstraints because of the 
	% way in which designdev objects are stored
	affectedObjects = length(objs);
end
	
% Do we have any more inputs? If not create a DesignDev object where the
% affectedObjects are replaced with data
if isempty(S) & isa(data,'designdev')
%%%%%%%% TO DO - affectedObjects could have length greater than 1
	newobjs = DesignDev2Cell(data);
	objs(affectedObjects) = newobjs;
elseif S(1).type == '.' 
	S2= S(2:end);
	for i = affectedObjects
		switch lower(S(1).subs)
		case 'basemodel'
			objs = i_assignModel(objs, data, i,S2);
		case 'designtree'
			objs = i_assignTree(objs, data, i,S2);
		case 'constraints'
			objs = i_assignConstraints(objs, data, i);
		case 'design'
			objs = i_assignDesign(objs, data, i);
		case 'data'
			objs = i_assignData(objs, data, i, S2);
		case 'currentpoint'
			objs{i}.currentPoint = data;
		case {'getconstraints', 'modifydesign', 'setdesignpoint', 'runexperiment'}
			objs = i_assignCallback(objs, data, i, lower(S(1).subs));
		otherwise
			error('Invalid subsasagn');
		end
	end
end

% Recreate the whole DesignDev object from the cell array of DesignDev objects
newobj = Cell2DesignDev(objs);

%----------------------------------------------
% Subfunction i_assignConstrinaints
%----------------------------------------------
function objs = i_assignConstraints(objs, data, i)

% if ~isa(data, 'des_constraints')
% 	warning('DesignDev constraints field can only be assigned to an object which inherits from des_constraints');
% end
objs{i}.constraints = data;

%----------------------------------------------
% Subfunction i_assignDesign
%----------------------------------------------
function objs = i_assignDesign(objs, data, i)

if isa(data, 'xregdesign')
	objs{i}.design = data;
	% update the design as well
	dtree= objs{i}.DesignTree;
	if ~dtree.chosen
		dtree.chosen= length(dtree.designs)+1;
	end
	dtree.designs{dtree.chosen}= data;
	objs{i}.DesignTree= dtree;
else
	error('DesignDev design field can only be assigned to an object which inherits from design');
end

%----------------------------------------------
% Subfunction i_assignData
%----------------------------------------------
function objs = i_assignData(objs, newData, i, S)
% Note that S represents passing on of subsasgn parameters
if isempty(S)
	objs{i}.data = newData;
else
	data = objs{i}.data;
    % Need to check if data is an object or not because if newData is also and object
    % then subsasgn(data, S, newData) calls class(newData)/subsasgn and not builtin/subsasgn
	if isobject(data)
		objs{i}.data = subsasgn(data, S, newData);
	else
		objs{i}.data = builtin('subsasgn', data, S, newData);
	end
end


%----------------------------------------------
% Subfunction i_assignModel
%----------------------------------------------
function objs = i_assignModel(objs, NewModel, i, S)
% Note that S represents passing on of subsasgn parameters
if isempty(S)
	objs{i} = setmodel(objs{i} , NewModel);
else
	error('subasgn is not defined for a model')
end

%----------------------------------------------
% Subfunction i_assignModel
%----------------------------------------------
function objs = i_assignTree(objs, NewTree, i, S)
% Note that S represents passing on of subsasgn parameters
if isempty(S)
	objs{i}.DesignTree = NewTree;
else
	error('subasgn is not defined for a design tree')
end



%----------------------------------------------
% Subfunction i_assignCallback
%----------------------------------------------
function objs = i_assignCallback(objs, data, i, callback)

%%
%% TO DO - should the user be able to setup a strategy which doesn't 
%%         exist on their own machine?
%%

% Get the strategy object from the data supplied
stratObj = getObjectFromCallback(data);
defParams = defaultParams(stratObj);
% Decompose the callback into a function and some parameters
[func, params] = expandCallback(data);
% If no parameters are supplied then use the default ones
if isempty(params)
	params = defParams;
end
% Make sure the supplied parameters are the same length as the default
if length(params) ~= length(defParams)
	error('Incorrect number of parameters supplied')
end
% 
switch callback
case 'getconstraints'
	objs{i}.getConstraints = i_checkObjectType(stratObj, 'GCStrategy', func, params);
case 'modifydesign'
	objs{i}.modifyDesign   = i_checkObjectType(stratObj, 'MDStrategy', func, params);
case 'setdesignpoint'
	objs{i}.setDesignPoint = i_checkObjectType(stratObj, 'SPStrategy', func, params);
case 'runexperiment'
	objs{i}.runExperiment  = i_checkObjectType(stratObj, 'REStrategy', func, params);
end	

%----------------------------------------------
% Subfunction i_checkObjectType
%----------------------------------------------
function callback = i_checkObjectType(obj, type, func, params)

if ~isa(obj, type)
	error(['Strategy callback must return an object of type ' type]);
end

callback = {func params{:}};
