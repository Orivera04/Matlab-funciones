function pdex14

%This is the evaluation for example #2.15 on page 12 of chapter 13
% close all

m = 0;   %1 For cylindrical evaluation, also known as the symmetry of the problem, you would enter
         % 0 if you were evaluating a slab or a 2 for spherical

x = linspace(0,1,40);  %the length of x and t must be greater than 3. The longer x is the better 
t = linspace(0,.1,40);   %accuracy will be obtained

sol = pdepe(m,@pdex14pde,@pdex14ic,@pdex14bc,x,t);

%The pdex211pde is a function for defining the components of the pde such as
%the functions of the pde which are c, f, s, that are in the form of 

%                           p=partial

%          c(x,t,u,pu/px)*pu/pt=x^(-m)*p/px*(x^m*f(x,t,u,pu/px)+s(x,t,u,pu/px)
%
% pdex211ic is the initial conditions function, and pdex215bc is the boundary 
% function.
%
%set the first solution equal to u

u = sol(:,:,1);     %the first position is tspan, the middle is position, and last is the temp

%plot the solution
figure
surf(x,t,u)

xlabel('position')
ylabel('time(t)')
zlabel('temp')
view(55,12)

%========================================================================

  set(gcf, 'PaperPosition',[0,0,5,4])           %print the image as encapsulated postscript
  print -depsc2  'example14.eps'
  

%========================================================================


figure
y=zeros(size(x));
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
plot(x,u(13,:))
plot(x,u(14,:))
xlabel('position')
ylabel('u(x,3)')
legend('Steady State Temp')

%========================================================================

 set(gcf, 'PaperPosition',[0,0,5,4])           %print the image as encapsulated postscript
 print -depsc2  'example14s.eps'
 


%=====================================================================
function [c,f,s] = pdex14pde(x,t,u,DuDx)

c=1;
f=DuDx;
s=0;

%====================================================================
function u0 = pdex14ic(x)

u0=sin(2*pi*x);
    

  
%=====================================================================

%The boundary conditions must be put into the form
%
%          p(x,t,u)+q(x,t)*f(x,t,u,pu/px)=0

function [pl,ql,pr,qr] = pdex14bc(xl,ul,xr,ur,t)

pl = ul;
ql = 0;
pr = ur;
qr = 0;
