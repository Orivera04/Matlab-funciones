function [f1,f2,f3,f4,f5]=zrm0n2(uf,s,t,flg)      
% Subroutine for Pb. 8.5.2;                               6/29/02 
%                                       
x=s(1); y=s(2); co=cos(uf); si=sin(uf); sy=2e2; yf=0;  
if flg==1
  f1=[co+y; si];                                         % f1=sdot
elseif flg==2
  f1=x-sy*(y-yf)^2/2;                                     % f1=phi
  f2=[1 -sy*(y-yf)];                                     % f2=phis
  f3=[0 0; 0 -sy];                                      % f3=phiss
elseif flg==3
  f1=[0 1; 0 0];                                           % f1=fs
  f2=[-si co]';                                            % f2=fu
  f3=zeros(4,2);                                          % f3=fss
  f4=zeros(2);                                            % f4=fsu
  f5=[-co -si]';                                          % f5=fuu
end
