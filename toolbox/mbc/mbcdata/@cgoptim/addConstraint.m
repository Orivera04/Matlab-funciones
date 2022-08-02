function optim = addConstraint(optim, varargin);
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 06:52:52 $

% Increase the number of constraints by one 
% optim = addConstraint(optim); adds a default new Constraint
% optim = addConstraint(optim, ConstraintLabel); adds a new Constraint labelled ConstraintLabel

if ~optim.canaddconstraints
    error('Cannot increase the number of constraints in this optimization');
end

if nargin < 2
    % need to invent a unique Label
    UniqueLabelFound = false;
    n = 1;
    while( ~UniqueLabelFound )
        ConstraintLabel = sprintf( 'Constraint%d', n );
        if ~ismember( ConstraintLabel, optim.constraintLabels )
            UniqueLabelFound = true;
        else
            n = n + 1;
        end
    end
else
    if ~isstr(varargin{1})
        error('ConstraintLabel must be a string');
    end
    ConstraintLabel = varargin{1};
end


optim.constraintLabels{end+1} = ConstraintLabel;

% create the conmod which will be wrapped by an xregpointer
conmod = [];
constraint = cgconstraint(ConstraintLabel, conmod, optim.values, 'dist');
optim.constraints = [optim.constraints xregpointer(constraint)];
