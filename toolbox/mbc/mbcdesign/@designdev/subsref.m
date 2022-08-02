function result = subsref(obj,S)
% DESIGNDEV/SUBSREF subsreference operator on designdev objects
%
% Possible subsref formats are :
%
% obj.field returns the outer level information i.e. same
%     as obj(end).field
%
% obj(i).field returns the information at level i
%
% obj([i j]).field returns a cell array containg levels [i j]
%     information where local or level 1 is i = 1 and global 
%     level is i = length(obj)
%
% obj([i j k]) returns an designdev object with the levels reordered
%     according to [i j k]

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:04:13 $


% Get the cell array of DesignDev objects
objs = DesignDev2Cell(obj);

% Are some objects specifically mentioned? If so, they are the numeric values
% in S(1).subs{1}. Note '(:)' would fail the isnumeric and so affect all objs 
if S(1).type == '()'
   if isnumeric(S(1).subs{1})
	   objs = objs(S(1).subs{1});
   end
	% Remove S(1) from the input
   S = S(2:end);
else
	% Here we have come in with something like obj.getConstraints
	% which has the meaning obj(end).getConstraints because of the 
	% way in which designdev objects are stored
	objs = objs(end);
end

% If there are no more inputs we are returning a reduced DesignDev object
% so reconstruct from the cell array
if isempty(S)
	result = Cell2DesignDev(objs);
% If there is a 'dot' then this is a field request, so switch on the field
% requested and return in a cell array
elseif  S(1).type == '.'
	result = cell(1,length(objs));
	S2 = S(2:end);
	for i = 1:length(objs)
		switch lower(S(1).subs)
		case 'basemodel'
			result{i} = getModel(objs{i});
		case 'designtree'
			result{i} = objs{i}.DesignTree;
		case 'constraints'
			result{i} = objs{i}.constraints;
		case 'design'
			result{i} = objs{i}.design;
		case 'currentpoint'
			result{i} = objs{i}.currentPoint;
		case 'data'
			result{i} = objs{i}.data;
		case 'channelnames'
			result{i} = channelNames(objs{i});
		case 'getconstraints'
			result{i} = objs{i}.getConstraints;
		case 'modifydesign'
			result{i} = objs{i}.modifyDesign;
		case 'setdesignpoint'
			result{i} = objs{i}.setDesignPoint;
		case 'runexperiment'
			result{i} = objs{i}.runExperiment;
		otherwise
			error('Invalid subsref argument');
		end
		if ~isempty(S2)
			result{i}= subsref(result{i},S2);
		end
	end
	% If result is a 1x1 cell then remove cell wrapper
	if iscell(result) & length(result) == 1
		result = result{1};
	end
else
	if ~isempty(S) 
		result = subsref(result,S);
	end
end

