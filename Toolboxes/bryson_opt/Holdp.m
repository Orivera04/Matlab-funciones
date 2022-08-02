function [f1,f2]=holdp(u,s,t,flg,xf)      
% Subroutine for Pb. 3.4.19; s=[th x y J]';         3/17/02 
%
th=s(1); x=s(2); y=s(3); J=s(4); z4=zeros(1,4); 
si=sin(th); co=cos(th); xf=10;
if flg==1, f1=[u; co; si; u^2];
elseif flg==2, f1=[J; th-2*pi; x-xf; y]; 
   f2=[0 0 0 1; 1 0 0 0; 0 1 0 0; 0 0 1 0];
elseif flg==3, f1=[z4; -si 0 0 0; co 0 0 0; z4];
    f2=[1 0 0 2*u]';
end
