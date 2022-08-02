function [f1,f2,f3]=martss(th,s,t,flg)      
% Subroutine for p4_5_21; solar sail DP for min time to Mars orbit;
%                                                      1/16/93, 9/5/02
%
al=.17;		                         % Kelley's value; Hur used al=.02
r=s(1); u=s(2); v=s(3); co=cos(th); si=sin(th); a=(al/r^2)*co^2;
if flg==1
   f1=[u; v^2/r-1/r^2+a*abs(co); -u*v/r+a*si];   
elseif flg==2
   f1=[t; r-1.5237; u; v-.8101];
   f2=[zeros(1,3); eye(3)];
   f3=[1 0 0 0]';
elseif flg==3
   f1=[0 1 0; -(v/r)^2+2/r^3-2*a*si/r 0 2*v/r;...
       u*v/r^2-2*a*co/r -v/r -u/r];
   f2=(al/r^2)*co*[0; -3*si*co; 1-3*si^2]; if th>pi/2, f2=-f2; end; 
   f3=zeros(3,1);
end

