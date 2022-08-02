function [yout,x,t] = impulse(a,b,c,d,iu,t)
%IMPULSE Impulse response of continuous-time linear systems.
%	 IMPULSE(A,B,C,D,IU)  plots the time response of the linear system
%		.
%		x = Ax + Bu
%		y = Cx + Du
%	to an impulse applied to the single input IU.  The time vector is
%	automatically determined.  
%
%	IMPULSE(NUM,DEN) plots the impulse response of the polynomial 
%	transfer function  G(s) = NUM(s)/DEN(s)  where NUM and DEN contain
%	the polynomial coefficients in descending powers of s.
%
%	IMPULSE(A,B,C,D,IU,T) or IMPULSE(NUM,DEN,T) uses the user-supplied
%	time vector T which must be regularly spaced.  When invoked with
%	left hand arguments,
%		[Y,X,T] = IMPULSE(A,B,C,D,...)
%		[Y,X,T] = IMPULSE(NUM,DEN,...)
%	returns the output and state time history in the matrices Y and X.
%	No plot is drawn on the screen.  Y has as many columns as there 
%	are outputs and length(T) rows.  X has as many columns as there 
%	are states.
%
%	See also: STEP,INITIAL,LSIM and DIMPULSE.

%	J.N. Little 4-21-85
%	Revised: 8-1-90  Clay M. Thompson, 2-20-92 ACWG
%	Copyright (c) 1986-93 by the MathWorks, Inc.

nargs = nargin;
if nargs==0, eval('exresp(''impulse'')'), return, end

error(nargchk(2,6,nargs));

if (nargs < 4) 	% Convert to state space
	[num,den] = tfchk(a,b);
	if nargs==3, t = c; end
	iu = 1;
	[a,b,c,d] = tf2ss(num,den);
	nargs = nargs+3;
else
	error(abcdchk(a,b,c,d));
end

[ny,nu] = size(d);
if (nu*ny==0)|isempty(a),
   x = []; t = []; if nargout~=0, yout=[]; end, return, 
end

if nargs>4
	if ~isempty(b),	b = b(:,iu); end
end

% Workout time vector if not supplied.
if nargs==5 | nargs==4

% The next three constants control the precision of the plot
% and the time interval of the plot.
        st=0.005; % Set settling time bound  = 0.5%
        tint=1; % Set time interval to approx.  1*st% set. time
        precision=30; % Show approx 30 points for simple graph

	m=min(size(b));
	[n,m]=size(b);
	if m>1, x0=max(abs(b.')).'; else, x0=b; end
        t=timvec(a,b,c,x0,st,precision);
end

%  Multivariable systems
if nargs==4
        [iu,nargs,y]=mulresp('impulse',a,b,c,d,t,nargout,0);
	if ~iu, if nargout, yout = y; end, return, end
end

dt = t(2)-t(1);
[aa,bb] = c2d(a,b,dt);
n = length(t);
x = ltitr(aa,bb,zeros(n,1),b);
y = x * c.';

% Plot Graph
if nargout==0
        plot(t,y,[t(1),t(length(t))],zeros(2,1),':')
        xlabel('Time (secs)'), ylabel('Amplitude')
	return % Suppress output
end
yout = y; 


