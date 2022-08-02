function crosspd=fcross(a,b)
% FCROSS.M Compute the cross product of two row vectors
%  CALL:  crosspd=fcross(a,b)
%    Vectors a,b must be 1 X 3 row vectors.
crosspd = [a(2)*b(3)-a(3)*b(2), a(3)*b(1)-a(1)*b(3), a(1)*b(2)-a(2)*b(1)];
%
%  Compare with command cross; type help cross
%