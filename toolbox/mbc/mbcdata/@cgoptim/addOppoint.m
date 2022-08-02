function optim = addOppoint(optim, varargin);
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:52:54 $

% Increase the number of operating point sets by one
% optim = addOppoint(optim); adds a default new data set
% optim = addOppoint(optim, OppointLabel); adds a new Oppoint labelled OppointLabel

if ~optim.canaddoppoints
    error('Cannot increase the number of data sets in this optimization');
end

if optim.canaddoppoints==2 % if 0 or 1 data sets are allowed
    if length(optim.oppointLabels) == 1
        error('Cannot increase the number of data sets in this optimization');
    end
end

if nargin < 2
    OppointLabel = ['OperatingPointSet' num2str(length(optim.oppointLabels)+1)];
else
    if ~isstr(varargin{1})
        error('OppointLabel must be a string');
    end
    OppointLabel = varargin{1};
end


optim.oppointValueLabels{end+1} = {};
optim.oppointValues{end+1} = [];

optim.oppointLabels{end+1} = OppointLabel;

optim.oppoints = [optim.oppoints xregpointer];
