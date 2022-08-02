function [f1,f2]=geo0(u,s,t,flg)
% Subroutine for Pb. 2.4.3; min distance to a meridian on
% a sphere;                                 10/96, 7/1/02
%
d=s(1); th=s(2); be=u; ct=cos(th); st=sin(th); sb=sin(be);
cb=cos(be);
if flg==1
    f1=ct*[1; sb]/cb;
elseif flg==2
    f1=d; 
    f2=[1 0];
elseif flg==3
    f1=-st*[0 1; 0 sb]; 
    f2=ct*[sb; 1]/cb^2;	
end	
