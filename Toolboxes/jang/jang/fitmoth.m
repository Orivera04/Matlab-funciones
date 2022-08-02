% Illustration of using various methods on fitting the moth data
% J.-S. Roger Jang, June 1993

% The moth data is in pp 373, exercise 12, Numerical Analysis by
% R. Burden and J. D. Faires

global moth;
moth = [
0.017 0.154;
0.087 0.296;
0.174 0.363;
1.11 0.531;
1.74 2.23;
4.09 3.58;
5.45 3.52;
5.96 2.40;
0.025 0.23;
0.111 0.357;
0.211 0.366;
0.999 0.771;
3.02 2.01;
4.28 3.28;
4.58 2.96;
4.68 5.10;
0.0020 0.181;
0.085 0.260;
0.171 0.334;
1.29 0.87;
3.04 3.59;
4.29 3.40;
5.30 3.88;
0.0020 0.180;
0.119 0.299;
0.210 0.428;
1.32 1.15;
3.34 2.83;
5.48 4.15;
0.025 0.234;
0.233 0.537;
0.783 1.47;
1.35 2.48;
1.69 1.44;
2.75 1.84;
4.83 4.66;
5.53 6.94];

x = moth(:,1); y = moth(:,2);
data_n = length(x);

% to fit y = a*x^b

% using transformed LSE
xx = (min(x):0.1:max(x))';
coef = polyfit(log(x), log(y), 1);
b = coef(1);
a = exp(coef(2));
y1 = a*xx.^b;
rmse_1 = norm(y - a*x.^b)/sqrt(data_n)

subplot(221);
plot(x, y, 'o', xx, y1, '-');
xlabel('x'); ylabel('y'); title('(a) Transformation method');
subplot(222);
plot(log(x), log(y), 'o', log(xx), log(y1), '-');
axis([-inf inf -inf inf]);
xlabel('log(x)'); ylabel('log(y)'); title('(b) Straight line in the transformed dimensions');

% using fmins in matlab
init_b = coef(1);
init_a = exp(coef(2));
new_coef = fmins('errmoth', [init_a init_b]);
a = new_coef(1);
b = new_coef(2);
rmse_2 = norm(y - a*x.^b)/sqrt(data_n)
y2 = b*xx.^a;
subplot(223);
plot(x, y, 'o', xx, y2, '-');
axis([-inf inf -inf inf]);
xlabel('x'); ylabel('y'); title('(c) Downhill simplex method');

% using gradient descent
a = init_a;
b = init_b;
step = 0.01;
for i = 1:100;
	dE_da = 0; dE_db = 0;
	% accumulate the gradient
	for j = 1:data_n,
		x_tmp = moth(j,1);
		y_tmp = moth(j,2);
		tmp1 = x_tmp^b;
		tmp2 = y_tmp - a*tmp1;
		dE_da = dE_da - 2*tmp2*tmp1;
		dE_db = dE_db - 2*tmp2*a*tmp1*log(x_tmp);
	end
	gradient_leng = norm([dE_da dE_db]);
	a = a - step*dE_da/gradient_leng;
	b = b - step*dE_db/gradient_leng;
end
rmse_3 = norm(y - a*x.^b)/sqrt(data_n)
y3 = b*xx.^a;
subplot(224);
plot(x, y, 'o', xx, y3, '-');
axis([-inf inf -inf inf]);
xlabel('x'); ylabel('y'); title('(d) Gradient descent');

