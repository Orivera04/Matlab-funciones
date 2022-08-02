function y=fbeval(U,b,x);
%LOCALMOD/FBEVAL evaluate function with parameters b and inputs x
% 
% y=fbeval(U,b,x);
% This function can be used with numjac

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:38:58 $

nb= size(U,1);
Ns= size(x,3);
B= reshape(b,nb,Ns);
y= cell(1,Ns);
for i=1:Ns
    U    = update(U,B(:,i));
    y{i} = eval(U,x{i});
end
y= cat(1,y{:});