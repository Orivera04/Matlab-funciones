function [a,om]=ellipgen(nx,hx,ny,hy,G,F,bx0,bxn,by0,byn)
% Function either solves:
%
% (ë2/ëx2+ë2/ëy2)*z+G(x,y)*z=F(x,y) over a rectangular region.
%
% Function call: [a,om]=ellipgen(nx,hx,ny,hy,G,F,bx0,bxn,by0,byn)
% hx, hy are panel sizes in x and y directions, 
% nx, ny are number of panels in x and y directions.
% F and G are (ny+1,nx+1) arrays representing F(x,y), G(x,y).
% bx0 and bxn are row vectors of boundary conditions at x0 and xn.
% each beginning at y0. Each is (ny+1) elements. 
% by0 and byn are row vectors of boundary conditions at y0 and yn.
% each beginning at x0. Each is (nx+1) elements.
% Array a is an (ny+1,nx+1) array of solutions, including the boundary values.
% om has no interpretation in this case.
%
% or the function solves
%
% (ë2/ëx2+ë2/ëy2)*z+lambda*G(x,y)*z=0 over a rectangular region.
%
% Function call: [a,om]=ellipgen(nx,hx,ny,hy,G,F)
% hx, hy are panel sizes in x and y directions, 
% nx, ny are number of panels in x and y directions.
% G are (ny+1,nx+1) arrays representing G(x,y).
% In this case F is a scalar and specifies the eigenvector to be returned in array a.
% Array a is an (ny+1,nx+1) array giving an eigenvector, including the boundary values.
% The vector om lists all the eigenvalues lambda.
%
nmax=(nx-1)*(ny-1); r=hy/hx;
a=zeros(ny+1,nx+1); p=zeros(ny+1,nx+1);
if nargin==6
  case=0;
  mode=F;
end
if nargin==10
  test=0;
  if F==zeros(ny+1,nx+1), test=1; end
  if bx0==zeros(1,ny+1), test=test+1; end
  if bxn==zeros(1,ny+1), test=test+1; end
  if by0==zeros(1,nx+1), test=test+1; end
  if byn==zeros(1,nx+1), test=test+1; end
  if test==5
    disp('WARNING - problem has trivial solution, z = 0.')
    disp('To obtain eigensolution use 6 parameters only.')
    break
  end  
  bx0=bx0(1,ny+1:-1:1); bxn=bxn(1,ny+1:-1:1);
  a(1,:)=byn; a(ny+1,:)=by0;
  a(:,1)=bx0'; a(:,nx+1)=bxn';
  case=1;
end
for i=2:ny
  for j=2:nx
    nn=(i-2)*(nx-1)+(j-1);
    q(nn,1)=i; q(nn,2)=j; p(i,j)=nn;
  end
end
C=zeros(nmax,nmax); e=zeros(nmax,1); om=zeros(nmax,1);
if case==1, g=zeros(nmax,1); end  
for i=2:ny
  for j=2:nx
    nn=p(i,j); C(nn,nn)=-(2+2*r^2); e(nn)=hy^2*G(i,j);
    if case==1, g(nn)=g(nn)+hy^2*F(i,j); end
    if p(i+1,j)~=0
      np=p(i+1,j); C(nn,np)=1;
    else
      if case==1, g(nn)=g(nn)-by0(j); end
    end
    if p(i-1,j)~=0
      np=p(i-1,j); C(nn,np)=1;
    else
      if case==1, g(nn)=g(nn)-byn(j); end
    end
    if p(i,j+1)~=0
      np=p(i,j+1); C(nn,np)=r^2;
    else
      if case==1, g(nn)=g(nn)-r^2*bxn(i); end
    end
    if p(i,j-1)~=0
      np=p(i,j-1); C(nn,np)=r^2;
    else
      if case==1, g(nn)=g(nn)-r^2*bx0(i); end
    end
  end
end
if case==1
  C=C+diag(e);
  z=C\g;
  for nn=1:nmax
    i=q(nn,1); j=q(nn,2);
    a(i,j)=z(nn);
  end
else
  [u,lam]=eig(C,-diag(e));
  [om,k]=sort(diag(lam));
  u=u(:,k);
  for nn=1:nmax
    i=q(nn,1); j=q(nn,2);
    a(i,j)=u(nn,mode);
  end
end
