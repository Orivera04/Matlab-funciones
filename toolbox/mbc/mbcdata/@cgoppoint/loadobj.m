function new = loadobj(P)
% cgoppoint/loadobj
%  loadobj conversion for dataset object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:52:08 $
if isstruct(P)
    new = cgoppoint;
    
    if isfield(P,'data')
        new.data = P.data;
    end
    if isfield(P,'name')
        new.name = P.name;
    end
    s = 0;
    if isfield(P,'factorinfo')
        if isfield(P.factorinfo,'ptr')
            new.ptrlist = [P.factorinfo.ptr];
            s = length(new.ptrlist);
        end
        if isfield(P.factorinfo,'orig_name')
            new.orig_name = {P.factorinfo.orig_name};
            for i = 1:length(P.factorinfo)
                f = strmatch(P.factorinfo(i).factortype,{'input','output'});
                if isempty(f), f = 0; end
                new.factor_type(i) = f;
            end
        else
            new.factor_type = repmat(0,1,s);
        end
        if isfield(P.factorinfo,'linkptr')
            new.linkptrlist = [P.factorinfo.linkptr];
        else
            for i = 1:s
                new.linkptrlist = [new.linkptrlist xregpointer];
            end
        end
        if isfield(P.factorinfo,'overwrite')
            new.overwrite = [P.factorinfo.overwrite];
        else
            new.overwrite = repmat(0,1,s);
        end
        if isfield(P.factorinfo,'group')
            new.group = [P.factorinfo.group];
        else
            new.group = repmat(0,1,s);
        end
        if isfield(P.factorinfo,'do_range')
            new.grid_flag = [P.factorinfo.do_range];
        else
            new.grid_flag = repmat(0,1,s);
        end
        if isfield(P.factorinfo,'range')
            new.range = {P.factorinfo.range};
        else
            new.range = cell(1,s);
        end
        if isfield(P.factorinfo,'constant')
            new.constant = [P.factorinfo.constant];
        else
            new.constant = repmat(0,1,s);
        end
        if isfield(P.factorinfo,'tolerance')
            new.tolerance = [P.factorinfo.tolerance];
        else
            new.tolerance = repmat(0,1,s);
        end
    else
        if isfield(P,'ptrlist')
            new.ptrlist = P.ptrlist;
            s = length(new.ptrlist);
        else
            s = 0;
        end
        if isfield(P,'orig_name')
            new.orig_name = P.orig_name;
        else
            new.orig_name = cell(1,s);
        end
        if isfield(P,'factor_type')
            new.factor_type = P.factor_type;
        else
            new.factor_type = repmat(0,1,s);
        end
        if isfield(P,'linkptrlist')
            new.linkptrlist = P.linkptrlist;
        else
            for i = 1:s
                new.linkptrlist = [new.linkptrlist xregpointer];
            end
        end
        if isfield(P,'overwrite')
            new.overwrite = P.overwrite;
        else
            new.overwrite = repmat(0,1,s);
        end
        if isfield(P,'group')
            new.group = P.group;
        else
            new.group = repmat(0,1,s);
        end
        if isfield(P,'grid_flag')
            new.grid_flag = P.grid_flag;
        else
            new.grid_flag = repmat(0,1,s);
        end
        if isfield(P,'range')
            new.range = P.range;
        else
            new.range = cell(1,s);
        end
        if isfield(P,'constant')
            new.constant = P.constant;
        else
            new.constant = repmat(0,1,s);
        end
        if isfield(P,'tolerance')
            new.tolerance = P.tolerance;
        else
            new.tolerance = repmat(0,1,s);
        end
        if isfield(P,'rules')
            new.rules = cgrules;
        end
    end
    
    if isfield(P,'units') & iscell(P.units)
        new.units = P.units;
    else
        for i = 1:s
            new.units = [new.units {junit}];
        end
    end
    if isfield(P,'created_flag')
        new.created_flag = P.created_flag;
    else
        new.created_flag = repmat(0,1,s);
    end
    % Addition - 19/ix/01
    if isfield(P, 'blocklen')
        new.blocklen = P.blocklen;
    else
        new.blocklen = [];
    end
else
    new = P;
end
    