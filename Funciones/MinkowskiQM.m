% Given x from 0 to 1, compute the Minkowski question mark function of x. 

function y = MinkowskiQM(x)

if x == 0
    y = 0;
    return;
end

if x == 1;
    y = 1;
    return;
end

if x > 1/2
    y = 1 - MinkowskiQM(1-x);
    return;
end

y = 0;
cf = cfrac(x,20);
len = length(cf);
term = -2;

for k=2:len
    a = cf(k);
    term = -term / 2^a;
    y = y + term;
end
    
    