function sumavector
global x1 x2 x3;
x1=1:100;
s1=suma(x1)
x2=x1.*x1;
s2=suma(x2)
x3=x2-x1;
s3=suma(x3)
function s=suma(x)
global x1 x2 x3;
s=sum(x);
