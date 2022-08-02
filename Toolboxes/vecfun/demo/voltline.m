vecinit cyl
%Suppose that the total line charge is:
q=1e-8;
%The charge on the line is located within the range [-2,2]
V=q/(4*pi*r^2)*log(abs((z+2+sqrt(r^2+(z+2)^2))/(z-2+sqrt(r^2+(z-2)^2))));
%Transform to Cartesian coordinates
V2=cyl2cart(V);
%Avoid origo (infinite potential on the source charge)
ri=.1;ro=1;
V2=setrange(V2,[ri ro 51],[ri ro 51],[-5 5 51]);
plot(V2,ri,ri,-5)
colormap hot
rotate3d
%view(144.5,14)