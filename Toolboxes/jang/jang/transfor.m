t1 = (0:10)';
y1 = exp(-0.3*t1);

t2 = t1 + 0.5*[0 rand(1,10)-0.5]';
y2 = y1 + 0.15*(rand(size(y1))-0.5);
%t2 = [0 1.0097 1.9954 2.8307 4.2381 5.0372 5.8866 7.0157 8.0993 9.0835 9.7987]';
%y2 = [1.0049 0.7519 0.5656 0.4061 0.3084 0.2320 0.1594 0.0876 0.0909 0.0903 0.0030]';
t2 = [0 0.80 1.84 2.90 4.06 4.81 6.07 7.06 8.15 8.87 9.98]';
y2 = [0.98 0.69 0.47 0.46 0.29 0.16 0.23 0.10 0.03 0.12 0.01]';

%t2 = [0 0.8 1.8 2.9 4.0 4.8 6.0 7.0 8.1 8.8 9.9]';
%y2 = [1.0 0.6 0.4 0.4 0.2 0.1 0.15 0.1 0.03 0.05 0.01]';


global t2 y2

% by LSE on linearlized model
B = log(y2);
A = [ones(size(t2)) t2];
para1 = A\B;
a = exp(para1(1,1));
b = para1(2,1);
y3 = a*exp(b*t2);

% by fmins in matlab
%para2 = fmins('fun', [a b]);
%aa = para2(1);
%bb = para2(2);
%y4 = aa*exp(bb*t2);

% by gradient descent
para3 = gd([a b], t2, y2);
aaa = para3(1);
bbb = para3(2);
y5 = aaa*exp(bbb*t2);

%plot(t1, y1, '-', t2, y2, '*', t2, y3, '--', t2, y4, ':', t2, y5, '-.');
plot(t2, y2, '*', t2, y3, '--', t2, y5, '-');
legend('Sample data', 'Curve by transformtion method', 'Curve by gradient descent');
xlabel('t');
ylabel('y');

