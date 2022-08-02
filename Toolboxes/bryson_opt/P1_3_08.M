% Script p1_3_08.m; min glide angle and descent rate using 
% FMINCON; p=[V ga al];                      10/96, 6/27/02
%
% Part (a);
p=[3 .1 .1]; optn=optimset('Display','Iter','MaxIter',100);
flg=1; p1=fmincon('mdr_f',p,[],[],[],[],[],[],'mdr_c',optn,flg)
%
% Part (b)
flg=2; p2=fmincon('mdr_f',p1,[],[],[],[],[],[],'mdr_c',optn,flg)

 