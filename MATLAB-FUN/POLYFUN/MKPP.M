function pp=mkpp(breaks,coefs)
%MKPP	Make piece-wise polynomial.  
%
%	   pp = mkpp(breaks,coefs)
%
%	puts together a pp function from the breaks and coefficients input or
%	requested. The number  l  of polynomial pieces is determined as
%	     l := length(breaks)-1 .
%	The  order  k  of the pp is obtained as
%	     k := length(coefs)/l ,
%	and this ratio had better be an integer. 
%	See also UNMKPP, PPVAL, SPLINE.

%	Carl de Boor 7-2-86
%	Revised 9-30-88 LS
%	Revised 18-nov-93 to use spline toolbox format CB
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if (nargin==0);
   breaks=input('Give the (l+1)-vector of breaks  >');  
   coefs=input('Give the (l by k) matrix of local pol. coefficients  >');
end
   coefs=coefs(:).';lk=length(coefs);l=length(breaks)-1;k=fix(lk/l+100*eps);
if (k<=0)|(l*k~=lk);
   fprintf('The given number %.0f of polynomial pieces is incompatible',l)
   fprintf(' with the total number %.0f of coefficients supplied!\n',lk)
   pp=[];   
else
   pp=[10 1 l breaks(:)' k coefs];
end
