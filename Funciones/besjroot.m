function rts=besjroot(norder,nrts,tol)
%
% rts=besjroot(norder,nrts,tol)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes an array of positive roots
% of the integer order Bessel functions besselj of 
% the first kind for various orders. A chosen number
% of roots is computed for each order
% norder - a vector of function orders for which
%          roots are to be computed. Taking 3:5
%          for norder would use orders 3,4 and 5.
% nrts   - the number of positive roots computed for
%          each order. Roots at x=0 are ignored.
% rts    - an array of roots having length(norder)
%          rows and nrts columns. The element in
%          column k and row i is the k'th root of
%          the function besselj(norder(i),x).
% tol    - error tolerance for root computation.

if nargin<3, tol=1e-5; end
jn=inline('besselj(n,x)','x','n');
N=length(norder); rts=ones(N,nrts)*nan;
opt=optimset('TolFun',tol,'TolX',tol);
for k=1:N
   n=norder(k); xmax=1.25*pi*(nrts-1/4+n/2);
   xsrch=.1:pi/4:xmax; fb=besselj(n,xsrch);
   nf=length(fb); K=find(fb(1:nf-1).*fb(2:nf)<=0);
   if length(K)<nrts
      disp('Search error in function besjroot')
      rts=nan; return
   else
      K=K(1:nrts);
      for i=1:nrts
         interval=xsrch(K(i):K(i)+1);
         rts(k,i)=fzero(jn,interval,opt,n);
      end
   end
end   