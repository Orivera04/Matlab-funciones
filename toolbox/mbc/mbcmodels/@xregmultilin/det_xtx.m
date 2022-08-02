function d=det_xtx(m)
%xreglinear/DET_XTX   Determinant of X'X
%   d=DET_XTX(m) calculates |X'X| for the model m

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:21 $

d=det_xtx(get(m,'currentmodel'));