function u=trifacsm(a)
%
% u=trifacsm(a)
% ~~~~~~~~~~~~~
%
% This function determines an upper triangular 
% matrix u such that u'*u=a where a must be 
% symmetric and positive definite.
%
% User m functions called: none
%----------------------------------------------

[L,u]=lu(a); d=1./sqrt(diag(u));
u=d(:,ones(length(d),1)).*u; 
