function varargout= stats(m, opt,x,y)
% NNMODEL/STATS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:33 $

switch opt
case 'summary'
   % return nObs
   s(1)= size(x,1);
   % return #weights + #bias
   s(2)= numParams(m);
   % return Box-Cox stats
   s(3)= get(m, 'boxcox');
   
   sse= sum( (y- yinv(m,eval(m,x))).^2 );
   sst= sum((y-mean(y)).^2);
   % return RMSE
   s(4)= sqrt(sse/(s(1)-s(2)));
   % return R^2
   s(5)= (sst-sse)/sst;
   if nargout
      varargout{1}=s;
   end
case 'validate'
   res= (y- yinv(m,eval(m,x)));
   studres= res;
   if nargout
      varargout{1}=res;
      varargout{2}= studres;
   end
end
