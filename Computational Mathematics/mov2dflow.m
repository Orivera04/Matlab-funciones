% This generates a sequence of 3D plots of concentration.
flow2d;
lim =[0 1 0 4 0 3];
for k=1:5:200
   %contour(x,y,u(:,:,k)')
   mesh(x,y,u(:,:,k)')
   title ('concentration versus space at different times' )
   axis(lim);
   k = waitforbuttonpress;
end
