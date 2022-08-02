function [f1,f2,f3,f4,f5]=dtdpcx(th,s,dt,t,flg)                   
% Subroutine for Pbs. 3.2.7, 3.5.7; DTDP for max uf & vf=0 w. spec. 
% (xf,yf); t in tf; (u,v) in a*tf; (x,y) in a*tf^2; s = [u,v,y,x]' =
% state vector; th = control;                       1/26/94, 4/27/97
% 
u=s(1); v=s(2); y=s(3); x=s(4); co=cos(th); si=sin(th);
if flg==1,                                       % f1 = f
 f1=s+dt*[co; si; v+dt*si/2; u+dt*co/2];
elseif flg==2,           
 f1=[u; v; y-.2; x-.2];			                 % f1 = Phi 
 f2=eye(4);				                         % f2 = Phis  
elseif flg==3,                         
 f1=[1 0 0 0; 0 1 0 0; 0 dt 1 0; dt 0 0 1];     % f1 = fs                      
 f2=dt*[-si; co; dt*co/2; -dt*si/2];            % f2 = fu
 f3=zeros(4);				       % f3 = fsu 
 f4=dt*[-co; -si; -dt*si/2; -dt*co];           % f4 = fuu  
end

	
