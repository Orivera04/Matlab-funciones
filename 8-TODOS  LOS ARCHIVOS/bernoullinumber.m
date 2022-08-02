function b = bernoullinumber(k)
if k == 0 
    b = 1;
elseif k == 1
    b = -1/2;
elseif mod(k,2)~= 0 
    b = 0;
else
    b = (-1)^k .*factorial(k).* ...
    det(toeplitz(1./factorial(2:k+1), [2 1 zeros(1, k-2)]));
end