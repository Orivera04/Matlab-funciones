% movie making example: rotate a 3-D surface plot
[X,Y,Z]=peaks(50);         % create data
surfl(X,Y,Z)               % plot surface with lighting
axis([-3 3 -3 3 -10 10])   % fix axes so that scaling does not change
axis vis3d off             % fix axes for 3D and turn off axes ticks etc.
shading interp             % make it pretty with interpolated shading
colormap(copper)           % choose a good colormap for lighting
for i=1:15                 % rotate and capture each frame
   view(-37.5+15*(i-1),30) % change the viewpoint for this frame
   m(i)=getframe;          % add this figure to the frame structure
end
cla       % clear axis for movie
movie(m)  % play the movie
