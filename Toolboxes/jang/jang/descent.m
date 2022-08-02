% Animation for steepest descent, Newton, and LM directions 
%
% Roger Jang, June 9, 1996

obj_fcn = 'paraf';	% a parabolic surface
obj_fcn = 'banana';	% banana function
obj_fcn = 'hyperf';	% a saddle point (this is used in the textbook)
obj_fcn = 'peaksf';	% peaks function

point_n = 50;
x=linspace(-3, 3, point_n);
y=linspace(-3, 3, point_n);
[xx,yy]=meshgrid(x,y);
zz=feval(obj_fcn, xx, yy);
figure('name', 'Objective Function', 'NumberTitle', 'off');
blackbg;
mesh(xx, yy, zz);
if matlabv==4,
	circleH = line(nan, nan, nan, 'linestyle', 'o', 'erasemode', 'xor');
elseif matlabv==5,
	circleH = line(nan, nan, nan, 'marker', 'o', 'erasemode', 'xor');
else
	error('Unknown MATLAB version');
end
xlabel('X'); ylabel('Y'); zlabel('z = f(x, y)'); title('Objective Function');
axis([-inf inf -inf inf -inf inf]);
set(gca, 'box', 'on');

figure('name', 'Steepest Descent, Newton, and LM Directions', 'NumberTitle', 'off');
blackbg;
contour(xx, yy, zz, 20);
axis image;
title('Click to see steepest descent (green) and Newton (white) directions.');
xlabel('LM directions: lambda = 1 (yellow) and lambda = 4 (cyan)');

gradH = line(nan, nan, 'erase', 'xor', 'color', 'g');
hessH = line(nan, nan, 'erase', 'xor', 'color', 'w');
LM1H =   line(nan, nan, 'erase', 'xor', 'color', 'y');
LM2H =   line(nan, nan, 'erase', 'xor', 'color', 'c');
AxisH = gca; FigH = gcf;

s = 0.2;
xx = [0 1 nan 1-s 1 1-s].';
yy = [0 0 nan s/2 0 -s/2].';
arr = xx + yy.*sqrt(-1);	% Avoid using "arrow" since it's a function
lambda1 = 1;
lambda2 = 4;

% The following is for animation

% action when button is first pushed down
action1 = ['curr_info=get(AxisH, ''currentPoint'');', ...
	'x=curr_info(1,1);', ...
	'y=curr_info(1,2);', ...
	'height=feval(obj_fcn,x,y);', ...
	'set(circleH,''xdata'',x,''ydata'',y,''zdata'',height);', ...
	'grad=feval(obj_fcn,x,y,1);', ...
	'tmp=-grad/norm(grad);', ...
	'grad_arr=arr*(tmp(1)+j*tmp(2))+x+j*y;', ...
	'set(gradH,''xdata'',real(grad_arr),''ydata'',imag(grad_arr));', ...
	'hessian_matrix=feval(obj_fcn,x,y,2);', ...
	'tmp=-inv(hessian_matrix)*grad;', ... 
	'tmp=tmp/norm(tmp);', ...
	'hess_arr=arr*(tmp(1)+j*tmp(2))+x+j*y;', ...
	'set(hessH,''xdata'',real(hess_arr),''ydata'',imag(hess_arr));' ...
	'tmp=-inv(hessian_matrix+lambda1*eye(size(hessian_matrix)))*grad;', ... 
	'tmp=tmp/norm(tmp);', ...
	'lm_arr=arr*(tmp(1)+j*tmp(2))+x+j*y;', ...
	'set(LM1H,''xdata'',real(lm_arr),''ydata'',imag(lm_arr));', ...
	'tmp=-inv(hessian_matrix+lambda2*eye(size(hessian_matrix)))*grad;', ... 
	'tmp=tmp/norm(tmp);', ...
	'lm_arr=arr*(tmp(1)+j*tmp(2))+x+j*y;', ...
	'set(LM2H,''xdata'',real(lm_arr),''ydata'',imag(lm_arr));'];
% actions after the mouse is pushed down
action2 = action1;
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
