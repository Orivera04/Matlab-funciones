[x,y,z] = sphere(200);
N = size(x,1);
x = x + randn(N)/500;
y = y + randn(N)/500;
z = z + randn(N)/500;
clf
h = surfl(x,y,z,[90,0],[0 1 0 0]);
shading flat
colormap(range(gray,.5,1))
view(-20,0)
axis  equal
axis off
