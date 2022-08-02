function [y,yy,yyy]=erl(k,l,T)
   term = 1; sumgt =1; sumigt = k;
   for n=1:k-1
      term = term*l*T/n;
      sumgt = sumgt + term;
      sumigt = sumigt + (k-n)*term;
      
   end;
   y=exp(-l*T)*term*l;
   yy = 1 - exp(-l*T)*sumgt;
   yyy = (1/l)*(k - exp(-l*T)*sumigt);

