function [f1,f2,f3,f4,f5]=marslin0(be,s,t,flg)
% Subroutine for p2_7_17 & p8_5_17; TDP for max radius orbit 
% transfer with small change in radius; s=[r u v]';  8/23/02
%
a=.1405; r=s(1); u=s(2); v=s(3); co=cos(be); si=sin(be); 
su=100; sv=su;
if flg==1
    f1=[u r+2*v+a*si -u+a*co]';
elseif flg==2
    f1=[r-su*u^2/2-sv*(v+r/2)^2/2];
    f2=[1-sv*(v+r/2)/2 -su*u -sv*(v+r/2)] ;
    f3=[-sv/4 0 -sv/2; 0 -su 0; -sv/2 0 -sv];
elseif flg==3
    f1=[0 1 0; 1 0 2; 0 -1 0];
    f2=a*[0 co -si]';
    f3=zeros(9,3);
    f4=zeros(3);
    f5=a*[0 -si -co]';
end
