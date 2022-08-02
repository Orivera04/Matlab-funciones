function para = gd(init_para, x, y)

% using gradient descent to fit y = a*exp(b*x);
data_n = length(x);


a = init_para(1);
b = init_para(2);
data_n = length(x);
step = 0.01;
for i = 1:100;
	dE_da = 0; dE_db = 0;
	% accumulate the gradient
	error = 0;
	for j = 1:data_n,
		tmp1 = a*exp(b*x(j));
		tmp2 = y(j) - tmp1;
		dE_da = dE_da + 2*tmp2*(-tmp1);
		dE_db = dE_db + 2*tmp2*(-tmp1)*x(j);
		error = error + tmp2^2;
	end
	leng = norm([dE_da dE_db]);
	fprintf('Iteration = %d, error = %f\n', i, error);
	a = a - step*dE_da/leng;
	b = b - step*dE_db/leng;
end
para = [a b]';
