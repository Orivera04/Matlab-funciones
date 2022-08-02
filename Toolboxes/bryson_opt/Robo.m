function sp=robo(t,s,flag,mu,us0)
% Subroutine for robo1_f & _c (subroutines for p9_3_14); 
%                                                     12/8/01
%
oms=s(1); ome=s(2); ths=s(3); the=s(4); 
A=[mu+4/3 (mu+1/2)*cos(the); (mu+1/2)*cos(the) mu+1/3];
b=[us0-1+(mu+1/2)*ome^2*sin(the); 1-(mu+1/2)*oms^2*sin(the)];
sp=[A\b; oms; ome-oms];

