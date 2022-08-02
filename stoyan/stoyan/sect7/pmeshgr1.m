% © Gergo Lajos 1998; program a Grafika c. reszhez
x=linspace(-2,2,100);
y=x;
[xx,yy]=meshgrid(x,y);
z=peaks(xx,yy).*sin(xx);
contour(x,y,z);