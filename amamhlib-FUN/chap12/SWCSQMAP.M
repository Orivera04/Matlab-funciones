function [z,a]=swcsqmap(zeta,ntrms,ifout)
%
% [z,a]=swcsqmap(zeta,ntrms,ifout)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function evaluates power series 
% approximations for mapping either the inside 
% of a circle onto the inside of a square, or 
% mapping the outside of a circle onto the 
% outside of a square. The Schwarz-Christoffel 
% integrals defining the mapping functions are 
% expanded in Taylor series and are truncated 
% to produce approximations in the following 
% polynomial forms:
%
%   For the interior problem:
%     z=sum(a(n)*zeta^(4*n-3),n=1:ntrms) 
%
%   For the exterior problem:
%     z=sum(a(n)*zeta^(-4*n+5),n=1:ntrms) 
%
% The side length of the square is adjusted 
% to equal 2.
% 
% zeta  - complex values where the mapping 
%         function is evaluated
% ntrms - number of terms used in the 
%         truncated series
% ifout - a parameter omitted if an interior 
%         map applies.  ifout can have any 
%         value (such as 1) to show that an 
%         exterior map is to be performed.  
%
% z     -  values of the mapping function
% a     -  coefficients in the mapping series
%
% User m functions called:  none
%----------------------------------------------

n=0:ntrms-2;
if nargin==2   % recursion formula for mapping 
               % interior on interior
   p1=(n+1/2)./(n+1); p2=(n+1/4)./(n+5/4);
else           % recursion formula for mapping 
               %exterior on exterior
   p1=(n-1/2)./(n+1); p2=(n-1/4)./(n+3/4);
end
a=[1,cumprod(-p1.*p2)]; a=a(:)/sum(a); 
z4=zeta.^4;
if nargin ==3, z4=1./z4; end; 
z=zeta.*polyval(flipud(a(:)),z4);