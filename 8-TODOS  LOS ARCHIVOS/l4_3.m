% List4_3 illustrates an application of shape_ 
% for Lagrange interpolation.
% Copyright S. Nakamura, 1995
clear
x = [1.1,   2.3,   3.9,   5.1];
y = [3.887, 4.276, 4.651, 2.117];
xi = [2.101 ,4.234];
np = length(x);
p=shape_pw(x);
for inp=1:2
  for i=1:np
    Temp = polyval(p(i,:),xi(inp));
    v(i) = Temp;
  end
  yi(inp)=v*y';
end
yi

