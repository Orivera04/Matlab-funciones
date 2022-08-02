function A=arbquad(x)

%**************************************************************************
%
% arbquad.m - quadrature for an arbitrary grid
%
% This script computes weights corresponding to an arbitrary grid for
% numerical integration. Note: If many grid points are desired, this 
% routine will work substantially better if the grid points are clustered
% near the boundary similar to the zeros of orthogonal polynomials.
% 
% Example:
% x=linspace(0,1,6);
% w=arbquad(x);
% err=w'*exp(x)-exp(1)+exp(0); % error is 4.8453e-07 for this example
% 
% Written by: Greg von Winckel - 05/02/05
% Contact: gregvw(at)chtm(dot)unm(dot)edu
%
%**************************************************************************

x=sort(x(:));   N=length(x);
a=min(x);       b=max(x);

[xl,wl]=lgwt(N+4,a,b);
L=lagrange(x,xl);
A=L*wl;

%==========================================================================

function [x,w,L]=lgwt(N,a,b)

N=N-1; N1=N+1; N2=N+2;
xu=linspace(-1,1,N1)';

% Initial guess
y1=cos((2*(0:N)'+1)*pi/(2*N+2));
y=y1;

% Legendre-Gauss Vandermonde Matrix
L=zeros(N1,N2);

% Derivative of LGVM
Lp=zeros(N1,N2);

% Compute the zeros of the N+1 Legendre Polynomial
% using the recursion relation and the Newton-Raphson method

y0=2;

% Iterate until new points are uniformly within epsilon of old points
while max(abs(y-y0))>eps
   
    L(:,1)=1;    Lp(:,1)=0;
    L(:,2)=y;    Lp(:,2)=1;
    
    for k=2:N1
        L(:,k+1)=( (2*k-1)*y.*L(:,k)-(k-1)*L(:,k-1) )/k;
    end
 
    Lp=(N2)*( L(:,N1)-y.*L(:,N2) )./(1-y.^2);   
    
    y0=y;
    y=y0-L(:,N2)./Lp;
   
end

% Linear map from[-1,1] to [a,b]
x=(a*(1-y)+b*(1+y))/2;      

% Compute the weights
w=(b-a)./((1-y.^2).*Lp.^2)*(N2/N1)^2;

%==========================================================================

function L=lagrange(x,xl)

% Get number of nodes
n=length(x);

% use this finer mesh for interpolating between nodes
N=length(xl);

x=x(:);

X=repmat(x,1,n);

% Compute the weights
w=1./prod(X-X'+eye(n),2);

xdiff=repmat(xl.',n,1)-repmat(x,1,N);

% find all the points where the difference is zero
zerodex=(xdiff==0); 

% See eq. 3.1 in Ref (1)
lfun=prod(xdiff,1);

% kill zeros
xdiff(zerodex)=eps;

% Compute lebesgue function
L=diag(w)*repmat(lfun,n,1)./xdiff;