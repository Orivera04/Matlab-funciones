clc
fprintf('Rational Arithmetic Menu:\n\n')
fprintf('1). Reduce a fraction to lowest terms.\n')
fprintf('2). Add two fractions.\n')
fprintf('3). Subtract two fractions.\n')
fprintf('4). Multiply two fractions.\n')
fprintf('5). Divide two fractions.\n')
fprintf('6). Exit program.\n\n')
n=input('Enter number of your choice: ');
function [num,den]=rationalReduce(num,den)
d=rationalGCD(num,den);
num=num/d;
den=den/d;
function d=rationalGCD(a,b)
while true
a=mod(a,b);
if a==0
d=b;
return
end
b=mod(b,a);
if b==0
d=a;
return
end
end
clc
fprintf('Reduce a rational number to lowest terms.\n\n')
num=input('Enter the numerator: ');
den=input('Enter the denominator: ');
fprintf('You’ve entered the fraction %d/%d.\n\n',num,den)
[num,den]=rationalReduce(num,den);
fprintf('When reduced to lowest terms: %d/%d\n\n',num,den)
fprintf('Press any key to continue.\n')
pause