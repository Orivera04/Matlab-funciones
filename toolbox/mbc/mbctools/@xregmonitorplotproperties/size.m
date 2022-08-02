function [s] = size(obj, dim)
%SIZE A short description of the function
%
%  OUT = SIZE(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:19:20 $ 

s = size(obj.plots);
if nargin > 1
   s = s(dim);
end