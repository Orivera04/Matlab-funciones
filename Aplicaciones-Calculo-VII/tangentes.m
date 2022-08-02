syms x;
f= '3*x^2 + 6*x +3';
ezplot(f)
derf=diff(f);
X=[-4,-2,0,2,4];
m=subs(derf,x,X);
hold on;
for i=1:5
    x0=X(i)
    y0=subs(f,x,x0)
    x1=X(i)+2
    y1=y0+m(i)*(x1-x0)*2
    plot([x0,x1],[y0,y1])
end
hold off