% cap5_quiver3_exemplo
x=-pi:0.5:pi;
y=-pi:0.5:pi;
[MX,MY]=meshgrid(x,y);
MZ=sin(MX)+cos(MY);
[U,V,W]=surfnorm(MX,MY,MZ);
quiver3(MX,MY,MZ,U,V,W);
hold on
surf(MX,MY,MZ)
