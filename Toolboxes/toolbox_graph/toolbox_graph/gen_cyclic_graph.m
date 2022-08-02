function [A,xy] = gen_cyclic_graph( n, S )

% gen_cyclic_graph - generate a Caley graph associated with
%   generating set S in Z/nZ.
%
%   [A,xy] = gen_cyclic_graph( n, S );
%
%   A : adjacency matrix of size nxn
%   xy : position (on the circle) of nx2.
%
%   Copyright (c) 2003 Gabriel Peyré

A = zeros(n,n);
x = (0:(n-1))'*2*pi/n;
xy = [ cos(x) sin(x) ];

for i=0:n-1
    for s = S
        A( i+1, mod(i+s,n)+1 ) = 1;
    end
end