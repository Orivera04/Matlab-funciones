% Plots a natural convection flow pattern on the cover
% needs func1 and func2
% Copyright S. Nakamura, 1995
function cav_plot
close
set(gcf, 'NumberTitle','off','Name', 'cav_plot: See back cover')

cla
load func1_.DAT   % stream funct
load func2_.DAT
for i=1:90
for j=1:30
k=i+ (j-1)*90;
x(j,i)=i;
y(j,i)=j;
f1(j,i)=func1_(k);
f2(j,i)=func2_(k); 
end
end
for i=2:2:89
for j=2:2:29
ic=i/2;
jc=j/2;
u(jc,ic)=f1(j+1,i) - f1(j-1,i); 
v(jc,ic)=-f1(j,i+1) + f1(j,i-1); 
xc(jc,ic)=x(j,i);
yc(jc,ic)=y(j,i);
end
end

%text(0, 39, ' Cellular convection flow pattern in a heated cavity')
%text(0, -2, 'Temperature distribution')

colormap jet
axis([0 80 0 80 -10 0])
view([0 0 10])
hold on
surf(x,y,-f2)
shading interp
%contour(f1)
axis([0 90 0 70 0 10])
quiver(xc,yc+40,u,v,5,'g')
axis('off')
return
