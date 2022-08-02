function [in_i,types,typestrs,ranges,numpts] = getGridInfo(op,det_fact_i)
%GETGRIDINFO

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 06:51:45 $

if nargin<2
    det_fact_i = [];
elseif length(det_fact_i)~=1
    error('generate detailed info for 1 factor only');
end

types = []; typestrs = []; ranges = [];
[op,dependant] = SetGroupDependants(op);
factors = get(op,'factors');

numpts = 1;
block_i = find(op.grid_flag==7);
if ~isempty(block_i)
    blocklen = ndblock(op,block_i);
    numpts = blocklen;
end

in_i = find(op.factor_type==1 & ~isvalid(op.linkptrlist));

if isempty(det_fact_i)
    do = in_i;
elseif det_fact_i
    do = det_fact_i;
else
    do = [];
end
for i = 1:length(do)
    fact_i = do(i);
    range = [];
    type = '';
    typestr = '';
    detail = '';
    if isvalid(op.linkptrlist(fact_i))
        % linked - cannot alter anything
        type = 'linked';
        lptr = op.linkptrlist(fact_i);
        typestr = ['Linked to ' lptr.getname];
        detail = [' is linked to ' lptr.getname '.'];
    else
        range = [];
        switch op.grid_flag(fact_i)
        case 0
            type = 'constant';
            typestr = 'Constant';
            range = op.constant(fact_i);
            detail = range;
        case 1
            type = 'grid';
            typestr = 'Grid';
            range = op.range{fact_i};
            detail = range;
            numpts = numpts*length(op.range{fact_i});
        case 6
            type = 'table';
            typestr = 'Grid';
            detail = ' is imported from a table.';
            numpts = numpts*length(op.range{fact_i});
        case 7
            type = 'block';
            typestr = 'Block';
            detail = [' is imported data  (block size: ' ...
                num2str(blocklen) ' points).'];
            % blocklength already included in numpts
        case 8
            dep_i = dependant(fact_i);
            rangestr = '';
            typestr = ['Dependant (' factors{dep_i} ')'];
            detail = [' is dependant on ' factors{dep_i} '.'];
            if isvalid(op.linkptrlist(dep_i))
                % linked - cannot alter anything
                type = 'grouplinked';
            else
                switch op.grid_flag(dep_i)
                case 0
                    type = 'groupconstant';
                case 1
                    type = 'groupgrid';
                case 6
                    type = 'groupgrid';
                case 7
                    type = 'groupblock';
                end
            end
        end
    end
    types = [types {type}];
    typestrs = [typestrs {typestr}];
    ranges = [ranges {range}];
end

out_i = setdiff(block_i,in_i);
if ~isempty(out_i)
    in_i = [in_i 0];
    types = [types {'outputblock'}];
    typestrs = [typestrs {'Block'}];
    ranges = [ranges {[]}];
end

if ~isempty(det_fact_i)
    if det_fact_i & ~isnumeric(detail)
        detail = [factors{det_fact_i} detail];
    elseif ~det_fact_i & ~isempty(out_i)
        if length(out_i)==1
            detail = ['1 output factor is imported data (block size: ' ...
                    num2str(blocklen) ' points).'];
        else
            detail = [num2str(length(out_i)) ' output factors are imported data (block size: ' ...
                    num2str(blocklen) ' points).'];
        end
    end
    in_i = detail;
end
    
