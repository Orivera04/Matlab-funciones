function [evecs,eigvals]=eigsym(k,m,c)
%
% [evecs,eigvals]=eigsym(k,m,c)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function solves the eigenvalue of the
% constrained eigenvalue problem
%    k*x=(lambda)*m*x, with c*x=0.
% Matrix k must be real symmetric and matrix
% m must be symmetric and positive definite;
% otherwise, computed results will be wrong.
%
% k       - a real symmetric matrix
% m       - a real symmetric positive 
%           definite matrix
% c       - a matrix defining the constraint 
%           condition c*x=0. This matrix is
%           omitted if no constraint exists.
%
% evecs   - matrix of eigenvectors orthogonal
%           with respect to k and m. The
%           following relations apply:
%           evecs'*m*evecs=identity_matrix
%           evecs'*k*evecs=diag(eigvals).
% eigvals - a vector of the eigenvalues
%           sorted in increasing order 
%
% User m functions called: trifacsm
%----------------------------------------------

if nargin==3
  q=null(c); m=q'*m*q; k=q'*k*q;
end
u=trifacsm(m); k=u'\k/u; k=(k+k')/2;
[evecs,eigvals]=eig(k);
[eigvals,j]=sort(diag(eigvals));
evecs=evecs(:,j); evecs=u\evecs;
if nargin==3, evecs=q*evecs; end
