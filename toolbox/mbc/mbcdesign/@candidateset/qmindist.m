function out=qmindist(obj,X)
%QMINDIST  Direct access to minimum distance function
%
% VAL=QMINDIST(OBJ,X)  provides direct access to the
% minimum distance mex function.
%
% For minimum interpoint distances calculations on the current set, see MINDIST.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:56:49 $

out=mx_distance(X,1);