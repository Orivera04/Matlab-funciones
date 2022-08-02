function [f1,f2,f3]=geot(be,s,t,flg)                
% Subroutine for p4_4_03; min dist. between points on a sphere (Tokyo
% and New York); indpt. variable=distance along path; state=[ph th]'; 
% ph=longitude, th=latitude, be=heading angle;%			    11/96, 6/2/98 
%
global thf phf; ph=s(1); th=s(2); ct=cos(th); st=sin(th); sb=sin(be);
cb=cos(be);  
if flg==1, f1=[cb/ct; sb];
elseif flg==2, f1=[t; ph-phf; th-thf;]; f2=[0 0; 1 0; 0 1]; f3=[1 0 0]';
elseif flg==3, f1=[0  cb*st/ct^2; 0  0]; f2=[-sb/ct; cb];
end

