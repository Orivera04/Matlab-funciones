function op = MatchToDD(op,dd)
% CGOPPOINT/MATCHTODD
%     op = matchtodd(op,dd) matches imported factor names against
%        variables in the data dictionary.
%     Checks that variables are not constant, and units are compatible.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:25:57 $

names = get(op,'orig_name');
ptrs = dd.find(names);
factor_type = repmat(0,1,length(names));
% fill unmatched columns with empty pointers
f = find(cellfun('isempty',ptrs));
ptrs(f) = {xregpointer};
% turn into a normal ptrlist
ptrs = [ptrs{:}];
% Check for repeated ptrs - keep one copy only of each ptr
[b,i] = unique(double(ptrs));
ptrs(:) = xregpointer;
ptrs(i) = assign(xregpointer,b);
% Check units - any incompatible units, don't assign
%  (if assigned manually, this generates a warning message)
units = get(op,'units');
for j = 1:length(i)
    if b(j)~=0
        % Check for constant variables - do not assign
        if ptrs(i(j)).isddvariable & ptrs(i(j)).isconstant
            ptrs(i(j)) = xregpointer;
        else
            un1 = units(i(j));
            un2 = ptrs(i(j)).grabUnits;
            if ~isempty(un1) & ~isempty(un2)
                if ~compatible(un1,un2)
                    ptrs(i(j)) = xregpointer;
                else
                    % convert data if appropriate
                    op.data(:,i(j)) = convert(un1,un2,op.data(:,i(j)));
                end
            end
        end
    end
end
% ignore unmatched columns; matched are inputs.
%  also set matched orig_names to empty
f = find(isvalid(ptrs));
factor_type(f) = 1;  
names(f) = {''};
% update dataset
op = set(op,'ptrlist',ptrs,'factor_type',factor_type,'orig_name',names);
