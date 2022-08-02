function y = subsasgn(y, S, x)
% In Package myAD - Automatic Differentiation
% by Martin Fink, May 2007
% martinfink 'at' gmx.at
if  isempty(S.subs{1}) return; end
if (length(S.subs)>1) error('No matrix assignments!'); end

if isa(x, 'myAD')
    if isa(y, 'myAD')
        y.values(S.subs{:},1) = x.values;
        y.derivatives(S.subs{1},:) = x.derivatives;
    else
        nd = size(x.derivatives,2);
        ny = length(y);
        testDeriv = zeros(ny, nd);
        y = myAD(y, testDeriv);
        y.values(S.subs{:},1) = x.values;
        y.derivatives(S.subs{1},:) = x.derivatives;
    end
else
    y.values(S.subs{:},1) = x;
    y.derivatives(S.subs{1},:) = 0;
end
