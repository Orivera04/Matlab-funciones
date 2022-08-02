function [f1,f2,f3,f4,f5]=dtdp0n2(th,s,dt,t,flg)                   
% Subroutine for Ex. 8.4.1 & Pb. 8.4.6; DTDP for max uf with spec. 
% (vf,yf); t in tf; (u,v) in a*tf,(x,y) in a*tf^2; s=[u,v,y,x]', th=
% control;                                             4/97, 6/11/02
%
global vf yf; u=s(1); v=s(2); y=s(3); co=cos(th); si=sin(th); sf=2e5;
if flg==1 
 f1=s+dt*[co; si; v+dt*si/2; u+dt*co/2];
elseif flg==2 
 f1=u-sf*((v-vf)^2+(y-yf)^2)/2; % Max u + penalty on term. constr.
 f2=[1 -sf*(v-vf) -sf*(y-yf) 0];
 f3=[0 0 0 0; 0 -sf 0 0; 0 0 -sf 0; 0 0 0 0];           % f3=phiss  
elseif flg==3                     
 f1=[1 0 0 0; 0 1 0 0; 0 dt 1 0; dt 0 0 1];                % f1=fs                      
 f2=dt*[-si; co; dt*co/2; -dt*si/2];                       % f2=fu
 f3=zeros(16,4);			                              % f3=fss
 f4=zeros(4);        		                              % f4=fsu
 f5=dt*[-co; -si; -dt*si/2; -dt*co/2];                    % f5=fuu       
end

	
