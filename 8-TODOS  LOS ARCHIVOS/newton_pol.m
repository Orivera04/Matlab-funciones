





function y=newton_pol(pol,a,b,pto,k,tol)
i=1; 
error=b-a
while (error>tol)
   [coc,rest,der]=horner3(pol,pto);  
   pto=pto-rest/der  
   error=(k^i/(1-k))*(b-a); 
   i=i+1
end 
y=pto













