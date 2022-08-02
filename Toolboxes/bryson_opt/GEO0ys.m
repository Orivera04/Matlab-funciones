function sp=geo0ys(ph,s)
% Subroutine for Pb. 8.5.3;              7/9/02
%
global ben thn phn K; th=s(2);
th1=interp1(phn,thn,ph); K1=interp1(phn,K,ph);
be1=interp1(phn,ben,ph); be=be1-K1(2)*(th-th1);
ct=cos(th); sb=sin(be); cb=cos(be);
sp=ct*[1; sb]/cb;
