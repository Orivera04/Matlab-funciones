function [ret,x0,str,ts,xts]=fig6_6(t,x,u,flag);
%FIG6_6	is the M-file description of the SIMULINK system named FIG6_6.
%	The block-diagram can be displayed by typing: FIG6_6.
%
%	SYS=FIG6_6(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes FIG6_6 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling FIG6_6 with a FLAG of zero:
%	[SIZES]=FIG6_6([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[407,280,949,688])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '5')
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
		'position',[240,50,260,70])

add_block('built-in/Integrator',[sys,'/','Displacement'])
set_param([sys,'/','Displacement'],...
		'position',[245,175,265,195])

add_block('built-in/Gain',[sys,'/','Stiffness'])
set_param([sys,'/','Stiffness'],...
		'orientation',2,...
		'position',[185,237,210,263])

add_block('built-in/Gain',[sys,'/','1//M'])
set_param([sys,'/','1//M'],...
		'position',[185,47,210,73])

add_block('built-in/Look Up Table',[sys,'/',['Coulombic',13,'Friction']])
set_param([sys,'/',['Coulombic',13,'Friction']],...
		'orientation',2,...
		'Input_Values','[-1,0,0,1]',...
		'Output_Values','[-gain-ini -ini ini gain+ini]')
set_param([sys,'/',['Coulombic',13,'Friction']],...
		'Mask Display','plot([-1 0 0 1],[-gain-ini, -ini, ini, gain+ini],[-1 1],[0 0],[0 0],[-x,x])',...
		'Mask Type','Coulombic Friction')
set_param([sys,'/',['Coulombic',13,'Friction']],...
		'Mask Dialogue','Coulombic Friction\ny = sign(x) * (Gain * abs(x) + Offset)|Offset discontinuity at zero:|Gain:',...
		'Mask Translate','ini=@1;gain=@2;x=max(ini,gain+ini);')
set_param([sys,'/',['Coulombic',13,'Friction']],...
		'Mask Help','This block has a discontinuity\nat zero and a linear gain afterward.\ny= sign(x)*(Gain*abs(x)+Offset)',...
		'Mask Entries','.5\/1\/',...
		'position',[165,102,195,128])

add_block('built-in/Step Fcn',[sys,'/','Step Input'])
set_param([sys,'/','Step Input'],...
		'Time','.1',...
		'After','2',...
		'position',[35,40,55,60])

add_block('built-in/Scope',[sys,'/',['Monitor',13,'Output']])
set_param([sys,'/',['Monitor',13,'Output']],...
		'Vgain','3.000000',...
		'Hgain','5.000000',...
		'Vmax','6.000000',...
		'Hmax','10.000000',...
		'Window',[17,5,555,445])
open_system([sys,'/',['Monitor',13,'Output']])
set_param([sys,'/',['Monitor',13,'Output']],...
		'position',[350,170,380,200])

add_block('built-in/Note',[sys,'/',['For use with "Dynamic Modeling and Control',13,'of Dynamic Systems" by Shearer, Kulakowski',13,'and Gardner.  Prentice Hall, 1997.',13,'Copyright 1997 by J.F. Gardner']])
set_param([sys,'/',['For use with "Dynamic Modeling and Control',13,'of Dynamic Systems" by Shearer, Kulakowski',13,'and Gardner.  Prentice Hall, 1997.',13,'Copyright 1997 by J.F. Gardner']],...
		'position',[280,290,285,295])
add_line(sys,[265,60;295,60;295,155;220,155;220,185;240,185])
add_line(sys,[295,115;200,115])
add_line(sys,[160,60;180,60])
add_line(sys,[215,60;235,60])
add_line(sys,[60,50;130,50])
add_line(sys,[270,185;310,185;310,250;215,250])
add_line(sys,[180,250;80,250;80,60;130,60])
add_line(sys,[160,115;115,115;115,70;130,70])
add_line(sys,[310,185;345,185])

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
