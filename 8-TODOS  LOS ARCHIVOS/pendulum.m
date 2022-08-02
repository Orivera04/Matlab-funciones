function pendulum(rundemo)
% pendulum(rundemo)
% This example analyzes damped oscillations of
% a simple pendulum and animates the motion.
% The governing second order differential
% equation is 
%
%   theta"(t) + 0.2*theta'(t)+sin(theta) = 0

% Type pendulum with no argument for inter-
% active input. Type pendulum(1) to run two
% example problems

% The equation of motion can be written as
% two first order equations:
% theta'(t)=w; w'(t)=-.2*w-sin(theta) 
% Letting z=[theta; w], then
% z'(t)=[z(2); -0.2*z(2)-sin(z(1))]

close; disp(' ')
disp('   DAMPED PENDULUM MOTION DESCRIBED BY')
disp(' theta"(t)+0.2*theta''(t)+sin(theta) = 0')

% Create an inline function defining the 
% differential equation in matrix form
zdot=inline(...
   '[z(2);-0.2*z(2)-sin(z(1))]','t','z');

% Set ode45 integration tolerances
ops=odeset('reltol',1e-5,'abstol',1e-5);

% Interactively input angular velocity repeatedly
if nargin==0

  while 1, close, disp(' ')
    disp('Select the angular velocity at the lowest')
    disp('point. Values of 2.42 or greater push the')
    disp(...
    'the pendulum over the top. Input zero to stop.')
    w0=input('w0 = ? > ');
	
    if isempty(w0) | w0==0
      disp(' '), disp('All Done'), disp(' '), return
    end
    disp(' ')
    t=input(['Input a vector of time values ',...
            '(Try 0:.1:30) > ? ']); 
	
    disp(' ')
    titl=input('Input a title for the graphs : ','s');
    disp(' '), disp(...
    'Input 1 to leave images of all positions shown')
    trac=input(...
        'in the animation, otherwise input 0 > ? ');  
	
    % Specify the initial conditions and solve the 
    % differential equation using ode45
    theta0=0; z0=[theta0;w0];
    [t,th]=ode45(zdot,t,z0,ops);    
    
    % Animate the motion
    animpen(t,th(:,1),titl,.05,trac)
  end

% Run two typical data cases
else

  % Choose time limits for the solution
  tmax=30; n=351; t=linspace(0,tmax,n);
  
  disp(' ')
  disp('Press return to see two examples'), pause	
    
  w0=2.42; W0=num2str(w0);
  [t,th]=ode45(zdot,t,[0;w0],ops);
  titl=['PUSHED OVER THE TOP FOR W0 = ',W0];
  animpen(t,th(:,1), titl,.05), pause(2) 
  
  w0=2.41; W0=num2str(w0);
  [t,th]=ode45(zdot,t,[0;w0],ops);
  titl=['NEARLY PUSHED OVER THE TOP FOR W0 = ',W0];
  animpen(t,th(:,1),titl,.05)
  close, disp(' '), disp('All Done'), disp(' ')
  
end

%===============================================

function animpen(t,th,titl,tim,trac)
%
% animpen(t,th,titl,tim,trac)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function plots theta versus t and animates
% the pendulum motion 
%
% t    - time vector for the solution
% th   - angular deflection values defining the
%        pendulum positions
% titl - a title shown on the graphs
% tim  - a time delay between successive steps of
%        the animation. This is used to slow down
%        the animation on fast computers
% trac - 1 if successive positions plotted in the
%        animation are retained on the screen, 0
%        if each image is erased after it is 
%        drawn

if nargin<5, trac=0; end; if nargin<4, tim=.05; end; 
if nargin<3, titl=''; end

% Plot the angular deflection
plot(t,180/pi*th(:,1),'k'), xlabel('time')
ylabel('angular deflection (degrees)'), title(titl)
grid on, shg, disp(' ')
disp('Press return to see the animation'), pause
% print -deps penangle

nt=length(th); z=zeros(nt,1); 
x=[z,sin(th)]; y=[z,-cos(th)];
hold off, close
if trac 
   axis([-1,1,-1,1]), axis square, axis off, hold on
end
for j=1:nt
   X=x(j,:); Y=y(j,:);
   plot(X,Y,'k-',X(2),Y(2),'ko','markersize',12)   
   if ~trac
	  axis([-1,1,-1,1]), axis square, axis off
   end
   title(titl), drawnow, shg
   if tim>0, pause(tim), end
end
% if trac==1, print -deps pentrace,  end
pause(1),hold off    
