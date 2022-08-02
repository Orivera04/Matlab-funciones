function idx = end(x, k, n)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

if (k==1)
    idx = length(x.values);
else
    idx = 1;
end
