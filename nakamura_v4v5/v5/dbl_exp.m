% function dbl_exp integrates a function named f_name by the 
% double exponential transformation method.
% Copyright S. Nakamura, 1995
function I=dbl_exp(f_name,a,b,n)  
%             a : lower limit of integration
%             b : upper limit of integration
%             h : grid interval
%             n : number of intervals
%             dxdz : dx/dz
%             hcos : hyperbolic cosine
%             hsin : hyperbolic sine
%             I : result of integration  
zmax=3.; h = 2*zmax/n;                     
z = -zmax:h:zmax;  exz = exp( z ); exzi=exz.^(-1);
hcos = (exz + exzi)/2.;   hsin = (exz - exzi)/2.;
s = exp( pi*0.5*hsin ); si=s.^(-1); 
x = (b*s + a*si).*(s + si).^(-1);             
p = pi*hsin/2;   w = exp( p );
dxdz = (b - a)*pi*hcos.*((w + w.^(-1))/2.0).^(-2)/4;
I = h*sum(feval(f_name,x).*dxdz);
      
  

         

