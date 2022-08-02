%Programa para representar de manera animada el proceso de límite,
clear
clc
syms x
f = (x^3 - 23*x^2 + 124*x + 78)/(x-13);
hold on
ezplot (f,[0,15]);
g=simplify(f);
c=13;
yc=subs(g,x,c);
plot(c,yc,'ok')
h=0.2;
xval=10;
disp('valores x  valores y')
axis([0 15 -10 250])
while xval < 12.8
    yval=subs(f,x,xval);
    fprintf('\n%f %f\n' ,xval,yval)
    plot(xval,0,'*r');
    plot(0,yval,'ko');
    plot([xval xval],[0 yval])
    plot([0 xval],[yval yval])
    pause(3);
    xval=xval+h;
    
end
hold off
fprintf('\n')
disp(['El límite de f en x=13 es: ',num2str(yc)])
