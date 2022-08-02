function parachute

%Define time interval of the jump
tstart=0;
tfinal=30;

%Define initial conditions. At t=0, position and velocity are both 0.
x0=[0,0];

%Define the variable that is to be changed at event trapped. The coefficient of drag is k1
%until the parachute is deployed, then it is k2.
k1=16.23;
k2=186.68;

%Set options for ode45. eventsm refers to a function m-file, at the end of this file that 
%defines the event to be trapped. In this case it is the time at which the paratrooper 
%reaches the end of the static line, when x=-9.81 meters.
options=odeset('Events',@eventsm);

%Define axis limits
set(gca,'xlim',[0 30]);

%Define output vectors.
tout = tstart;
xout = x0;
teout = [];
xeout = [];

%Run the ode45 solver using the pre-defined options and initial conditions
[t,x,te,xe,ie]=ode45(@projectm,[tstart,tfinal],x0,options,k1);

% Accumulate output. The vectors tout and xout will accumulate the output data of ode45. 
nt = length(t);
tout = [tout; t(2:nt)];
xout = [xout; x(2:nt,:)];


% Set the new initial conditions to be used at the time of the trapped event. t2start is the time 
% of the trapped event, x0(1) & x0(2) are the respective values of x at that time.
t2start=t(33,1);
x0(1) = x(nt,1);
x0(2) = x(nt,2);

%Run the ode45 solver again with the new initial conditions, with k1 substituted for k2
[t,x,te,xe,ie]=ode45(@projectm,[t2start,tfinal],x0,options,k2);

% Accumulate output. tout2 and xout2 will accumulate the continuous data for the entire duration
% of the jump. This is the data required for the project.
nt2 = length(t);
tout2 = [tout; t(2:nt2)];
xout2 = [xout; x(2:nt2,:)];
    
    
%plot of time vs. position component of x
plot(tout2,xout2(:,1))
title('Graph of Position vs. Time')
xlabel('Time')
ylabel('Position')
grid on

% The following two lines of code, when uncommented, will save a copy of the graph, in .eps format, to the
% the directory this file is saved in. It will do this every time that the program is run.  Therefore it is
% wise to leave them commented during any trials, only uncommenting them when needed. This applies to the 
% identical lines of code following the next graph.

% set(gcf,'PaperPosition',[0,0,4,3])
% print -depsc2 figure2.eps

%plot of time vs. velocity component of x
figure
plot(tout2,xout2(:,2))
title('Graph of Velocity vs. Time')
xlabel('Time (seconds)')
ylabel('Velocity (meters/second)')
grid on

% set(gcf,'PaperPosition',[0,0,4,3])
% print -depsc2 figure3.eps


%function m-file to define the system of equations for the ode45 program
function xprime=projectm(t,x,k)

xprime=zeros(2,1);
xprime(1)=x(2);
xprime(2)=-9.81-k*x(2)/97.4;


%function m-file that defines the event to be trapped.
function [value,isterminal,direction] = eventsm(t,x,k)
% Locate the time when x=-9.81 meters and change k values
% This represents the time at which the chute is deployed


value = x(1)+9.1;     % Detect height -9.81m
isterminal = 1;       % Stop the integration
direction = 0;        % detects all zeros
