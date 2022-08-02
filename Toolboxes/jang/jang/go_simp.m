global OPT_METHOD	% optimization method
OPT_METHOD = 'simp';	% this is used in peaksfcn.m 
global PREV_PT		% previous data point

var_n = 2;		% Number of input variables
range = [-3, 3; -3, 3];	% Range of the input variables
% Plot peaks function
peaks;
colormap((jet+white)/2);
% Plot contours of peaks function
figure;
[x, y, z] = peaks;
pcolor(x,y,z); shading interp; hold on;
contour(x, y, z, 20, 'r');
hold off; colormap((jet+white)/2);
axis square;
xlabel('Demo for Downhill Simplex Search');
title('Click to choose an initial point.');
drawnow;

fcn = 'peaksfcn';

% The following is for animation
AxisH = gca; FigH = gcf;
% action when button is first pushed down
action1 = ['curr_info=get(AxisH, ''currentPoint'');', ...
	'x1=curr_info(1,1);', ...
	'x2=curr_info(1,2);', ...
	'if range(1,1)<=x1&x1<=range(1,2)&range(2,1)<=x2&x2<=range(2,2),', ...
	'x=fmins(fcn, [x1, x2]);', ...
	'line(x(1), x(2), ''linestyle'', ''o'', ''markersize'', 10, ''clipping'', ''off'', ''erase'', ''none'', ''color'', ''w'', ''tag'', ''member'', ''linewidth'', 2);', ...
	'PREV_PT=[];', ...
	'end', ...
	];
% actions after the mouse is pushed down
action2 = 'fprintf('''')';
% action when button is released
action3 = [];

% temporary storage for the recall in the down_action
set(AxisH,'UserData',action2);

% set action when the mouse is pushed down
down_action=[ ...
    'set(FigH,''WindowButtonMotionFcn'',get(AxisH,''UserData''));' ...
    action1];
set(FigH,'WindowButtonDownFcn',down_action);

% set action when the mouse is released
up_action=[ ...
    'set(FigH,''WindowButtonMotionFcn'','' '');', action3];
set(FigH,'WindowButtonUpFcn',up_action);

% Make everything interruptible
set(findobj(FigH,'Interrupt','no'), 'Interrupt','yes');
