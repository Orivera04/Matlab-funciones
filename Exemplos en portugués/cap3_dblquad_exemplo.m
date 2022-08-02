echo on
% cap3_dblquad_exemplo
d=dblquad('cap3_funcao4',-1,1,-1,1)
x=-2:0.1:2;
y=-2:0.1:2;
[X,Y]=meshgrid(x,y);
xd=-1:0.1:1;
yd=-1:0.1:1;
[XD,YD]=meshgrid(xd,yd);
Z=cos(X)+cos(Y);
ZD=cos(XD)+cos(YD);
surf(X,Y,Z)
alpha(0.4)
hold
waterfall(XD,YD,ZD)