function [f1,f2]=dgeo0(be,s,dt,t,flg)               
% Subroutine for Pbs. 2.2.3 & 2.5.3; min dist. to a meridian on a sphere
% t--> phi=long; s=[d th]'; d=dist, th=lat, be=heading angle;     6/2/98 
%
c=pi/180; thf=40.7*c; d=s(1); th=s(2); sb=sin(be); cb=cos(be);  
b=exp(dt*tan(be)); z=b*tan(th/2+pi/4); th1=2*atan(z)-pi/2;
ct=cos(th/2+pi/4); zt=b/(ct^2*(1+z^2)); zb=2*z*dt/(cb^2*(1+z^2));         	       
if flg==1
 if abs(sb)>1e-4,
  f1=[d+(th1-th)/sb; th1]; else f1=[d+dt*cos(th); th];  
 end;		       			       
elseif flg==2
 f1=d; f2=[1 0];				    
elseif flg==3
   f1=[1 (zt-1)/sb; 0 zt]; f2=[zb/sb-(th1-th)*cb/sb^2; zb];  
end;

