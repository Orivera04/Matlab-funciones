function f=mdr_f(p,flg)             
% Subroutine for Pb. 1.3.08;       10/96, 6/27/02
%
V=p(1); ga=p(2); al=p(3); alm=1/12; eta=1/2;
if flg==1, f=ga; elseif flg==2, f=V*sin(ga); end

