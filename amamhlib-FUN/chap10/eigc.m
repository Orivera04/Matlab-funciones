function [vecs,eigvals]=eigc(k,m,idzero)
%
% [vecs,eigvals]=eigc(k,m,idzero)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes eigenvalues and 
% eigenvectors for the problem 
%            k*x=eigval*m*x 
% with some components of x constrained to 
% equal zero. The imposed constraint is
%            x(idzero(j))=0 
% for each component identified by the index 
% matrix idzero.
%
% k       - a real symmetric stiffness matrix 
% m       - a positive definite symmetric mass 
%           matrix
% idzero  - the vector of indices identifying 
%           components to be made zero
%
% vecs    - eigenvectors for the constrained 
%           problem. If matrix k has dimension 
%           n by n and the length of idzero is 
%           m (with m<n), then vecs will be a 
%           set on n-m vectors in n space
% eigvals - eigenvalues for the constrained 
%           problem. These are all real.
%
% User m functions called:  eigsym
%----------------------------------------------

n=size(k,1); j=1:n; j(idzero)=[]; 
c=eye(n,n); c(j,:)=[];
[vecs,eigvals]=eigsym((k+k')/2, (m+m')/2, c);
