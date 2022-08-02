function examplecwave
% This function creates an example wave plot
% for a circular membrane
clf
[u,x,y,t]=membwave(2,.5,1,6*pi,1.5);
colormap([1 1 0]), k=fix((size(u,3)-1)/8);
n=1+k*(0:8); ninesurfs(x,y,1.5*u(:,:,n)); 
m=size(u,3); clf
d=[min(x(:)), max(x(:)), min(y(:)), max(y(:)),...
   min(u(:)), max(u(:))]; 

for j=1:m
  surf(-x,y,-1.5*u(:,:,j)), xlabel(num2str(j))
  axis(d)
  axis equal
  colormap([1 1 0])
  colormap('default')
  axis off
  title(['Index = ',num2str(j)])
  shg, pause
end

function ninesurfs(x,y,z)
% ninesurfs(x,y,z) plots nine surfaces
if nargin==0, [x,y,z]=sphere; end
d=[min(x(:)), max(x(:)), min(y(:)), max(y(:)),...
   min(z(:)), max(z(:))];  
colormap([1 1 0]);  %colormap('default')
subplot(3,3,1), surf(x,y,z(:,:,1)), axis(d), axis equal, axis off, shg, % pause
subplot(3,3,2), surf(x,y,z(:,:,2)), axis(d), axis equal, axis off, shg, % pause
subplot(3,3,3), surf(x,y,z(:,:,3)), axis(d), axis equal, axis off, shg, % pause
subplot(3,3,4), surf(x,y,z(:,:,4)), axis(d), axis equal, axis off, shg, % pause
subplot(3,3,5), surf(x,y,z(:,:,5)), axis(d), axis equal, axis off, shg, % pause
subplot(3,3,6), surf(x,y,z(:,:,6)), axis(d), axis equal, axis off, shg, % pause
subplot(3,3,7), surf(x,y,z(:,:,7)), axis(d), axis equal, axis off, shg, % pause
subplot(3,3,8), surf(x,y,z(:,:,8)), axis(d), axis equal, axis off, shg, % pause
subplot(3,3,9), surf(x,y,z(:,:,9)), axis(d), axis equal, axis off, shg,  pause
subplot