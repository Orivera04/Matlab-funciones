function [c,ceq]=mindist_c(p)
% Subroutine for p1_3_04; min distance between 2 lines in 3D; 
%                                               5/98, 3/22/02

x1=p(1:3); x2=p(4:6); A1=[1 2 3; 1 -1 2]; A2=[3 2 1; 2 -1 1];
b1=[10 10]'; b2=[3 -4]'; ceq=[A1*x1-b1; A2*x2-b2]; c=[];