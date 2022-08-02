function [f1,f2,f3,f4,f5]=dtdpc(th,s,dt,t,flg,psi)                   
% Subroutine for Ex.3.2.1, Pb.3.2.06, Ex.3.5.2, Ex.8.4.1; DTDP for max
% uf to vf=0 and spec. yf; t in tf; (u,v) in a*tf; (x,y) in a*tf^2;
% s=[u,v,y,x]', th=control;                             1/94, 6/11/02
%
global vf yf; u=s(1); v=s(2); y=s(3); x=s(4); co=cos(th); si=sin(th);
if flg==1
    f1=s+dt*[co; si; v+dt*si/2; u+dt*co/2];
elseif flg==2
    f1=[u; v-vf; y-yf];
    f2=[eye(3) zeros(3,1)]; 
    f3=zeros(12,4);
elseif flg==3
    f1=[1 0 0 0; 0 1 0 0; 0 dt 1 0; dt 0 0 1];
    f2=dt*[-si; co; dt*co/2; -dt*si/2];
    f3=zeros(16,4);                                         % f3=fss
	f4=zeros(4);                                            % f4=fsu 
    f5=dt*[-co -si -dt*si/2 -dt*co/2]';                     % f5=fuu       
end

	
