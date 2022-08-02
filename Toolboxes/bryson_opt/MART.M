function [f1,f2,f3]=mart(be,s,t,flg)
% Subroutine for e04_5_1 & e04_7_1; TDP for min time to planetary
% orbit;                                             1/93, 9/5/02
%
global rf; T=.1405; B=.07489; r=s(1); u=s(2); v=s(3); co=cos(be);
si=sin(be); a=T/(1-B*t);
if flg==1
    f1=[u; v^2/r-1/r^2+a*si; -u*v/r+a*co];        
elseif flg==2
    f1=[t; r-rf; u; v-1/sqrt(rf)];
    f2=[zeros(1,3); eye(3)]; 
    f3=[1 0 0 0]';                                 
elseif flg==3
    f1=[0 1 0; -(v/r)^2+2/r^3 0 2*v/r; u*v/r^2 -v/r -u/r];
    f2=a*[0; co; -si];                             
end

