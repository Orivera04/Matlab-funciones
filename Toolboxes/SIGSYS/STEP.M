function [yout,x,t] = step(a,b,c,d,iu,t)
%STEP	Step response of continuous-time linear systems.
%	STEP(A,B,C,D,IU)  plots the time response of the linear system:
%		.
%		x = Ax + Bu
%		y = Cx + Du
%	to a step applied to the input IU.  The time vector is auto-
%	matically determined.  STEP(A,B,C,D,IU,T) allows the specification
%	of a regularly spaced time vector T.
%
%	[Y,X] = STEP(A,B,C,D,IU,T) or [Y.X,T] = STEP(A,B,C,D,IU) returns
%	the output and state time response in the matrices Y and X 
%	respectively.  No plot is drawn on the screen.  The matrix Y has 
%	as many columns as there are outputs, and LENGTH(T) rows.  The 
%	matrix X has as many columns as there are states.  If the time 
%	vector is not specified, then the automatically determined time 
%	vector is returned in T.
%
%	[Y,X] = STEP(NUM,DEN,T) or [Y,X,T] = STEP(NUM,DEN) calculates the 
%	step response from the transfer function description 
%	G(s) = NUM(s)/DEN(s) where NUM and DEN contain the polynomial 
%	coefficients in descending powers of s.
%
%	See also: LSIM and DSTEP.

%	J.N. Little 4-21-85
%	Revised A.C.W.Grace 9-7-89, 5-21-92
%	Copyright (c) 1986-93 by the MathWorks, Inc.

nargs = nargin;
if nargs==0, eval('exresp(''step'')'), return, end

error(nargchk(2,6,nargs));

if (nargs < 4) 	% Convert to state space
        [num,den] = tfchk(a,b);
	if nargs==3, t = c; end
	[a,b,c,d] = tf2ss(num,den);
	iu = 1;
	nargs = nargs+3;
else
	error(abcdchk(a,b,c,d));
end

[ny,nu] = size(d);
if nu*ny==0, x = []; t = []; if nargout~=0, yout=[]; end, return, end

if nargs>4 
	if ~isempty(b), b=b(:,iu); end
	d=d(:,iu);
end

% Workout time vector if not supplied.
if (nargs==5 | nargs==4),
  if isempty(a),
    t = 0:.1:1;
  else
    % The next two constants control the precision of the plot
    % and the time interval of the plot.
	st=0.005; % Set settling time bound  = 0.5%
	precision=30; % Show approx 30 points for simple graph
    % Step response is effectively equal to placing initial conditions
    % on the plant as follows:
	[n,m]=size(b);
	if abs(rcond(a)) > eps
		x0 = -a\(b*ones(m,1));
    % Cater for pure integrator case
	else
		x0 = ones(n,1);
	end
	t=timvec(a,b,c,x0,st,precision);
  end
end


%  Multivariable systems
if nargs==4
        [iu,nargs,y]=mulresp('step',a,b,c,d,t,nargout,0);
        if ~iu, if nargout, yout = y; end, return, end
end


% Simulation
dt = t(2)-t(1);
[aa,bb] = c2d(a,b,dt);
n = length(t);
[nb,mb] = size(b);
x = ltitr(aa,bb,ones(n,1),zeros(nb,mb));
if isempty(a),
  x = [];
  y = ones(n,1)*d.';
else
  y=x*c.'+ ones(n,1)*d.';
end
if nargout==0,		% If no output arguments, plot graph
	dcgain = 0;
	if abs(rcond(a)) > eps
		dcgain=-c/a*b+d;
	end
        plot(t,y,[0,t(length(t))],[dcgain';dcgain'],':')
        xlabel('Time (secs)'), ylabel('Amplitude')

        return % Suppress output
end
yout = y; 
