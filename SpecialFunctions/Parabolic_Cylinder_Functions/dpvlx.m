%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dv=dpvlx(a,x)
%       ===================================================================
%       Purpose: Compute derivative of parabolic cylinder function V(a,x)
%                for large argument x (|x| >> |a| and |a| moderate)
%       Input:   x  --- Argument 
%                a ---  Parameter 
%       Output:  dv --- V'(a,x)
%       Routine called:
%       'dpulx' for computing U'(a,x) for large |x|
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
x1=abs(x);
qe=exp(x1*x1/4);
s0=sqrt(2.0/pi);
q0=x1^(a-1/2);
dqe=x1*qe/2.0;
dq0=(a-1/2)*x1^(a-3/2);
r1=1.0; 
r2=1.0;
sv1=1.0;
sv2=0.0;
for  k=1:20;
ak=(2.0*k-a-3/2)*(2.0*k-a-1/2)/(2.0*k);
r1=r1*ak/(x1*x1);
r2=r2*ak;
s2=-2.0*k/x1^(2.0*k+1);
sv1=sv1+r1;
sv2=sv2+r2*s2;
end; 
dv=s0*((qe*dq0+dqe*q0)*sv1+qe*q0*sv2);
if(x < 0.0)
    if a < 0&&(a+1/2)==fix(a+1/2)
    dv=-dv*sin(pi*a);
    else
    xa=-x;
    du=dpulx(a,xa);
    g0=gamma(a+1/2);
    cp=cos(pi*a)*cos(pi*a);
    dv=-(cp*g0*du/pi+sin(pi*a)*dv);
    end; 
end;


