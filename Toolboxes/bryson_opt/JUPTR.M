function [f1,f2,f3]=juptr(be,s,t,flg)    
% Subroutine for Pb. 4.4.17; TDP for min time to the
% orbit of Jupiter;                     2/4/94, 7/14/02
%
T=.1405; B=.07489; r=s(1); u=s(2); v=s(3);
co=cos(be); si=sin(be); a=T/(1-B*t);
if flg==1,
 f1=[u; v^2/r-1/r^2+a*si; -u*v/r+a*co; v/r];   % f1 = f
elseif flg==2,
 f1=[t; r-5.20; u; v-.4385];                 % f1 = Phi
 f2=[zeros(1,4); eye(3) zeros(3,1)];        % f2 = Phix
 f3=[1 0 0 0]';                             % f3 = Phit
elseif flg==3,
 f1=[0 1 0 0; -(v/r)^2+2/r^3 0 2*v/r  0];     % f1 = fx
 f1=[f1; u*v/r^2 -v/r -u/r 0; 0 0 0 0];
 f2=a*[0; co; -si;  0];                       % f2 = fu
end

