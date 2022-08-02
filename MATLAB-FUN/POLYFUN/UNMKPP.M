function [breaks,coefs,l,k]=unmkpp(pp)
%UNMKPP	Supply details about piecewise polynomial.
%
%	    [breaks,coefs,l,k] = unmkpp(pp)
%
%	takes apart the  pp  function into its pieces.
%	See also MKPP, SPLINE, PPVAL.

%	Carl de Boor 7-2-86
%	Revised 19-nov-93 to match spline toolbox format CB
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if (pp(1)==10)
   l=pp(3); breaks=pp(3+[1:l+1]);
   k=pp(5+l); coefs=reshape(pp(5+l+[1:k*l]),l,k);
else
   error('the input array does not seem to describe a pp function')
end

