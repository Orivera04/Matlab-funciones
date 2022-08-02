function [yout,x,n] = dstep(a,b,c,d,iu,n)
%DSTEP	Step response of discrete-time linear systems.
%	DSTEP(A,B,C,D,IU)  plots the response of the discrete system:
%
%		x[n+1] = Ax[n] + Bu[n]
%		y[n]   = Cx[n] + Du[n]
%
%	to a step applied to the single input IU.  The number of points is
%	determined automatically.
%
%	DSTEP(NUM,DEN)  plots the step response of the polynomial transfer
%	function  G(z) = NUM(z)/DEN(z)  where NUM and DEN contain the 
%	polynomial coefficients in descending powers of z.
%
%	DSTEP(A,B,C,D,IU,N) or DSTEP(NUM,DEN,N) uses the user-supplied 
%	number of points, N.  When invoked with left hand arguments,
%		[Y,X] = DSTEP(A,B,C,D,...)
%		[Y,X] = DSTEP(NUM,DEN,...)
%	returns the output and state time history in the matrices Y and X.
%	No plot is drawn on the screen.  Y has as many columns as there 
%	are outputs and X has as many columns as there are states.
%
%	See also: DIMPULSE and STEP.

%	J.N. Little 4-21-85
%	Revised JNL 7-18-88, CMT 7-31-90, ACWG 6-21-92
%	Copyright (c) 1986-93 by the MathWorks, Inc.

if nargin==0, eval('exresp(''dstep'');'), return,end

error(nargchk(2,6,nargin));

if (nargin==2),		% Transfer function without number of points
	[num,den] = tfchk(a,b);
	iu = 1;
	[a,b,c,d] = tf2ss(num,den);

elseif (nargin==3),	% Transfer function with number of points
	[num,den] = tfchk(a,b);
	n = c;
	iu = 1;
	[a,b,c,d] = tf2ss(num,den);

elseif (nargin>=4)
	error(abcdchk(a,b,c,d));
end

[ny,nu] = size(d);
if nu*ny==0, x = []; n = []; if nargout~=0, yout=[]; end, return, end

if nargin>4
	if ~isempty(b), b=b(:,iu); end
	d=d(:,iu);
end

% Workout time vector if not supplied.
if nargin==4 | nargin==5 | nargin==2
	if isempty(a),
		n = 11;
	else
		% The next line controls the number of samples in the plot if N not specified
		st=0.005; % Set settling time bound  = 0.5%
		% Step response is effectively equal to placing initial conditions
		% on the plant as follows:
		[ns,mu]=size(b);
		x0=(eye(ns,ns)-a)\(b*ones(mu,1));
		% Cater for pure integrator case
		infind=find(~finite(x0));
		x0(infind)=ones(length(infind),1);
		n=dtimvec(a,b,c,x0,st);

		%  Multivariable systems
		if nargin==4
		    [iu,nargin,y]=mulresp('dstep',a,b,c,d,n,nargout,0);
		    if ~iu, if nargout, yout = y; end, return, end
		end
	end
end

[ny,nu] = size(d);
if (nargin <= 3)&(nargout <= 1),	% transfer function description 
	y = dlsim(num,den,ones(n,1));		% More efficient: uses FILTER
else
	[y,x] = dlsim(a,b,c,d,ones(n,nu));
end

if nargout==0,		% If not output arguments, plot graph
	status = ishold;
	if rcond(a-eye(size(a))) > eps
		dcgain=-c/(a-eye(size(a)))*b+d;
	else
		dcgain = 0;
	end

	stairs([0:n-1],y)
	hold on
	plot([0,n-1],[dcgain';dcgain'],'w:')

	xlabel('No. of Samples')
	ylabel('Amplitude')

	if ~status, hold off, end	% Return hold to previous status
	return % Suppress output
end
yout = y; 
