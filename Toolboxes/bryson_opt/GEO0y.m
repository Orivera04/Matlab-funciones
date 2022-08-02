function [f1,f2,f3,f4,f5]=geo0y(u,s,t,flg)
% Subroutine for Pb. 2.7.3 & 8.5.3; min distance 
% to a point on a sphere;                 7/3/02
%
global thf sth; d=s(1); th=s(2); be=u; 
st=sin(th); ct=cos(th); sb=sin(be); cb=cos(be);
if flg==1
    f1=ct*[1; sb]/cb;
elseif flg==2
    f1=d+sth*(th-thf)^2/2; 
    f2=[1 sth*(th-thf)];
    f3=[0 0; 0 sth];
elseif flg==3
    f1=-st*[0 1; 0 sb]/cb;
    f2=ct*[sb; 1]/cb^2;	
    f3=-ct*[0 0; 0 1; ...
            0 0; 0 sb]/cb;
    f4=-st*[0 sb; 0 1]/cb^2;
    f5=ct*[1+sb^2; 2*sb]/cb^3;
end	
