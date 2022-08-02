function c= loadobj(c)
%  COVMODEL/LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:22 $

if isa(c,'struct')
   c= xregcovariance(c);
end