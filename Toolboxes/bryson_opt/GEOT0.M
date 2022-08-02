function [f1,f2]=geot0(be,s,t,flg)
% Subroutine for p2_4_7 & 2_6_7; min distance on a sphere using a 
% quadratic penalty fcn on terminal error;          10/96, 7/1/02
%
global thf Sf;
d=s(1); th=s(2); ct=cos(th); st=sin(th); cb=cos(be); sb=sin(be);
if flg==1
    f1=ct*[1; sb]/cb;
elseif flg==2
    f1=d+Sf*(th-thf)^2/2; 
    f2=[1 Sf*(th-thf)];
elseif flg==3
    f1=st*[0 -1; 0 -sb]/cb;
    f2=ct*[sb; 1]/cb^2;	
end	
