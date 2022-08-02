x =2.^[2:32]-1;
b = isprime(x);
i=find(b==1);
fprintf('%d ',x(i));
fprintf('\nsont des nombres premiers');
fprintf('\nde la forme 2^n-1');