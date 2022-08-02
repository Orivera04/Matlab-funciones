function [ret,x0,str,ts,xts]=fig6_3(t,x,u,flag);
%FIG6_3	is the M-file description of the SIMULINK system named FIG6_3.
%	The block-diagram can be displayed by typing: FIG6_3.
%
%	SYS=FIG6_3(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes FIG6_3 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling FIG6_3 with a FLAG of zero:
%	[SIZES]=FIG6_3([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[70,247,699,656])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '2')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '.01')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','+--',...
		'position',[135,42,155,78])

add_block('built-in/Integrator',[sys,'/','Velocity'])
set_param([sys,'/','Velocity'],...
		'Initial','1',...
		'position',[240,50,260,70])

add_block('built-in/Integrator',[sys,'/','Displacement'])
set_param([sys,'/','Displacement'],...
		'position',[245,175,265,195])

add_block('built-in/Gain',[sys,'/','Stiffness'])
set_param([sys,'/','Stiffness'],...
		'orientation',2,...
		'Gain','100',...
		'position',[185,237,210,263])

add_block('built-in/Gain',[sys,'/','Damping'])
set_param([sys,'/','Damping'],...
		'orientation',2,...
		'position',[185,102,210,128])

add_block('built-in/Gain',[sys,'/','1//M'])
set_param([sys,'/','1//M'],...
		'position',[185,47,210,73])

add_block('built-in/Product',[sys,'/','Product'])
set_param([sys,'/','Product'],...
		'position',[330,53,360,77])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'orientation',1,...
		'Vgain','1.000000',...
		'Hgain','2.000000',...
		'Vmax','2.000000',...
		'Hmax','4.000000',...
		'Window',[486,19,817,333],...
		'position',[450,125,480,155])

add_block('built-in/Integrator',[sys,'/','Energy Lost'])
set_param([sys,'/','Energy Lost'],...
		'position',[415,55,435,75])

add_block('built-in/Step Fcn',[sys,'/','Step Input'])
set_param([sys,'/','Step Input'],...
		'Time','.1',...
		'After','0',...
		'position',[25,40,45,60])

add_block('built-in/Note',[sys,'/','L'])
set_param([sys,'/','L'],...
		'position',[420,245,425,250])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'orientation',1,...
		'position',[390,220,410,240])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'inputs','2',...
		'position',[430,241,460,274])

add_block('built-in/To Workspace',[sys,'/','To Workspace'])
set_param([sys,'/','To Workspace'],...
		'mat-name','yout',...
		'position',[485,252,535,268])

add_block('built-in/Scope',[sys,'/','Monitor Output'])
set_param([sys,'/','Monitor Output'],...
		'Vgain','0.500000',...
		'Hgain','5.000000',...
		'Vmax','1.000000',...
		'Hmax','10.000000',...
		'Window',[496,79,827,393],...
		'position',[450,170,480,200])

add_block('built-in/Note',[sys,'/',['For use with "Dynamic Modeling and Control',13,'of Dynamic Systems" by Shearer, Kulakowski',13,'and Gardner.  Prentice Hall, 1997.',13,'Copyright 1997 by J.F. Gardner']])
set_param([sys,'/',['For use with "Dynamic Modeling and Control',13,'of Dynamic Systems" by Shearer, Kulakowski',13,'and Gardner.  Prentice Hall, 1997.',13,'Copyright 1997 by J.F. Gardner']],...
		'position',[290,310,295,315])
add_line(sys,[270,185;445,185])
add_line(sys,[265,60;295,60;295,155;220,155;220,185;240,185])
add_line(sys,[295,115;215,115])
add_line(sys,[160,60;180,60])
add_line(sys,[215,60;235,60])
add_line(sys,[310,185;310,250;215,250])
add_line(sys,[180,250;80,250;80,60;130,60])
add_line(sys,[180,115;100,115;100,70;130,70])
add_line(sys,[365,65;410,65])
add_line(sys,[295,60;325,60])
add_line(sys,[440,65;465,65;465,120])
add_line(sys,[155,115;155,100;310,100;310,70;325,70])
add_line(sys,[400,245;405,250;425,250])
add_line(sys,[465,260;480,260])
add_line(sys,[465,95;375,95;375,265;425,265])
add_line(sys,[50,50;130,50])

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
