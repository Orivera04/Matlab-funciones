function[X,Y, Z] = Torus(a, b)
r = linspace(b-a, b+a, 10);
th = linspace(0, 2*pi, 22);
x = r'*cos(th);
y = r'*sin(th);
z = real(sqrt(a^2-(sqrt(x.^2+y.^2)-b).^2));
X = [x x];
Y = [y y];
Z = [z -z];