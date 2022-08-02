% L3_2. See Example 3.6.  Copyright S. Nakamura, 1995 
clear
for n=5:14
   for i=1:n
      for j=1:n
         a(i,j) = 1/(i+j-1);
      end
   end
   c = cond(a);
   d = det(a)*det(a^(-1));
   fprintf(' n=%3.0f   cond(a) = %e  det*det = %e\n', n,c,d)
end

