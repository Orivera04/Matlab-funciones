function x = transpose(x)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.values = permute(x.values, [2 1]);
    x.derivatives = permute(x.derivatives, [2 1 3]);
