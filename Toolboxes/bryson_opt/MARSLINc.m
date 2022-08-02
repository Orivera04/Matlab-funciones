function [f1,f2]=marslinc(be,s,t,flg)
% Subroutine for Pb. 3.4.17; TDP for orbit transfer with
% small change in radius; s=[r v u]';      2/97, 8/17/02
%
a=.1405; r=s(1); v=s(2); u=s(3); co=cos(be); si=sin(be);
if flg==1
    f1=[v; r+2*u+a*si; -v+a*co];
elseif flg==2
    f1=[r; v; u+r/2];
    f2=[1 0 0; 0 1 0; 1/2 0 1];
elseif flg==3
    f1=[0 1 0; 1 0 2; 0 -1 0];
    f2=a*[0 co -si]';
end
