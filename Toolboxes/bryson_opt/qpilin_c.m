function [c,ceq]=qpilin_c(p,Q,R,G,c1)
% Subroutine for p1_3_06.m; general QPI with linear 
% equality constraints;               5/98, 3/22/02
%
u=p(1:2); x=p(3:5); ceq=x-G*u-c1; c=[];
