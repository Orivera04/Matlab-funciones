function sys=tf(r,t)
%TF Convert Rational Polynomial Object to TF Object in Control Toolbox. (MM)
% TF(R) converts the rational polynomial R into a continuous-time TF object.
% TF(R,T) converts R into a discrete-time TF object having sampling time T.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/28/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1
	sys=tf(r.n,r.d);
else
	sys=tf(r.n,r.d,t);
end
