function y= eval(U,x);
% xregusermod/EVAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:03 $

y= feval(U.funcName,U,x);

if ~isreal(y)
	ind = find(imag(y)~=0);
	y(ind)=NaN;
end