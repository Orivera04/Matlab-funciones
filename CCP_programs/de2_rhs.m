function zprime=de2_rhs(t,z)
% Right hand sides of system of D.E.'s
%  dz(1)/dt=...
%  dz(2)/dt=...   where y=z(1) and yp=z(2).
% Both z and zprime are column vectors.
global a b

zprime=[z(2)
       -a*z(2)-b*z(1)] ;
