function [f1,f2,f3]=dgeot(be,s,dt,t,flg)   
% Subroutine for p4_2_03; min dist. to point on a sphere t-->d=distance
% along path; s=[th ph]'; th=latitude, ph=longitude; be=heading angle
% (control); APPROX system equations;            10/96, 5/97, 2/4/98 
%
global thf phf; th=s(1); ph=s(2); ct=cos(th); st=sin(th); sb=sin(be);
cb=cos(be);  
if flg==1, f1=s+dt*[sb; cb/ct];                              
elseif flg==2, f1=[t; th-thf; ph-phf]; f2=[0 0; eye(2)]; f3=[t/dt 0 0]';                                
elseif flg==3, f1=[1 0; dt*cb*st/ct^2 1]; f2=dt*[cb -sb/ct]';                             
  f3=[sb cb/ct]';                                 
end;

