function astroid(Z,bool)
%ASTROID(Z,BOOL)
%
%Z=the angle step between tracings from 0 to 2*pi ie. ASTROID(pi/2) renders four angles
%To see the circles that sweep out the astroid, put any number as the second parameter 
%of astroid ie. ASTROID(Z,1)
%
%Written by: Eric Rane 9/28/97

%clear everything out and setup the labels
hold off;
axis off;
%fake an O to get it perfectly centered
plot(0,0,'o');
hold on;
shg;

for theta=0:Z:2*pi
   
   %place a marker where the smaller circle touches the larger circle
   text(cos(theta),sin(theta),'I');
   %place a marker where the point traces the asteroid
   x=cos(theta)^3;
   y=sin(theta)^3;
   plot(x,y,'m*');
   
   a4=linspace(0,1);
   
      x=a4*cos(theta);
      y=-a4*sin(theta)+sin(theta);
      plot(x,y);
   
   if(nargin==2)

      x=a4*cos(theta);
      y=a4*sin(theta);
      plot(x,y);
         
      t=linspace(0,2*pi);
      x=(cos(t)+3*cos(theta))/4;
      y=(sin(t)+3*sin(theta))/4;
      plot(x,y);
      
      x=linspace(cos(theta)^3,cos(theta));
      y=linspace(sin(theta)^3,sin(theta));
      plot(x,y);
      
      y=linspace(0,sin(theta));
      x=cos(theta);
      plot(x,y);
      
      y=linspace(0,sin(theta));
      x=0;
      plot(x,y);
      
      t=linspace(0,theta);
      x=cos(t)/8;
      y=sin(t)/8;
      plot(x,y);
      
      t=linspace(-theta,theta);
      x=cos(t)/8+cos(theta)/2;
      y=sin(t)/8+sin(theta)/2;
      plot(x,y);      
   end
end

t=linspace(0,2*pi,1000);
y=sin(t);
x=cos(t);
plot(x,y);
axis equal;
x=cos(t).^3;
y=sin(t).^3;
comet(x,y);
plot(x,y,'red');
