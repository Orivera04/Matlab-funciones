% EXFFLOW.M Plot the function u=xy and the streamlines 
%   Use cursor and mouse to annotate graph with u and v (gtext)
%
clear
clf
xline=0:001:3;		% 45 deg. line
yline=xline;
c=[1,3,5]
x1=1:.001:5;
x2=1.7:.001:5;
x3=2:.001:5;
u_c1=c(1)./x1;
u_c2=c(2)./x2;
u_c3=c(3)./x3;
plot(xline,yline)
hold
plot(x1,u_c1,'--',x2,u_c2,'--',x3,u_c3,'--')
% plot the field lines x^2-y^2=const
c=[1 2 3] 
x1=1:.005:5;
y1=sqrt(x1.^2 - c(1)^2);
x2=2:.005:5;
y2=sqrt(x2.^2 - c(2)^2);
x3=3:.005:5;
y3=sqrt(x3.^2 - c(3)^2);
plot(x1,y1,x2,y2,x3,y3)
axis([0 5 0 5])
title('Potential u=xy and Field v=y*i+x*j')
gtext('u')
gtext('v')
xlabel('x')
ylabel('y')
%
% Version 5:  changed call to title (lower case)
