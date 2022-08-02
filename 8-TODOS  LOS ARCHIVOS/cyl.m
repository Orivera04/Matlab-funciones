N = 20;
dt = 2*pi/N;
t = 0:dt:(N-1)*dt;
%N = 20;
%t = linspace(0,2*pi,N);
x = [cos(t) cos(t)];
y = [sin(t) sin(t)];
z = [zeros(size(t)) ones(size(t))];
vert = [x' y' z'];
faces = zeros(N,4);
faces(1:N-1,1) = (1:N-1)';
faces(1:N-1,2) = ((N+1):(2*N-1))';
faces(1:N-1,3) = ((N+2):(2*N))';
faces(1:N-1,4) = (2:N)';
faces(N,:) = [N 2*N N+1 1];

%faces = zeros(N,4);
%faces(:,1) = (1:N)';
%faces(:,2) = ((N+1):(2*N))';
%faces(:,3) = ((N+2):(2*N+1))';
%faces(:,4) = (2:(N+1))';
%
%faces(N,3) = N+1;
%faces(N,4) = 1;

dist = sqrt((x + .5).^2 + y.^2 + (z-.25).^2);
T = 1./dist;


clf
colormap(hot)
view(3)
h = patch('vertices',vert,'faces',faces,'facevertexcdata',T',...
    'facecolor','interp',...
    'marker','.',...
    'markersize',30,...
    'edgecolor','flat');
axis equal
