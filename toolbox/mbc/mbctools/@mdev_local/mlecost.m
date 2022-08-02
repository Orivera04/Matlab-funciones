function [f,Beta,G,W,Li]=mlecost(x,mdev,FixLocal,PredMode)
%
% Data= [y Z]
% W is blkdiag sparse

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:04:55 $


% sigma
% Form Gamma from x
% x is upper triangular elements 

Ng= mdev.MLE.Init.Nf;
SF= mdev.MLE.Init.ScaleX;
W0= mdev.MLE.Init.W0;
y= mdev.MLE.Init.y;
X= mdev.MLE.Init.X;

N= size(X,1);
p= size(X,2);

Gc = triu(ones(Ng));
if nargin>2 & FixLocal
   Gc( Gc~=0 )= x(:);
   Gc= Gc*SF{2};
   sigma2= SF{1}^2;
elseif nargin > 2
   sigma2= SF{1}^2*x(1)^2;
   Gc( Gc~=0 ) = x(2:end);
   Gc= Gc*SF{2};
else
   Gc( Gc~=0 ) = x(2:end);
   sigma2= x(1)^2;
end
G= Gc'*Gc;

% Add G and sigma2 to blk diag elements of W
% This needs to be written as a MEX
% I don't know what the effect is going to be if
% any Wii*s + G is zero
% Use i_blkdiag_add as an M alterntaive
W= blkdiag_add(W0,sigma2,G);

% Form cholesky decomposition of W
% Transposed now for qr
try
   Wc = chol(W);
catch
   error('Not positive definite')
   return
end

% Divide by Wc to set up weighted least squares
% (y-Zb)'/W*(y-Zb)

Wci = (Wc\speye(size(Wc)))';
X= Wci*X;

% Calculate weighted residuals Wc\(y-Zb);
y= Wci*y;

Beta= X\y;
r= y-X*Beta;

% log likelihood function
% log(det(W)) + (y-Zb)'/W*(y-Zb)
% e= 2*log(diag(Wc)) + r.^2;

f= sum( 2*log(diag(Wc)) + r.^2);
% Note det(W)  = det(Wc)^2
%      det(Wc) = prod(diag(Wc)) as Wc is triangular
%      use log(prod(x)) = sum(log(x)) to avoid overflow

if nargout>1
   % don't calculate in optimisation
   Li=    reshape(2*log(diag(Wc)) + r.^2,Ng,length(r)/Ng);
   % sum over response features
   Li= sum(Li)';
end

drawnow

% Used for testing only
function W=i_blkdiag_add(W,S,G);

Nb= size(W,1)/size(G,1);
Ng=size(G,1);
for i=0:Nb-1;
   Wind=i*Ng+1:(i+1)*Ng;
   wt=W(Wind,Wind);
   W(Wind,Wind)= wt*S+G;
end