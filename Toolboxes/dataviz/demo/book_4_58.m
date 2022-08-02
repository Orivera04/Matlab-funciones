%  book_4_58.m
%  calls loess2

load galaxy

%  loess surface fit parameters
alpha = 0.25;
lambda = 2;

%  smooth and grid the data
XI = -25:3:25;
YI = (-45:3:45)';
nx = length(XI);
ny = length(YI);
newx = repmat(XI,ny,1);
newy = repmat(YI,1,nx);
newz = loess2(EastWest,NorthSouth,Velocity,newx,newy,alpha,lambda,1);

mesh(newx,newy,newz);
xlabel('East-West')
ylabel('North-South')
zlabel('Velocity')
title('Galaxy')
view(150,25)
