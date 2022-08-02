function dd = dedir(f,v,s)
syms x y;
%f = la funcion f 
%s = el vector s 
%u = el valor de u 
%v = el valor de v 
gradi = [diff(f,x) diff(f,y)]
gradie = subs(gradi,{x y},{v(1) v(2)})
dd = gradie*(s/norm(s))';