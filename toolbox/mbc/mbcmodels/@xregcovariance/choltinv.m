function [Wc]= choltinv_cov(c,varargin)
%CHOLTINV

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:04 $

Wc=1;
if ~isempty(c.wfunc)
   % simple weighting function
   w= feval(c.wfunc,c,varargin{:});
   if length(w)<50
      Wc= diag(1./sqrt(w));
   else
      % use sparse matrices if > 100x100
      Wc= spdiags(1./sqrt(w),0,length(w),length(w));
   end
end

if ~isempty(c.cfunc)
   % correlation function
   w= feval(c.cfunc,c,varargin{:});
   d=1;
   if all(isfinite(find(w)))
      [ch,p]= chol(w);
      if p 
         d= sqrt(diag(w));
         if ~any(d==0)
            % chol failed - try scaling first
            if issparse(w)
               d= spdiags(1./d,0,length(w),length(w));
            else
               d= diag(1./d);
            end
            w= d*w*d;
            [ch,p]= chol(w);
            if p
               warning('non finite covariance matrix')
               ch= diag(ones(size(w,1),1))*1e10;
               % ch= i_svdch(w);
            end
         else
            warning('non finite covariance matrix')
            ch= diag(ones(size(w,1),1))*1e10;
         end
      else
         d=1;
      end
   else
      warning('non finite covariance matrix')
      ch= diag(ones(size(w,1),1))*1e10;
   end
   if length(Wc)>1
      Wc= ((d*Wc)/ch)';
   else
      if issparse(w)
         I= d*speye(size(w));
      else
         I= d*eye(size(w));
      end
      Wc= inv(ch)';
   end
end  


function ch= i_svdch(w)

% use svd for singular case
[U,S,V]=svd(w);
n= size(w,1);
tol = n * max(S(:)) * eps;
r = sum(diag(S) > tol);
ch= (U*sqrt(S(:,1:r)))';
