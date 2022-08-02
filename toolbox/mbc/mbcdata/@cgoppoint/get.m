function out = get(P,arg1,arg2)
% value = get(p,property) returns the property for all factors
% value = get(p,index,property) returns property for selected factor(s) only
% get(cgoppoint) shows fields

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:41 $

out = [];
if nargin == 1
    out.data = 'data matrix';
    out.name = 'operating point set name';
    out.numpoints = 'number of operating points';
    out.numfactors = 'number of factors';
    out.factors = 'cell array of factor names';
    out.factor_type = '0 - ignore, 1 - input, 2 - output';
    out.orig_name = 'imported data column name';
    out.ptrlist = 'vector of pointers to factors';
    out.linkptrlist = 'linked pointer (null for no link)';
    out.overwrite = 'overwrite flag: 0 - evaluate data, 1 - overwrite';
    out.group = 'group number (0 - no group)';
    out.grid_flag = 'Grid inputs: 0 - constant, 1 - range, 7 - block';
    out.range = 'Internal range for gridding';
    out.constant = 'Internal constant for gridding';
    out.type = 'Dataset type';
    out.rules = 'Rules set for filtering points';
    %out.filter
    %out.outliers
elseif nargin>1
    if nargin==2 & ischar(arg1)
        property = arg1;
        index = [];
    elseif nargin==3 & isnumeric(arg1) & ischar(arg2)
        property = arg2;
        index = arg1;
        if any(~ismember(index,1:length(P.ptrlist)))
            error('cgoppoint::get: bad index into factors');
        end
    else
        error('cgoppoint::get: expect property name');
    end
    switch lower(property)
    case 'name'
        out = P.name;
        index = [];
    case 'type'
        out = 'Dataset';
        index = [];
    case 'data'
        out = P.data;
        index = [];
    case 'numpoints'
        S = size(P.data);
        out = S(1);
        if S(2) == 0
            out = 0;
        end
        index = [];
    case 'numfactors'
        out = length(P.ptrlist);
        index = [];
    case 'ptrlist'
        out = P.ptrlist;
    case 'linkptrlist'
        out = P.linkptrlist;
    case 'rules'
        out = P.rules;
    case 'group'
        out = P.group;
    case 'overwrite'
        out = P.overwrite;
    case 'do_range'
        warning('get: do_range');
        out = P.grid_flag;
    case 'grid_flag'
        out = P.grid_flag;
    case 'range'
        out = P.range;
    case 'constant'
        out = P.constant;
    case 'orig_name'
        out = P.orig_name;
    case 'factor_type'
        out = P.factor_type;
    case 'tolerance'
        out = P.tolerance;  
    case 'units'
        out = P.units;
    case 'created_flag'
        out = P.created_flag;
    case 'factors'
        for i = 1:length(P.ptrlist)
            if isvalid(P.ptrlist(i))
                if P.created_flag(i)==-2
                    out{i} = P.orig_name{i};
                else
                    out{i} = P.ptrlist(i).getname;
                end
            else
                out{i} = [P.orig_name{i}];
            end
        end
    case 'assignednames'
        for i = 1:length(P.ptrlist)
            if isvalid(P.ptrlist(i))
                if P.created_flag(i)==-2 | P.created_flag(i)==1
                    out{i} = P.orig_name{i};
                else
                    out{i} = P.ptrlist(i).getname;
                    if P.created_flag(i)~=0 & ~isempty(P.orig_name{i})
                        out{i} = [out{i} ' (' P.orig_name{i} ')'];
                    end
                end
            else
                out{i} = P.orig_name{i};
            end
        end
    case 'factor_type_names'
        for i = 1:length(P.ptrlist)
            switch P.factor_type(i)
            case 1
                out{i} = 'Input';
            case 2
                out{i} = 'Output';
            otherwise
                out{i} = 'X  Ignored';
            end
        end
    case 'assign_lock'
        out = cellfun('isempty',P.orig_name);
    case {'used_overwrite','display_overwrite','iseditable'}
        if isempty(P.ptrlist)
            out = [];
        else
        out = P.overwrite;
        out(find(P.factor_type==0)) = 0;   % ignored columns
        % values and unassigned column must be overwritten
        valid = isvalid(P.ptrlist);
        for i = 1:length(P.ptrlist)
            if ~valid(i) | P.ptrlist(i).isddvariable
                out(i) = 1;
            end
        end
        % set all members of non-linked group to overwrite.
        gno = setdiff(P.group,0);
        out(find(ismember(P.group,gno))) = 1;
        % set linked factors to non-overwrite
        % set all members of linked group to non-overwrite.
        link_i = find(isvalid(P.linkptrlist));
        gno = setdiff(P.group(link_i),0);
        link_i = [link_i find(ismember(P.group,gno))];
        out(link_i) = 0;
    end
    case {'evaldisp_overwrite','isoverwrite'}
        if isempty(P.ptrlist)
            out = [];
        else
        out = P.overwrite;
        out(find(P.factor_type==0)) = 0;   % ignored columns
        % values and unassigned column must be overwritten
        valid = isvalid(P.ptrlist);
        for i = 1:length(P.ptrlist)
            if valid(i) & P.ptrlist(i).isddvariable
                out(i) = 1;
            end
        end
        % unassigned do not overwrite
        out(find(~valid)) = 0;
        % set all members of group to overwrite.
        gno = setdiff(P.group,0);
        out(find(ismember(P.group,gno))) = 1;
        % set linked factors to overwrite
        link_i = find(isvalid(P.linkptrlist) & P.created_flag~=-2);
        out(link_i) = 1;
        % set created ptrs to non-overwrite
        cr_i = find(P.created_flag==1);
        out(cr_i) = 0;
    end
    case 'isevaluation'
        % Begin with inverse of overwrite flag.
        if isempty(P.ptrlist)
            out = [];
        else
        out = ~P.overwrite;
        valid = isvalid(P.ptrlist);
        out(find(P.factor_type==0)) = 0;   % ignored columns
        % values and unassigned column cannot evaluate
        for i = 1:length(P.ptrlist)
            if valid(i) & P.ptrlist(i).isddvariable
                out(i) = 0;
            end
        end
        % unassigned do not evaluate
        out(find(~valid)) = 0;
        % set all members of group to overwrite.
        gno = setdiff(P.group,0);
        out(find(ismember(P.group,gno))) = 0;
        % set linked factors to overwrite
        link_i = find(isvalid(P.linkptrlist) & P.created_flag~=-2);
        out(link_i) = 0;
        % set created ptrs to non-evaluate
        cr_i = find(P.created_flag==1);
        out(cr_i) = 0;
    end
    case 'blocklen'
        out = P.blocklen;
    otherwise
        error(['get: unknown property ' property]);
    end
    
    if ~isempty(index)
        out = out(index);
        if length(index)==1 & iscell(out)
            out = out{1};
        end
    end
end
