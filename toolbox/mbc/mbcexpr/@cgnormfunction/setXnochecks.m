function LT = setXnochecks(LT,x)
%SETXNOCHECKS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:15:09 $

% Sets the x argument in the LUT LT to x
% NO CHECKS ARE DONE AND NO UPDATES OF THE NORMALISERS FLIST ARE MADE!
% To be used when the pointer to LT is unavailable (e.g. in the loadobj of cglookupone)

LT.Xexpr = x;





