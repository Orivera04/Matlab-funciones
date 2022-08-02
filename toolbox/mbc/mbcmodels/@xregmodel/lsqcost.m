function [r,J,yhat]= lsqcost(m,x,y,Wc,varargin);
% MODEL/LSQCOST
%
% [r,yhat,J]= lsqcost(m,x,y,Wc);
%   m   model object
%   x   coded x values
%   y   ytrans
%   Wc, the weights, are optional
% Outputs
%   r    residuals (weights and TBS adjusted)
%   yhat estimated (transformed)
%   J    jacobian (is not calculated if nargout<3)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:30 $

yhat= eval(m,x);
if nargout>1
   J= jacobian(m,x,1,yhat);
end

% deal with TBS
if m.TransBS & ~isempty(m.ytrans)
   yhat= ytrans(m,yhat);
end

r= y-yhat;


% modify residuals and jacobian by weights
if nargin>3 & ~isempty(Wc)
   nr=length(r);
   if size(Wc,1)~=nr
		c= covmodel(m);
		if ~isempty(c)
			% recalculate covariance model
			Wc = choltinv(covmodel(m),yhat,x);
		else
			Wc = 1;
		end
   end
   r= Wc*r;
   if nargout>1
      J= Wc*J;
   end
end



