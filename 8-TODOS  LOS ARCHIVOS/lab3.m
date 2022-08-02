%Utilizando la orden ezplot
syms x
f=(x^3-9*x^2-45*x-91)/(x-13);
hold on
ezplot (f,[-15,15]);
g=simplify(f);
c=13;
yc=subs(g,x,c);
plot(c,yc,'ok')
h=0.4;
xval=10;
disp('valores x  valores y')
axis([0 15 0 250])
while xval < 13
    yval=subs(f,x,xval);
    fprintf('\n%f %f\n' ,xval,yval)
    plot(xval,0,'*r');
    plot(0,yval,'ko');
    plot([xval xval],[0 yval])
    plot([0 xval],[yval yval])
    pause(5);
    xval=xval+h;
    
end
hold off
