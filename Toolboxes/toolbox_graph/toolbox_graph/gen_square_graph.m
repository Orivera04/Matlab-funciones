function [A,xy] = gen_square_graph( n, connectivity )

% gen_square_graph - generate a Caley graph on a square grid, i.e.
%   of (Z/nZ)^2
%   associated to the generativ set S = { [-1,0], [1,0], [0,1], [0,-1] } 
%   for 'connectivity==4' and 
%   S = { [-1,-1], [1,1], [-1,1], [1,-1], [-1,0], [1,0], [0,1], [0,-1] } 
%   for 'connectivity==8'
%
%    [A,xy] = gen_square_graph( n, connectivity );
%
%   A : adjacency matrix of size n x n
%   xy : position matrix of size n x 2.
%
%   Copyright (c) 2003 Gabriel Peyré

if nargin<2
    connectivity = 4;
end

A = zeros(n^2,n^2);
xy = zeros(n^2,2);
h = 1/(n-1);

for i=0:n-1
for j=0:n-1
    k = i+n*j;
    xy(k+1,1) = i*h;
    xy(k+1,2) = j*h;
    if i<n-1
        A( k+1, k+2 ) = 1;
    end
    if i>0
        A( k+1, k ) = 1;
    end
    if j<n-1
        A( k+1, k+1+n ) = 1;
    end
    if j>0
        A( k+1, k+1-n ) = 1;
    end
    if connectivity==8
        if (i<n-1) & (j<n-1)
            A( k+1, k+2+n ) = 1;
        end
        if (i<n-1) & (j>0)
            A( k+1, k+2-n ) = 1;
        end
        if (i>0) & (j>0)
            A( k+1, k-n ) = 1;
        end
        if (i>0) & (j<n-1)
            A( k+1, k+n ) = 1;
        end
    end
end
end