% List4_4 illustrates computation of derivative of 
% Lagrange interpolation.
% Copyright S. Nakamura, 1995
clear
x = [1.1,   2.3,   3.9,   5.1];
y = [3.887, 4.276, 4.651, 2.117];
xi = [2.101 ,4.234];
np = length(x);
p=shape_pw(x);
for i=1:np
   pd(i,:) = polyder(p(i,:));
end
for inp=1:length(xi)
  for i=1:np
    vd(i) = polyval(pd(i,:),xi(inp));
  end
  yi(inp)=vd*y';
end
disp '    xi        yi'
disp([xi;yi]')

