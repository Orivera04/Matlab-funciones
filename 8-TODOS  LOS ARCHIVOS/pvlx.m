%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function v=pvlx(a,x)
%       ===================================================================
%       Purpose: Compute parabolic cylinder function V(a,x)
%                for large argument x (|x| >> |a| and |a| moderate)
%       Input:   x  --- Argument 
%                a ---  Parameter 
%       Output:  v --- V(a,x)
%       Routine called:
%       'pulx' for computing U(a,x) for large |x|
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
x1=abs(x);
qe=exp(x1*x1/4);
a0=sqrt(2.0/pi)*qe*x1^(a-1/2);
r=1.0;
v=1.0;
for  k=1:20;
r=r*(2.0*k-a-3/2)*(2.0*k-a-1/2)/(2*k*x1*x1);
v=v+r;
if(abs(r/v)< eps)
    break; end;
end; 
v=a0*v;
if(x < 0.0)
    if a < 0&&(a+1/2)==fix(a+1/2)
    v=v*sin(pi*a);
    else
    xa=-x;
    u=pulx(a,xa);
    g0=gamma(a+1/2);
    cp=cos(pi*a)*cos(pi*a);
    v=cp*g0*u/pi+sin(pi*a)*v;
    end; 
end; 

