heat2d;
lim =[0 1 0 1 0 400];
for k=1:5:200
   mesh(x,y,u(:,:,k)')
   title ('heat versus space at different times' )
   axis(lim);
  k = waitforbuttonpress;
end
