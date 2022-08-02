function s = getsize(this)
%GETSIZE  Returns grid size required for plotting data. 
%
%   S = GETSIZE(THIS) returns the plot size needed to render the
%   data (S(1) is the number of rows and S(2) the number of columns).
%   The value [0 0] indicates that the data is invalid, and NaN's 
%   is used for arbitrary sizes.

%   Copyright 1986-2002 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:04 $
s = size(this.SimData);
if s(1)==0
   s = NaN(1,2);
end
