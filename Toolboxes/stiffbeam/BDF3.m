function [y, l] = BDF3(fun, t, yvec, h, var)

l = 0;
TOL = 1e-12;

[n,p] = size(yvec);
y = zeros(n,1);
yold = ones(n,1);

while norm(y-yold)> TOL
	yold = y;
	fvec = feval(fun, t + h, yold,'',var);
	y = 6/11*(h*fvec + 3*yvec(:,3) - 1.5*yvec(:,2) + 1/3*yvec(:,1));
	l = l+1;
	if (l == 500) break; end;
end

return