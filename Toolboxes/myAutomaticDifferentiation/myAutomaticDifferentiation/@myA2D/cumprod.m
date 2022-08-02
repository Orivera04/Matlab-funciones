function x = cumprod(x)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    n = size(x.values,1);
    for i = 2:n
        x.secderiv(i,:,:) = squeeze(x.values(i-1)*x.secderiv(i,:,:) + x.values(i)*x.secderiv(i-1,:,:)) + ...
                        x.derivatives(i-1,:)'*x.derivatives(i,:) + x.derivatives(i,:)'*x.derivatives(i-1,:);
        x.derivatives(i,:) = x.values(i-1).*x.derivatives(i,:) + x.values(i).*x.derivatives(i-1,:);
        x.values(i) = x.values(i-1).*x.values(i);
    end
