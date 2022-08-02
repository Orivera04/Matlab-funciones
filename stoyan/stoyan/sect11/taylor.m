% © Molnarka Gy''oz''o 1998; program a Matlab programozasa c. reszhez

kl=[];
for m=1:1:10
    x=12; y=cos(x);k=1;d=1; yk=1;
      while d >= 10^(-m) 
         yk=yk+(-1)^k*x^(2*k)/gamma(2*k+1);
         d=abs(y-yk);
         k=k+1;
      end
    kl=[kl,k];
end
kl