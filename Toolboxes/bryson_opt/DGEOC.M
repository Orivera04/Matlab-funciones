function [f1,f2]=dgeoc(be,s,dt,t,flg)               
% Subroutine for Pbs. 3.2.3 & 3.5.3; min dist. between 2 points on a 
% sphere; t-->phi=longitude; s=[d th]'; d=distance, th=latitude,
% be=heading angle;	 	                   10/96, 5/97, 2/98, 6/4/98 
%
thf=40.7*pi/180; d=s(1); th=s(2); ct=cos(th); st=sin(th); sb=sin(be);
cb=cos(be); tb=tan(be); b=exp(dt*tb); z=b*tan(th/2+pi/4); gbb=(st*dt)^2;
g=2*atan(z)-pi/2; gt=(b^2+z^2)/(b*(1+z^2)); gb=2*z*dt/((1+z^2)*cb^2);
if flg==1
 if abs(sb)<.0001, f1=[d+dt*ct; th]; else f1=[d+(g-th)/sb; g]; end			                          
elseif flg==2, f1=[d; th-thf]; f2=eye(2);             
elseif flg==3                                           
 if abs(sb)<.0001, f1=[1 -dt*st; 0 1];  f2=[gbb; gb];                                
 else f1=[1 (gt-1)/sb; 0 gt]; f2=[gb/sb-(g-th)*cb/sb^2; gb]; end;						  
end;

