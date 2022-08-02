function f=clmb_727_f(p,flg)            
% Subroutine for Pb. 1.3.21c;                        1/94, 6/27/02  
%
V=p(1); ga=p(2); 
if flg==1, f=-ga;                           % Maximize climb angle
      else f=-V*sin(ga); end                 % Maximize climb rate
