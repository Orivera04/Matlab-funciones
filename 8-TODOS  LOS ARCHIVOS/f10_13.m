% f10_13 same as L10_8
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.13(a); List 10.8')
clear,clf
e=1.6e-19;         % Charge of electron, Coulomb
m=9.1e-31;         %  Electron mass, Kg
B=[0;0;0.1]*e/m;   % Magnetic field strength, Telsa  
E=[0;2e4;0]*e/m;   % Electri field strength, Volt/meter
h=0.5e-11;           % Time step, second
v(:,1)=1e5*[-10;2;0.1];  % Intial velocity of electron, meter/sec 
t(1)=0;             % Time intialization, sec
xyz(:,1)=[0;0;0];
epm=e/m;
for i=2:400
  t(i)=h*i;
  k1=h*(vxv_(v(:,i-1),B) + E) ; 
  k2=h*(vxv_(v(:,i-1)+k1,B) + E) ;
  v(:,i)=v(:,i-1) + 0.5*(k1+k2);
  xyz(:,i)=xyz(:,i-1)+0.5*(v(:,i-1)+v(:,i))*h;
end 
plot3(xyz(1,:), xyz(2,:),xyz(3,:))
axis([-5,5,-1,2,0,0.3]*1e-4)
xlabel('X'); ylabel('Y'); zlabel('Z');
%print electron1.ps
figure(2)
set(gcf,'NumberTitle','off','Name','Figure10.13(b); List 10.8')
plot3(xyz(1,:), xyz(2,:),xyz(3,:))
xlabel('X'); ylabel('Y'); zlabel('Z');
view([0,0,1])
%print electron2.ps
figure(3)
set(gcf,'NumberTitle','off','Name','Figure10.13(c); List 10.8')
plot3(v(1,:), v(2,:),v(3,:))
xlabel('Vx'); ylabel('Vy'); zlabel('Vz');
%print electron3.ps
figure(4)
set(gcf,'NumberTitle','off','Name','Figure10.13(d); List 10.8')
plot(t,v(1,:),t, v(2,:),t,v(3,:)*100)
xlabel('t'); ylabel('Velocities'); 
text(t(10),v(1,10), 'Vx')
text(t(30),v(2,30), 'Vy')
text(t(200),v(3,200)*100, 'Vz*100')
%print electron4.ps

