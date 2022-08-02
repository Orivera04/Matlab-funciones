function [ret,x0,str]=F0427S(t,x,u,flag);
%F0427S is the M-file description of the SIMULINK system named F0427S.
%       The block-diagram can be displayed by typing: F0427S.
%
%       SYS=F0427S(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%       Setting FLAG=1 causes F0427S to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%       Calling F0427S with a FLAG of zero:
%       [SIZES]=F0427S([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[9,75,382,256])
     open_system(sys)
end;
set_param(sys,'algorithm',		'RK-45')
set_param(sys,'Start time',	'0.0')
set_param(sys,'Stop time',		'4')
set_param(sys,'Min step size',	'0.0001')
set_param(sys,'Max step size',	'.01')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',	'')

add_block('built-in/Step Fcn',[sys,'/','Step Fcn'])
set_param([sys,'/','Step Fcn'],...
		'Time','0',...
		'position',[20,30,40,50])

add_block('built-in/Sum',[sys,'/','Sum'])
set_param([sys,'/','Sum'],...
		'inputs','+-',...
		'position',[85,35,105,55])

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
		'position',[140,29,170,61])

add_block('built-in/Transfer Fcn',[sys,'/','G2(s)'])
set_param([sys,'/','G2(s)'],...
		'Denominator','[1 0]',...
		'position',[215,27,250,63])

add_block('built-in/Scope',[sys,'/','C*(s)'])
set_param([sys,'/','C*(s)'],...
		'Vgain','1.100000',...
		'Hgain','4.000000',...
		'Vmax','2.200000',...
		'Hmax','8.000000',...
		'Window',[395,215,640,413])
open_system([sys,'/','C*(s)'])
set_param([sys,'/','C*(s)'],...
		'position',[345,92,365,118])

add_block('built-in/Scope',[sys,'/','C(s)'])
set_param([sys,'/','C(s)'],...
		'Vgain','1.100000',...
		'Hgain','4.000000',...
		'Vmax','2.200000',...
		'Hmax','8.000000',...
		'Window',[395,17,640,215])
open_system([sys,'/','C(s)'])
set_param([sys,'/','C(s)'],...
		'position',[345,32,365,58])


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
		'position',[295,80,325,130])
add_line(sys,[175,45;205,45])
add_line(sys,[255,45;335,45])
add_line(sys,[45,40;75,40])
add_line(sys,[110,45;130,45])
add_line(sys,[255,45;270,45;270,95;60,95;60,50;75,50])
add_line(sys,[330,105;335,105])
add_line(sys,[255,45;280,45;280,105;285,105])

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
