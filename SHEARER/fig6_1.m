function [ret,x0,str,ts,xts]=fig6_1(t,x,u,flag);
%FIG6_1	is the M-file description of the SIMULINK system named FIG6_1.
%	The block-diagram can be displayed by typing: FIG6_1.
%
%	SYS=FIG6_1(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes FIG6_1 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling FIG6_1 with a FLAG of zero:
%	[SIZES]=FIG6_1([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[119,123,627,561])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '50')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '.1')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','+--',...
		'position',[135,42,155,78])

add_block('built-in/Integrator',[sys,'/','Velocity'])
set_param([sys,'/','Velocity'],...
		'position',[240,50,260,70])

add_block('built-in/Integrator',[sys,'/','Displacement'])
set_param([sys,'/','Displacement'],...
		'position',[245,175,265,195])

add_block('built-in/Scope',[sys,'/','Monitor Output'])
set_param([sys,'/','Monitor Output'],...
		'Vgain','2.000000',...
		'Hgain','50.000000',...
		'Vmax','4.000000',...
		'Hmax','100.000000',...
		'Window',[39,212,608,768],...
		'position',[420,170,450,200])

add_block('built-in/Gain',[sys,'/','Stiffness'])
set_param([sys,'/','Stiffness'],...
		'orientation',2,...
		'position',[185,237,210,263])

add_block('built-in/Gain',[sys,'/','Damping'])
set_param([sys,'/','Damping'],...
		'orientation',2,...
		'position',[185,102,210,128])

add_block('built-in/Gain',[sys,'/','1//M'])
set_param([sys,'/','1//M'],...
		'position',[185,47,210,73])

add_block('built-in/Signal Generator',[sys,'/','Force Input'])
set_param([sys,'/','Force Input'],...
		'Peak','1.000000',...
		'Peak Range','5.000000',...
		'Freq','1.000000',...
		'Freq Range','5.000000',...
		'Wave','Sqr',...
		'Units','Rads',...
		'position',[20,33,65,67])

add_block('built-in/Note',[sys,'/',['For use with "Dynamic Modeling and Control',13,'of Dynamic Systems" by Shearer, Kulakowski',13,'and Gardner.  Prentice Hall, 1997.',13,'Copyright 1997 by J.F. Gardner']])
set_param([sys,'/',['For use with "Dynamic Modeling and Control',13,'of Dynamic Systems" by Shearer, Kulakowski',13,'and Gardner.  Prentice Hall, 1997.',13,'Copyright 1997 by J.F. Gardner']],...
		'position',[245,300,250,305])
add_line(sys,[270,185;415,185])
add_line(sys,[265,60;295,60;295,155;220,155;220,185;240,185])
add_line(sys,[295,115;215,115])
add_line(sys,[160,60;180,60])
add_line(sys,[215,60;235,60])
add_line(sys,[70,50;130,50])
add_line(sys,[310,185;310,250;215,250])
add_line(sys,[180,250;80,250;80,60;130,60])
add_line(sys,[180,115;100,115;100,70;130,70])

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
