N = 100;
v = linspace(0,1,N);
[x,y] = meshgrid(v);
x = [1; 1]*x(:)';
y = [1; 1]*y(:)';
z = [zeros(1,N^2); 0.01*ones(1,N^2)];
plot3(x,y,z,'r')
set(gca,'proj','per')  
axis equal
set(gca,'cameraposition',[.5 -1 .2])
drawnow
axis vis3d off
set(gca,'cameraposition',[.5 -.1 0.03])
disp('Done.')

