function [k,s,e]=lqr(a,b,q,r,nn)
%LQR	Linear quadratic regulator design for continuous systems.
%	[K,S,E] = LQR(A,B,Q,R)  calculates the optimal feedback gain 
%	matrix K such that the feedback law  u = -Kx  minimizes the cost
%	function:
%		J = Integral {x'Qx + u'Ru} dt
%
%	subject to the constraint equation: 
%		.
%		x = Ax + Bu 
%                
%	Also returned is S, the steady-state solution to the associated 
%	algebraic Riccati equation and the closed loop eigenvalues E:
%				  -1
%		0 = SA + A'S - SBR  B'S + Q     E = EIG(A-B*K)
%
%	[K,S,E] = LQR(A,B,Q,R,N) includes the cross-term N that relates
%	u to x in the cost function.
%
%		J = Integral {x'Qx + u'Ru + 2*x'Nu}
%
%	The controller can be formed with REG.

%	J.N. Little 4-21-85
%	Revised 8-27-86 JNL
%	Revised 7-18-90 Clay M. Thompson
%	Copyright (c) 1986-93 by the MathWorks, Inc.

error(nargchk(4,5,nargin));
error(abcdchk(a,b));
if ~length(a) | ~length(b)
        error('A and B matrices cannot be empty.')
end

[m,n] = size(a);
[mb,nb] = size(b);
[mq,nq] = size(q);
if (m ~= mq) | (n ~= nq) 
	error('A and Q must be the same size');
end
[mr,nr] = size(r);
if (mr ~= nr) | (nb ~= mr)
	error('B and R must be consistent');
end

if nargin == 5
	[mn,nnn] = size(nn);
	if (mn ~= m) | (nnn ~= nr)
		error('N must be consistent with Q and R');
	end
	% Add cross term
	q = q - nn/r*nn';
	a = a - b/r*nn';
else
	nn = zeros(m,nb);
end

% Check if q is positive semi-definite and symmetric
nq = norm(q,1);
if any(eig(q) < -eps*nq) | (norm(q'-q,1)/nq > eps)
	disp('Warning: Q is not symmetric and positive semi-definite');
end
% Check if r is positive definite and symmetric
nr = norm(r,1);
if any(eig(r) <= -eps*nr) | (norm(r'-r,1)/nr > eps)
	disp('Warning: R is not symmetric and positive definite');
end

% Start eigenvector decomposition by finding eigenvectors of Hamiltonian:
[v,d] = eig([a b/r*b';q, -a']);
d = diag(d);
[e,index] = sort(real(d));	 % sort on real part of eigenvalues
if (~( (e(n)<0) & (e(n+1)>0) ))
	error('Can''t order eigenvalues, (A,B) may be uncontrollable.');
else
  e = d(index(1:n));		 % Return closed-loop eigenvalues
end
chi = v(1:n,index(1:n));	 % select vectors with negative eigenvalues
lambda = v((n+1):(2*n),index(1:n));
s = -real(lambda/chi);
k = r\(nn'+b'*s);
