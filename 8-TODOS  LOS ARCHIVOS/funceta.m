function [f,f2]=funceta(n,type,eta)
%
% [f,f2]=funceta(n,type,eta)
% ~~~~~~~~~~~~~~~~~~~~~~~~~
eta=eta(:); neta=length(eta);
if type==1, N=0:n-1; f=cos(eta*N);
else, N=1:n; f=sin(eta*N); end
f2=-repmat(N.^2,neta,1).*f;