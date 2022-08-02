function x = modn(x,n)         %last updated 9/24/93
%MODN  Returns the remainder of x divided by n.
%      x can be a matrix. It is assumed n is a positive integer.
%
%      Use  in the form --> r = modn(x,n)  or  modn(x,n)  <--
%
%  By: David R. Hill, MATH Dept., Temple University
%      Philadelphia, Pa.  19122
mess='>>>>>> Error: n must be a positive integer ';
if n <= 0 | fix(n)~=n
   disp(mess)
   return
end
if all(all(x>=0))
   x = x - (fix(x/n)*n);
else
   k=1+fix(abs(min(min(x)))/n);
   x=k*n+x;
   x = x - (fix(x/n)*n);
end

