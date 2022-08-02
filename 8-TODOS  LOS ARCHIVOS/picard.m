clear;
x(1) = 1.0;
eps = .0001;
for m=1:20
	x(m+1) = gpic(x(m));
	if abs(x(m+1)-x(m))<eps
		break;
	end
end
x'
m
fixed_point = x(m+1)