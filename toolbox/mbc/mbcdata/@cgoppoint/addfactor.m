function p = addfactor(p,factor,data,varargin);
% p = addfactor(p,ptrlist,[data]) adds factor indexed by ptr
% p = addfactor(p,namelist,[data]) adds named factors. namelist is single name or cell array.
%  data is empty or not present - add blank factors
%  data is matrix - bolt data to existing data
%  data is cell array - set ranges of factors
% p = addfactor(...,property,value,...) sets property/value pairs for the new factors
%
% For ptrlist input, factor_type is set to 'input' for value expressions, 
%   'output' for non-value expressions;
% For namelist input, all factor_types are set to 'input'
% To override these defaults, use p = addfactor(...,'factor_type','type')
%
% Range and tolerance are calculated for new factors.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:24 $

nf = length(p.ptrlist);
np = get(p,'numpoints');
olddata = p.data;
done_range = 0; done_tolerance = 0;
argsused = 1;
if nargin>2
    dataarg = data;
end

if nargin==1
    data = olddata;
    
elseif (length(factor)==1) & isa(factor,'xregpointer') & isvalid(factor(1)) & isa(factor.info,'cglookup') & ~nf & ...
        (nargin==2 | ~isnumeric(data))
    if nargin>2 & ischar(data) & strcmp(lower(data),'fill')
        fillopt = 'fill';
        argsused = 3;
    else
        fillopt = '';
        argsused = 2;
    end
    [p,data] = create_from_table(p,factor,fillopt);
            
elseif isempty(factor)
    if nargin>2 & isempty(data)
        argsused = 3;
    else
        argsused = 2;
    end
    data = olddata;
    
else
    if ischar(factor)
        factor = {factor};
    end
    
    if nargin==2
        argsused = 2;
    elseif (nargin>2) & ischar(data)
        argsused = 2;
    else
        argsused = 3;
    end
    
    %check 'factor' is in a valid form - allow cell, pointer list
    if iscell(factor)
        for i = 1:length(factor)
            if ~ischar(factor{i}) & ~isempty(factor{i})
                error('addfactor(p,factor): cell array must be of factor names');
            end
        end
    elseif isa(factor,'xregpointer')
        for i = 1:length(factor)
            if ~ (isa(factor(i),'xregpointer'))
                error('addfactor(p,factor): factor list must be vector of xregpointers');
            end
        end
    else
        error('addfactor(p,factor): factor must be xregpointer list or array of names');
    end
    
    %check 'data' is in a valid form - empty, matrix or cell
    range = []; constant = [];
    if (argsused<3) | isempty(data)
        if (argsused>2) & iscell(data) %empty cell - get default ranges
            for i = 1:length(factor)
                range{i} = i_eval(factor(i).info);
            end
            done_range = 1;
        end
        data = [olddata repmat(0,np,length(factor))];
    elseif iscell(data)
        if length(factor)~=length(data)
            error('addfactor(p,factor,data): data length must match number of new factors');
        else
            done_range = 1;
            range = data;
        end
        data = [olddata repmat(0,np,length(factor))];
    elseif isnumeric(data)
        if size(data,2)~=length(factor)
            if size(data,1)==length(factor)
                data = data';
            else
                error('addfactor: data size must match number of new factors');
            end
        end
        if size(data,1)==1
            constant = data;
            if nf & np
                data = [olddata repmat(data,np,1)];
            end
        else
            if nf & np
                if size(data,1)~=np
                    error('addfactor: number of data points must match existing data');
                else
                    data = [olddata data];
                end
            elseif nf & ~np
                data = [repmat(get(p,'constant'),size(data,1),1) data];
            elseif ~nf
                %leave data as it is
            end
        end
    end
        
    nf2 = length(factor);
    % Don't need to do anything with rules selection or outliers.
    if iscell(factor)
        p.orig_name = [p.orig_name factor];
        p.factor_type = [p.factor_type repmat(1,1,nf2)]; % inputs
        p.overwrite = [p.overwrite repmat(1,1,nf2)]; % overwrite by default
        p.group = [p.group repmat(0,1,nf2)];
        p.grid_flag = [p.grid_flag repmat(0,1,nf2)];
        p.range = [p.range cell(1,nf2)];
        p.constant = [p.constant repmat(0,1,nf2)];
        p.tolerance = [p.tolerance repmat(0,1,nf2)];
        p.created_flag = [p.created_flag repmat(0,1,nf2)]; 
        for i = 1:nf2
            p.ptrlist = [p.ptrlist xregpointer];
            p.units = [p.units {junit}];
            p.linkptrlist = [p.linkptrlist xregpointer];
        end
    elseif isa(factor,'xregpointer')
        p.ptrlist = [p.ptrlist factor];
        p.orig_name = [p.orig_name cell(1,nf2)];
        p.group = [p.group repmat(0,1,nf2)];
        if ~isempty(range)
            p.range = [p.range range];
            p.grid_flag = [p.grid_flag repmat(1,1,nf2)];
        else
            p.range = [p.range cell(1,nf2)];
            p.grid_flag = [p.grid_flag repmat(0,1,nf2)];
        end
        if ~isempty(constant)
            p.constant = [p.constant constant];
        else
            p.constant = [p.constant repmat(0,1,nf2)];
        end
        p.tolerance = [p.tolerance repmat(0,1,nf2)];
        p.created_flag = [p.created_flag repmat(-1,1,nf2)]; % created from cage
        for i = 1:nf2
            if ~isvalid(factor(i)) | factor(i).isa('cgvariable')
                p.factor_type = [p.factor_type 1]; % input
                p.overwrite = [p.overwrite 1]; 
            else
                p.factor_type = [p.factor_type 2]; % output
                p.overwrite = [p.overwrite 0]; 
            end
            p.units = [p.units {junit}];
            p.linkptrlist = [p.linkptrlist xregpointer];
        end
    end
