% Script p9_2_2.m; quad. PI & quad. inequality 
% constraint;                           12/97, 3/31/02
%
p0=[1,1]; optn=optimset('Display','Iter');
p=fmincon('nlpb_f',p0,[],[],[],[],[],[],'nlpb_c',optn) 
	