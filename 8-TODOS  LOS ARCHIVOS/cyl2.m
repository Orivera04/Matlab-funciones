N = 100; % Number of points around the circle
M = 30; % Number of circles in the cylinder
dt = 2*pi/N;
t = (0:dt:(N-1)*dt)';
h = linspace(0,1,M); % vector of heights
xv = cos(t);
yv = sin(t);

% Reproduce the vertices at different heights:
x = repmat(xv,M,1);
y = repmat(yv,M,1);
z = ones(N,1)*h;
z = z(:);
vert = [x y z];

% These are the facets of a single 'layer':
facets = zeros(N,4);
facets(1:N-1,1) = (1:N-1)';
facets(1:N-1,2) = ((N+1):(2*N-1))';
facets(1:N-1,3) = ((N+2):(2*N))';
facets(1:N-1,4) = (2:N)';
facets(N,:) = [N 2*N N+1 1];

% Reproduce the layers at the different heights:
faces = zeros((M-1)*N,4);
for i=1:M-1
  rows = (1:N) + (i - 1)*N;
  faces(rows,:) = facets + (i - 1)*N;
end

%Define heat source and temperature:
xs = -0.5;
ys = 0;
zs = 0.25;
dist = sqrt((x - xs).^2 + (y - ys).^2 + (z - zs).^2);
T = 1./dist;

clf
colormap(hot)
h = patch('vertices',vert,'faces',faces,'facevertexcdata',T,...
    'facecolor','interp',...
    'edgecolor',[.5 .7 0],...
    'linestyle','.');
view(78,36)
axis equal
% Plot the source:
hold on
plot3([xs xs],[ys ys],[0 zs])
plot3(xs,ys,zs,'*')