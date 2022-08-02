% L3_3. See Example 3.7.  Copyright S. Nakamura, 1995
clear
for n=11:11
   for i=1:n
      for j=1:n
         a(i,j) = 1/(i+j-1);
      end
   end
   a_inv = a*inv(a);
for j=1:n;
   for i=1:n
   fprintf(' %7.4f', a_inv(i,j))
   end
   fprintf(' \n')
end
end

