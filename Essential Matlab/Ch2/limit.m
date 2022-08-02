a = 10;
x = 1;
k = 20;           % number of terms

for n = 1:k
 x = a * x / n;
 disp( [n x] )
end