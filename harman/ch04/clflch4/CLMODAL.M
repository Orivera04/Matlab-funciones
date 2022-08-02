function [M,Dlam]=clmodal(A)
% CALL: [M,Dlam]=clmodal(A) computes a modal matrix M and
%   the matrix Dlam=(M^-1)*A*M
[M Dlam]=eig(A);      % M is Modal matrix
%                       Dlam is diagonal   
%
% Notice that this function is implemented with only one
%   MATLAB command