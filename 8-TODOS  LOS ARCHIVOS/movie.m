%First, decide on the number of frames 
nframes = 50; n=50; s=0.1
%Next, set up the first plot as before, except using the default EraseMode (normal). 
x = rand(n,1)-0.5;
y = rand(n,1)-0.5;
h = plot(x,y,'.');
set(h,'MarkerSize',18);
axis([-1 1 -1 1])
axis square
axis off
grid off
%Generate the movie and use getframe to capture each frame. 
for k = 1:nframes
   x = x + s*randn(n,1);
   y = y + s*randn(n,1);
   set(h,'XData',x,'YData',y)
   M(k) = getframe;
end
%Finally, play the movie 30 times. 
movie(M,30)