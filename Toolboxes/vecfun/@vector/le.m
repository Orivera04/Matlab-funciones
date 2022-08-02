function y=le(A,B)
%<=  Less than or equal.
%   V <= W does the comparison between the vector functions
%   V and W and returns 1 if the relation is true and 0 if it is not.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

A=vector(A);
B=vector(B);
y=vec2sca(A,1)<=vec2sca(B,1) &...
   vec2sca(A,2)<=vec2sca(B,2) &...
   vec2sca(A,3)<=vec2sca(B,3);