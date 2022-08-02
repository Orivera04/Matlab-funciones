figure(1)
clf
R = 0.5;
N = 200;
[x,y] = meshgrid(linspace(-1,1,N));
r = zeros(size(x));                   
rind = find((x + 0.2).^2 + (y + 0.2).^2 < R^2);
r(rind) = ones(size(rind));
g = zeros(size(x));       
gind = find((x - 0.2).^2 + (y + 0.2).^2 < R^2);
g(gind) = ones(size(gind));
b = zeros(size(x));    
bind = find(x.^2 + (y - 0.2).^2 < R^2);    
b(bind)=ones(size(bind));
rgb = cat(3,r,g,b);
imagesc(rgb)
axis equal off

figure(2)
%B&W version:
q = rgb;                                          
qq = 0.3*q(:,:,1) + 0.59*q(:,:,2) + 0.11*q(:,:,3);
imagesc(qq)
map = (range(gray,.5,1));
map(1,:) = 1;            
colormap(map)
axis equal off