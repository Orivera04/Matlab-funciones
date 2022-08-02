function [f1,f2]=marc(be,s,t,flg)      
% Subroutine for Exs. 3.4.1,2, 3.6.2, 4.5.1,2, 
% Pbs. 3.4.20a,b, 3.4.21;                  3/94, 9/13/02 
%                                       
T=.1405; mdot=.07489; a=T/(1-mdot*t); r=s(1); u=s(2);
v=s(3); co=cos(be); si=sin(be); 
if flg==1
   f1=[u; v^2/r-1/r^2+a*si; -u*v/r+a*co];
elseif flg==2
   f1=[r; u; v-1/sqrt(r)]; 
   f2=[1 0 0; 0 1 0; 1/(2*r^1.5) 0 1];
elseif flg==3
   f1=[0 1 0; -(v/r)^2+2/r^3 0 2*v/r; u*v/r^2 -v/r -u/r]; 
   f2=a*[0; co; -si];
end
