% P5_2.M Solve the equation Du+2tu=f for
%  f=2t; f=1
%  (Requires Symbolic Math Toolbox)
u1=dsolve('Du+2*t*u=2*t','u(0)=0')
u2=dsolve('Du+2*t*u=1','u(0)=0')
%
% The second case can be solved numerically
%