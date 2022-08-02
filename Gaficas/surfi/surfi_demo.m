
function surfi_demo(N)

if nargin<1
	N=1000;
end

% generate vertices
X = rand(1,N);
Y = rand(1,N);
D = (0.5-X).^2 + (0.5-Y).^2;
M = 0.001./D;
M = min(M,0.5);
Z = 0.5 - D - M;

% surface plot them
figure(1)
clf
surfi(X,Y,Z)
