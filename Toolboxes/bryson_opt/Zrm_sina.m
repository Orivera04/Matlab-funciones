function sp=zrm_sina(t,s,flg,thf,tf)                                     
% Subroutine for Pb. 8.7.3a; s=[x y]';      	      3/93, 12/96, 7/23/98
%
x=s(1); y=s(2); c=cos(thf); s2y=(sin(y))^2;
th1=acos(c/(1-c*s2y)); if th1>.0001, th=th1; else th=-th1; end
sp=[cos(th)+s2y; sin(th)];

