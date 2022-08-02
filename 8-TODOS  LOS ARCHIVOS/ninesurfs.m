function ninesurfs(x,y,z)
% ninesurfs(x,y,z) plots nine surfaces
if nargin==0, [x,y,z]=sphere; end
d=[min(x(:)), max(x(:)), min(y(:)), max(y(:)),...
   min(z(:)), max(z(:))];  
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