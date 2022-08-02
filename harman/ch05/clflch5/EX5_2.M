% EX5_2.M Plot solution to ydot=1/(t-1)
% for 3 initial values. y=ln|t-1|+c.
c=[-10 0 6.9014];         % Define constant values 
t=[1.005:.1:10];          % Define t to avoid t=1
m=length(t);
n=length(c);
y=zeros(m,n);             
for I=1:3
 y(:,I) =log(abs(t-1)') + c(I);
end
clf                       % Clear any figures
plot(t,y(:,1),t,y(:,2),t,y(:,3))
xlabel('t')
ylabel('y(t)')
title('Solution of dy/dt=1/(t-1)')
grid
axis([0,10,-20,20])       % Plot limits 
gtext('(t0,y0)=(2,-10)')  % Annotate with mouse clicks  
gtext('(t0,y0)=(2,0)')
gtext('(t0,y0)=(4,8)')
%
% Note: Using gtext command, the figure will be annotated where you click 
%   with the mouse (cursor). 
%	