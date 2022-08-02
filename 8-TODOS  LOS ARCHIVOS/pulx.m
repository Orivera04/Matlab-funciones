%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function u=pulx(a,x)
%       ===================================================================
%       Purpose: Compute parabolic cylinder function U(a,x)
%                for large argument x (|x| >> |a| and |a| moderate)
%       Input:   x --- Argument 
%                a --- Parameter 
%       Output:  u --- U(a,x)
%       Routine called:
%       'pvlx' for computing V(a,x) for large |x|
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
eps=1.0e-15;
qe=exp(-x*x/4);
a0=qe*abs(x)^(-a-1/2);
r=1.0;
u=1.0;
for  k=1:20;
r=-r*(2.0*k+a-1/2)*(2.0*k+a-3/2)/(2*k*x*x);
u=u+r;
if(abs(r/u)< eps)
    break; end;
end; 
u=a0*u;
if(x < 0.0)
    if a < 0&&(a+1/2)==fix(a+1/2)
    u=-u*sin(pi*a);
    else
    x1=-x;
    v=pvlx(a,x1);
    g0=gamma(a+1/2);
    u=pi*v/g0-sin(pi*a)*u;
    end; 
end; 
