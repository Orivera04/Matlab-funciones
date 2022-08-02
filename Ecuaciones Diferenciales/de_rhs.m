function zprime=de_rhs(t,z)
% RHS for van der Pol system of DE's:
%  dI/dt + I*(I^2-a) + V = 0
%  dV/dt -I = 0 
%     Let z(1)= I, z(2)= V.

global a

zprime=[-z(1)*(z(1)^2 - a) - z(2)
         z(1)   ]; 
