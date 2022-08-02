function zprime=fdamp_rhs(t,z)
% RHS for forced damped mass-spring DE:
%  D2y + c*Dy +  k^2*y = F0*cos(w*t)
% System is
%  y' = yp 
%  yp' = -c*yp - k^2*y +F0*cos(w*t) 
%    so z(1)= y, z(2)= yp

global c k w F0

ksq=k^2;

zprime=[z(2); -c*z(2)-ksq*z(1)+F0*cos(w*t)]; 
