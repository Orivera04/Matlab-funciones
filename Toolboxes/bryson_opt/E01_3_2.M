% Script e01_3_2.m; sailboat max velocity (flg=1) or max 
% upwind velocity (flg=2); y=[V Wr al th ps]'; uses FMINCON; 
%                                                 9/96, 7/25/02
%
flg=1; y0=[.5 1 .5 .5 1.5]; optn=optimset('Display','Iter'); 
lb=zeros(1,5); ub=[1 2 1 1.5 4]; mu=1;  
y=fmincon('slbt_f1',y0,[],[],[],[],lb,ub,'slbt_c',optn,mu,flg)

