clear;
x(1) = 1.0;
eps = .0001;
for m=1:20
	x(m+1) = x(m) - fnewt(x(m))/fnewtp(x(m));
	if abs(fnewt(x(m+1)))<eps
		break;
	end
end
x'
m
fixed_point = x(m+1)