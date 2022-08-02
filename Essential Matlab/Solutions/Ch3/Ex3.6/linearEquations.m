a = input('Enter a: ');
b = input('Enter b: ');
c = input('Enter c: ');
d = input('Enter d: ');
e = input('Enter e: ');
f = input('Enter f: ');
u = a * e - b * d;
v = c * e - b * f;
if u == 0
 if v == 0
   disp('Lines coincide.');
 else
   disp('Lines are parallel.');
 end
else
 x = v / u;
 y = (a * f - d * c) / u;
 disp( [x y] );
end