function [f1,f2]=frmc(th,s,t,flg)
% Subroutine for Pb. 3.4.04 for use with FOPC ; continuous Fermat Pb.,
% max range (xf) with V=1+y & specified yf;        11/96, 1/98, 6/17/98
%
global yf; x=s(1); y=s(2); c=cos(th); s=sin(th);
if flg==1, f1=(1+y)*[c; s];
elseif flg==2, f1=[x; y-yf];  f2=eye(2);
elseif flg==3, f1=[0 c; 0 s]; f2=(1+y)*[-s; c];
end;
