function [p,indout] = eval_fill(p)
% [p,ind] = eval_fill(...) returns the indices of factors which 
%   have been evaluated.
%
%  Use eval_fill to evaluate all outputs of a dataset (eg when inputs change)
%  Eval_fill checks for order of evaluation and validity of each factor.
%
%  See also: check_eval, i_eval, eval_fill

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 06:51:39 $


if ~isempty(p.data)
    indout = [];
    [ch_eval,d1,d2,order] = check_eval(p);

    % Do dependants first
    f = find(p.grid_flag~=8);
    flg = get(p, 'grid_flag');
    p = set(p, f, 'grid_flag', 7);
    p = range_grid(p);
    p = set(p, 'grid_flag', flg);

    for i = 1:length(order)
        % evaluate factors in order
        if p.factor_type(order(i))
            if ch_eval(order(i))
                if isvalid(p.ptrlist(order(i)))
                    newdata = i_eval(p,order(i),'eval_fill');
                    newdata(isnan(newdata)) = 0;
                    p.data(:,order(i)) = newdata;
                end
                % invalid pointer - keep existing data
                indout = [indout order(i)];
            else
                % cannot evaluate - fill with 0
                p.data(:,order(i)) = 0;
            end
        end
    end
end