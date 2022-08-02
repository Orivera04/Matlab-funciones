function pdeprb6

% close all
 
m=0;

x=linspace(0,1,30);
t=linspace(0,.15,30);

sol=pdepe(m,@pdeprb6pde,@pdeprb6ic,@pdeprb6bc,x,t)

u=sol(:,:,1);
figure
surf(x,t,u)
xlabel('position')
ylabel('time')
zlabel('temp')
az = 58;
el = 10;
view(az, el);
%========================================================================

 set(gcf, 'PaperPosition',[0,0,5,4])           %print the image as encapsulated postscript
 print -depsc2  'example4.eps'
  

%========================================================================
figure
y=.25*ones(size(x));
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
xlabel('position')
ylabel('temp')
legend('steady state temp')

%========================================================================

 set(gcf, 'PaperPosition',[0,0,5,4])           %print the image as encapsulated postscript
 print -depsc2  'example4s.eps'
 

%========================================================================
function [c,f,s]=pdeprb6pde(x,t,u,DuDx)

c=1;
f=DuDx;
s=0;

function u0=pdeprb6ic(x)

if x < 1/2
    u0=x;
else
    u0=(1-x);
end

function [p1,q1,pr,qr]=pdeprb6bc(x1,u1,xr,ur,t)

p1=0;
q1=1;
pr=0;
qr=1;
