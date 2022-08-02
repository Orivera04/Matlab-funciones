function d=rationalGCD(a,b)
while true
a=mod(a,b)
if a==0
d=b
return
end
b=mod(b,a)
if b==0
d=a;
return
end
end