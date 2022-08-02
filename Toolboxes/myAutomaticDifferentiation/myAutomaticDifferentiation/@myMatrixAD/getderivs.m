function Jac = getderivs(x)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    Jac = squeeze(x.derivatives);
    if (size(Jac,2)==1) Jac = Jac.'; end
