function y=fbeval(U,b,x);
% xregusermod/FBEVAL evaluate function with parameters b and inputs x
% 
% y=fbeval(U,b,x);
% This function can be used with numjac

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:08 $

U= update(U,b);
y= eval(U,x);