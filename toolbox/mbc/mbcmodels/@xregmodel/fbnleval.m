function y=fbnleval(U,b,x);
% MODEL/FBNLEVAL evaluate function with parameters nonlinear b and inputs x
% 
% y=fbnleval(U,b,x);
% This function can be used with numjac

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:52 $

U= nlupdate(U,b);
y= eval(U,x);