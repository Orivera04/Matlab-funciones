function z=plotsurface2(surface,s,s0,s1,t,t0,t1)
surface1=subs(surface,{s,t},{'x1','y1'});
[x1,y1]=meshgrid(s0:.01*(s1-s0):s1,t0:.01*(t1-t0):t1);
X2=eval(vectorize(surface1(1)));
Y2=eval(vectorize(surface1(2)));
Z2=eval(vectorize(surface1(3)));
surf(X2,Y2,Z2)