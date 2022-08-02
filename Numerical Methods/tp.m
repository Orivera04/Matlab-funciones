function  z = tp (A, B, x, M)

z = A(1);

for  j = 1:M
   z = z + A(j+1) * cos(j*x) + B(j+1) * sin(j*x);
end
