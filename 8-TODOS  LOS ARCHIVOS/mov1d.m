flow1d;
lim =[0 1. 0 1];
for k=1:5:150 
   plot(x,u(:,k))
   title ('concentration versus space at different times' )
   axis(lim);
   k = waitforbuttonpress;
end
