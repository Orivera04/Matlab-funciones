function pdex211

%This is the evaluation of example 1.

close all

m = 0;   % For slab evaluation, also known as the symmetry of the problem, 1 for cylindrical, 2 for
         % spherical.

x = linspace(0,1,40);  %This creates 40 equally spaced points between 0 and 1
t = linspace(0,15,20); %This creates 20 equally spaced time points between 0 and 20

sol = pdepe(m,@pdex211pde,@pdex211ic,@pdex211bc,x,t);

%The pdex211pde is a function for defining the components of the pde, that are the column
%vectors c,f,s.  The pde has to be put into the form shown below. 
%
%                           p=partial
%
%          c(x,t,u,pu/px)*pu/pt=x^(-m)*p/px*(x^m*f(x,t,u,pu/px)+s(x,t,u,pu/px)
%
% pdex211ic is the initial conditions function, and pdex211bc is the boundary 
% function.
%
%

u = sol(:,:,1);     %extract the first solution component

%plot the solution

surf(x,t,u)
xlabel('position')
ylabel('time(t)')
zlabel('temp')


%========================================================================

 set(gcf, 'PaperPosition',[0,0,5,4])           %print the image as encapsulated postscript
 print -depsc2  'example1.eps'
 

%========================================================================

%plot the solution to the ivb-problem at various times

figure
y=100*x;
plot(x,y,'r:')
hold on
plot(x,u(1,:))
plot(x,u(2,:))
plot(x,u(3,:))
plot(x,u(4,:))
plot(x,u(5,:))
plot(x,u(6,:))
plot(x,u(7,:))
plot(x,u(8,:))
plot(x,u(9,:))
plot(x,u(10,:))
plot(x,u(11,:))
plot(x,u(12,:))
xlabel('position')
ylabel('u(x,3)')
legend('steady state temp')
%========================================================================

 set(gcf, 'PaperPosition',[0,0,5,4])           %print the image as encapsulated postscript
 print -depsc2  'example1s.eps'
 
%=====================================================================

function [c,f,s] = pdex211pde(x,t,u,DuDx);

c = 1/.02;
f = DuDx;       %from the form shown earlier
s = 0;

%======================================================================

function u0 = pdex211ic(x);
 
u0 = 0;

%=======================================================================

%             put into the form,
%
%         p(x,t,u)+q(x,t)f(x,t,u,DuDx)=0
%

function  [p1,q1,pr,qr]=pdex211bc(x1,u1,xr,ur,t);

p1 = u1;
q1 = 0;
pr = ur-100;
qr = 0;


% After running this program you can see that the solution is approaching 
% the steady state solution which is ((T_L-T_0)/L)x+T_0 which for this equation equals 100x.
% You can increase the time values at the top to  see it converge a little better.  
