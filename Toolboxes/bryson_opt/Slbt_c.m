function [c,ceq]=slbt_c(y,mu,flg)                          
% Subroutine for e01_3_2 & p1_3_07; sailboat max velocity;
% y=[V Wr al th ps]'; 	                    10/96, 6/24/02
%
V=y(1); Wr=y(2); al=y(3); th=y(4); ps=y(5);
ceq(1)=V^2-mu^2*Wr^2*sin(al)*sin(th); 
ceq(2)=Wr^2-V^2-1+2*V*cos(ps);
ceq(3)=Wr*sin(al+th)-sin(ps);



