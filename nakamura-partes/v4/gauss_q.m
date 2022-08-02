% function gauss_q integrates a function named by f_name
% by Gauss quadrature of order n.
% Copyright S. Nakamura, 1995 
function I = gauss_q(f_name, a, b, n)
p=legen_pw(n);
x = roots(p)';x = sort(x);
for j=1:n
   y = zeros(1,n); y(j)=1;
   p = polyfit(x,y,n-1);
   P = poly_itg(p);
   w(j) = polyval(P,1) - polyval(P,-1);
end
x = 0.5*((b-a)*x + a + b);
y=feval(f_name, x);
I = sum(w.*y)*(b-a)/2;
fprintf('\n     x            y            w \n')
for j=1:n
fprintf('%e %e %e\n', x(j),y(j), w(j))
end

