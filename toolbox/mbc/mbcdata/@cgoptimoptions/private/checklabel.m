function ok = checklabel(opt, label)
%CHECKLABEL Check to see if the supplied label is unique,
%
%   OK = CHECKLABEL(OPTIONS, LABEL) is a private helper function that
%   checks whether a supplied label is unique.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:54:11 $ 


% Labels are checked for uniqueness against all other labels in the
% optimization
ok = true;

% Free variables
ok = isempty(strmatch(label, getFreeVariables(opt), 'exact'));

if ok
    % Objectives
    info = getObjectives(opt);
    if ~isempty(info)
        ok = isempty(strmatch(label, {info(:).label}, 'exact'));
    end
end

if ok
    % Linear Constraints
    info = getLinearConstraints(opt);
    if ~isempty(info)
        ok = isempty(strmatch(label, {info(:).label}, 'exact'));
    end
end

if ok
    % Model Constraints
    info = getModelConstraints(opt);
    if ~isempty(info)
        ok = isempty(strmatch(label, {info(:).label}, 'exact'));
    end
end

if ok
    % Operating Point sets
    info = getOperatingPointSets(opt);
    if ~isempty(info)
        ok = isempty(strmatch(label, {info(:).label}, 'exact'));
    end
end

if ok
    % Parameters
    info = getParameters(opt);
    if ~isempty(info)
        ok = isempty(strmatch(label, {info(:).label}, 'exact'));
    end
end