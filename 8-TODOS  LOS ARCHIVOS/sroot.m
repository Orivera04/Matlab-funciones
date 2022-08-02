function  r = sroot (a)

p0 = 1;

for  k = 1:50
   p1 = (p0 + a / p0) / 2;
   disp(p1);
   if  abs(p1 - p0) / p1  < eps, break, end;
   p0 = p1;
end
