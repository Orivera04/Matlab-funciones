clear;
A = [4 6 1;0 1 1;0 0 4]
d = [100 10 20]'
n = 3
x(n) = d(n)/A(n,n);
for j = n:-1:2
	for i = 1:j-1
	          d(i) = d(i) - A(i,j)*x(j);
	end
	x(j-1) = d(j-1)/A(j-1,j-1);
end
x'