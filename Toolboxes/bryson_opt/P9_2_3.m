% Script p9_2_3.m; min fuel consumption cruise for F4H 
% with h<=60 kft, M<=2; p=[V h alpha eta]'; 12/97, 3/31/02
%
p0=[1000 50000 .1 1], 
optn=optimset('Display','Iter','MaxIter',19);
p=constr('f4_cruse',p0,optn)
	