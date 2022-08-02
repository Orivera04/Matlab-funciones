[x,y]=meshgrid(-2:.1:2,-2:.1:2);
z=3*ones(41,41);
surf(x,y,z,'AlphaDataMapping','scaled',...
'AlphaData',gradient(z),'FaceColor','green');alpha(0.5);
hold on;
w=x.^2+y.^2;
surf(x,y,w,'AlphaDataMapping','scaled',...
     'AlphaData',gradient(z),'FaceColor','red');alpha(0.5);
 t=0:.1:2*pi;
 u=sqrt(3)*cos(t);
 v=sqrt(3)*sin(t);
 [m,n]=size(u);
 w1=3*ones(1,n);
 %w2=zeros(1,n);proyeccion de interseccion sobre XY.
 plot3(u,v,w1,'b')%agregando u,v,w2,'b' grafica proyeccion.
