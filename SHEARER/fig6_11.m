function [ret,x0,str,ts,xts]=fig6_11(t,x,u,flag);
%FIG6_11	is the M-file description of the SIMULINK system named FIG6_11.
%	The block-diagram can be displayed by typing: FIG6_11.
%
%	SYS=FIG6_11(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes FIG6_11 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling FIG6_11 with a FLAG of zero:
%	[SIZES]=FIG6_11([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[130,128,769,644])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '10')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '.1')
set_param(sys,'Relative error','1e-5')
set_param(sys,'Return vars',   '')

add_block('built-in/Gain',[sys,'/','1//Mass'])
set_param([sys,'/','1//Mass'],...
		'position',[150,82,175,108])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','--',...
		'position',[90,85,110,105])

add_block('built-in/Integrator',[sys,'/','Velocity'])
set_param([sys,'/','Velocity'],...
		'Initial','3',...
		'position',[215,85,235,105])

add_block('built-in/Gain',[sys,'/','K1'])
set_param([sys,'/','K1'],...
		'orientation',2,...
		'position',[175,32,200,58])

add_block('built-in/Sum',[sys,'/','Sum2'])
set_param([sys,'/','Sum2'],...
		'orientation',2,...
		'inputs','+-',...
		'position',[365,230,385,250])

add_block('built-in/Constant',[sys,'/','X1'])
set_param([sys,'/','X1'],...
		'orientation',2,...
		'position',[430,235,450,255])

add_block('built-in/Integrator',[sys,'/','Displacement'])
set_param([sys,'/','Displacement'],...
		'position',[310,85,330,105])

add_block('built-in/Gain',[sys,'/','K2'])
set_param([sys,'/','K2'],...
		'orientation',2,...
		'position',[305,227,330,253])

add_block('built-in/Gain',[sys,'/','b'])
set_param([sys,'/','b'],...
		'orientation',2,...
		'Gain','10',...
		'position',[390,292,415,318])

add_block('built-in/Sum',[sys,'/','Sum1'])
set_param([sys,'/','Sum1'],...
		'orientation',2,...
		'position',[250,250,270,270])

add_block('built-in/Constant',[sys,'/','Null'])
set_param([sys,'/','Null'],...
		'orientation',2,...
		'Value','0',...
		'position',[250,325,270,345])

add_block('built-in/Switch',[sys,'/','>x1?'])
set_param([sys,'/','>x1?'],...
		'orientation',2,...
		'position',[180,254,210,286])

add_block('built-in/Switch',[sys,'/','>0?'])
set_param([sys,'/','>0?'],...
		'orientation',2,...
		'position',[115,254,145,286])

add_block('built-in/Clock',[sys,'/','Clock'])
set_param([sys,'/','Clock'],...
		'position',[370,10,390,30])

add_block('built-in/Mux',[sys,'/','Mux'])
set_param([sys,'/','Mux'],...
		'inputs','3',...
		'position',[475,89,505,121])

add_block('built-in/To Workspace',[sys,'/','For Plotting'])
set_param([sys,'/','For Plotting'],...
		'mat-name','yout',...
		'position',[530,97,580,113])

add_block('built-in/Note',[sys,'/',['For use with "Dynamic Modeling and Control',13,'of Dynamic Systems" by Shearer, Kulakowski',13,'and Gardner.  Prentice Hall, 1997.',13,'Copyright 1997 by J.F. Gardner']])
set_param([sys,'/',['For use with "Dynamic Modeling and Control',13,'of Dynamic Systems" by Shearer, Kulakowski',13,'and Gardner.  Prentice Hall, 1997.',13,'Copyright 1997 by J.F. Gardner']],...
		'position',[280,375,285,380])
add_line(sys,[240,95;305,95])
add_line(sys,[115,95;145,95])
add_line(sys,[180,95;210,95])
add_line(sys,[335,95;400,95;390,235])
add_line(sys,[360,95;360,45;205,45])
add_line(sys,[170,45;60,45;60,90;85,90])
add_line(sys,[300,240;290,240;290,255;275,255])
add_line(sys,[385,305;290,305;290,265;275,265])
add_line(sys,[360,240;335,240])
add_line(sys,[400,105;470,105])
add_line(sys,[275,95;275,155;460,155;470,115])
add_line(sys,[425,245;390,245])
add_line(sys,[460,155;475,155;475,305;420,305])
add_line(sys,[245,260;215,260])
add_line(sys,[245,335;235,335;235,280;215,280])
add_line(sys,[345,240;345,195;235,195;235,270;215,270])
add_line(sys,[510,105;525,105])
add_line(sys,[395,20;420,20;420,95;470,95])
add_line(sys,[110,270;60,270;60,100;85,100])
add_line(sys,[235,335;160,335;150,280])
add_line(sys,[175,270;150,270])
add_line(sys,[165,270;165,260;150,260])

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
