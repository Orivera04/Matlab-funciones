function [f1,f2]=geoc(be,s,t,flg)
% Subroutine for Pb. 3.4.03 & 3.6.03; min dist. between points on a
% sphere; t-->phi=longitude; s=[d th]'; d=distance, th=latitude, be=
% heading angle;                                  11/96, 1/98, 6/22/98
%
global thf; d=s(1); th=s(2); st=sin(th); ct=cos(th); sb=sin(be);
cb=cos(be);
if flg==1, f1=[ct/cb; ct*tan(be)];
elseif flg==2, f1=[d; th-thf]; f2=eye(2);				                  
elseif flg==3, f1=[0 -st/cb; 0 -st*tan(be)]; f2=[ct*sb/cb^2; ct/cb^2]; 			           
end

