% Script p1_2_05.m; min time path thru region with two
% layers of const. velocity magnitude using Snell's law;
%                                         5/98, 6/27/02
%
v1=25; v2=6; y1=100;y2=300; x2=300; 
optn=optimset('Display','Iter','MaxIter',100); p0=[1 .5];
p=fsolve('snel',p0,optn,v1,v2,y1,y2,x2);
th1=p(1), th2=p(2)
Lmin=y1/(v1*cos(th1))+(y2-y1)/(v2*cos(th2))
th0=atan(y2/x2), L1=y1/(v1*cos(th0))+(y2-y1)/(v2*cos(th0))

