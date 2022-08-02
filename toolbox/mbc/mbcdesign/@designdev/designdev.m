function obj =  designdev(varargin)
%DESIGNDEV is the constructor function for a design container object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:01 $

% Created 12/10/2000

% The Constraints object to be used with this DesignDev object


% this is in design object
%  should this be a list of all constraint parameters? 
obj.constraints = des_constraints;

% The Design object and model to be used with this DesignDev object
m= xregcubic('nfactors',1);
des= designobj(m);

% delete this field and reference design in design tree structure ? 
obj.design = des;

% General data field to hold information that will be used in the
% initialisation phases of the experiment
obj.data = [];

% Field to hold the current point that a designdev has reached
obj.currentPoint = 1;

% design tree structure for use in design editor
obj.DesignTree= struct('designs',{{des}},...
	'parents',0,...
	'chosen',1);

obj.ConstraintType = 'constant';  % 'constant|fitdata|otherdata'

%-------------------------------------------------------
% The strategy objects of a DesignDev object
%-------------------------------------------------------

% The getConstraints object handle
obj.getConstraints = {'GCStrategy'};

% The modifyDesign object handle
obj.modifyDesign = {'MDStrategy'};

% The setDesignPoint object handle
obj.setDesignPoint = {'SPStrategy'};

% The runExperiment object handle
obj.runExperiment = {'REStrategy'};

% Next object in the designdev list
obj.next = [];



% Allow first input parameter to be next in designdev list
if length(varargin) > 0
	input = varargin{1}(:);
	if isa(input,'designdev')
		obj.next = input(1);
	else
		error('DesignDev requires one designdev object as input')
	end
end

% Create the class
obj = class(obj,'designdev');