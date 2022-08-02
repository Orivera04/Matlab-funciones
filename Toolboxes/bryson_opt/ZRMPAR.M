function sp=zrmpar(t,s)		                                     
% Subroutine for p4_3_14; min time to cross a river with a parabolic
% current; uc=1-y^2; s=(x,y) in h, uc in V, t in h/V;  2/97, 6/25/98 
%
global th0; y=s(2); uo=1; secth=uo/cos(th0)+1-y^2;
c=1/secth; s=sqrt(1-c^2); sp=[-c+1-y^2; s];


