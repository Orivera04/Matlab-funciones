function out=qmaxdist(obj,X)
%QMAXDIST  Direct access to maximum distance function
%
% VAL=QMAXDIST(OBJ,X)  provides direct access to the
% maximum distance mex function.
%
% For maximum interpoint distances calculations on the current set, see MAXDIST.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:56:48 $

out=mx_distance(X,0);