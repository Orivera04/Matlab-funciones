function  [yout,x] = lsim(a, b, c, d, u, t, x0)
%LSIM	Simulation of continuous-time linear systems to arbitrary inputs.
%	LSIM(A,B,C,D,U,T) plots the time response of the linear system:
%			.
%			x = Ax + Bu
%			y = Cx + Du
%	to the input time history U. Matrix U must have as many columns as
%	there are inputs, U.  Each row of U corresponds to a new time 
%	point, and U must have LENGTH(T) rows.  The time vector T must be
%	regularly spaced.  LSIM(A,B,C,D,U,T,X0) can be used if initial 
%	conditions exist.
%
%	LSIM(NUM,DEN,U,T) plots the time response of the polynomial 
%	transfer function  G(s) = NUM(s)/DEN(s)  where NUM and DEN contain
%	the polynomial coefficients in descending powers of s.  When 
%	invoked with left hand arguments,
%		[Y,X] = LSIM(A,B,C,D,U,T)
%		[Y,X] = LSIM(NUM,DEN,U,T)
%	returns the output and state time history in the matrices Y and X.
%	No plot is drawn on the screen.  Y has as many columns as there 
%	are outputs, y, and with LENGTH(T) rows.  X has as many columns 
%	as there are states.
%
%	See also: STEP.

%	LSIM normally linearly interpolates the input (using a first order hold)
%	which is more accurate for continuous inputs. For discrete inputs such 
%	as square waves LSIM tries to detect these and uses a more accurate 
%	zero-order hold method. LSIM can be confused and for accurate results
%	a small time interval should be used.

%	J.N. Little 4-21-85
%       Revised A.C.W.Grace 8-27-89 (added first order hold)
%	                    1-21-91 (test to see whether to use foh or zoh)
%	Copyright (c) 1986-93 by the MathWorks, Inc.

error(nargchk(4,7,nargin));

if (nargin==4),			% transfer function description 
	[num,den] = tfchk(a,b);
	u = c;
	t = d;
	% Convert to state space
	[a,b,c,d] = tf2ss(num,den);

elseif (nargin==5),
	 error('Wrong number of input arguments.');
else
	error(abcdchk(a,b,c,d));
end

[ns,n] = size(a);
if (nargin==6)|(nargin==4),
	x0 = zeros(ns,1);
end

[p,m]=size(d);
if p*m==0, x=[]; if nargout~=0, yout=[]; end; return; end

if m==1, u=u(:); end, [nu,mu]=size(u);
t=t(:); nt = length(t);

% Make sure u has the right number of columns and rows.
if mu~=m, error('U must have the same number of columns as inputs.'); end
if nu~=nt, error('U must have the same number of rows as the length of T.'); end
	
TS=t(2)-t(1);
% First Order Hold Approximation 

% Try to find out whether the input is step-like or continuous

% Differentiate u
udiff = u(2:nu,:)-u(1:nu-1,:);

% Find all transition points of the input i.e., all changing inputs
uf = find(udiff ~= 0);

% Find out if changes in the input occur after a number of constant inputs.
% If they do then assume that it is a step-like input and use a zero 
% order hold method. Otherwise assume that the input is continuous and 
% linearly interpolate using first order hold method.
usteps = find(diff(uf) == 1);
foh = (length(usteps) > 0);

if foh 
	% Use first order hold approximation 

% For first order hold approximation first add m integrators in series
	[a,b,c,d]=series(zeros(m),eye(m),eye(m),zeros(m),a,b,c,d);

% For first order hold add (z-1)/TS in series
% This is equivalent to differentiating u.
% Transfer first sample to initial conditions.

	x0=[zeros(m,1);x0(:)]+(b*u(1,:).');
	u(1:nu-1,:) = udiff/TS;
	u(nu,:)=u(nu-1,:);
end

% Get equivalent zero order hold discrete system
[A,B] = c2d(a,b,t(2)-t(1));


x = ltitr(A,B,u,x0);
y = x * c.' + u * d.';

if foh
	% Remove the integrator state
	x=x(:,1+m:n+m);
end

if nargout==0		% If no output arguments, plot graph
	plot(t,y), xlabel('Time (secs)'), ylabel('Amplitude')
	return % Suppress output
end
yout = y; 

