function ftsgupdateaxes(hSrc, hVal, hAxes)
%FTSGUPDATEAXES NOT A USER FCN: Updates properties of axes in a figure window.
%
%   This is NOT a user-callable function.  
%
%   This function is a helper function to @FINTS/PLOT.M function.  It lives 
%   in the private directory of the FINTS class.
%

%   Author: P. N. Secakusuma, 23-10-2000
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.2 $   $Date: 2002/01/21 12:27:31 $

set(hAxes, hSrc.name, hVal.newValue)

return

