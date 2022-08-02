%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function w=pwlx(a,x)
%       ===================================================================
%       Purpose: Compute parabolic cylinder function W(a,x)
%                for large argument x (|x| >> |a| and |a| moderate)
%       Input  : a --- Parameter 
%                x --- Argument 
%       Output : w ------ W(a,x)                
%       Routine called:
%               'cgamma' for computing complex Gamma function
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
u=zeros(1,100);
v=zeros(1,100);
[r0,i0]=cgamma(1/2,a,0);
phi2=i0;
[gr0,gi0]=cgamma(1/2,a,1);
den=gr0*gr0+gi0*gi0;
for  k=2:2:40;
m=fix(k/2);
[gr,gi]=cgamma(k+1/2,a,1);
uk=(gr*gr0+gi*gi0)/den;
vk=(gr0*gi-gr*gi0)/den;
u(m)=uk;
v(m)=vk;
end;  
sv1=v(1)/(2.0*x*x);
su2=u(1)/(2.0*x*x);
fac=1;
for  k=3:2:20;
    fac=-k*(k-1)*fac;
    fd=fac*2^k*x^(2*k);
    sv1=sv1+v(k)/fd;
    su2=su2+u(k)/fd;
end;
sv2=0.0;
su1=0.0;
fac=1;
for  k=2:2:20;
    fac=-k*(k-1)*fac;
    fd=fac*2^k*x^(2*k);
    sv2=sv2+v(k)/fd;
    su1=su1+u(k)/fd;
end;
s1=1+sv1-su1;
s2=-sv2-su2;
ea=exp(pi*a);
sea=sqrt(1+ea*ea);
fk=sea-ea;
ifk=sea+ea;
x1=abs(x);
fa=x1*x1/4-a*log(x1)+pi/4+phi2/2;
if (x > 0.0)
    w=sqrt(2.0*fk/x1)*(s1*cos(fa)-s2*sin(fa));
elseif (x < 0.0)
    xa=-x;
    w=sqrt(2.0*ifk/xa)*(s1*sin(fa)+s2*cos(fa));
end;   
