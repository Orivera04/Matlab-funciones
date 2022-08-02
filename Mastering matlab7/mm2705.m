% mm2705.m
[X,Y,Z]=sphere(12);
subplot(1,2,1)
mesh(X,Y,Z), title('Figure 27.5a: Opaque')
hidden on
axis square off
subplot(1,2,2)
mesh(X,Y,Z), title('Figure 27.5b: Transparent')
hidden off
axis square off