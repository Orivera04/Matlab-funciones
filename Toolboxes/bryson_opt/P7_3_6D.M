% Script p7_3_6d.m; approx. solution with three const.
% thrust direc. periods;                 1/97, 7/23/02
%
c=pi/180; be=c*90; tau=2.3; z=1; ga=c*65; p0=[z ga]; 
optn=optimset('Display','Iter');
p=fsolve('ctdp',p0,optn,be,tau);
%
z=p(1); ga=p(2); disp('  z     ga     be    tau');
disp([z   ga/c      be/c     tau]);