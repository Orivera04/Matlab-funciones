function list = listnames(D,showalias);
%LISTNAMES Return the list of all variable names
%
%  NAMES = LISTNAMES(DD, SHOWALIAS) returns a list of all the names in the
%  variable dictionary.  If SHOWALIAS is false or omitted then the list
%  just contains the primary names of the variable items, otherwise it
%  also contains a list of the alias names as well.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:23:32 $

if nargin<2
    showalias = false;
end

ptrs = D.ptrlist;
nItems = length(ptrs);
if showalias
    nCells = 2*nItems;
else
    nCells = nItems;
end
list = cell(nCells, 1);

nCellsUsed = 0;
for n = 1:nItems
    list{nCellsUsed+1} = ptrs(n).getname;
    nCellsUsed = nCellsUsed + 1;
    if showalias
        als = ptrs(n).getaliaslist;
        nAls = length(als);
        if (nCellsUsed+nAls+1)>nCells
            % Add another nItems to output cell array
            list = [list; cell(nItems, 1)];
            nCells = nCells + nItems;
        end
        if nAls
            list(nCellsUsed+1:nCellsUsed+nAls) = als;
            nCellsUsed = nCellsUsed + nAls;
        end
    end   
end

if showalias
    % Trim cell array
    list = list(1:nCellsUsed);
end