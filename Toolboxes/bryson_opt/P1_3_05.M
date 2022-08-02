% Script p1_3_05.m; min time path thru region with 2 layers
% of const. velocity magnitude using FMINCON;  1/94, 6/27/02
%
optn=optimset('Display','Iter','MaxIter',50); 
p=[1.2 .2]; lb=[0 0]; ub=[pi/2 pi/2]; 
p1=fmincon('snell_f',p,[],[],[],[],lb,ub,'snell_c',optn)


