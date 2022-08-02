% This code solves the partial differential equation
%       -u_xx - u_yy + a1 u_x + a2 u_y + a3 u = f.
% It uses gmres with the SSOR preconditioner.
clear;                                   
%  Input data. 
nx = 65;
ny = nx;
hh = 1./nx;
errtol=.0001;
kmax = 200;
a1 = 1.;
a2 = 10.;
a3 = 1.;
ac = 4.+a1*hh+a2*hh+a3*hh*hh;
rac = 1./ac;
aw = 1.+a1*hh;
ae = 1.;
as = 1.+a2*hh;
an = 1.;
%  Initial guess. 
x0(1:nx+1,1:ny+1) = 0.0;                 
x = x0;
h = zeros(kmax);
v = zeros(nx+1,ny+1,kmax);
c = zeros(kmax+1,1);
s = zeros(kmax+1,1);
for j= 1:ny+1
 	for i = 1:nx+1
	    b(i,j) = hh*hh*200.*(1.+sin(pi*(i-1)*hh)*sin(pi*(j-1)*hh));
    end 
end 
rhat(1:nx+1,1:ny+1) = 0.;
w = 1.60;
r = b;
errtol = errtol*sum(sum(b(2:nx,2:ny).*b(2:nx,2:ny)))^.5;
%   This preconditioner is SSOR.
%rhat = ssorpc(nx,ny,ae,aw,as,an,ac,rac,w,r,rhat);
%r(2:nx,2:ny) = rhat(2:nx,2:ny); 
rho = sum(sum(r(2:nx,2:ny).*r(2:nx,2:ny)))^.5;
g = rho*eye(kmax+1,1);
v(2:nx,2:ny,1) = r(2:nx,2:ny)/rho;
k = 0;
%  Begin gmres loop.
while((rho > errtol) & (k < kmax))        
    k = k+1;
%  Matrix vector product.
    v(2:nx,2:ny,k+1) = -aw*v(1:nx-1,2:ny,k)-ae*v(3:nx+1,2:ny,k)-...
                        as*v(2:nx,1:ny-1,k)-an*v(2:nx,3:ny+1,k)+...
                        ac*v(2:nx,2:ny,k);
%   This preconditioner is SSOR.
%rhat = ssorpc(nx,ny,ae,aw,as,an,ac,rac,w,v(:,:,k+1),rhat);
%v(2:nx,2:ny,k+1) = rhat(2:nx,2:ny); 
    %  Begin modified GS. May need to reorthogonalize. 
    for j=1:k                              
        h(j,k) = sum(sum(v(2:nx,2:ny,j).*v(2:nx,2:ny,k+1)));
        v(2:nx,2:ny,k+1) = v(2:nx,2:ny,k+1)-h(j,k)*v(2:nx,2:ny,j);
    end
    h(k+1,k) = sum(sum(v(2:nx,2:ny,k+1).*v(2:nx,2:ny,k+1)))^.5;
    if(h(k+1,k) ~= 0)
         v(2:nx,2:ny,k+1) = v(2:nx,2:ny,k+1)/h(k+1,k);
    end
%  Apply old Givens rotations to h(1:k,k).
    if k>1                                
       for i=1:k-1
         hik        = c(i)*h(i,k)-s(i)*h(i+1,k);
         hipk       = s(i)*h(i,k)+c(i)*h(i+1,k);
         h(i,k)     = hik;
         h(i+1,k)   = hipk;
       end
    end
    nu = norm(h(k:k+1,k));
%  May need better Givens implementation. 
%  Define and Apply new Givens rotations to h(k:k+1,k).    
    if nu~=0                              
        c(k)        = h(k,k)/nu;
        s(k)        = -h(k+1,k)/nu;
        h(k,k)      = c(k)*h(k,k)-s(k)*h(k+1,k);
        h(k+1,k)    = 0;
        gk          = c(k)*g(k) -s(k)*g(k+1);
        gkp         = s(k)*g(k) +c(k)*g(k+1);
        g(k)        = gk;
        g(k+1)      = gkp;
    end
    rho=abs(g(k+1));
    mag(k) = rho;
 end 
%  End of gmres loop.  
%  h(1:k,1:k) is upper triangular matrix in QR.
  y=h(1:k,1:k)\g(1:k); 
%  Form linear combination.
for i=1:k                                 
   x(2:nx,2:ny) = x(2:nx,2:ny) + v(2:nx,2:ny,i)*y(i);
end
k
semilogy(mag)
x((nx+1)/2,(nx+1)/2)
%  mesh(x)
%  eig(h(1:k,1:k))
