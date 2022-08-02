     disp('>> % 	INNER PRODUCT');
     % 	INNER PRODUCT
     GAfigure; clc; %/
     disp('>> % 	INNER PRODUCT');
     % 	INNER PRODUCT
     disp('>> %');
     %
     global x B v w; %/
     clf; %/
     disp('>> % 	The inner product of two vectors is a scalar ');
     % 	The inner product of two vectors is a scalar 
     disp('>> % 	(its magnitude denotes the relative angle)');
     % 	(its magnitude denotes the relative angle)
     fprintf(1,'\n');     disp('>> v = e1;');
     v = e1;
     disp('>> w = unit(e1 + e2);');
     w = unit(e1 + e2);
     draw(v,'b'); %/
     GAtext(0.7*v - 0.1*unit(e2^v)/I3,'v'); %/
     draw(w,'g'); %/
     GAtext(0.7*w + 0.1*unit(e2^w)/I3,'w'); %/
     fprintf(1,'>> inner(v,w)  ');
     input('');
     inner(v,w) %w
     disp('>> % Geometrically, this is a zero-dimensional subspace:');
     % Geometrically, this is a zero-dimensional subspace:
     disp('>> % a weighted point at the origin.');
     % a weighted point at the origin.
     draw(inner(v,w),'r'); %/
     draw(I3/100000,'r'); %/
     GAprompt; %/
     fprintf(1,'\n');     disp('>> % 	The inner product x.B of a vector x and a bivector B is ');
     % 	The inner product x.B of a vector x and a bivector B is 
     disp('>> % 	a vector in B, perpendicular to x');
     % 	a vector in B, perpendicular to x
     disp('>> % 	(its magnitude denotes the relative angle)');
     % 	(its magnitude denotes the relative angle)
     fprintf(1,'\n');     clf; %/
     disp('>> x = unit(e1 + e3); ');
     x = unit(e1 + e3); 
     draw(x,'b'); %/
     GAtext(0.7*x + 0.1*unit(e2^x)/I3,'x'); %/
     disp('>> B = e1^e2; ');
     B = e1^e2; 
     draw(B,'y'); %/
     GAtext(-0.5*v+0.1*B/I3,'B'); %/
     fprintf(1,'>> inner(x,B)  ');
     input('');
     inner(x,B) %w
     axis off; %/
     draw(inner(x,B),'r'); %/
     GAtext(inner(x,B)+0.1*B/I3,'x \bullet B'); GAprompt; %/ 
     disp('>> %	Spinning shows that x.B is "the part of B least like x".');
     %	Spinning shows that x.B is "the part of B least like x".
     GAorbiter(-360,10); %/
