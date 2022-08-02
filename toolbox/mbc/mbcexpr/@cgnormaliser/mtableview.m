function mtableview(T,ThisTable,index)
%MTABLEVIEW
%
%  MTABLEVIEW(T,ThisTable,index)
%
%  This table is assumed to be an instance of UDD class mbctable.simple,
%  containing an instance of
%  com.mathworks.toolbox.mbc.gui.table.SimpleNumericTable

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.4 $  $Date: 2004/04/12 23:34:41 $

try
    difference = false;
    if nargin > 2
        % history display
        data = [];
        mem = get(T,'memory');
        if index(1) <= length(mem)
            data = mem{index(1)}.Values;
            BP = mem{index(1)}.Breakpoints;
            % a newly initialised normaliser contains no data.
            if isempty(data)
                data = zeros(size(BP));
            end
        end
        if length(index) == 2 & index(2) <= length(mem)
            data2 = mem{index(2)}.Values;
            BP2 = mem{index(2)}.Breakpoints;
            % a newly initialised normaliser contains no data.
            if isempty(data2)
                data2 = zeros(size(BP2));
            end
            if isequal(size(data),size(data2))
                data = data-data2;
                BP = BP - BP2;
                difference = true;
            else
                % can't compare different sizes of matrix
                data=[];
                BP=[];
            end
        end
    else
        data = get(T,'values');
        BP = get(T,'breakpoints');
    end

    data = [BP(:),data(:)];

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
        ThisTable.table.initTable(data,{'Input','Output'},{'','0'});
    end
catch
    disp('Error:');
    [x,y]=lasterr;
    disp(x);
    disp(y);
    ThisTable.table.clearTable;
end
