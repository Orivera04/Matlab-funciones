function LT = change(LT,v);
%CHANGE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:35 $

% Sets the values field of LT to v, the BP field of LT to u
% without affecting the memory field, this is to be used in optimisation.

LT.Values = v;
 

