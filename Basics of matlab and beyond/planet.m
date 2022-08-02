v = linspace(-50,45,50);
[x,y] = meshgrid(v,v);

z1 = zeros(size(x));
z2 = z1;

r1 = sqrt((x - 20).^2 + (y - 10).^2);
r2 = sqrt((x + 12).^2 + (y + 15).^2);

indout1 = find(r1>15);
z1(indout1) = -1 ./r1(indout1).^2;
indout2 = find(r2>3);
z2(indout2) = -1 ./r2(indout2).^2;

z = z1 + z2;
k = min(min(min(z1,z2)));
indin1 = find(r1<=15);
z(indin1) = k*ones(size(indin1));
indin2 = find(r2<=3);
z(indin2) = k*ones(size(indin2));
mesh(z,[20 40])