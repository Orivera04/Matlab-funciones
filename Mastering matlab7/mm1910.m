% mm1910.m

x =[0     -0.31786        1.095       -1.874      0.42818      0.89564 ...
 0.73096      0.57786     0.040314      0.67709       0.5689     -0.25565];

y =[-0.54648     -0.84676     -0.24634      0.66302      -0.8542      -1.2013...
     -0.11987    -0.065294       0.4853     -0.59549     -0.14967     -0.43475];

%z = rand(1,12); % no z component for now

z=[0.12105 0.45075 0.71588 0.89284 0.2731 0.25477...
   0.8656  0.23235 0.80487 0.9084  0.23189 0.23931];
xi = linspace(min(x),max(x),30); % desired x points
yi = linspace(min(y),max(y),30); % desired y points
[Xi,Yi] = meshgrid(xi,yi); % create mesh grid
Zi = griddata(x,y,z,Xi,Yi); % grid the scattered data at Xi,Yi points
mesh(Xi,Yi,Zi)
hold on
plot3(x,y,z,'ko')  % show original data
hold off
title('Figure 19.10: Griddata Example')