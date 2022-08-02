function out = pevSupported(m)
%TWOSTAGE/PEVSUPPORTED overloaded method for twostage models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:07 $


% Get the global models and check they support PEV
gbmd= globalmodels(m);
% And the local model, for a linear reconstruct
lmd= get(m,'local');

% Iterate through the global models
for i=1:length(gbmd)
	ok(i) = pevSupported(gbmd{i});
end

% At the moment (25/09/00) only the localmodels below support PEV
switch lower(class(lmd))
case {'localpspline','localpoly'}
	ok(end+1) = 1;
otherwise
	ok(end+1) = 0;
end

out = all(ok);
