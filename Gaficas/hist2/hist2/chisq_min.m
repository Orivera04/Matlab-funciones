function [parout,chisq]=chisq_min(par, xin, yin, sigmain)

global x;
global y;
global sigma;

clear parout;

x = xin;
y = yin;
if nargin == 4
  sigma = sigmain;
else
%  sigma = ones(size(x));
%  sigma = max(ones(size(x)), sqrt(y));
  sigma = sqrt(y);
end;

options=foptions;
options(14)= 500*prod(size(x));
parout=fmins('gx',par,options);
chisq = gx(parout);
