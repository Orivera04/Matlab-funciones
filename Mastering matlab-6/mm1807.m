
x =[0     -0.31786        1.095       -1.874      0.42818      0.89564 ...
 0.73096      0.57786     0.040314      0.67709       0.5689     -0.25565];

y =[-0.54648     -0.84676     -0.24634      0.66302      -0.8542      -1.2013...
     -0.11987    -0.065294       0.4853     -0.59549     -0.14967     -0.43475];

z = zeros(1,12); % no z component for now

plot(x,y,'o')

tri = delaunay(x,y);
hold on, trimesh(tri,x,y,z), hold off
hidden off
title('Figure 18.7: Delaunay Triangulation')
axis([-2 1.5 -1.5 1])