end

p.data = data;
%new_i = [size(olddata,2)+1 : length(fi_all)];
if ~done_range
%    p = SetRange(p,new_i); 
end
if nargin>argsused
    if (argsused == 2) & ischar(dataarg)
        args = {dataarg,varargin{:}};
    else
        args = {varargin{:}};
    end
    done_tolerance = ~isempty(strmatch('tolerance',args(1:2:end)));
    if nf
        p = set(p,[nf+1:length(p.ptrlist)],args{:});
    else
        p = set(p,args{:});
    end
end
if ~done_tolerance
%    p = SetTolerance(p,new_i,'quick');
end



function [p,data] = create_from_table(p,tptr,do_fill)
ax = get(tptr.info,'axes');
ptrlist = get(tptr.info,'axesptrs');
tabledata = get(tptr.info,'values');
% make up the combined data set
if iscell(ax)
    if any(isinf([ax{:}]) | isnan([ax{:}])) | isempty(tabledata)
        data = zeros(0,3); ax{1} = []; ax{2} = []; tabledata = [];
    else
    	[Col1, Col2] = meshgrid(ax{1},ax{2});
    	data = [Col1(:) Col2(:)];
    end
else
    if any(isinf(ax) | isnan(ax)) | isempty(tabledata)
        ax = {[]};
        data = zeros(0,2); tabledata = [];
    else
    	data = ax(:);
        ax = {ax(:)};
    end
end

nf = size(data,2);
    % Don't need to do anything with rules selection or outliers.
p.orig_name = [p.orig_name cell(1,nf)];
p.factor_type = [p.factor_type repmat(1,1,nf)]; % inputs
p.overwrite = [p.overwrite repmat(1,1,nf)]; % overwrite by default
p.group = [p.group repmat(0,1,nf)];
p.grid_flag = [p.grid_flag repmat(6,1,nf)];
p.range = [p.range ax];
p.constant = [p.constant repmat(0,1,nf)];
p.tolerance = [p.tolerance repmat(0,1,nf)];
p.created_flag = [p.created_flag repmat(-1,1,nf)];
for i = 1:nf
    p.ptrlist = [p.ptrlist ptrlist(i)];
    p.units = [p.units {junit}];
    p.linkptrlist = [p.linkptrlist xregpointer];
end

if strcmp(do_fill,'fill')
    nf = 1;
    p.orig_name = [p.orig_name cell(1,nf)];
    p.factor_type = [p.factor_type repmat(2,1,nf)]; % output
    p.overwrite = [p.overwrite repmat(0,1,nf)]; % overwrite by default
    p.group = [p.group repmat(0,1,nf)];
    p.grid_flag = [p.grid_flag repmat(0,1,nf)];
    p.range = [p.range cell(1,nf)];
    p.constant = [p.constant repmat(0,1,nf)];
    p.tolerance = [p.tolerance repmat(0,1,nf)];
    p.ptrlist = [p.ptrlist tptr];
    p.units = [p.units {junit}];
    p.created_flag = [p.created_flag repmat(-1,1,nf)];
    p.linkptrlist = [p.linkptrlist xregpointer];
    data = [data tabledata(:)];
end


