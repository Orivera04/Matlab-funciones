function [Phi, Gamma] = c2d(a, b, t)
%C2D	Conversion of state space models from continuous to discrete time.
%	[Phi, Gamma] = C2D(A,B,T)  converts the continuous-time system:
%		.
%		x = Ax + Bu
%
%	to the discrete-time state-space system:
%
%		x[n+1] = Phi * x[n] + Gamma * u[n]
%
%	assuming a zero-order hold on the inputs and sample time T.
%
%	See also: C2DM.

%	J.N. Little 4-21-85
%	Copyright (c) 1986-93 by the MathWorks, Inc.

error(nargchk(3,3,nargin));
error(abcdchk(a,b));

[m,n] = size(a);
[m,nb] = size(b);
s = expm([[a b]*t; zeros(nb,n+nb)]);
Phi = s(1:n,1:n);
Gamma = s(1:n,n+1:n+nb);
