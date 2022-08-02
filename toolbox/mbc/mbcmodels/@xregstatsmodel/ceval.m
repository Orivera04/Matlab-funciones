function c = ceval( m, x )
%CEVAL Constraint model evaluation
%
%  C = CEVAL( MODEL, X );  Evaluates the constraints at X
% X is a (N-by-NF) array, where NF is the number of inputs, and N the number of
% points to evaluate the model at.
%
% C<0 indictates the point is inside the constraint

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:57:42 $

% check the number of inputs and outputs
error(nargchk(2,2, nargin, 'struct'));
error(nargoutchk(0,1, nargout, 'struct'));

if iscell(x)
    bigLength= max(cellfun('prodofsize',x));
    Xg = zeros(bigLength,length(x));
    for i = 1:length(x)
        if length(x{i}) == 1
            Xg(:,i) = x{i}(:);
        else
            Xg(1:length(x{i}),i)= x{i}(:);
        end
    end
else
    % we are passed a numeric array - check it has the right size
    NF = nfactors( m );
    if NF==size(x,2)
        Xg = x;
    else
        str = '';
        if NF>1
            str = 's';
        end
        error('mbc:xregstatsmodel:InvalidSize', 'Incorrect number of inputs.  Model has %d input%s', NF, str );
    end

end

cmodel = get( m, 'constraints' );
if ~isempty( cmodel);
    c = ceval( cmodel, Xg, m.mvModel );
else
    error('mbc:xregstatsmodel:NoConstraintModel', 'There is no constraint model associated with this model');
end