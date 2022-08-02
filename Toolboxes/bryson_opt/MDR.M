function [f,g]=mdr(p,flg)             
% Subroutine for Pb. 1.3.8; min glide angle & min descent rate using
% CONSTR;                                             10/96, 9/10/98
%
V=p(1); ga=p(2); al=p(3); alm=1/12; eta=1/2;
g=[al*tan(ga)-eta*(al^2+alm^2); al*V^2-cos(ga)];
if flg==1, f=ga; elseif flg==2, f=V*sin(ga); end

