function wprime=de3_rhs(t,w)
% Right hand sides of system of D.E.'s
%  dw(1)/dt=...
%  dw(2)/dt=...
%  dw(3)/dt=...   where x=w(1),y=w(2), and z=w(3).
% Both w and wprime are column vectors.
global b k

wprime=[-b*w(1)*w(2)
         b*w(1)*w(2) - k*w(2)
         k*w(2)] ;