% © Gergo Lajos 1998; program a Grafika c. reszhez
 x=-2:0.3:7;y=-5:0.3:5;
 [X,Y]=meshgrid(x,y);
 Z=cos(1+X).*sin(1./(1+Y.^2));
 surfc(X,Y,Z); 