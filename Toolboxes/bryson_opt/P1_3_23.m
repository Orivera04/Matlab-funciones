% Script p1_3_23.m; F4H cruise for min fuel per unit dist. (flg=1)
% or min fuel per unit time (flg=2); p=[V h alpha eta]' in ft/sec,
% ft, rad, -; thrust=eta*Tmax(V,h);                   12/97, 3/26/02 
%
optn=optimset('MaxIter',500); lb=[300 0 .01 0]; 
ub=[1000 6e4 .3 1]; p0=[822 32250 .0744 .268];
%
% Part (a) min fuel (lb/mile):
flg=1; 
p=fmincon('f4_cruse_f',p0,[],[],[],[],lb,ub,'f4_cruse_c',optn,flg);
J=f4_cruse_f(p,flg); V=p(1); h=p(2); alpha=p(3); eta=p(4);
display('lb/mile    V     h/1000    alpha     eta');
display([J V h/10000 alpha eta]);
%
% Part (b) min fuel (lb/sec):
flg=2;        
p=fmincon('f4_cruse_f',p0,[],[],[],[],lb,ub,'f4_cruse_c',optn,flg);
J=f4_cruse_f(p,flg); V=p(1); h=p(2); alpha=p(3); eta=p(4);
display('l/sec    V     h/1000    alpha     eta');
display([J V h/10000 alpha eta]);


