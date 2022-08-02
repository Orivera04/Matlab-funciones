function sp=zrm0_noc(t,ds,flg,tn,thn,sn,K)
% Subroutine for Pb. 8.5.2;                      7/5/02
%
dx=ds(1); dy=ds(2); sn1=interp1(tn,sn,t);
thn1=interp1(tn,thn,t); K1=interp1(tn,K,t); dth=-K1*dy;
sp=[dy-sin(thn1)*dth; cos(thn1)*dth];