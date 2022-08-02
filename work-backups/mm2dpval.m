function z=mm2dpval(p,x,y)
%MM2DPVAL 2D Polynomial Evaluation. (MM)
% MM2DPVAL(P,X,Y) evaluates 2D polynomial P at the values in
% X and Y. X and Y must be the same size and can be the
% plaid output of MESHGRID.
%
% The polynomial fit contains terms up to X^Nx and Y^Ny and all
% possible crossproduct terms X^iY^j where i<=Nx, j<=Ny and
% i+j<=max(Nx,Ny).
%
% See also MM2DP2P,MM2DPADD,MM2DPCHK,MM2DPDER,MM2DPFIT,MM2DPINT,MM2DPSTR,MM2DPXY.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 12/6/96, v5: 1/14/96, 5/30/97, 11/18/98
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[pp,nx,ny,ncy,cy]=mm2dpchk(p);

[rx,cx]=size(x);
x=x(:);
y=y(:);
nrow=length(x);
if nrow~=length(y)
	error('X and Y Must be the Same Size.')
end
ncol=length(pp);

% Use VanderMonde matrix approach rather than Horner's method
% roundoff, overflow, and underflow are greater, but accuracy
% is the same as that used to find the coefficients originally.

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
z=reshape((X.*Y)*pp.',rx,cx);
