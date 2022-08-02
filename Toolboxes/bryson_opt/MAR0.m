function [f1,f2,f3,f4,f5]=mar0(be,s,t,flg)      
% Subroutine for Pbs. 2.6.9, 2.7.9, & 8.5.9;               8/21/02 
% 
global su sv;
T=.1405; mdot=.07489; a=T/(1-mdot*t); r=s(1); 
rs=sqrt(r); u=s(2); v=s(3); co=cos(be); si=sin(be);
if flg==1
  f1=[u; v^2/r-1/r^2+a*si; -u*v/r+a*co];                 % f1=sdot
elseif flg==2
  f1=[r-su*u^2/2-sv*(v-1/rs)^2/2];                        % f1=phi
  f2=[1-sv*(v-1/rs)/(2*rs^3) -su*u -sv*(v-1/rs)];        % f2=phis
  f3=[((3*sv*v)/(4*rs^5))-sv/r^3 0 -sv/(2*rs^3); ...
      0 -su 0; -sv/(2*rs^3) 0 -sv];                     % f3=phiss
elseif flg==3
  f1=[0 1 0; -(v/r)^2+2/r^3 0 2*v/r; u*v/r^2 -v/r -u/r];   % f1=fs
  f2=a*[0 co -si]';                                        % f2=fu
  f3=[zeros(3);                                           % f3=fss
    2*v^2/r^3-6/r^4 0 -2*v/r^2; 0 0 0; -2*v/r^2 0 2/r; ...
   -2*u*v/r^3 v/r^2 u/r^2; v/r^2 0 -1/r; u/r^2 -1/r 0];     
  f4=zeros(3);                                            % f4=fsu
  f5=a*[0 -si -co]';                                      % f5=fuu
end
