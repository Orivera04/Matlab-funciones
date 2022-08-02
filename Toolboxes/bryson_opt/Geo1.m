function [f1,f2]=geo1(u,s,t,flg)
% Subroutine for Pb. 2.4.7; min distance on a sphere using quad. penalty
% on term. lat error;                               10/96, 8/97, 6/24/98
%
global Sf thf;
d=s(1); th=s(2); be=u; ct=cos(th); st=sin(th); cb=cos(be); sb=sin(be);
if flg==1, f1=[ct/cb; ct*sb/cb];
elseif flg==2, f1=d+Sf*(th-thf)^2/2; f2=[1 Sf*(th-thf)];
elseif flg==3,
  f1=[0 -st/cb; 0 -st*sb/cb]; f2=(ct/cb^2)*[sb; 1];	
end	
