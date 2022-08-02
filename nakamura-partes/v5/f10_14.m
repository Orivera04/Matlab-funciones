% f10_14  same as L10_9
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name',...
         'Figure 10.14; List 10.9')
clear,clf
M=0.5; k = 100; B=0; a = B/M;
b = k/M; n=0; t=0; h = 0.025;
y(:,1) = [1;0]; t(1)=0; % initial condition
M=[0,1; -b,-a];
while t<=1
 n=n+1;
  k1 = h*M*y(:,n);
  k2 = h*M*(y(:,n)+k1/2);
  k3 = h*M*(y(:,n)+k2/2);
  k4 = h*M*(y(:,n)+k3);
  y(:,n+1) = y(:,n) + (k1 + 2*k2 + 2*k3 + k4)/6;
  t(n+1) = n*h;
end
plot(t,y(1,:), '-', t,y(2,:),':');
h1=text(0.6513,  -17.8152,'t (s)');
set(h1,'FontSize',[18])
h2=text(-0.1247,  -3.1232, ' y and v');
set(h2,'FontSize',[18],'Rotation',[90])
text(t(5),y(1,5)+0.3,'Displacement, u','FontSize',[18])
text(t(7),y(2,7),'Velocity, v','FontSize',[18])
axis([0,1,-15,15])
%print x10_14fig.ps

