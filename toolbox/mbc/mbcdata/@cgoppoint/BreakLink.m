function op = BreakLink(op,factors)
% op = BreakLink(op,fact_i)
% eval_fill required afterwards.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 06:51:03 $

for j = 1:length(factors)
    fact_i = factors(j);
    op.linkptrlist(fact_i) = xregpointer;
    f = find(op.ptrlist==op.ptrlist(fact_i));
    f = setdiff(f,fact_i);
    overwrite = get(op,'iseditable');
    if overwrite(fact_i)
        op.factor_type(fact_i) = 1;
    else
        op.factor_type(fact_i) = 2;
    end
    if length(f)==1
        % Retrieve original data from hidden column
        if size(op.data, 1) > 0
            % Ensure there is at least 1 row in ds
            op.data(:,fact_i) = op.data(:,f);
        end
        op = removefactor(op,f);
        op.factor_type(fact_i) = 1;
    end
end

% Slows things down - do when OK pressed.
%op = eval_fill(op);
