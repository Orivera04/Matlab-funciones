function pp=mmspmath(a,op,b)
%MMSPMATH Mathematics on 1-D Spline Piecewise Polynomials. (MM)
% MMSPMATH(PP1,'op',PP2) performs the mathematical operation 'op'
% on the spline piecewise polynomials PP1 and PP2 and returns the
% resulting piecewise polynomial.
% 'op' is one of the following: '+', '-', '*'
%
% If all breakpoints of PP1 and PP2 match, '+' and '-' operations
% are performed without approximation and the '*' operation is
% approximated by constructing a new cubic spline having the proper
% function values and slopes at the breakpoints.
% If some breakpoints of PP1 and PP2 do NOT match, all operations
% are performed by evaluating the PP1 and PP2 at the union of their
% breakpoints, performing the requested operation, then fitting a new
% cubic spline to the resulting data.
%
% MMSPMATH(K,'op',PP) or MMSPMATH(PP,'op',K) where K is a scalar
% performs the designated scalar-piecewise polynomial operation.
% Scalar operations are performed without approximation.
%
% See also MMSPHELP

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 8/20/99, 9/28/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin~=3
   error('Incorrect Number of Input Arguments.')
end
if ~ischar(op) | isempty(find(op=='+-*'))
   error('Second Argument Must be ''+'', ''-'', or ''*''')
end
[errmsga,ppa]=mmspchk(a);
[errmsgb,ppb]=mmspchk(b);
if ~ppa & ppb
   [breaks,coefs,npolys,ncoef,dim]=unmkpp(b);
   if dim>1
      error('MMSPMATH Not Written for Multidimensional Splines.')
   end
   switch op(1)
   case '+'
      coefs(:,ncoef)=a(1)+coefs(:,ncoef);
   case '-'
      coefs=-coefs;
      coefs(:,ncoef)=a(1)+coefs(:,ncoef);
   case '*'
      coefs=a(1)*coefs;
   end
   pp=mkpp(breaks,coefs);
elseif ppa & ~ppb
   [breaks,coefs,npolys,ncoef,dim]=unmkpp(a);
   if dim>1
      error('MMSPMATH Not Written for Multidimensional Splines.')
   end
   switch op(1)
   case '+'
      coefs(:,ncoef)=coefs(:,ncoef)+b(1);
   case '-'
      coefs(:,ncoef)=coefs(:,ncoef)-b(1);
   case '*'
      coefs=coefs*b(1);
   end
   pp=mkpp(breaks,coefs);
elseif ~ppa & ~ppb
   error('At Least One Input Must be a Piecewise Polynomial.')
else
   [bra,ca,npa,nca,dima]=unmkpp(a);
   [brb,cb,npb,ncb,dimb]=unmkpp(b);
   if dima~=1 | dimb~=1
      error('MMSPMATH Not Written for Multidimensional Splines.')
   end
   x=[bra brb];
   if (length(bra)==length(brb))& all(abs(bra-brb)<=eps*max(abs(x)))
      switch op(1)
      case '+'
         nc=max(nca,ncb);
         coefs=[zeros(npa,nc-nca) ca]+[zeros(npb,nc-ncb) cb];
         pp=mkpp(bra,coefs);
      case '-'
         nc=max(nca,ncb);
         coefs=[zeros(npa,nc-nca) ca]-[zeros(npb,nc-ncb) cb];
         pp=mkpp(bra,coefs);
      case '*'
         [ya,dyal,dyar]=mmspget(a,'y','dyl','dyr');
         [yb,dybl,dybr]=mmspget(b,'y','dyl','dyr');
         y=ya.*yb;
         dyl=yb(1:end-1).*dyal + ya(1:end-1).*dybl;
         dyr=yb(2:end).*dyar + ya(2:end).*dybr;
         pp=mmhermite(bra,y,dyl,dyr);
      end
   else % breakpoints don't match
      x=mmunique(x);
      ya=mmppval(a,x);
      yb=mmppval(b,x);
      switch op(1)
      case '+'
         pp=spline(x,ya+yb);
      case '-'
         pp=spline(x,ya-yb);
      case '*'
         pp=spline(x,ya.*yb);
      end
   end
end




