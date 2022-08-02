function [ret,x0,str,ts,xts]=fig6_14(t,x,u,flag);
%FIG6_14	is the M-file description of the SIMULINK system named FIG6_14.
%	The block-diagram can be displayed by typing: FIG6_14.
%
%	SYS=FIG6_14(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes FIG6_14 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling FIG6_14 with a FLAG of zero:
%	[SIZES]=FIG6_14([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[143,179,850,568])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '2')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '.1')
set_param(sys,'Relative error','1e-5')
set_param(sys,'Return vars',   '')

add_block('built-in/Gain',[sys,'/','1//Mass'])
set_param([sys,'/','1//Mass'],...
		'position',[150,82,175,108])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','-+',...
		'position',[90,85,110,105])

add_block('built-in/Integrator',[sys,'/','Velocity'])
set_param([sys,'/','Velocity'],...
		'Initial','-3',...
		'position',[215,85,235,105])

add_block('built-in/Gain',[sys,'/','K1'])
set_param([sys,'/','K1'],...
		'orientation',2,...
		'position',[175,32,200,58])

add_block('built-in/Sum',[sys,'/','Sum3'])
set_param([sys,'/','Sum3'],...
		'orientation',2,...
		'inputs','-+',...
		'position',[240,35,260,55])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[390,45,410,65])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'position',[500,94,530,126])

add_block('built-in/To Workspace',[sys,'/','For Plotting'])
set_param([sys,'/','For Plotting'],...
		'mat-name','yout',...
		'position',[570,102,620,118])

add_block('built-in/Constant',[sys,'/','X0'])
set_param([sys,'/','X0'],...
		'orientation',2,...
		'Value','x0',...
		'position',[320,10,340,30])

add_block('built-in/Integrator',[sys,'/','Displacement'])
set_param([sys,'/','Displacement'],...
		'Initial','x0',...
		'position',[325,85,345,105])

add_block('built-in/Mux',[sys,'/','Mux1'])
set_param([sys,'/','Mux1'],...
		'orientation',2,...
		'inputs','2',...
		'position',[375,196,405,229])

add_block('built-in/MATLAB Fcn',[sys,'/','Snubber Force'])
set_param([sys,'/','Snubber Force'],...
		'orientation',2,...
		'position',[250,193,330,237])

add_block('built-in/Note',[sys,'/',['For use with "Dynamic Modeling and Control',13,'of Dynamic Systems" by Shearer, Kulakowski',13,'and Gardner.  Prentice Hall, 1997.',13,'Copyright 1997 by J.F. Gardner',13,'',13,'Set ''x0=2'' in MATLAB workspace before running']])
set_param([sys,'/',['For use with "Dynamic Modeling and Control',13,'of Dynamic Systems" by Shearer, Kulakowski',13,'and Gardner.  Prentice Hall, 1997.',13,'Copyright 1997 by J.F. Gardner',13,'',13,'Set ''x0=2'' in MATLAB workspace before running']],...
		'position',[345,275,350,280])
add_line(sys,[240,95;320,95])
add_line(sys,[115,95;145,95])
add_line(sys,[180,95;210,95])
add_line(sys,[170,45;60,45;60,90;85,90])
add_line(sys,[350,95;400,95;400,105;495,105])
add_line(sys,[535,110;565,110])
add_line(sys,[415,55;440,55;440,95;495,95])
add_line(sys,[235,45;205,45])
add_line(sys,[350,95;350,50;265,50])
add_line(sys,[315,20;285,20;285,40;265,40])
add_line(sys,[370,215;335,215])
add_line(sys,[245,215;60,215;60,100;85,100])
add_line(sys,[60,145;450,145;450,125;495,125])
add_line(sys,[265,95;265,130;430,130;430,115;495,115])
add_line(sys,[440,105;440,205;410,205])
add_line(sys,[465,115;465,220;410,220])

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
