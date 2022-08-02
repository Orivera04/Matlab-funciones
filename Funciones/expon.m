function expo = expon(n,x)
expon=1;
for i=1:n
    expon = expon + x^n/fact(n)
end;