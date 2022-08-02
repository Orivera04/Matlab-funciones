% P10_15.M Determine error versus stepsize
%  y(x)=exp(x) at x=1
%    h=10^(-k) for k=1,2,...,10
%
clear
format compact
format long
x=1:10;
h=10.^(-x);
Dk=(exp(1+h)-exp(1))./h;
err=exp(1)-Dk;
['            k               h                 Dk                err    ']
[x(:) h(:) Dk(:) err(:)]
