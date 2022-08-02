function rhat=ssor(r,n,w)
rhat = zeros(n+1);
 for j= 2:n
      for i = 2:n
         rhat(i,j)=w*(r(i,j)+rhat(i-1,j)+rhat(i,j-1))/4.;
      end
   end
   rhat(2:n,2:n) = ((2.-w)/w)*(4.)*rhat(2:n,2:n);
   for j= n:-1:2
      for i = n:-1:2
         rhat(i,j)=w*(rhat(i,j)+rhat(i+1,j)+rhat(i,j+1))/4.;
      end
   end