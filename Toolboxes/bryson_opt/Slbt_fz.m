function f=slbt_fz(y,mu,flg)                          
% Subroutine for e01_3_2 & p1_3_07; sailboat max velocity (flg=1) or max
% upwind velocity (flg=2); y=[V Wr al th ps]'; 	          10/96, 3/20/02
%
V=y(1); Wr=y(2); al=y(3); th=y(4); ps=y(5);
if flg==1, f=-V; elseif flg==2, f=V*cos(ps); end




