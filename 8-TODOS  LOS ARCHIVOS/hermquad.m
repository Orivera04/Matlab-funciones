function [H0,H1]=hermquad(x)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% hermquad.m
%
% Computes the Hermite Quadrature weights for a set of grid points
%
% -1 <= x_1 < x_2 < ... < x_{N} <= +1
%  
% specified by the column vector x
%
%                 N                 N
%  /\+1          ---               ---
%  |             \                 \
%  |   f(x) dx =  >  H0_j*f(x_j) +  >  H1_j*f'(x_j) + E
%  |             /                 /
% \/-1           ---               ---
%                j=1               j=1
%
% Reference: F. B. Hildebrand, Intoduction to Numerical Analysis 2nd Ed,
%            Dover Publications, New York (1987) page 385
%
% Written by: Greg von Winckel - 10/26/05
% Contact: gregvw(at)math(dot)unm(dot)edu
% URL: http://www.math.unm.edu/~gregvw
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N=length(x); M=2*N;
[xl,wl]=lgwt(M);
L=barylag([x eye(N)], xl);
D=collocD(x);
dX=repmat(xl,1,N)-repmat(x',M,1);
L2=L.^2; 
H0=wl'*(L2-2*dX*diag(diag(D)).*L2);
H1=wl'*(dX.*L2);

function [x,w,L]=lgwt(N)
N=N-1; N1=N+1; N2=N+2;
xu=linspace(-1,1,N1)';
y1=cos((2*(0:N)'+1)*pi/(2*N+2));
y=y1(N1:-1:1);
L=zeros(N1,N2); Lp=zeros(N1,N2);
y0=2;   iter=0;

while max(abs(y-y0))>eps  
    L(:,1)=1;    Lp(:,1)=0;
    L(:,2)=y;    Lp(:,2)=1;
    for k=2:N1
        L(:,k+1)=( (2*k-1)*y.*L(:,k)-(k-1)*L(:,k-1) )/k;
    end
    Lp=(N2)*( L(:,N1)-y.*L(:,N2) )./(1-y.^2);   
    y0=y;
    y=y0-L(:,N2)./Lp;
   iter=iter+1;
end
x=y;
w=2./((1-x.^2).*Lp.^2)*(N2/N1)^2;
L=L(1:N1,1:N1);

function [p]=barylag(data,x)
[Mr,Mc]=size(data);     N=length(x);
X=repmat(data(:,1),1,Mr);
W=repmat(1./prod(X-X.'+eye(Mr),1),N,1);
xdist=repmat(x,1,Mr)-repmat(data(:,1).',N,1);
[fixi,fixj]=find(xdist==0);
xdist(fixi,fixj)=NaN;
H=W./xdist;
p=(H*data(:,2:Mc))./repmat(sum(H,2),1,Mc-1);
p(fixi,:)=data(fixj,2:Mc);

function D=collocD(x);
N=length(x); N1=N+1; N2=N*N;
X=repmat(x,1,N);                    Xdiff=X-X'+eye(N);
W=repmat(1./prod(Xdiff,2),1,N);    
D=W./(W'.*Xdiff); 
D(1:N1:N2)=1-sum(D);                D=-D';

