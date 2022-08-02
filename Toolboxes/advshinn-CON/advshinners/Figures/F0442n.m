function [ret,x0,str]=F0442N(t,x,u,flag);
%F0442N is the M-file description of the SIMULINK system named F0442N.
%       The block-diagram can be displayed by typing: F0442N.
%
%       SYS=F0442N(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%       Setting FLAG=1 causes F0442N to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%       Calling F0442N with a FLAG of zero:
%       [SIZES]=F0442N([],[],[],0),  returns a vector, SIZES, which
%	contains the sizes of the state vector and other parameters.
%		SIZES(1) number of states
%		SIZES(2) number of discrete states
%		SIZES(3) number of outputs
%		SIZES(4) number of inputs.
%	For the definition of other parameters in SIZES, see SFUNC.
%	See also, TRIM, LINMOD, LINSIM, EULER, RK23, RK45, ADAMS, GEAR.

% Note: This M-file is only used for saving graphical information;
%       after the model is loaded into memory an internal model
%       representation is used.

% the system will take on the name of this mfile:
sys = mfilename;
new_system(sys)
simver(1.2)
if(0 == (nargin + nargout))
     set_param(sys,'Location',[4,321,453,460])
     open_system(sys)
end;
set_param(sys,'algorithm',		'RK-45')
set_param(sys,'Start time',	'0.0')
set_param(sys,'Stop time',		'10*sqrt(2)')
set_param(sys,'Min step size',	'0.0001')
set_param(sys,'Max step size',	'.05')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',	'')

add_block('built-in/Step Fcn',[sys,'/',['Unit',13,'Step']])
set_param([sys,'/',['Unit',13,'Step']],...
		'Time','0',...
		'position',[15,20,35,40])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','+-',...
		'position',[60,25,80,45])

add_block('built-in/Gain',[sys,'/','K'])
set_param([sys,'/','K'],...
		'Gain','Kint',...
		'position',[105,24,150,46])

add_block('built-in/Discrete Zero-Pole',[sys,'/','Gd(z)'])
set_param([sys,'/','Gd(z)'],...
		'Zeros','[.93]',...
		'Poles','[.2]',...
		'Sample time','sqrt(2)',...
		'position',[170,18,230,52])

add_block('built-in/Discrete Zero-Pole',[sys,'/','G(z)'])
set_param([sys,'/','G(z)'],...
		'Zeros','-.98',...
		'Poles','[1 .93]',...
		'Sample time','sqrt(2)',...
		'position',[245,18,305,52])

add_block('built-in/Scope',[sys,'/','C(z)'])
set_param([sys,'/','C(z)'],...
		'Vgain','1.500000',...
		'Hgain','15.000000',...
		'Vmax','3.000000',...
		'Hmax','30.000000',...
		'Window',[472,280,640,480])
open_system([sys,'/','C(z)'])
set_param([sys,'/','C(z)'],...
		'position',[390,22,410,48])

add_block('built-in/Outport',[sys,'/','Outport'])
set_param([sys,'/','Outport'],...
		'hide name',0,...
		'Drop Shadow',4,...
		'Mask Display','plot(t,y); 1',...
		'Mask Type','Optimization outport',...
		'Mask Dialogue','eval(''optblock'')')
set_param([sys,'/','Outport'],...
		'Mask Translate','t=1:10; y=[-.5 1.5 .6 1.3 .8 1.1 .95 1.02 .99 1];',...
		'Mask Help','',...
		'position',[375,68,430,122])
add_line(sys,[40,30;50,30])
add_line(sys,[235,35;235,35])
add_line(sys,[85,35;95,35])
add_line(sys,[155,35;160,35])
add_line(sys,[310,35;330,35;330,85;40,85;40,40;50,40])
add_line(sys,[310,35;380,35])
add_line(sys,[310,35;355,35;355,95;365,95])

% Return any arguments.
if (nargin | nargout)
	% Must use feval here to access system in memory
	if (nargin > 3)
		if (flag == 0)
			eval(['[ret,x0,str]=',sys,'(t,x,u,flag);'])
		else
			eval(['ret =', sys,'(t,x,u,flag);'])
		end
	else
		[ret,x0,str] = feval(sys);
	end
end
