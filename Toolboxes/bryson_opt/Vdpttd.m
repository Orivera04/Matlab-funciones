function [f1,f2,f3]=vdpttd(ga,s,t,flg)                      
% Subroutine for Pb. 4.4.12; VDP for min time to a spec. range
% with gravity, thrust, & drag; s=[V x y]'; t in units of
% sqrt(l/g), V in sqrt(g*l), x in l, a in g;     1/93, 7/15/02
%
a=.05; yf=-.3; xf=1.98; 
V=s(1); x=s(2); y=s(3); co=cos(ga); si=sin(ga);
if flg==1
 f1=[a-si-V^2; V*co; V*si];  		                  % f1 = f
elseif flg==2
 f1=[t; x-xf; y-yf];                                % f1 = Phi
 f2=[0 0 0; 0 1 0; 0 0 1];                         % f2 = Phis
 f3=[1 0 0]';                                      % f3 = Phit
elseif flg==3
 f1=[-2*V 0 0; co 0 0; si 0 0];                      % f1 = fs
 f2=[-co; -V*si; V*co];      		                 % f2 = fu
end

