function x = ctranspose(x)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.values = conj(permute(x.values, [2 1]));
    x.derivatives = conj(permute(x.derivatives, [2 1 3]));
