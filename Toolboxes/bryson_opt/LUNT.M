function [f1,f2,f3]=lunt(be,s,t,flg)
% Subroutine for p4_5_19; TDP for min time orbit injection from surface 
% of the moon; s=[r u v]';                                 2/91, 9/5/02
%
rf=1.1129; r=s(1); u=s(2); v=s(3); a=3; co=cos(be); si=sin(be); 	
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

