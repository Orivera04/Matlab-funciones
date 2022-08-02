function [ret,x0,str,ts,xts]=kkk(t,x,u,flag);
%KKK	is the M-file description of the SIMULINK system named KKK.
%	The block-diagram can be displayed by typing: KKK.
%
%	SYS=KKK(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes KKK to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling KKK with a FLAG of zero:
%	[SIZES]=KKK([],[],[],0),  returns a vector, SIZES, which
%	contains the sizes of the state vector and other parameters.
%		SIZES(1) number of states
%		SIZES(2) number of discrete states
%		SIZES(3) number of outputs
%		SIZES(4) number of inputs
%		SIZES(5) number of roots (currently unsupported)
%		SIZES(6) direct feedthrough flag
%		SIZES(7) number of sample times
%
%	For the definition of other parameters in SIZES, see SFUNC.
%	See also, TRIM, LINMOD, LINSIM, EULER, RK23, RK45, ADAMS, GEAR.

% Note: This M-file is only used for saving graphical information;
%       after the model is loaded into memory an internal model
%       representation is used.

% the system will take on the name of this mfile:
sys = mfilename;
new_system(sys)
simver(1.3)
if (0 == (nargin + nargout))
     set_param(sys,'Location',[286,36,786,336])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '1200')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '0.1')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Zero-Order Hold',[sys,'/',['Zero-Order',13,'Hold']])
set_param([sys,'/',['Zero-Order',13,'Hold']],...
		'position',[295,79,330,111])

add_block('built-in/Note',[sys,'/','x(t)'])
set_param([sys,'/','x(t)'],...
		'position',[250,70,255,75])

add_block('built-in/Integrator',[sys,'/','Integrator'])
set_param([sys,'/','Integrator'],...
		'Initial','1.2',...
		'position',[205,85,225,105])

add_block('built-in/Transport Delay',[sys,'/',['Transport',13,'Delay']])
set_param([sys,'/',['Transport',13,'Delay']],...
		'orientation',2,...
		'Delay Time','17',...
		'position',[195,200,235,230])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'orientation',2,...
		'inputs','2',...
		'position',[70,171,105,229])

add_block('built-in/Note',[sys,'/','x(t-tau)'])
set_param([sys,'/','x(t-tau)'],...
		'position',[150,210,155,215])

add_block('built-in/Note',[sys,'/','x(t) '])
set_param([sys,'/','x(t) '],...
		'position',[150,160,155,165])

add_block('built-in/Fcn',[sys,'/','Fcn'])
set_param([sys,'/','Fcn'],...
		'Expr','-0.1*u[1]+0.2*u[2]/(1+power(u[2],10))',...
		'position',[85,80,120,110])

add_block('built-in/Note',[sys,'/','-0.1x(t)+x(t-tau)//[1+x(t-tau)^10]'])
set_param([sys,'/','-0.1x(t)+x(t-tau)//[1+x(t-tau)^10]'],...
		'position',[100,55,105,60])


%     Subsystem  'x(k)'.

new_system([sys,'/','x(k)'])
set_param([sys,'/','x(k)'],'Location',[0,59,274,252])

add_block('built-in/S-Function',[sys,'/',['x(k)/S-function',13,'M-file which plots',13,'lines',13,'']])
set_param([sys,'/',['x(k)/S-function',13,'M-file which plots',13,'lines',13,'']],...
		'function name','sfunyst',...
		'parameters','ax, color, npts, dt',...
		'position',[130,55,180,75])

add_block('built-in/Inport',[sys,'/','x(k)/x'])
set_param([sys,'/','x(k)/x'],...
		'position',[65,55,85,75])
add_line([sys,'/','x(k)'],[90,65;125,65])
set_param([sys,'/','x(k)'],...
		'Mask Display','plot(0,0,100,100,[83,76,63,52,42,38,28,16,11,84,11,11,11,90,90,11],[75,58,47,54,72,80,84,74,65,65,65,90,40,40,90,90])',...
		'Mask Type','Storage scope.')
set_param([sys,'/','x(k)'],...
		'Mask Dialogue','Storage scope using MATLAB graph window.\nEnter plotting ranges and line type.|Initial Time Range:|Initial y-min:|Initial y-max:|Storage pts.:|Line type (rgbw-.:xo):')
set_param([sys,'/','x(k)'],...
		'Mask Translate','npts = @4; color = @5; ax = [0, @1, @2, @3]; dt=-1;')
set_param([sys,'/','x(k)'],...
		'Mask Help','This block uses a MATLAB figure window to plot the input signal.  The graph limits are automatically scaled to the min and max values of the signal stored in the scope''s signal buffer.  Line type must be in quotes.  See the M-file sfunyst.m.')
set_param([sys,'/','x(k)'],...
		'Mask Entries','5\/-10\/10\/1200\/''y-/g--/c-./w:/m*/ro/b+''\/')


%     Finished composite block 'x(k)'.

set_param([sys,'/','x(k)'],...
		'position',[370,75,400,115])
add_line(sys,[230,95;290,95])
add_line(sys,[125,95;200,95])
add_line(sys,[190,215;110,215])
add_line(sys,[65,200;45,200;45,95;80,95])
add_line(sys,[230,95;255,95;255,215;240,215])
add_line(sys,[255,185;110,185])
add_line(sys,[335,95;365,95])

drawnow

% Return any arguments.
if (nargin | nargout)
	% Must use feval here to access system in memory
	if (nargin > 3)
		if (flag == 0)
			eval(['[ret,x0,str,ts,xts]=',sys,'(t,x,u,flag);'])
		else
			eval(['ret =', sys,'(t,x,u,flag);'])
		end
	else
		[ret,x0,str,ts,xts] = feval(sys);
	end
else
	drawnow % Flash up the model and execute load callback
end
