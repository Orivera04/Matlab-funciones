function pAltered = setInputsFromTableAt(obj, indextype, varargin)
%SETINPUTSFROMTABLEAT Set inputs to specified table values
%
%  SETINPUTSFROMTABLEAT sets the value of inputs that are also filling
%  tables.  The value is set to the value in the specified table cell from
%  the corresponding table.
%
%  SETINPUTSFROMTABLAT(OBJ, 'list', index) sets the inputs to correspond to
%  the table index that is linked to the specified point in the saved list.
%  If there is no table cell linked to that point, no values are set.
%
%  SETINPUTSFROMTABLAT(OBJ, 'table', R, C) sets the inputs to correspond to
%  the specified table index.
%
%  P_ALTERED = SETINPUTSFROMTABLAT(...) returns a list of poitners to the
%  inputs that have had their values altered.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/04/04 03:36:41 $ 

pAltered = null(xregpointer, 0);

if numTables(obj)>0
    CELL_FOUND = true;
    if strcmp(indextype, 'table')
        tableindex = varargin;
    elseif strcmp(indextype, 'list')
        % Find the table link if it exists
        [tableindex, CELL_FOUND] = getTableFromIndex(obj.DataKeyTable, varargin{1});
    end
    
    if CELL_FOUND
        pAll = getAllTableData(obj);
        hTbl = infoarray(pAll(:,1));
        pFill = pAll(:, 2);
        CaptureFrom = true(size(pFill));
        CaptureFrom(isnull(pFill)) = false;
        is_inport = pveceval(pFill(CaptureFrom), @isinport);
        CaptureFrom(CaptureFrom) = [is_inport{:}];

        for n = 1:numTables(obj);
            if CaptureFrom(n)
                tbl_vals = get(hTbl{n}, 'values');
                pFill(n).info = pFill(n).setvalue(tbl_vals(tableindex{:}));
            end
        end
        pAltered = pFill(CaptureFrom);
    end
end
