function [wfindif,mat]=cbfrqfdm(n)
%
% [wfindif,mat]=cbfrqfdm(n)
% ~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes approximate cantilever
% beam frequencies by the finite difference 
% method. The truncation error for the 
% differential equation and boundary 
% conditions are of order h^2.
%
% n       - Number of frequencies to be 
%           computed
% wfindif - Approximate frequencies in 
%           dimensionless form
% mat     - Matrix having eigenvalues which 
%           are the square roots of the 
%           frequencies
%
% User m functions called:  none
%----------------------------------------------

% Form the primary part of the frequency matrix
mat=3*diag(ones(n,1))-4*diag(ones(n-1,1),1)+...
    diag(ones(n-2,1),2); mat=(mat+mat');

% Impose left end boundary conditions 
% y(0)=0 and y'(0)=0
mat(1,[1:3])=[7,-4,1]; mat(2,[1:4])=[-4,6,-4,1];

% Impose right end boundary conditions
% y''(1)=0 and y'''(1)=0
mat(n-1,[n-3:n])=[1,-4,5,-2]; 
mat(n,[n-2:n])=[2,-4,2];

% Compute approximate frequencies and 
% sort these values
w=eig(mat); w=sort(w); h=1/n; 
wfindif=sqrt(w)/(h*h);