vert = [0 0 0
    1 1 0
    1 -1 0
    1 0 -1
    1 0 1];
fac = [1 2 3
    1 4 5];
clf
patch('verti',vert,'faces',fac,'facecolor','y')
view(3)
box
xyz

vert2 = [0 0 0
    1 1 0
    1 -1 0
    1 0 -1
    1 0 1
    1 0 0];
fac2 = [1 2 6
    1 6 3
    1 4 6
    1 6 5];

clf
patch('verti',vert2,'faces',fac2,'facecolor','y')
view(3)
box
xyz
