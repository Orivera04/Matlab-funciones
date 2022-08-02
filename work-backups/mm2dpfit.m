function p=mm2dpfit(x,y,z,a,b,c)
%MM2DPFIT 2D Polynomial Curve Fitting. (MM)
% MM2DPFIT(X,Y,Z,Nx,Ny) fits the data in X,Y,Z to 2D polynomials
% in X and Y having orders Nx and Ny respectively.
% X, Y, and Z must all be the same size where Z(i)=f(X(i),Y(i)).
%
% MM2DPFIT(X,Y,Z,W,Nx,Ny) weights the data using W. W(i) is the 
% weight associated with X(i), Y(i), and Z(i). All elements of W
% must be positive.
%
% X and Y can be the plaid output of MESHGRID.
%
% The polynomial fit contains terms up to X^Nx and Y^Ny and all
% possible crossproduct terms X^iY^j where i<=Nx, j<=Ny and
% i+j<=max(Nx,Ny). This corresponds to terms in the Taylor series
% expansion of a function of two variables.
% Example: Nx=2, Ny=2, gives the quadratic form:
% p(1) + p(2)X + p(3)X^2 + p(4)Y + p(5)XY + p(6)Y^2
%
% Nx=3, Ny=4 gives:
% Y^0 terms:  p(1)     + p(2)X     + p(3)X^2     + p(4)X^3 +
% Y^1 terms:  p(5)Y    + p(6)XY    + p(7)X^2Y    + p(8)X^3Y +
% Y^2 terms:  p(9)Y^2  + p(10)XY^2 + p(11)X^2Y^2 + 
% Y^3 terms:  p(12)Y^3 + p(13)XY^3
% Y^4 terms:  p(14)Y^4
%
% The returned vector is formed as [Nx Ny p].
%
% Warning: Fitting to high order 2D polynomials is numerically
% sensitive. Use this function with caution.
%
% See also MM2DP2P,MM2DPADD,MM2DPCHK,MM2DPDER,MM2DPINT,MM2DPSTR,MM2DPVAL,MM2DPXY.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 12/6/96, v5: 1/14/97 5/30/97, 11/18/98
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==5
   nx=a; ny=b; w=[];
elseif nargin==6
   w=a(:); nx=b; ny=c;
   if any(w<=eps)
      error('Weights Must be Positive.')
   end
else
   error('Incorrect Number of Input Arguments.')
end
if length(nx)~=1 | length(ny)~=1 | nx<1 | ny<1
   error('Nx and Ny Must be Greater Than 0.')
end
x=x(:);
y=y(:);
z=z(:);
nrow=length(x);
if nrow~=length(y) | nrow~=length(z) | (~isempty(w) & (nrow~=length(w)))
   error('X, Y, Z and W Must be the Same Size.')
end

if nx>=ny               % number of columns in each power of Y
   ncy=nx+1:-1:nx-ny+1;
elseif nx<ny
   ncy=min(ny+1:-1:1,nx+1);
end
cy=[1 cumsum(ncy)+1];   % columns where powers of Y change
ncol=cy(end)-1;         % total number of coefficients

if nrow<ncol
   error(sprintf('At Least %.0f Data Points are Required.',ncol))
end
X=ones(nrow,ncol);      % allocate space for x and y data
Y=X;
X(:,2)=x;
for i=3:ncy(1)          % build first Vandermonde section for X
   X(:,i)=X(:,i-1).*x;
end
yy=repmat(y,1,ncy(1));
for i=2:length(ncy)     % build all others for X and Y
   idx=cy(i):cy(i+1)-1;   % columns to fill this time
   X(:,idx)=X(:,1:ncy(i));
   Y(:,idx)=Y(:,cy(i-1):cy(i-1)+ncy(i)-1).*yy(:,1:ncy(i));
end
if isempty(w) % no weights
   p=(X.*Y)\z;
else
   p=(X.*Y.*repmat(w,1,ncol))\(z.*w);
end
p=[nx ny p.'];
