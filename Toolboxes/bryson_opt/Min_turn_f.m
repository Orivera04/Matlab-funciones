function f=min_turn_f(p,ga,flg)           
% Subroutine for p1_3_09c;       1/95, 3/22/02
%
V=p(1); al=p(2);  sg=p(3);  alm=1/12; eta=1/2; 
if flg==1, f=-al*sin(sg)/(cos(ga))^2;  	             
 elseif flg==2, f=-tan(sg)/V;                               
end