function C=times(A,B)
%.*  Vector dot product.
%   C = DOT(A,B) returns the dot product of the vector functions
%   A and B. Ie C = (A,B) = Ax*Bx + Ay*By + Az*Bz.
%
%   See also DOT, CROSS.

% Copyright (c) 2001-09-02, B. Rasmus Anthin.

C=dot(A,B,inputname(1),inputname(2));