function [f1,f2,f3]=frmt(th,s,t,flg)
% Subroutine for p4_4_04; min time to a point with V=1+y;
%                                               11/96, 6/25/98
%
global xf yf; x=s(1); y=s(2); c=cos(th); s=sin(th);
if flg==1, f1=(1+y)*[c; s];
elseif flg==2, f1=[t; x-xf; y-yf]; f2=[0 0; eye(2)];
   f3=[1 0 0]';
elseif flg==3, f1=[0 c; 0 s]; f2=(1+y)*[-s; c]; 
end;
