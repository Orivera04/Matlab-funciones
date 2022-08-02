% Script p1_3_21c.m; max climb angle (flg=1) or max climb rate (flg=2)
% for 727 at sea level, using FMINCON; gamma=ga, L=ga (flg=1) or 
% L=V*sin(ga) (flg=2); p=[V ga al]'; char. length lc=2W/(g*rho*S); 
% V^2 in g*l, (thrust,drag,lift) in W=weight;             7/97, 6/27/02 
%
%flg=1;                                            % For max climb angle
flg=2;                                             % For max climb rate
W=180000; S=1560; rho=.002203; g=32.2; lc=2*W/(rho*g*S); Vc=sqrt(g*lc);
optn=optimset('Display','Iter','MaxIter',100);
c=pi/180; lb=[0 0 0]; ub=[400/Vc 20*c 15*c];  
if flg==1, p0=[280/Vc 7*c 10*c]'; else p0=[340/Vc 6*c 6*c]; end
p=fmincon('clmb_727_f',p0,[],[],[],[],lb,ub,'clmb_727_c',optn,flg);
V=p(1)*Vc, ga=p(2)/c, al=p(3)/c, RC=V*p(2)	
