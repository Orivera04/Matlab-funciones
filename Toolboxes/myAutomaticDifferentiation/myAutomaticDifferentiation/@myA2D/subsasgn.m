function y = subsasgn(y, S, x)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at
if  isempty(S.subs{1}) return; end
if (length(S.subs)>1) error('No matrix assignments!'); end

if isa(x, 'myA2D')
    if isa(y, 'myA2D')
        y.values(S.subs{:},1) = x.values;
        y.derivatives(S.subs{1},:) = x.derivatives;
        y.secderiv(S.subs{1},:,:) = x.secderiv;
    else
        nd = size(x.derivatives,2);
        ny = length(y);
        testDeriv = zeros(ny, nd);
        testSecDeriv = zeros(ny, nd, nd);
        y = myA2D(y, testDeriv, testSecDeriv);
        y.values(S.subs{:},1) = x.values;
        y.derivatives(S.subs{1},:) = x.derivatives;
        y.secderiv(S.subs{1},:,:) = x.secderiv;
    end
else    
    y.values(S.subs{:},1) = x;
    y.derivatives(S.subs{1},:) = 0;
    y.secderiv(S.subs{1},:,:) = 0;
end
