a = [1 1; 0.1 1];
x = funm(a,@log)
y = log(a)
expm(x)
exp(y)