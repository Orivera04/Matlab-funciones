[X,Y,Z]=sphere(12);
subplot(1,2,1)
mesh(X,Y,Z), title('Figure 26.5a: Opaque')
hidden on
axis square off
subplot(1,2,2)
mesh(X,Y,Z), title('Figure 26.5b: Transparent')
hidden off
axis square off