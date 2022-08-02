function y= eval(p,x);
% POLYNOM/EVAL  Evaluate polynomial

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:40:20 $




c= double(p); 
y = polyval_mex(c,x);

