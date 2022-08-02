function [ret,x0,str]=P0417C1S(t,x,u,flag);
%P0417C1S       is the M-file description of the SIMULINK system named P0417C1S.
%       The block-diagram can be displayed by typing: P0417C1S.
%
%       SYS=P0417C1S(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%       Setting FLAG=1 causes P0417C1S to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%       Calling P0417C1S with a FLAG of zero:
%       [SIZES]=P0417C1S([],[],[],0),  returns a vector, SIZES, which
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
set_param(sys,'Stop time',		'100')
set_param(sys,'Min step size',	'0.0001')
set_param(sys,'Max step size',	'.1')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',	'')

add_block('built-in/Discrete Transfer Fcn',[sys,'/',['Zero Order Hold',13,'0.1 Second Rate']])
set_param([sys,'/',['Zero Order Hold',13,'0.1 Second Rate']],...
		'Numerator','1',...
		'Denominator','1',...
		'Sample time','Ts',...
		'Mask Display','plot(0,0,100,100,[90,70,70,50,50,30,30,10],[30,30,50,50,80,80,20,20])')
set_param([sys,'/',['Zero Order Hold',13,'0.1 Second Rate']],...
		'Mask Type','Zero Order Hold',...
		'Mask Dialogue','Zero Order Hold|Sample Time:',...
		'Mask Translate','Ts=@1;')
set_param([sys,'/',['Zero Order Hold',13,'0.1 Second Rate']],...
		'Mask Help','Implements a sample-and-hold latch operating at the sampling interval you specify.',...
		'Mask Entries','0.1\/',...
		'position',[95,69,125,101])

add_block('built-in/Zero-Pole',[sys,'/','G(s)'])
set_param([sys,'/','G(s)'],...
		'Zeros','[]',...
		'Poles','[0 ;-1]',...
		'position',[170,67,215,103])


%     Subsystem  ['Sampler',13,'0.1 Second Rate'].

new_system([sys,'/',['Sampler',13,'0.1 Second Rate']])
set_param([sys,'/',['Sampler',13,'0.1 Second Rate']],'Location',[130,95,330,265])

add_block('built-in/Outport',[sys,'/',['Sampler',13,'0.1 Second Rate/out_1']])
set_param([sys,'/',['Sampler',13,'0.1 Second Rate/out_1']],...
		'position',[185,50,205,70])

add_block('built-in/Inport',[sys,'/',['Sampler',13,'0.1 Second Rate/in_1']])
set_param([sys,'/',['Sampler',13,'0.1 Second Rate/in_1']],...
		'position',[80,45,100,65])


%     Subsystem  ['Sampler',13,'0.1 Second Rate/Pulse generator'].

new_system([sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator']])
set_param([sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator']],'Location',[30,25,279,253])

add_block('built-in/Clock',[sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator/Clock']])
set_param([sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator/Clock']],...
		'position',[60,80,80,100])

add_block('built-in/Discrete Transfer Fcn',[sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator/Zero order hold.',13,'Used to hit pulse start']])
set_param([sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator/Zero order hold.',13,'Used to hit pulse start']],...
		'Denominator','[1]',...
		'Sample time','[Ts,start]',...
		'position',[135,127,180,163])

add_block('built-in/Fcn',[sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator/Fcn']])
set_param([sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator/Fcn']],...
		'Expr','ht * ((( rem(u[1]-start,Ts) <= duration) - (u[1] < start)) > 0)',...
		'position',[135,80,175,100])

add_block('built-in/Outport',[sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator/out_1']])
set_param([sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator/out_1']],...
		'position',[215,80,235,100])

add_block('built-in/Discrete Transfer Fcn',[sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator/Zero order hold.',13,'Used to hit pulse end']])
set_param([sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator/Zero order hold.',13,'Used to hit pulse end']],...
		'Denominator','[1]',...
		'Sample time','[Ts,start+duration]',...
		'position',[135,197,180,233])
add_line([sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator']],[85,90;125,90])
add_line([sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator']],[180,90;205,90])
set_param([sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator']],...
		'Mask Display','plot(0,0,100,100,[90,75,75,60,60,35,35,20,20,10],[20,20,80,80,19,20,80,80,20,20])',...
		'Mask Type','Pulse generator')
set_param([sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator']],...
		'Mask Dialogue','Pulse generator.|Pulse period (secs):|Pulse width:|Pulse height:|Pulse start time:',...
		'Mask Translate','Ts = @1; duration = @2; ht = @3; start = @4;')
set_param([sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator']],...
		'Mask Help','Pulse generator which ensures pulse transitions are hit. Uses clock, fcn and ZOH block. Unmask to see how it works.',...
		'Mask Entries','.1\/.01\/1\/-.005\/')


%     Finished composite block ['Sampler',13,'0.1 Second Rate/Pulse generator'].

set_param([sys,'/',['Sampler',13,'0.1 Second Rate/Pulse generator']],...
		'position',[60,73,100,127])

add_block('built-in/Product',[sys,'/',['Sampler',13,'0.1 Second Rate/Product']])
set_param([sys,'/',['Sampler',13,'0.1 Second Rate/Product']],...
		'position',[130,50,155,70])
add_line([sys,'/',['Sampler',13,'0.1 Second Rate']],[160,60;175,60])
add_line([sys,'/',['Sampler',13,'0.1 Second Rate']],[105,55;120,55])
add_line([sys,'/',['Sampler',13,'0.1 Second Rate']],[105,100;120,65])


%     Finished composite block ['Sampler',13,'0.1 Second Rate'].

set_param([sys,'/',['Sampler',13,'0.1 Second Rate']],...
		'position',[270,5,300,55])

add_block('built-in/Scope',[sys,'/','C(z)'])
set_param([sys,'/','C(z)'],...
		'Vgain','5000.000000',...
		'Hgain','100.000000',...
		'Vmax','10000.000000',...
		'Hmax','200.000000',...
		'Window',[412,0,640,220])
open_system([sys,'/','C(z)'])
set_param([sys,'/','C(z)'],...
		'position',[340,17,360,43])

add_block('built-in/Scope',[sys,'/','c*(t)'])
set_param([sys,'/','c*(t)'],...
		'Vgain','5000.000000',...
		'Hgain','100.000000',...
		'Vmax','10000.000000',...
		'Hmax','200.000000',...
		'Window',[414,220,640,444])
open_system([sys,'/','c*(t)'])
set_param([sys,'/','c*(t)'],...
		'position',[340,72,360,98])


%     Subsystem  'Unit Ramp'.

new_system([sys,'/','Unit Ramp'])
set_param([sys,'/','Unit Ramp'],'Location',[100,393329,265,393439])

add_block('built-in/Constant',[sys,'/','Unit Ramp/Constant'])
set_param([sys,'/','Unit Ramp/Constant'],...
		'position',[55,45,75,65])

add_block('built-in/Integrator',[sys,'/','Unit Ramp/Integrator'])
set_param([sys,'/','Unit Ramp/Integrator'],...
		'position',[110,45,130,65])

add_block('built-in/Outport',[sys,'/','Unit Ramp/out_1'])
set_param([sys,'/','Unit Ramp/out_1'],...
		'position',[160,45,180,65])
add_line([sys,'/','Unit Ramp'],[80,55;100,55])
add_line([sys,'/','Unit Ramp'],[135,55;150,55])


%     Finished composite block 'Unit Ramp'.

set_param([sys,'/','Unit Ramp'],...
		'position',[20,60,50,110])
add_line(sys,[130,85;160,85])
add_line(sys,[220,85;240,85;240,30;260,30])
add_line(sys,[305,30;330,30])
add_line(sys,[220,85;330,85])
add_line(sys,[55,85;85,85])

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
