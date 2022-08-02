function [y, l] = BDF2(fun, t, yvec, h, var)

l = 0;
TOL = 1e-12;

[n,p] = size(yvec);
y = zeros(n,1);
yold = ones(n,1);

while norm(y-yold)> TOL
	yold = y;
	fvec = feval(fun, t + h, yold,'',var);
	y = 2/3*(h*fvec + 2*yvec(:,2) - 0.5*yvec(:,1));
	l = l+1;
	if (l == 500) break; end;
end

return