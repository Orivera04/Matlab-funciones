function y= ceval(c,X,m);
%CONBASE/CEVAL 
%
% y= ceval(c,X,m);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 06:56:54 $

if nargin>2
    % code the data to [-1,1]
    [LB,UB,r] = range(m);
    mid= (LB+UB)/2;
    X= double(X);
    for i= 1:size(X,2);
        X(:,i)= 2*(X(:,i)-mid(i))./r(i);
    end    
else
    X= double(X);
end

y= constraindist(c,X);
if ~isreal(y)
   y(abs(imag(y))>1e-6)=NaN;
   y= real(y);
end

    