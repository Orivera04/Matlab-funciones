function J= jacobian(m,x,IsCoded,yhat)
% MODEL/JACOBIAN 
% 
% J= jacobian(m,x,IsCoded,yhat)
%    m       :model object
%    x       :X data
%    IsCoded : optional boolean (default 0)
%    yhat    : optional fitted values used when TBS is on. If these are not supplied
%              they are calculated

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:25 $

if nargin<3 | ~IsCoded
   x= code(m,x);
end

J= CalcJacob(m,x);

if m.TransBS & ~isempty(m.ytrans)
   if nargin<4
      yhat = eval(m,x);
   end
   dy   = ydiff(m,yhat);
   if issparse(J) | length(yhat)>100
      % use sparse matrices
      J= spdiags(dy,0,length(yhat),length(yhat))*J;
   else
      % us full 
      J= diag(dy)*J;
   end
end



