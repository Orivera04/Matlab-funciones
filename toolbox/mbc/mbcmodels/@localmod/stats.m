function out= stats(m,StatsType,varargin);
% LOCALMOD/STATS localmod statistics
%
% out= stats(m,StatsType,varargin);
%   Supported statistics
%    'local' [R2 F prob]
%    'ssedf' [sse df sse_natural]
%    'mse'   mse

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:39:42 $

if nargin>2
   X= code(m,varargin{1});
   y= ytrans(m,varargin{2});
   yhat= eval(m,X);
   r= y- yhat;
else
   Store= get(m,'store');
   if isempty(Store)
      out=[];
      error('LOCALMOD Store not initialised')
   else
      X= Store.X;
      y= Store.y;
      r= Store.r;
   end
end



if nargin>1 
   sse = r'*r;  % Residual sum of squares.
   sst = norm(y-mean(y))^2;     % Total sum of squares.
   ssr = sst-sse;
   nobs = length(y);
   p = size(m,1);
   
   mse = sse/(nobs-p);
   
   R2   = ssr/sst;
   switch lower(StatsType)
   case 'local'
      F    = ssr/(p)/mse;
      prob = 1 - fcdf(F,p,nobs-p);   % Significance probability for regression
      out = [R2,F,prob];
   case 'ssedf'
      ytinv= get(m,'yinv');
      if ~isempty(ytinv)
         yhat= eval(m,X);
         rn= ytinv(y)- ytinv(yhat);
         rn= rn(isfinite(rn));
         if ~isreal(rn)
            rn(imag(rn)~=0)=[];
         end
         ssen = sum(rn.^2);
      else
         ssen= sse;
      end
      out = [sse nobs-p ssen];
   case 'mse'
      out= mse;
   end
end
