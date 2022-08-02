function [l,p,e] = lqe(a,g,c,q,r,t)
%LQE	Linear quadratic estimator design. For the continuous-time system:
%		.
%		x = Ax + Bu + Gw            {State equation}
%		z = Cx + Du + v             {Measurements}
%	with process noise and measurement noise covariances:
%		E{w} = E{v} = 0,  E{ww'} = Q,  E{vv'} = R, E{wv'} = 0
%
%	L = LQE(A,G,C,Q,R) returns the gain matrix L such that the 
%	stationary Kalman filter:
%	      .
%	      x = Ax + Bu + L(z - Cx - Du)
%
%	produces an LQG optimal estimate of x. The estimator can be formed
%	with ESTIM.
%
%	[L,P,E] = LQE(A,G,C,Q,R) returns the gain matrix L, the Riccati
%	equation solution P which is the estimate error covariance, and 
%	the closed loop eigenvalues of the estimator: E = EIG(A-L*C).
%
%	[L,P,E] = LQE(A,G,C,Q,R,N) solves the estimator problem when the
%	process and sensor noise is correlated: E{wv'} = N.

%	J.N. Little 4-21-85
%	Revised Clay M. Thompson  7-16-90
%	Copyright (c) 1986-93 by the MathWorks, Inc.

error(nargchk(5,6,nargin));

% Calculate estimator gains using LQR and duality:
if nargin==5
  [k,s,e] = lqr(a',c',g*q*g',r);
else
  [k,s,e] = lqr(a',c',g*q*g',r,g*t);
end  
l=k';
p=s';

