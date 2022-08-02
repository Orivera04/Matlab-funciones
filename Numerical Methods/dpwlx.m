%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dw=dpwlx(a,x)
%       ===================================================================
%       Purpose: Compute derivative of parabolic cylinder function W(a,x)
%                for large argument x (|x| >> |a| and |a| moderate)
%       Input  : a --- Parameter 
%                x --- Argument 
%       Output : dw ------ W'(a,x)                
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
x1=abs(x);
sv1=v(1)/(2.0*x1*x1);
su2=u(1)/(2.0*x1*x1);
fac=1;
dsv1=-2.0*sv1/x1;
dsu2=-2.0*su2/x1;
for  k=3:2:20;
    fac=-k*(k-1)*fac;
    fd=fac*2^k*x1^(2*k);
    fdd=-2.0*k/x1;
    sv1=sv1+v(k)/fd;
    su2=su2+u(k)/fd;
    dsv1=dsv1+fdd*v(k)/fd;
    dsu2=dsu2+fdd*u(k)/fd;
end; 
sv2=0.0;
su1=0.0;
dsv2=0.0;
dsu1=0.0;
fac=1;
for  k=2:2:20;
    fac=-k*(k-1)*fac;
    fd=fac*2^k*x1^(2*k);
    fdd=-2.0*k/x1;
    sv2=sv2+v(k)/fd;
    su1=su1+u(k)/fd;
    dsv2=dsv2+fdd*v(k)/fd;
    dsu1=dsu1+fdd*u(k)/fd;
end; 
s1=1+sv1-su1;
s2=-sv2-su2;
ds1=dsv1-dsu1;
ds2=-dsv2-dsu2;
ea=exp(pi*a);
sea=sqrt(1+ea*ea);
fk=sea-ea;
ifk=sea+ea;
fa=x1*x1/4-a*log(x1)+pi/4+phi2/2;
dfa=x1/2-a/x1;
if (x > 0.0)
    w=sqrt(2.0*fk/x1)*(s1*cos(fa)-s2*sin(fa));
    dw=-w/(2.0*x1)+sqrt(2*fk/x1)*((ds1-s2*dfa)*cos(fa)-(s1*dfa+ds2)*sin(fa));
elseif (x < 0.0)
    xa=-x;
    w=sqrt(2.0*ifk/xa)*(s1*sin(fa)+s2*cos(fa));
    dw=-(-w/(2.0*xa)+sqrt(2*ifk/xa)*((ds1-s2*dfa)*sin(fa)+(s1*dfa+ds2)*cos(fa)));
end;   
