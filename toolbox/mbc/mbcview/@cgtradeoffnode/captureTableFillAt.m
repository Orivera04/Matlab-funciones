function done = captureTableFillAt(obj, pT,  varargin)
%CAPTURETABLEFILLAT Save current values of fill expressions to tables
%
%  DONE = CAPTURETABLEFILLAT(OBJ, pTable, Row, Column) saves the output
%  values of fill expressions to the specified cells in each table
%  specified in the pointer vector pTable.  
%
%  DONE is a vector the same length as pTable indicating how many cells
%  were successfully filled in each table.  If no problems are encountered,
%  DONE will contain valuesequal to length(Row) and length(Column).
%  
%  You should ensure that all input variables are set to inputs that are
%  the same length as the length of Row and Column.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:16 $ 

if isempty(pT)
    done = [];
    return
else
    done = zeros(size(pT));
end
% Make sure the table inputs are set up for the correct cells.  We assume
% that all other inputs are set to the correct values.
obj.Tables(1).setinportsforcells(varargin{:});

% Get all of the table filling items corresponding to the specified tables
idx = findptrs(pT, obj.Tables);
pFill = obj.FillExpressions(idx);
pMask = obj.FillMaskExpressions(idx);
TablesToFill = ~isnull(pFill);

% Dereference all of the tables and filling items.
tables = infoarray(pT);
fillexpr = cell(size(tables));
maskexpr = fillexpr;
fillexpr(TablesToFill) = infoarray(pFill(TablesToFill));
maskexpr(TablesToFill) = infoarray(pMask(TablesToFill));

% Form linear index from Row and Column
L = sub2ind(getTableSize(tables{1}), varargin{:});

for n = 1:length(pT);
    if TablesToFill(n)
        if isSwitchExpr(maskexpr{n})
            doPoints = isSwitchPoint(maskexpr{n});
            done(n) = sum(doPoints);
        else
            doPoints = true(1, length(L));
            done(n) = length(L);
        end

        if done(n)>0
            V = get(tables{n}, 'values');
            FillEval = i_eval(fillexpr{n});
            V(L(doPoints)) = FillEval(doPoints);
            actiondesc = sprintf('Filled from output of item "%s" by tradeoff.', ...
                getname(fillexpr{n}));
            tables{n} = set(tables{n}, 'values', {V, actiondesc});

            % Add points that completed to the extrapolation mask
            tables{n} = addToExtrapolationMask(tables{n}, ...
                varargin{1}(doPoints), varargin{2}(doPoints));
        end
    end
end

if any(done>0)
    % Save changes back to the table pointers
    passign(pT(TablesToFill), tables(TablesToFill));    
end
