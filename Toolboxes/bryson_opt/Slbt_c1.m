function [c,ceq]=slbt_c1(y,ps)                          
% Subroutine for p1_3_07e;                          10/96, 3/20/02
%
V=y(1); Wr=y(2); al=y(3); th=y(4); mu=1; 
ceq(1)=V^2-mu^2*Wr^2*sin(al)*sin(th); ceq(2)=Wr^2-V^2-1+2*V*cos(ps);
ceq(3)=Wr*sin(al+th)-sin(ps); c=[];



