function fn = fatorial (n)
if n<=1
    fn = 1;
else
    fn = n * fatorial(n-1);
end