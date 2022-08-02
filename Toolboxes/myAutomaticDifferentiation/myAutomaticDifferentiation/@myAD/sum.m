function x = sum(x)
% In Package myAD - Automatic Differentiation
% by Martin Fink, May 2007
% martinfink 'at' gmx.at

    x.derivatives = sum(x.derivatives);
    x.values = sum(x.values);
