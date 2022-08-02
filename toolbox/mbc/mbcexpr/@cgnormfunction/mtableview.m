function mtableview(T,ThisTable,index)
%CGNORMFUNCTION/MTABLEVIEW Displays the normfunction data
%
%  MTABLEVIEW(T,ThisTable)
%  MTABLEVIEW(T,ThisTable,index)
%  MTABLEVIEW(T,ThisTable,[index1 index2])
%  T: instance of cgnormfunction
%  ThisTable: instance of mbctable.simple
%  index: (optional)  The index of the previous version for which the data
%         is to be shown.  If two indices are given, the differences between
%         them are shown.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.4.4 $  $Date: 2004/04/12 23:34:42 $

try
    difference = false;
    xNormaliser = get(T,'x');
    if nargin > 2
        % history display
        values=[];
        mem = getmemory(T,index(1));
        if isempty(mem)
            values = [];BP = [];
        else
            values = mem.Values;
            [stuff,ind] = getmemory(xNormaliser.info,mem.Date);
            if isempty(ind)
                X = xNormaliser.info;
            else
                X = xNormaliser.history_reset(ind);
            end
            BP = get(X,'Breakpoints');
        end
        if length(index) == 2
            mem = getmemory(T,index(2));
            v2 = mem.Values;
            if isequal(size(values),size(v2))
                [stuff,ind] = getmemory(xNormaliser.info,mem.Date);
                if isempty(ind)
                    X = xNormaliser.info;
                else
                    X = xNormaliser.history_reset(ind);
                end
                if isempty(X)
                    % if the normaliser is incomplete, stop now.
                    ThisTable.table.clearTable;
                    return
                end

                BP = BP - invert(X,mem.Breakpoints);
                values = values-v2;
                difference = true;
            end
        end
    else
        values = get(T,'values');
        BP = get(T,'breakpoints');
        if isempty(values) || isempty(BP)
            values = []; BP = [];
        else
            if xNormaliser.isempty
                % if the normaliser is incomplete, stop now.
                ThisTable.table.clearTable;
                return;
            end
            BP = xNormaliser.invert(BP);
        end
    end
    % init. table data.
    data = [BP(:), values(:)];

    import com.mathworks.toolbox.mbc.gui.table.*;
    S = size(data);
    if any(S==0)
        ThisTable.table.clearTable;
    else
        if difference
            ThisTable.table.setCellRenderer(DifferenceRenderer);
        else
            ThisTable.table.setCellRenderer(NumericRenderer);
        end
        ThisTable.table.initTable(data,{'Input','Output'},{'0',''});
    end
catch
    disp('Error:');
    [x,y]=lasterr;
    disp(x);
    disp(y);
    ThisTable.table.clearTable;
end
