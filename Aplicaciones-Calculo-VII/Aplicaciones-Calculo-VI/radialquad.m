function [r,w,P,Bs,Ds,Dp]=radialquad(N,k,R)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% radialquad.m - Radial Quadrature Rules and Spectral Method Matrices
%
% Computes the nodes and weights for numerically solving integrals 
% of the form
%
%  /R 
%  |  f(r) r^k dr
%  /0
%
% on N grid points. Exact to machine precision for f(r) as a polynomial of
% order 2N-1 or less. Constructs Vandermonde and
% Integration/Differentiation matrices for Radial differential equations. 
%
% Inputs:
%
% N - number of grid points
% k - Order of radial weight term
% R - radius or radial domain
%
% Outputs:
%
% r  - radial grid points
% w  - quadrature weights
% P  - Radial Jacobi Vandermonde matrix
% Bs - Spectral Tau integration matrix
% Ds - Spectral Tau differentiation matrix
% Dp - Pseudospectral differentiation matrix
%
% Usage:
%
% [r,w,P,Bs,Ds,Dp]=radialquad(N,k,R)
%
% Written by: Greg von Winckel - 07/14/05
% Contact: gregvw(at)chtm(dot)unnm(dot)edu
% 
%--------------------------------------------------------------------------
% 
% References: 
%
% 1) The radial quadrature is adapted from two scripts by Walter Gautschi,
%    which may be found here:
%
% http://www.cs.purdue.edu/archives/2002/wxg/codes/OPQ.html
%
% 2) The Tau matrices are detailed in the paper:
%
% "Integration preconditioners for differential operators in spectral tau-
% methods" by E. A. Coutsias, T. Hagstrom, J. S. Hesthaven, and D. Torres. 
% Houston Journal of Mathematics p.21-38 (1996)
%
% Which is available here:
% 
% http://math.unm.edu/~vageli/papers/ico.ps
%
% 3) Information regarding "one-sided" Jacobi bases for radial problems
%    can be found in:
%
% J. P. Boyd, "Chebyshev and Fourier Spectral Methods. Second Ed. (Rev)"
% Dover Books (2001). See section 18.5.1 beginning on page 387
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compute Nodes and Weights
k1=k+1; k2=k+2; 
n=1:N;  nnk=2*n+k;
A=[k/k2 repmat(k^2,1,N)./(nnk.*(nnk+2))];
n=2:N; nnk=nnk(n);
B1=4*k1/(k2*k2*(k+3)); nk=n+k; nnk2=nnk.*nnk;
B=4*(n.*nk).^2./(nnk2.*nnk2-nnk2);
ab=[A' [(2^k1)/k1; B1; B']]; s=sqrt(ab(2:N,2));
[V,X]=eig(diag(ab(1:N,1),0)+diag(s,-1)+diag(s,1));
[X,I]=sort(diag(X));    

R2=R/2;

% Grid points
r=R2*(X+1); 

% Quadrature weights
w=R2^(k1)*ab(1,2)*V(1,I)'.^2;

% Vandermonde matrix
P=zeros(N,N);
a1=zeros(N,1); a2=a1;  a3=a1;  a4=a1;

n=(0:(N-1))';   twon=2*n;
twonk=twon+k;   twonk1=twon+k1;   twonk2=twon+k2;

a1(n+1)=2*(n+1).*(n+k1).*twonk;
a2(n+1)=twonk1.*(-k^2);
a3(n+1)=twonk.*twonk1.*twonk2;
a4(n+1)=2*n.*(n+k).*twonk2;

P(:,1)=1;
P(:,2)=(-k+k2*(2*r/R-1))/2;
    
for j=2:(N-1)
    P(:,j+1)=(a2(j)+a3(j).*(2*r/R-1)).*P(:,j)/a1(j)...
        -a4(j)*P(:,j-1)/a1(j);
end

% Tau Integration matrix
j1=(0:N-2)'; j2=(1:N)';   j3=(1:N-1)';

band1=2*(j1+k1)./((2*j1+k2).*(2*j1+k1));
band2=-2*k./((2*j2+k2).*(2*j2+k));
band3=-2*j3./((2*j3+k1).*(2*j3+k));

band2=[0;band2(1:N-1)];   band3=[0;band3(2:N-1)];

Bs=R2*(diag(band1,-1) + diag(band2) + diag(band3,1));  

% Tau (spectral) Differentiation matrix
Ds=zeros(N); Ds(1:N-1,2:N)=Bs(2:N,1:N-1)\eye(N-1);

% Pseudospectral (pointspace) Differentiation matrix
N1=N+1; N2=N*N;
X=repmat(r,1,N);                    Xdiff=X-X'+eye(N);
W=repmat(1./prod(Xdiff,2),1,N);    
Dp=W./(W'.*Xdiff); 
Dp(1:N1:N2)=1-sum(Dp);              Dp=-Dp';

