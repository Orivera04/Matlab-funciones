function obj = run(obj, startPoint)
%DESIGNDEV/RUN The iterative DesignDev run procedure

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:04:05 $

% Note at the moment the run procedure has no return variables, hence any changes
% that occur within the procedure a local in scope and do not affect the object
% on which they are called. This may be changed in the future if we want a record
% of the internal working of a run

% Note this procedure is usually run after executing DesignDev/init which
% allows the information about the experiment to be passed to the experimental
% apparatus and allows any misunderstandings to throw errors before actually
% running

if nargin == 2
	obj.currentPoint = startPoint;
end

% Get function handle to the GCStrategy object and any params
[GCobj, params] = getObjectFromCallback(obj.getConstraints);
% Evaluate GCStrategy with current constraints object and extra params
obj = run(GCobj, obj, params{:});

% Second stage is evaluate with an MDStrategy object
[MDobj, params] = getObjectFromCallback(obj.modifyDesign);
obj = run(MDobj, obj, params{:});

% Now itereate through each design point in turn 
while obj.currentPoint <= npoints(obj.design)

	% Log the state of the object
	log(obj, 'log');
	
	% Third stage is to setDesignPoint with SPStrategy
	[SPobj, params] = getObjectFromCallback(obj.setDesignPoint);
	obj = run(SPobj, obj, params{:});

	% Fourth stage is to runExperiment
	[REobj, params] = getObjectFromCallback(obj.runExperiment);
	obj = run(REobj, obj, params{:});
	
	% Fifth stage is to iterate down the chain of designdev objects
	if ~isempty(obj.next)
		obj.next = run(obj.next);
	end
	
	obj.currentPoint = obj.currentPoint + 1;
end

% Reset the current point
obj.currentPoint = 1;