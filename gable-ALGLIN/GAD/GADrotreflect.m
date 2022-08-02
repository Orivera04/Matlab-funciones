% |
% |  TWO REFLECTIONS MAKE A ROTATION
% |
v = e1; %/
w = e2; %/
I2 = v^w/norm(v^w); %/
phi = pi/4;%/
R = gexp(-I2*phi/2);%/
x = e1+e3;%/
clf;%/
draw(x,'r'); GAtext(1.1*x,'x','r'); %/
axis off; %/
draw(I2,'y'); %/
draw(v,'g'); GAtext(1.1*v,'v','g'); %/
Rv = R*v; %/
draw(Rv,'g'); GAtext(1.1*Rv,'w','g'); %/
axis([-0.6 1 -0.6 0.7 -1 1]);
% |  a vector x and the v^w- plane 
% |
GAprompt; %/
Sx = v*x/v; %/
draw(Sx,'b'); GAtext(1.1*Sx,'v x v^{-1}','b'); %/
DrawPolyline({x,Sx},'m'); %/
axis([-0.6 1 -0.6 0.7 -1 1]);
% |  first reflection, in v
% |
GAprompt; %/
Rx = Rv*Sx/Rv; %/
draw(Rx,'r'); GAtext(1.1*Rx,'(w v) x (w v)^{-1}','r'); %/
DrawPolyline({Sx,Rx},'m'); %/
axis([-0.6 1 -0.6 0.7 -1 1]);
% |  second reflection, in v
% |
   n = 10; %% number of points on rotation arc %/
   DR = gexp(-I2*phi/2/n); %/
   y = x; %/
   for i=1:n %/
      yy = DR*y/DR; %/
      DrawPolyline({y,yy},'k'); %/
      y = yy; %/
   end %/
rej = (x^I2)/I2; %/ 
DrawPolyline({x,rej,Rx},'k'); %/
DrawPolyline({0.00001*e1,rej},'k'); %/
axis([-0.6 1 -0.6 0.7 -1 1]);
% |  the result is a rotation in the v^w-plane,
% |  over twice the angle from v to w
% |
GAorbiter(-360,10); %/
