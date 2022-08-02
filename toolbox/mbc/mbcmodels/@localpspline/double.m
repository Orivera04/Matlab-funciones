function x=double(qs);
% QUADSPLINE/DOUBLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:41:05 $

plo= qs.polylow(:);
phi= qs.polyhigh(:);
if DatumType(qs)
	x=[qs.knot+datum(qs); plo(end) ; phi(end-2:-1:1); plo(end-2:-1:1)];
else
	x=[qs.knot; plo(end) ; phi(end-2:-1:1); plo(end-2:-1:1)];
end
