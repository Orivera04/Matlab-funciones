function f=slbt_f(y,mu,flg)                          
% Subroutine for e01_3_2 & p1_3_07; sailboat max velocity;
% y = [V Wr al th ps]'; 	                     10/96, 6/24/02
%
V=y(1); Wr=y(2); al=y(3); th=y(4); ps=y(5);
if flg==1, f=-V; elseif flg==2, f=V*cos(ps); end


g(1)=V^2-mu^2*Wr^2*sin(al)*sin(th); g(2)=Wr^2-V^2-1+2*V*cos(ps);
g(3)=Wr*sin(al+th)-sin(ps);



