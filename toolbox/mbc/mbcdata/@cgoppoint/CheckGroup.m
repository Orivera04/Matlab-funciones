function op = CheckGroup(op,doEval);
% op = CheckGroup(op)
%  Ensure group members are correctly set up.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.4 $  $Date: 2004/02/09 06:51:06 $


if nargin<2
    doEval= true;
end

% Check for any symvalues; ensure required cgvalues are in dataset;
%   set up group number correctly.
valid_i = find(isvalid(op.ptrlist));
req_ptrs = [];
valfact = []; valptrs = [];
symfact = []; symgrp = [];

% Build lists of ptrs and symvalues required in each group.
for i = 1:length(valid_i)
    ptr = op.ptrlist(valid_i(i));
    if ptr.isddvariable
        rhsptrs = ptr.getrhsptrs;
        keep = [];
        for j = 1:length(rhsptrs)
            if rhsptrs(j).isdsvariable
                keep = [keep j];
            end
        end
        rhsptrs = rhsptrs(keep);
        % empty - cgvalue; non-empty - symvalue
        if isempty(rhsptrs)
            valptrs = [valptrs ptr];
            valfact = [valfact valid_i(i)];
        else
            done = 0;
            for j = 1:length(req_ptrs)
                if any(ismember(double(rhsptrs),double(req_ptrs{j})))
                    % combine with existing group
                    if done
                        error('cgoppoint::checkdataset: required to combine two independant groups. Check cgsymvalue definitions.');
                    end
                    done = 1;
                    % Change 12/x/01 - This must be j!
%                    req_ptrs{i} = [req_ptrs{i} rhsptrs];
                    req_ptrs{j} = [req_ptrs{j} rhsptrs];
                    symfact = [symfact valid_i(i)];
                    symgrp = [symgrp j];
                end
            end
            if ~done
                % create new group
                req_ptrs = [req_ptrs {rhsptrs}];
                symfact = [symfact valid_i(i)];
                symgrp = [symgrp length(req_ptrs)];
            end
        end
    end
end

% Now assign group numbers
group = repmat(0,1,length(op.ptrlist));
need = []; grpneed = [];
for i = 1:length(req_ptrs)
    % Put symvalues in group
    syms = find(symgrp==i);
    group(symfact(syms)) = i;
    % Find cgvalues
    vals = find(ismember(double(valptrs),double(req_ptrs{i})));
    if any(group(valfact(vals)))
        error('cgoppoint::checkdataset: cgvalue required to be in two groups.');
    end
    group(valfact(vals)) = i;
    % Find any cgvalues required, but not in dataset.
    % Add to dataset.
    thisneed = setdiff(double(req_ptrs{i}),double(valptrs));
    need = [need thisneed];
    grpneed = [grpneed repmat(i,size(thisneed))];
end
op.group = group;

if ~isempty(need)
    if length(unique(need)) ~= length(need)
        error('cgoppoint::checkdataset: cgvalue required to be in two groups.');
    end
    op = addfactor(op,assign(xregpointer,need),'group',grpneed,'grid_flag',8,...
        'factor_type',1);
end
% Ensure only one live group member per group
op = SetGroupDependants(op);

if doEval
    % Need to do an eval_fill.
    op = eval_fill(op);
end
