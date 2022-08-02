
function [xx, sol] = bvperr(n)
   h  = 1/n;
   C = 1;
   cond = 1;
   c2=(20*exp(1)-20)/(exp(1)-exp(-1));
   c1 =20 -c2;
   for i = 1:n-1
      xx(i) = i*h;
		a(i) = cond*2 + C*h*h;
		b(i) = -cond;
		c(i) = -cond;
        f(i) = 10*xx(i)*(1. - xx(i));
		d(i) = h*h*(f(i) );
        exactsol(i)=c1*exp(xx(i))+c2*exp(-xx(i))+10*xx(i)*(1-xx(i))-20;
	end
   sol = trid(n-1,a,b,c,d);
   xx = [0 xx 1.];
   sol = [0 sol 0.];
   exactsol = [0 exactsol 0.];
   error =sol-exactsol;
   norm_error = max(abs(error))
   plot(xx,sol);