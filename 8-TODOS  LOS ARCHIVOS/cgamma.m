%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gr,gi]=cgamma(x,y,kf)
%       ===================================================================
%       Purpose: Compute complex gamma function Gamma(z) or Ln[Gamma(z)]
%       Input :  x  --- Real part of z
%                y  --- Imaginary part of z
%                kf --- Function code
%                       kf=0 for Ln[Gamma(z)]
%                       kf=1 for Gamma(z)
%       Output:  gr --- Real part of Ln[Gamma(z)] or Gamma(z)
%                gi --- Imaginary part of Ln[Gamma(z)] or Gamma(z)
%       ===================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This program was inspired by the Matlab program 'specfun' (author 
%  B. Barrowes) which is a direct conversion by 'f2matlab' (author
%  B. Barrowes) of the corresponding Fortran program in 
%  S. Zhang and J. Jin, 'Computation of Special functions' (Wiley, 1966).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  E. Cojocaru, January 2009
%  Observations, suggestions and recommendations are welcome at e-mail:
%   ecojocaru@theory.nipne.ro
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=0.0;
% Bernoulli's numbers B2n divided by [2*n(2*n-1)], n = 1,2,... 
B=[1/12, -1/360, 1/1260, -1/1680, 1/1188,  -691/360360, 7/1092, ...
      -3617/122400, 43867/244188, -174611/125400];  
% Compute firstly Gamma(|x|,sign(x)*y)
if(x < 0.0);
x1=x;
x=-x;
y=-y;
end; 
x0=x;
if(x <= 7.0);
na=fix(7-x);
x0=x+na;
end;  
% Compute log[Gamma(|x|+na,sign(x)*y)] by using relation for |z|>>1:
% log[Gamma(z)]=(z-1/2)*log(z)-z+(1/2)*log(2*pi)+ ...
%     sum{B2n/[2*n*(2*n-1)*z^(2*n-1)]}, where summation is from n=1 to Inf
z1=sqrt(x0*x0+y*y);
th=atan(y/x0);
gr=(x0-0.5)*log(z1)-th*y-x0+0.5*log(2.0*pi);
gi=th*(x0-0.5)+y*log(z1)-y;
for  k=1:10;                                
t=z1^(1-2*k);
gr=gr+B(k)*t*cos((2.0*k-1.0)*th); %  with B(n)=B2n/[2*n*(2*n-1)]
gi=gi-B(k)*t*sin((2.0*k-1.0)*th);
end;  
% Compute log[Gamma(|x|,sign(x)*y)] from log[Gamma(|x|+na,sign(x)*y)]
% by using recurrence relation: Gamma(z+n)=z*(z+1)*...(z+n-1)*Gamma(z)
if(x <= 7.0);
gr1=0.0;
gi1=0.0;
for  j=0:na-1;
gr1=gr1+0.5*log((x+j)^2+y*y);
gi1=gi1+atan(y/(x+j));
end;  
gr=gr-gr1;
gi=gi-gi1;
end;  
% If x < 0, compute log[Gamma(z)] by using relation:
% Gamma(z)*Gamma(-z)=-pi/[z*sin(pi*z)]
if(x1 < 0.0);
z1=sqrt(x*x+y*y);
th1=atan(y/x);
sr=-sin(pi*x)*cosh(pi*y);
si=-cos(pi*x)*sinh(pi*y);
z2=sqrt(sr*sr+si*si);
th2=atan(si/sr);
if(sr < 0.0);
th2=pi+th2;
end;  
gr=log(pi/(z1*z2))-gr;
gi=-th1-th2-gi;
end; 
% Compute Gamma(z) from log[Gamma(z)] by using relations:
% |Gamma(z)|=exp{real{log[Gamma(z)]}}; arg[Gamma(z)]=imag{log[Gamma(z)]}
if(kf == 1);
g0=exp(gr);
gr=g0*cos(gi);
gi=g0*sin(gi);
end;



