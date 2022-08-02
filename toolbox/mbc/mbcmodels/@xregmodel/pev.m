function [p,yhat]=pev(m,x,Natural,varargin);
% MODEL/PEV evaulate pev 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:52:48 $

if nargin<=2 | Natural
   x= code(m,x);
end

if isnumeric(x)
	nc= size(x,1);
    % when calculating the size of the chunks, cope with size(m,1)==0
    np= ceil( 1e6/max( size( m, 1 ), 1 ) );
	niter=floor(nc./np);
	nover=rem(nc,np);	
	
	p= zeros(nc,1);
	for n=1:niter
		
		lns= (1:np)+(n-1).*np;
		p(lns)= evalpev(x(lns,:),m,varargin{:});
	end
	if nover
		% last load of points (<10000)
		lns= (1:nover)+(niter).*np;
		p(lns)= evalpev(x(lns,:),m,varargin{:});
	end
else
	p= evalpev(x,m,varargin{:});
end

if nargout>1 | ~isempty(m.ytrans)
	yhat= eval(m,x);
	if ~isempty(m.yinv)
		dy= yinvdiff(m,yhat);
		p= dy.^2.*p;
		yhat= yinv(m,yhat);
	elseif m.TransBS & ~isempty(m.ytrans)
		ws= warning;
		warning off
		% Calculate inverse transformation using symbolic toolbox
		m.yinv   = finverse(sym(m.ytrans));
		warning(ws)
		yt = ytrans(m,yhat);
		dy= yinvdiff(m,yt);
		p= dy.^2.*p;
	end
end
if ~isreal(p)
   p(abs(imag(p))>1e-6)=NaN;
   p= real(p);
end
p(p<0)=NaN;
if nargout>1 & ~isreal(yhat)
   yhat(abs(imag(yhat))>1e-6)=NaN;
   yhat= real(yhat);
end