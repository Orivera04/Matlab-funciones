function [ret,x0,str]=P0420BS(t,x,u,flag);
%P0420BS        is the M-file description of the SIMULINK system named P0420BS.
%       The block-diagram can be displayed by typing: P0420BS.
%
%       SYS=P0420BS(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%       Setting FLAG=1 causes P0420BS to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%       Calling P0420BS with a FLAG of zero:
%       [SIZES]=P0420BS([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[6,143,393,277])
     open_system(sys)
end;
set_param(sys,'algorithm',		'RK-45')
set_param(sys,'Start time',	'0.0')
set_param(sys,'Stop time',		'10')
set_param(sys,'Min step size',	'0.0001')
set_param(sys,'Max step size',	'.01')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',	'')

add_block('built-in/Step Fcn',[sys,'/','Step Fcn'])
set_param([sys,'/','Step Fcn'],...
		'Time','0',...
		'position',[25,75,45,95])

add_block('built-in/Zero-Pole',[sys,'/','G(s)'])
set_param([sys,'/','G(s)'],...
		'Zeros','[]',...
		'Poles','[0 ;-1]',...
		'position',[170,67,215,103])


%     Subsystem  'Sampler'.

new_system([sys,'/','Sampler'])
set_param([sys,'/','Sampler'],'Location',[130,6553695,330,6553865])

add_block('built-in/Outport',[sys,'/','Sampler/out_1'])
set_param([sys,'/','Sampler/out_1'],...
		'position',[185,50,205,70])

add_block('built-in/Inport',[sys,'/','Sampler/in_1'])
set_param([sys,'/','Sampler/in_1'],...
		'position',[80,45,100,65])


%     Subsystem  'Sampler/Pulse generator'.

new_system([sys,'/','Sampler/Pulse generator'])
set_param([sys,'/','Sampler/Pulse generator'],'Location',[30,25,279,253])

add_block('built-in/Clock',[sys,'/','Sampler/Pulse generator/Clock'])
set_param([sys,'/','Sampler/Pulse generator/Clock'],...
		'position',[60,80,80,100])

add_block('built-in/Discrete Transfer Fcn',[sys,'/',['Sampler/Pulse generator/Zero order hold.',13,'Used to hit pulse start']])
set_param([sys,'/',['Sampler/Pulse generator/Zero order hold.',13,'Used to hit pulse start']],...
		'Denominator','[1]',...
		'Sample time','[Ts,start]',...
		'position',[135,127,180,163])

add_block('built-in/Fcn',[sys,'/','Sampler/Pulse generator/Fcn'])
set_param([sys,'/','Sampler/Pulse generator/Fcn'],...
		'Expr','ht * ((( rem(u[1]-start,Ts) <= duration) - (u[1] < start)) > 0)',...
		'position',[135,80,175,100])

add_block('built-in/Outport',[sys,'/','Sampler/Pulse generator/out_1'])
set_param([sys,'/','Sampler/Pulse generator/out_1'],...
		'position',[215,80,235,100])

add_block('built-in/Discrete Transfer Fcn',[sys,'/',['Sampler/Pulse generator/Zero order hold.',13,'Used to hit pulse end']])
set_param([sys,'/',['Sampler/Pulse generator/Zero order hold.',13,'Used to hit pulse end']],...
		'Denominator','[1]',...
		'Sample time','[Ts,start+duration]',...
		'position',[135,197,180,233])
add_line([sys,'/','Sampler/Pulse generator'],[85,90;125,90])
add_line([sys,'/','Sampler/Pulse generator'],[180,90;205,90])
set_param([sys,'/','Sampler/Pulse generator'],...
		'Mask Display','plot(0,0,100,100,[90,75,75,60,60,35,35,20,20,10],[20,20,80,80,19,20,80,80,20,20])',...
		'Mask Type','Pulse generator')
set_param([sys,'/','Sampler/Pulse generator'],...
		'Mask Dialogue','Pulse generator.|Pulse period (secs):|Pulse width:|Pulse height:|Pulse start time:',...
		'Mask Translate','Ts = @1; duration = @2; ht = @3; start = @4;')
set_param([sys,'/','Sampler/Pulse generator'],...
		'Mask Help','Pulse generator which ensures pulse transitions are hit. Uses clock, fcn and ZOH block. Unmask to see how it works.',...
		'Mask Entries','1\/.01\/1\/-.005\/')


%     Finished composite block 'Sampler/Pulse generator'.

set_param([sys,'/','Sampler/Pulse generator'],...
		'position',[60,73,100,127])

add_block('built-in/Product',[sys,'/','Sampler/Product'])
set_param([sys,'/','Sampler/Product'],...
		'position',[130,50,155,70])
add_line([sys,'/','Sampler'],[160,60;175,60])
add_line([sys,'/','Sampler'],[105,55;120,55])
add_line([sys,'/','Sampler'],[105,100;120,65])


%     Finished composite block 'Sampler'.

set_param([sys,'/','Sampler'],...
		'position',[270,5,300,55])

add_block('built-in/Scope',[sys,'/','C(z)'])
set_param([sys,'/','C(z)'],...
		'Vgain','10.000000',...
		'Hgain','10.000000',...
		'Vmax','20.000000',...
		'Hmax','20.000000',...
		'Window',[413,0,640,222])
open_system([sys,'/','C(z)'])
set_param([sys,'/','C(z)'],...
		'position',[340,17,360,43])

add_block('built-in/Scope',[sys,'/','c*(t)'])
set_param([sys,'/','c*(t)'],...
		'Vgain','10.000000',...
		'Hgain','10.000000',...
		'Vmax','20.000000',...
		'Hmax','20.000000',...
		'Window',[413,222,640,444])
open_system([sys,'/','c*(t)'])
set_param([sys,'/','c*(t)'],...
		'position',[340,72,360,98])


%     Subsystem  'First Order Hold'.

new_system([sys,'/','First Order Hold'])
set_param([sys,'/','First Order Hold'],'Location',[0,0,404,171])

add_block('built-in/Gain',[sys,'/','First Order Hold/Gain'])
set_param([sys,'/','First Order Hold/Gain'],...
		'Gain','1/Ts',...
		'position',[285,33,325,77])

add_block('built-in/Integrator',[sys,'/','First Order Hold/Integrator'])
set_param([sys,'/','First Order Hold/Integrator'],...
		'position',[235,42,260,68])

add_block('built-in/Sum',[sys,'/','First Order Hold/Sum'])
set_param([sys,'/','First Order Hold/Sum'],...
		'inputs','+-',...
		'position',[190,37,210,68])

add_block('built-in/Discrete Transfer Fcn',[sys,'/','First Order Hold/Zero Order Hold'])
set_param([sys,'/','First Order Hold/Zero Order Hold'],...
		'Numerator','1',...
		'Denominator','1',...
		'Sample time','Ts',...
		'position',[95,27,140,63])

add_block('built-in/Unit Delay',[sys,'/','First Order Hold/Unit Delay'])
set_param([sys,'/','First Order Hold/Unit Delay'],...
		'Sample time','Ts',...
		'position',[95,93,145,117])

add_block('built-in/Inport',[sys,'/','First Order Hold/input'])
set_param([sys,'/','First Order Hold/input'],...
		'position',[25,35,45,55])

add_block('built-in/Outport',[sys,'/','First Order Hold/output'])
set_param([sys,'/','First Order Hold/output'],...
		'position',[345,45,365,65])
add_line([sys,'/','First Order Hold'],[330,55;335,55])
add_line([sys,'/','First Order Hold'],[265,55;275,55])
add_line([sys,'/','First Order Hold'],[215,55;225,55])
add_line([sys,'/','First Order Hold'],[150,105;165,105;165,60;180,60])
add_line([sys,'/','First Order Hold'],[145,45;180,45])
add_line([sys,'/','First Order Hold'],[50,45;85,45])
add_line([sys,'/','First Order Hold'],[65,45;65,105;85,105])
set_param([sys,'/','First Order Hold'],...
		'Mask Display','plot(0,0,100,100,[90,70,50,30,10],[60,40,80,30,20])',...
		'Mask Type','First Order Hold',...
		'Mask Dialogue','First Order Hold|Sample Time:',...
		'Mask Translate','Ts=@1;')
set_param([sys,'/','First Order Hold'],...
		'Mask Help','Implements a first order sample-and-hold latch operating at the sampling interval you specify.',...
		'Mask Entries','1\/')


%     Finished composite block 'First Order Hold'.

set_param([sys,'/','First Order Hold'],...
		'position',[95,70,125,100])
add_line(sys,[50,85;85,85])
add_line(sys,[130,85;160,85])
add_line(sys,[220,85;240,85;240,30;260,30])
add_line(sys,[305,30;330,30])
add_line(sys,[220,85;330,85])

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
