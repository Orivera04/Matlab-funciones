function [ret,x0,str]=F0442S(t,x,u,flag);
%F0442S is the M-file description of the SIMULINK system named F0442S.
%       The block-diagram can be displayed by typing: F0442S.
%
%       SYS=F0442S(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%       Setting FLAG=1 causes F0442S to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%       Calling F0442S with a FLAG of zero:
%       [SIZES]=F0442S([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[7,81,478,195])
     open_system(sys)
end;
set_param(sys,'algorithm',		'RK-45')
set_param(sys,'Start time',	'0.0')
set_param(sys,'Stop time',		'10*sqrt(2)')
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
		'position',[75,35,95,55])

add_block('built-in/Gain',[sys,'/','K'])
set_param([sys,'/','K'],...
		'Gain','.2565',...
		'position',[115,34,160,56])

add_block('built-in/Discrete Zero-Pole',[sys,'/','Gd(z)'])
set_param([sys,'/','Gd(z)'],...
		'Zeros','[.93]',...
		'Poles','[.2]',...
		'Sample time','sqrt(2)',...
		'position',[175,28,235,62])

add_block('built-in/Discrete Zero-Pole',[sys,'/','G(z)'])
set_param([sys,'/','G(z)'],...
		'Zeros','-.98',...
		'Poles','[1 .93]',...
		'Sample time','sqrt(2)',...
		'position',[255,28,315,62])


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
		'position',[375,20,405,70])

add_block('built-in/Scope',[sys,'/','C(z)'])
set_param([sys,'/','C(z)'],...
		'Vgain','1.500000',...
		'Hgain','15.000000',...
		'Vmax','3.000000',...
		'Hmax','30.000000',...
		'Window',[300,214,640,400])
open_system([sys,'/','C(z)'])
set_param([sys,'/','C(z)'],...
		'position',[440,32,460,58])
add_line(sys,[45,40;65,40])
add_line(sys,[240,45;245,45])
add_line(sys,[100,45;105,45])
add_line(sys,[165,45;165,45])
add_line(sys,[320,45;330,45;330,90;60,90;60,50;65,50])
add_line(sys,[320,45;365,45])
add_line(sys,[410,45;430,45])

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
