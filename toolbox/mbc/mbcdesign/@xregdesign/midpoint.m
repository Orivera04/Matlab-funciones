function pt=midpoint(d)
% MIDPOINT  return the center point for a design object
%
%  PT=MIDPOINT(D) returns the point at the center of the
%  design candidate space.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:07 $

% Created 19/9/2000

lims=designlimits(d);
lims=cat(1,lims{:});

pt=(sum(lims,2).*0.5)';
return