p =  [-1 -1 2 1];   %polyn�me -x^3-x^2 + 2x + 1
a =  compan(p)      %matrice compagnon
poly(a)             %polyn�me caract�ristique

r0 = [1 2 3 4];     %vecteur de racines
p =  poly(r0)       %polyn�me ayant ces racines
r1 =  roots(p)      %racines du polyn�me