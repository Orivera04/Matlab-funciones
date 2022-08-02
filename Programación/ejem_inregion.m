%   Ejemplo para inregion
     xv = [-3 -3 1 1 3 1 -1 -1 -3];
     yv = [-3 -1 3 1 1 -1 -1 -3 -3];
     [x,y] = meshgrid(-3:1/2:3);
     [in,on] = inregion(x,y,xv,yv);
     p = find(in-on);
     q = find(on);
     plot(xv,yv,'-',x(p),y(p),'ko',x(q),y(q),'ro')
     axis([-5 5 -4 4])

% If (xv,yv) is not closed, close it.
