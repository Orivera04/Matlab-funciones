% EX6_6.M Taylor series example
% Calculate error in Taylor series expansion (6 terms) of exp(x)
format long
x=1.0
yexact=exp(1)
nfact=5*4*3*2*1;
yseries=1+x+(x^2)/2+(x^3)/(3*2)+(x^4)/(4*3*2) +(x^5)/(nfact)
fprintf('Error in 6 term Taylor series for exp(1) \n')
yerror=abs(yexact-yseries)
errbound=yexact*(1/(6*nfact))
%
% Modify the script to allow input of variable x and the 
%  number of terms in the series. Then, test the error as
%  a function of x and n. Try the symbolic command taylor 