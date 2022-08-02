function out = fis(x, y, type)

% x < a
a = 6;
mf1 = 1 - exts_mf(x, [a-1, a+1, 1]);

% y < b
b = 3;
mf2 = 1 - exts_mf(y, [b-1, b+1, 1]);

% y < c
c = 7;
mf3 = 1 - exts_mf(y, [c-1, c+1, 1]);

w = zeros(4,1);
f = zeros(4,1);

if type == 0, % zero order TSK
	w(1) = mf1*mf2;
	f(1) = 1;
	w(2) = mf1*(1-mf2);
	f(2) = 3;
	w(3) = (1-mf1)*mf3;
	f(3) = 5;
	w(4) = (1-mf1)*(1-mf3);
	f(4) = 9;
elseif type == 1, % first order TSK
	w(1) = mf1*mf2;
	f(1) = 2*x-y-20;
	w(2) = mf1*(1-mf2);
	f(2) = -2*x+2*y+10;
	w(3) = (1-mf1)*mf3;
	f(3) = 6*x-y+5;
	w(4) = (1-mf1)*(1-mf3);
	f(4) = 3*x+4*y+20;
else
	error('Unknown type!');
end

out = w'*f/sum(w);
