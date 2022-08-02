p =  [-1 -1 2 1];   %polynôme -x^3-x^2 + 2x + 1
a =  compan(p)      %matrice compagnon
poly(a)             %polynôme caractéristique

r0 = [1 2 3 4];     %vecteur de racines
p =  poly(r0)       %polynôme ayant ces racines
r1 =  roots(p)      %racines du polynôme