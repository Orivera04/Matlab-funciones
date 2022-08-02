aVector=[10 15 10 10];
bVector=[10 10 15 10];
cVector=[10 10 10 15];
trial=1;

a=aVector(trial);
b=bVector(trial);
c=cVector(trial);
loadJK=[-92 0 0 (a+b+c)];
unknownDirections=[DR(90),12,b+c;DR(180),12,b+c;DR(180),12,0];
unknownForces=threevector(loadJK,unknownDirections);
PointG=twovector(loadJK,[DR(-90) atan2(-a,12)]);
magJ=mag(PointG(2,:));
PointH=twovector(unknownForces(3,:),[atan2(c,-12),DR(90)]);
magK=mag(PointH(1,:));
areaJK=rectube(0.4,0.4,0.2,0.05,'area');
AverageNormalJ=magJ/areaJK
AverageNormalK=magK/areaJK
