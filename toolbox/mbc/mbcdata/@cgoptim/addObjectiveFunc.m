function optim = addObjectiveFunc(optim, objectiveFuncLabel)
%ADDOBJECTIVEFUNC Add a new obejctive to the optimization
%
%  OPTIM = ADDOBJECTIVEFUNC(OPTIM, LABEL) adds a new objective labelled
%  with the given LABEL.  If LABEL is omitted, a default will be chosen
%  that is unique from other objectives.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.3 $    $Date: 2004/04/04 03:26:03 $

if ~optim.canaddobjectiveFuncs
    error('Cannot increase the number of objectives in this optimization');
end

if nargin < 2
    objectiveFuncLabel = sprintf('Objective%d', length(optim.objectiveFuncLabels)+1);
else
    if ~ischar(objectiveFuncLabel)
        error('objectiveFuncLabel must be a string');
    end
end


optim.objectiveFuncLabels{end+1} = objectiveFuncLabel;

% allow new objectives to be either min or max (default min)
canswitchminmax = 1;
optim.objectiveFuncs = [optim.objectiveFuncs xregpointer(cgobjectivefunc(objectiveFuncLabel, '', canswitchminmax))];
