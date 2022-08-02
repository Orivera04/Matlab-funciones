function mtableview(T,ThisTable,index)
%MTABLEVIEW
%
%  MTABLEVIEW(T,ThisTable,index)
%
%  This table is assumed to be an instance of UDD class mbctable.simple,
%  containing an instance of
%  com.mathworks.toolbox.mbc.gui.table.SimpleNumericTable

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.2.5 $  $Date: 2004/04/12 23:34:37 $

% Sets up the tableviewer for a cglookuptwo object.
try
    difference = false;
    if nargin > 2
        % history display
        mem = get(T,'memory');

        data = [];

        if index(1) <= length(mem)
            data = mem{index(1)}.Values;
        end
        if length(index) == 2 & index(2) <= length(mem)
            data2 = mem{index(2)}.Values;
            if isequal(size(data),size(data2))
                data = data-data2;
                difference = true;
            end
        end

        xNormaliser = get(T,'x');
        [stuff,ind] = getmemory(xNormaliser.info,mem{index(1)}.Date);
        if isempty(ind)
            X = xNormaliser.info;
        else
            X = xNormaliser.history_reset(ind);
        end
        yNormaliser = get(T,'y');
        [stuff,ind] = getmemory(yNormaliser.info,mem{index(1)}.Date);
        if isempty(ind)
            Y = yNormaliser.info;
        else
            Y = yNormaliser.history_reset(ind);
        end
    else
        data = get(T,'values');
        X = info(get(T, 'x'));
        Y = info(get(T, 'y'));
    end
    S = size(data);
    t = ThisTable.table;
    if any(~S)
        t.clearTable;
        return
    end

    if isempty(X) || isempty(Y)
        % if either normaliser is incomplete, stop now.
        t.clearTable;
        return
    end

    xHeadings = invert(X,(0:S(2)-1));
    yHeadings = invert(Y,(0:S(1)-1));

    import com.mathworks.toolbox.mbc.gui.table.*;
    if difference
        t.setCellRenderer(DifferenceRenderer);
    else
        t.setCellRenderer(NumericRenderer);
    end
    % init. table data.
    t.initTable(data, yHeadings, xHeadings);
    xvar = get(X, 'x');
    yvar = get(Y, 'x');
    t.labelAxes(yvar.getname,xvar.getname);
catch
    ThisTable.table.clearTable;
    [m,i]=lasterr;
    disp('Error: ');
    disp(m);
    disp(i);
end
