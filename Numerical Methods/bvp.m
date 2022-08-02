function [xx, sol] = bvp(n,cond,r,c,usur,f)
   h  = 1/n;
   C = (2/r)*c;
   for i = 1:n-1
      xx(i) = i*h;
		a(i) = cond*2 + C*h*h;
		b(i) = -cond;
		c(i) = -cond;
		d(i) = h*h*(f + C*usur);
	end
   sol = trid(n-1,a,b,c,d);
   xx = [0 xx 1.];
   sol = [0 sol 0.];