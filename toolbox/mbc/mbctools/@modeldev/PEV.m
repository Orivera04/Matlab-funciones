function y= PEV(mdev,X);
%PEV prediction error variance
%
% y= PEV(mdev,X);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:09:46 $

y= pev(model(mdev),X);
