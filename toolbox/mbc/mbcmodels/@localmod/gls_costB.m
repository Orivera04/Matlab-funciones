function [res,J,YHAT]= gls_costB(B,L,DATA,Wc,Scale,c0,optparams)
% LOCALMOD/GLS_COSTB generalised least-squares cost function for localmod coefficients
% 
% [res,J,YHAT]= gls_costB(B,L,DATA,Wc)
%   B    from lsqnonlin
%   L    local model
%   DATA [X,Y] sweepset
%   Wc   where (Wc'*Wc) = inv( cov(L,X) ) / sigma^2;

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:39:08 $

if nargin<6
   c0=1;
end

B= reshape(B,size(L,1),size(DATA,3));
if nargin>4
   B= Scale*B;
end

Ns= size(DATA,3);
if nargin<4 | isempty(Wc)
   Wc=cell(Ns,1);
end
res= DATA(:,1);
if ~isa(DATA,'sweepset')
   DATA={DATA};
   res= {res};
end
YHAT= cell(Ns,1);
J= cell(Ns,1);

for i=1:Ns;
   
   d= DATA{i};
   Xs= d(:,1:end-1);
   Ys= d(:,end);
   
   L= update(L,B(:,i));
   dat= datum(L);
   for j=1:length(dat)
      Xs(:,j)= Xs(:,j)-dat(j);
   end
   wc= Wc{i};
   if ~isempty(wc) & size(Xs,1)~=size(wc,1)
      yhat= eval(L,Xs);
      if isTBS(L)
         yhat= ytrans(L,yhat);
      end
      wc= choltinv(L.covmodel,yhat,Xs);
   end
   
   % calculate residuals
   if nargout>1
      [r,Ji,YHAT{i}]= lsqcost(L,Xs,Ys,wc);
      if nargin>4
         Ji=Ji*Scale;
      end
      J{i}= Ji;
   else
      r= lsqcost(L,Xs,Ys,wc);
   end
   res{i}=r;

end   
if nargout<3
   % output for lsqnonlin
   res = double(res)/c0;
   
   % deal with nonfinite residuals
   ir= isfinite(res);
   if ~all(ir)
      res(~ir)= 10/sqrt(length(res));
   end
   % deal with complex residuals
   if ~isreal(res)
      ir= abs(imag(res))>1e-6;
      res(ir)= 10/sqrt(length(res));
      res= real(res);
   end
   if nargout==2
      % jacobian as sparse block diagonal
      J  = spblkdiag(J{:});
      J= J/c0;
   end
end


