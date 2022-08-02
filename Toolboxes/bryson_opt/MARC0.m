function [f1,f2]=marc0(be,s,t,flg)      
% Subroutine for p2_4_9.m;                            8/9/02
%                                       
T=.1405; mdot=.07489; a=T/(1-mdot*t); r=s(1); u=s(2); v=s(3);
co=cos(be); si=sin(be); ud=v^2/r-1/r^2+a*si; vd=-u*v/r+a*co;
su=1e4; sv=su;
if flg==1
   f1=[u; ud; vd; v/r];
elseif flg==2
   f1=[r-su*u^2/2-sv*(v-1/sqrt(r))2/2]; 
   f2=[1+sv*(v-1/sqrt(r))/(2*r^1.5) -su*u -sv*(v-1/sqrt(r)) 0];
elseif flg==3
   f1=[0 1 0 0; -(v/r)^2+2/r^3 0 2*v/r 0; u*v/r^2 -v/r ...
      -u/r 0; 0 0 0 0]; 
   f2=a*[0; co; -si; 0];
end
