function mtableview(T,ThisTable,index)
%CGLOOKUPONE/MTABLEVIEW Displays the lookup table data
%
%  MTABLEVIEW(T,ThisTable)
%  MTABLEVIEW(T,ThisTable,index)
%  MTABLEVIEW(T,ThisTable,[index1 index2])
%  T: instance of cglookupone
%  ThisTable: instance of mbctable.simple
%  index: (optional)  The index of the previous version for which the data
%         is to be shown.  If two indices are given, the differences between
%         them are shown.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.4 $  $Date: 2004/04/12 23:34:36 $

try
    difference = false;
    data = get(T,'values');
    BP = get(T,'breakpoints');
    if nargin > 2
        % history display
        mem = getmemory(T,index(1));
        if isempty(mem)
            data = [];BP = [];
        else
            data = mem.Values;
            BP = mem.Breakpoints;
            if length(index) == 2
                mem = getmemory(T,index(2));
                if isempty(mem)
                    data = [];BP = [];
                else
                    data2 = mem.Values;
                    if isequal(size(data),size(data2))
                        BP = BP - mem.Breakpoints;
                        data = data-data2;
                        difference = true;
                    else
                        data=[];BP=[];
                    end
                end
            end
        end
    else
        data = get(T,'values');
        BP = get(T,'breakpoints');
    end
    % init. table data.
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
        ThisTable.table.initTable(data,{'Input','Output'},{'0',''});
    end
catch
    disp('Error:');
    [x,y]=lasterr;
    disp(x);
    disp(y);
    ThisTable.table.clearTable;
end
