function sp=vdp0ys(t,s)                      
% Subroutine for Pb.8.5.1;         7/9/02
%
global tn sn un K; V=s(1); 
s1=interp1(tn,sn,t); u1=interp1(tn,un,t);
K1=interp1(tn,K,t);
ga=u1-K1*(s-s1'); co=cos(ga); si=sin(ga);
sp=[si; V*co; V*si];
