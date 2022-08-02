function sqdirichlet(N,f);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Computes eiegenfunctions of the Laplace operator
% on a conformally mapped square domain with Dirichlet 
% conditions using Chebyshev-collocation
%
% -Delta u=lambda u,  u(boundary)=0
%
% N - polynomial truncation
% f - w=f(z) is the symbolic mapping function
%
% Written by: Greg von Winckel - 03/20/05
% Contact:    gregvw@chtm.unm.edu
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N1=N+1;

% Complex variable
z=sym('z','unreal');

% Chebyshev grid
x=cos(pi*(0:N)'/N);

% Construct differentiation matrix
X=repmat(x,1,N1);                   
Xdiff=X-X'+eye(N1);
W=repmat(1./prod(Xdiff,2),1,N1);    
D=W./(W'.*Xdiff); 
D(1:(N1+1):N1^2)=1-sum(D);           
D=-D';
D2=D*D; D2=D2(2:N,2:N);
I=eye(N-1);

% Product grid
[xx,yy]=meshgrid(x,x);

% Complex grid
zz=xx+i*yy;

% Sample Mapping function on grid
F=subs(f,z,zz);
Fz=subs(diff(f,z),z,zz);

Fz2=Fz.*conj(Fz);

% Remove boundary points
Fz2=Fz2(2:N,2:N);

% Laplace operator
L=-kron(D2,I)-kron(I,D2);

[U,lambda]=eigsort(L,diag(Fz2(:)),0);


for k=1:6

u=zeros(N1);
u(2:N,2:N)=reshape(U(:,k),N-1,N-1);

xf=linspace(-1,1,100)';

[xxf,yyf]=meshgrid(xf,xf);
zzf=xxf+i*yyf;
wf=subs(f,z,zzf);

% Interpolate to finer grid
uf=laginterp2d(u,x,x,xf,xf);

% Plot first eigenfunction
subplot(3,2,k)
surf(real(wf),imag(wf),uf);
shading interp;
view(2);
axis tight;
end




function [p]=laginterp2d(f, xn, yn, xf, yf)

[M,N]=size(f);

xn=xn(:); xf=xf(:); yn=yn(:); yf=yf(:);
Mf=length(xf);      Nf=length(yf);

% Compute the barycentric weights
X=repmat(xn,1,M);   Y=repmat(yn,1,N);

% matrix of weights
Wx=repmat(1./prod(X-X.'+eye(M),1),Mf,1);
Wy=repmat(1./prod(Y-Y.'+eye(N),1),Nf,1);

% Get distances between nodes and interpolation points
xdist=repmat(xf,1,M)-repmat(xn.',Mf,1);
ydist=repmat(yf,1,N)-repmat(yn.',Nf,1);

% Find all of the elements where the interpolation point is on a node
[xfixi,xfixj]=find(xdist==0);
[yfixi,yfixj]=find(ydist==0);

% Approximate zeros (easier than exact substitution in 2D)
xdist(xfixi,xfixj)=eps; ydist(yfixi,yfixj)=eps;

Hx=Wx./xdist;
Hy=Wy./ydist;

% Interpolated polynomial
p=(Hx*f*Hy.')./(repmat(sum(Hx,2),1,Nf).*repmat(sum(Hy,2).',Mf,1));



function [Vs,Ds]=eigsort(A,B,pt)

% Sorts the eigenvalues and eigenvectors of Ax=lambda*Bx

N=length(A);

[V,D]=eig(A,B);
Vs=zeros(N);

D=diag(D);
%temp=isfinite(D);
%Vs=Vs(:,temp);
%D=D(temp);

Ds=zeros(N,1);

rad=abs(D-pt);

for j=1:N
    
    [val,dex]=min(rad);
    
    Ds(j)=D(dex);
    Vs(:,j)=V(:,dex);
    Nj1=N-j+1;
    dm1=dex-1; dp1=dex+1;
    range=[1:dm1,dp1:Nj1];
    % delete minimum
    rad=rad(range);
    D=D(range);
    V=V(:,range);
end

