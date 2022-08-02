function C = checkerboard(n)
% CHECKERBOARD  A matrix of zeros and ones.
%   checkerboard(n) is an n-by-n matrix.
[I,J] = meshgrid(1:n);
C = (mod(I+J,2)==0);
