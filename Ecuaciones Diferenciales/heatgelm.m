clear;
n = 30
h = 1./(n+1);
K = .001;
beta = K/(h*h);
A = zeros(n,n);
for i=1:n
   d(i) = sin(pi*i*h)/beta;
   A(i,i) = 2;
   if i<n 
	A(i,i+1) = -1;
   end;
   if i>1 
	A(i,i-1) = -1;
   end;
end
d = d'
A
temp = A\d