function [ret,x0,str]=F0421S(t,x,u,flag);
%F0421S is the M-file description of the SIMULINK system named F0421S.
%       The block-diagram can be displayed by typing: F0421S.
%
%       SYS=F0421S(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%       Setting FLAG=1 causes F0421S to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%       Calling F0421S with a FLAG of zero:
%       [SIZES]=F0421S([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[12,56,380,234])
     open_system(sys)
end;
set_param(sys,'algorithm',		'RK-45')
set_param(sys,'Start time',	'0.0')
set_param(sys,'Stop time',		'5')
set_param(sys,'Min step size',	'0.0001')
set_param(sys,'Max step size',	'.01')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',	'')


%     Subsystem  'Ramp'.

new_system([sys,'/','Ramp'])
set_param([sys,'/','Ramp'],'Location',[-15,6553715,155,6553845])

add_block('built-in/Integrator',[sys,'/','Ramp/Integrator'])
set_param([sys,'/','Ramp/Integrator'],...
		'position',[105,60,125,80])

add_block('built-in/Step Fcn',[sys,'/','Ramp/Step Fcn'])
set_param([sys,'/','Ramp/Step Fcn'],...
		'Time','0',...
		'position',[50,60,70,80])

add_block('built-in/Outport',[sys,'/','Ramp/out_1'])
set_param([sys,'/','Ramp/out_1'],...
		'position',[150,60,170,80])
add_line([sys,'/','Ramp'],[75,70;95,70])
add_line([sys,'/','Ramp'],[130,70;140,70])


%     Finished composite block 'Ramp'.

set_param([sys,'/','Ramp'],...
		'position',[10,15,40,65])

add_block('built-in/Discrete Transfer Fcn',[sys,'/','Zero Order Hold'])
set_param([sys,'/','Zero Order Hold'],...
		'Numerator','1',...
		'Denominator','1',...
		'Sample time','Ts',...
		'Mask Display','plot(0,0,100,100,[90,70,70,50,50,30,30,10],[30,30,50,50,80,80,20,20])',...
		'Mask Type','Zero Order Hold')
set_param([sys,'/','Zero Order Hold'],...
		'Mask Dialogue','Zero Order Hold|Sample Time:',...
		'Mask Translate','Ts=@1;',...
		'Mask Help','Implements a sample-and-hold latch operating at the sampling interval you specify.')
set_param([sys,'/','Zero Order Hold'],...
		'Mask Entries','1\/',...
		'position',[85,24,115,56])

add_block('built-in/Transfer Fcn',[sys,'/','G2(s)'])
set_param([sys,'/','G2(s)'],...
		'Denominator','[1 1]',...
		'position',[165,22,200,58])

add_block('built-in/Scope',[sys,'/','C(s)'])
set_param([sys,'/','C(s)'],...
		'Vgain','5.000000',...
		'Hgain','6.000000',...
		'Vmax','10.000000',...
		'Hmax','12.000000',...
		'Window',[400,4,639,208])
open_system([sys,'/','C(s)'])
set_param([sys,'/','C(s)'],...
		'position',[320,27,340,53])


%     Subsystem  'Sampler'.

new_system([sys,'/','Sampler'])
set_param([sys,'/','Sampler'],'Location',[130,6553695,330,6553865])

add_block('built-in/Product',[sys,'/','Sampler/Product'])
set_param([sys,'/','Sampler/Product'],...
		'position',[130,50,155,70])


%     Subsystem  'Sampler/Pulse generator'.

new_system([sys,'/','Sampler/Pulse generator'])
set_param([sys,'/','Sampler/Pulse generator'],'Location',[30,25,279,253])

add_block('built-in/Discrete Transfer Fcn',[sys,'/',['Sampler/Pulse generator/Zero order hold.',13,'Used to hit pulse end']])
set_param([sys,'/',['Sampler/Pulse generator/Zero order hold.',13,'Used to hit pulse end']],...
		'Denominator','[1]',...
		'Sample time','[Ts,start+duration]',...
		'position',[135,197,180,233])

add_block('built-in/Outport',[sys,'/','Sampler/Pulse generator/out_1'])
set_param([sys,'/','Sampler/Pulse generator/out_1'],...
		'position',[215,80,235,100])

add_block('built-in/Fcn',[sys,'/','Sampler/Pulse generator/Fcn'])
set_param([sys,'/','Sampler/Pulse generator/Fcn'],...
		'Expr','ht * ((( rem(u[1]-start,Ts) <= duration) - (u[1] < start)) > 0)',...
		'position',[135,80,175,100])

add_block('built-in/Discrete Transfer Fcn',[sys,'/',['Sampler/Pulse generator/Zero order hold.',13,'Used to hit pulse start']])
set_param([sys,'/',['Sampler/Pulse generator/Zero order hold.',13,'Used to hit pulse start']],...
		'Denominator','[1]',...
		'Sample time','[Ts,start]',...
		'position',[135,127,180,163])

add_block('built-in/Clock',[sys,'/','Sampler/Pulse generator/Clock'])
set_param([sys,'/','Sampler/Pulse generator/Clock'],...
		'position',[60,80,80,100])
add_line([sys,'/','Sampler/Pulse generator'],[180,90;205,90])
add_line([sys,'/','Sampler/Pulse generator'],[85,90;125,90])
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

add_block('built-in/Inport',[sys,'/','Sampler/in_1'])
set_param([sys,'/','Sampler/in_1'],...
		'position',[80,45,100,65])

add_block('built-in/Outport',[sys,'/','Sampler/out_1'])
set_param([sys,'/','Sampler/out_1'],...
		'position',[185,50,205,70])
add_line([sys,'/','Sampler'],[105,100;120,65])
add_line([sys,'/','Sampler'],[105,55;120,55])
add_line([sys,'/','Sampler'],[160,60;175,60])


%     Finished composite block 'Sampler'.

set_param([sys,'/','Sampler'],...
		'position',[240,80,270,130])

add_block('built-in/Scope',[sys,'/','C*(s) '])
set_param([sys,'/','C*(s) '],...
		'Vgain','5.000000',...
		'Hgain','6.000000',...
		'Vmax','10.000000',...
		'Hmax','12.000000',...
		'Window',[398,209,640,434])
open_system([sys,'/','C*(s) '])
set_param([sys,'/','C*(s) '],...
		'position',[320,92,340,118])
add_line(sys,[120,40;155,40])
add_line(sys,[205,40;310,40])
add_line(sys,[45,40;75,40])
add_line(sys,[275,105;310,105])
add_line(sys,[205,40;215,40;215,105;230,105])

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
