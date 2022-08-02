function p = evalpev(X,m);
%EVALPEV Evaluate PEV for model
%
%  EVALPEV(X, m) evaluates PEV for the model at teh points given in X.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $  $Date: 2004/02/09 07:53:37 $

nf = nfactors(m);
[N,ng] = size(m.OpPoints);
Bnds = getcode(m,nf-ng+1:nf);
range = diff(Bnds,[],2);
tol = getTolerance(m);

Xop = X(:,end-ng+1:end);
Xlocal = X(:,1:end-ng);
Neval = size(X,1);

% group evaluations based on operating point values
f = [1;  ...
    find(any(abs(diff(Xop,1,1)) > repmat(tol.*range', Neval-1,1) , 2)) + 1 ; ...
    size(Xop,1)+1];

p = zeros(size(X,1),1);
for i=1:length(f)-1
    % index into current data
    ind = f(i):f(i+1)-1;
    % find current operating point
    opIndex = find(all( abs( m.OpPoints-repmat(Xop(f(i),:),N,1) ) < repmat(tol.*range',N,1) , 2) );
    if ~isempty(opIndex)
        % select model and evaluate
        p(ind) = pev(m.ModelList{opIndex(1)},Xlocal(ind,:));
    else
        % can't find model so model is not defined
        p(ind) = NaN;
    end
end
