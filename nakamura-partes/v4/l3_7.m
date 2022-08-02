% List3_7.  See Example 3.13.  Copyright S. Nakamura, 1995
clear; format short
a(1,1) = 1/2 + 1/4 + 1/3; a(1,2) = -1/4; a(1,3) = -1/3;
a(2,1) = a(1,2); a(2,2) = 1/4 + 1/3 + 1/5; a(2,3) = -1/5;
a(3,1) = a(1,3); a(3,2) = a(2,3); a(3,3) = 1/3 + 1/5 + 1/3;
y(1) = 20/2; y(2) = 0; y(3) = 5/3;
x = zeros(1,3);
w=1.2;
for it=1:50
   error = 0;
   for i=1:3
      s=0; xb = x(i);
      for j=1:3
         if i~=j, s = s + a(i,j)*x(j); end
      end
      x(i) = w*(y(i) -s)/a(i,i) + (1-w)*x(i);
      error = error + abs(x(i) - xb);
   end
   fprintf(' It. no. = %3.0f, error = %7.2e\n', ...
           it, error)
   if error/3 < 0.0001, break; end
end
x

