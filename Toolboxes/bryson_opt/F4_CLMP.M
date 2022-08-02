function [ef,psi,Phidot]=f4_clmp(t,y,nu)                   
% Errors in terminal constraints for F4H minimum time to climb to 
% 20 km, M=1, ga=0; s = [V ga h m x]'; u=alpha; lengths in lc, 
% time in tc; 				                         9/96, 2/18/97
%
Wo=.9888*41998; S=530; g=32.2; rho=.002378; lc=2*Wo/(g*rho*S); 
Vc=sqrt(g*lc); Vf=968.1/Vc; hf=(20000/.3048)/lc;
%
V=y(1); ga=y(2); h=y(3); la=y([6:10]); psi=[V-Vf; ga; h-hf];
phis=zeros(1,5);  psis=[eye(3) zeros(3,2)];
ef=la-phis'-psis'*nu; phit=1; psit=zeros(3,1);
ydot=feval('f4_clme',t,y); phidot=phit+phis*ydot([1:5]);
psidot=psit+psis*ydot([1:5]); Phidot=phidot+nu'*psidot;

 
