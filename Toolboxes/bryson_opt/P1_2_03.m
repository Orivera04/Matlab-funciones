% Script p1_2_03.m; pseudo-inverse solution to 
% a set of linear equations; example of 2 eqns.
% with 3 unknowns;                5/98, 6/27/02
%
A=[1 2 3; 1 -1 2], b=[10 10]'
x=A'*((A*A')\b)
x1=pinv(A)*b
