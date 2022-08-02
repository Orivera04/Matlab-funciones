[X,Y] = meshgrid(-3:.125:3);
Z = peaks(X,Y);
surfl(X,Y,Z);
axis vis3d
axis off
movieAz360(50,'test.avi',100);