function num_rows = getnumrowsoppoint(optim, varargin);
% cgoptim/getnumrowsoppoint
% Return the number of rows in an input operating point set
% num_rows = getnumrowsoppoint(optim, 'dataset1');

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:53:22 $

% start : a few sanity checks
if isempty(optim.oppoints)
    error('mbc:cgoptim:InvalidState', 'getOppoint : There are no oppoints to access');
end

if nargin > 1
    datasetname = varargin{1};
    % now get the index to the requested (or default = 1) dataset
    dsind = find(strcmp(lower(datasetname), lower(optim.oppointLabels)));
else
    dsind = 1;
end


if isempty(dsind)
    errstr = ['getOppoint: Cannot find operating point set labelled, ', datasetname, ', in the optimization'];
    error('mbc:cgoptim:InvalidState', errstr);
end

% return the requested dataset
datasetptr = optim.oppoints(dsind); 
num_rows = datasetptr.get('numpoints');
