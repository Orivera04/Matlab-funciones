function yhatp= presspred(m,yhat,i);
% xreglinear/PRESSPRED

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:55 $

if nargin > 2
   H= m.Store.H(i);
   y= m.Store.y(i);
else
   H= m.Store.H;
   y= m.Store.y;
end

yhat_t= ytrans(m,yhat);
r= y-yhat_t;
ok= H~=1;
if ~all(ok)
	yhatp= zeros(size(yhat));
	yhatp(ok)= yhat_t(ok) - H(ok).*r(ok)./(1-H(ok));
	yhatp(~ok)= Inf;
else
	yhatp= yhat_t - H.*r./(1-H);
end
yhatp = yinv(m,yhatp);

bd=~isfinite(y);
if any(bd)
   yhatp(bd)= yhat(bd);
end

if ~isreal(yhatp)
	yhatp(abs(imag(yhatp))>eps)= NaN;
	yhatp =real(yhatp);
end


