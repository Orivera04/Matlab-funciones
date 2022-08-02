a = triu(reshape(1:15,5,3)); 
x = [1 1 1 0 0]'; 
b = a'*x;
y1 = (a')\b         
opts.UT = true; opts.TRANSA = true;
y2 = linsolve(a,b,opts)
