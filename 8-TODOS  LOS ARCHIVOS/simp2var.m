function I=simp2var(fsimp,c,d,a,b,m,n)

%I=simp2var('fsimp',c,d,a,b,m,n)
%Simpson integration for 2 variables
%Edit boundaries 'c', 'd', they can be variable.
%'a' and 'b' are fixed boundaries

h=(b-a)/(2*n);

I1=0;
I2=0;
I3=0;

for i=0:(2*n)
   x=a+i*h;
   dx=feval(d,x);										%Variable upper boundary
   %cx=feval(c,x);										%Variable lower boundary
   %dx=d;												%Fixed upper boundary (deactivate if it's variable)
   cx=c;												%Fixed lower boundary (decativate if it's variable)
   kx=(dx-cx)./(2*m);
   K1=feval(fsimp,x,cx)+feval(fsimp,x,dx);
   K2=0;
   K3=0;
   for j=1:(2*m-1)
      y=cx+j*kx;
      z=feval(fsimp,x,y);
      if gcd(2,j)==2
         K2=K2+z;
      else
         K3=K3+z;
      end
   end
   L=(kx/3)*(K1+2*K2+4*K3);
   if i==0 | i==2*n
      I1=I1+L;
   else
      if gcd(2,i)==2
         I2=I2+L;
      else
         I3=I3+L;
      end
   end
end

I=(h/3).*(I1+2*I2+4*I3);