function [p,yhat]=pev(m,x,Natural);
% NNMODEL/PEV evaulate pev 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:29 $

if nargin<=2 | Natural
   x= code(m,x);
end

yhat= yinv(m,eval(m,x));
p= yhat;p(:)=NaN;
if ~isreal(p)
   p(abs(imag(p))>1e-6)=NaN;
   p= real(p);
end
if nargout>1 & ~isreal(yhat)
   yhat(abs(imag(yhat))>1e-6)=NaN;
   yhat= real(yhat);
end