function [x,w] = GLNodeWt(ord)
%Nodes and weights found by solving an eigenvalue problem%

%   x = vector of nodes     %
%   w = vector of weights   %
%   ord = Order of quadrature rule  %

beta = (1:ord-1)./sqrt(4*(1:ord-1).^2-1);
J    = diag(beta,-1) + diag(beta,1);
[V,D]= eig(J);
[x,ix]= sort(diag(D));
w    = 2*V(1,ix)'.^2;
