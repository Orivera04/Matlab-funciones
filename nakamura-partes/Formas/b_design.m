% b_design: used in fan_rot for Fig B.1
function [thb,zb]=b_design
 minz=-0.5; 
maxz=0.1;
 minth=-0.4;
 maxth=0.4;
r=0.4;
dth=pi/32;
th=0:dth:2*pi   ;
x=r*cos(th);
y=r*sin(th).* (x+0.5).*(5-x)/15  ...
        - (x+0.4).*(x-0.4)+ (0.6/0.8)*(x)-0.2 ;
thb=x;
zb=y;






