function LnX = Ln(N,alpha,x)

if N==0,
     LnX=1;
     return;
else

  if N==1,
        LnX=1+alpha-x;
        return;
  end
  
end  

if N >1,
    arrayLn=zeros(N+1,1);
    arrayLn(1)=1;
    arrayLn(2)=1+alpha-x;
   for n=3:N+1,
        arrayLn(n)=((2*(n-1)-1+alpha-x)*arrayLn(n-1)...
                     -(n-2+alpha)*arrayLn(n-2))/(n-1);
   end
end

LnX=arrayLn(N+1);