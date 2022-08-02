figure(1)
clf
R = 1;
N = 200;
gamma = 1;
[x,y] = meshgrid(linspace(-2,2,N));
r = sqrt((x + 0.4).^2 + (y + 0.4).^2);
ind = find(r>R);
r(ind) = zeros(size(ind));
g = sqrt((x - 0.4).^2 + (y + 0.4).^2);
ind = find(g>R);
g(ind) = zeros(size(ind));
b = sqrt(x.^2 + (y - 0.4).^2);
ind = find(b>R);
b(ind) = zeros(size(ind));
rgb = cat(3,r,g,b);
imagesc(rgb)
axis equal off


figure(2)
%B&W version:
q = rgb;                                          
qq = 0.3*q(:,:,1) + 0.59*q(:,:,2) + 0.11*q(:,:,3);
imagesc(qq)
map = (range(gray,.3,1));
map(1,:) = 1;            
colormap(map)
axis equal off
