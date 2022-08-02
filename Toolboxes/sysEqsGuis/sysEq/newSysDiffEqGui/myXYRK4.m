function newPt=myXYRK4(strExpression,h,t,currXYVal)
%Precondition: the ftns and the currXYVal must come in the order
%x,y
%this is after you give values to the string with showEq
%ie. sysStr =
%Dx=2*x + 4*y
%Dy=-x+6*y 
%Post condition: return vector of values for this system
x=currXYVal(1);
y=currXYVal(2);
[totFtn c]=size(strExpression);
format long
%calc m1=h*f(t,x,y) and k1=h*f(t,x,y)
m1=h*subs(strExpression(1,:),{'t','x','y'},{t,x,y});
k1=h*subs(strExpression(2,:),{'t','x','y'},{t,x,y});

%calc m2=h*f(t+0.5*h,x+0.5*m1,y+0.5*k1) and k2=h*f(t+0.5*h,x+0.5*m1,y+0.5*k1)
m2=h*subs(strExpression(1,:),{'t','x','y'},{t+0.5*h,x+0.5*m1,y+0.5*k1});
k2=h*subs(strExpression(2,:),{'t','x','y'},{t+0.5*h,x+0.5*m1,y+0.5*k1});

%calc m3=h*f(t+0.5*h,x+0.5*m2,y+0.5*k2) and k3=h*f(t+0.5*h,x+0.5*m2,y+0.5*k2)
m3=h*subs(strExpression(1,:),{'t','x','y'},{t+0.5*h,x+0.5*m2,y+0.5*k2});
k3=h*subs(strExpression(2,:),{'t','x','y'},{t+0.5*h,x+0.5*m2,y+0.5*k2});

%calc m3=h*f(t+h,x+m3,y+k3) and k3=h*f(t+h,x+m3,y+k3)
m4=h*subs(strExpression(1,:),{'t','x','y'},{t+h,x+m3,y+k3});
k4=h*subs(strExpression(2,:),{'t','x','y'},{t+h,x+m3,y+k3});

newX=x + (1/6)*(m1 +2*m2 + 2*m3 + m4);
newY=y + (1/6)*(k1 +2*k2 + 2*k3 + k4);
newX=str2num(char(newX));
newY=str2num(char(newY));
newPt=[newX newY];
