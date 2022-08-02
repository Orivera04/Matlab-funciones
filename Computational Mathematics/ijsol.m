clear;
A = [4 6 1;0 1 1;0 0 4]
d = [100 10 20]'
n = 3
x(n) = d(n)/A(n,n);
for i = n:-1:1
   sum = d(i);
	for j = i+1:n
	         sum = sum - A(i,j)*x(j);
	end
	x(i) = sum/A(i,i);
end
x