af=[-4 0 0 3;deg2xy([45 7 1 1])];
ycord=rectangl(2,1,'centY'); % Find centroid of section
[force, momment]=reaction(af,[5,ycord]);
fnormal=mag(force,'x');
fshear=mag(force,'y');
area=rectangl(2,1,'area');
normalstress=fnormal/area