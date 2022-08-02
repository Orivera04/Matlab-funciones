function p=backbusyptr
% BACKGBUSYPTR   Pointer definition file
%
%   PTR=BACKGROUNDBUSYPOINTER returns a matrix of ones, twos and
%   NaNs suitable for using as a custom pointer in MATLAB.
%   The image is of a small pointer with an hourglass, indicating
%   action is occuring in the background but the user is still free
%   to perform some action.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:33:10 $

% Created 29/11/99

p=[ 1   NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;
    1   1   NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;
    1   2   1   NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;
    1   2   2   1   NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;
    1   2   2   2   1   NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;
    1   2   2   2   2   1   NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;
    1   2   2   2   2   2   1   NaN NaN NaN NaN NaN NaN NaN NaN NaN;
    1   2   2   2   2   1   1   1   NaN 1   1   1   1   1   1   1;
    1   2   1   2   2   1   NaN NaN NaN NaN 1   2   2   2   1   NaN;
    1   1   NaN 1   2   2   1   NaN NaN NaN 1   2   1   2   1   NaN;
    1   NaN NaN 1   2   2   1   NaN NaN NaN 1   1   2   2   1   NaN;
    NaN NaN NaN NaN 1   2   2   1   NaN NaN NaN 1   1   1   NaN NaN;
    NaN NaN NaN NaN 1   2   2   1   NaN NaN 1   2   2   2   1   NaN;
    NaN NaN NaN NaN NaN 1   1   NaN NaN NaN 1   2   1   2   1   NaN;
    NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 1   1   2   1   2   NaN;
    NaN NaN NaN NaN NaN NaN NaN NaN NaN 1   1   1   1   1   1   1];

return
      