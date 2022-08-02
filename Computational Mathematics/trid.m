function x = trid(n,a,b,c,d)
	alpha = zeros(n,1);
	gamma = zeros(n,1);
	y = zeros(n,1);
	alpha(1) = a(1);
	gamma(1) = c(1)/alpha(1);
	y(1) = d(1)/alpha(1);
	for i = 2:n
		alpha(i) = a(i) - b(i)*gamma(i-1);
		gamma(i) = c(i)/alpha(i);
		y(i) = (d(i) - b(i)*y(i-1))/alpha(i);
	end
	x(n) = y(n);
	for i = n-1:-1:1
		x(i) = y(i) - gamma(i)*x(i+1);
	end
