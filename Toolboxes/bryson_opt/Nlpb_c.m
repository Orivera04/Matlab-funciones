function [c,ceq]=nlpb_c(p)
% Function file for p9_2_2.m; 6/97, 4/12/98
%
x=p(1); y=p(2); 
c=[(x-3)^2+(y-1)^2-5; (x-3)^2+(y+1)^2-5];
ceq=[];