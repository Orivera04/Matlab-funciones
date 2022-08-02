% Script p1_3_07.m; max velocity (flg=1) or max upwind velocity (flg=2)
% of a sailboat using FMINCON; y=[V Wr alpha theta psi];  1/94, 3/22/02
%
flg=1; mu=1; y0=[.6 1 .6 .6 1.3];
optn=optimset('Display','Iter','MaxIter',50); 
lb=zeros(1,5); ub=[1.5 2 1.3 1.3 pi];
y=fmincon('slbt_fz',y0,[],[],[],[],lb,ub,'slbt_c',optn,mu,flg)


