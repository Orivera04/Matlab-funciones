%  tables.m  A simple demonstration of the use of a script file.
%
%  We're just trying to set up and print a nice table of squares and cubes.
%
n = [ 0 : 10 ]
n2 = n .^ 2;
n3 = n .* n2;
b = [ n; n2; n3 ];
b'
