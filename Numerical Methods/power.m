function [lambda,V]= power(A,X,epsilon,max1)

lambda=0;cnt=0;err=1;iterating=1;state=iterating;
while ((cnt<=max1)&(state==iterating))
   Y=A*X;
   [m j]=max(abs(Y));
   c1=Y(j);
   cnt=cnt+1;
end
V=Y;