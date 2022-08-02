function [y, l] = AM4(fun, t, y, fvec, h, var)

l = 0;
TOL = 1e-9;
fold = fvec(:,4)+ones(size(fvec(:,4)));

while norm(fvec(:,4)-fold)> TOL
	fold = fvec(:,4);
	yp = y + h/24*(9*fvec(:,4) + 19*fvec(:,3) - 5*fvec(:,2) + fvec(:,1));
	fvec(:,4) = feval(fun, t + h, yp,'',var);
	l = l+1;
	if (l==1000) break; end;
end

y = y + h/24*(9*fvec(:,4) + 19*fvec(:,3) - 5*fvec(:,2) + fvec(:,1));
return