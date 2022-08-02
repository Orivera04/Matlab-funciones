function d= parameters(L);
% POLYNOM/PARAMETERS absolute parameter values

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:39 $

% shift polynom parameters back to zero datum
L= shift(L,-datum(L));
d= double(L);