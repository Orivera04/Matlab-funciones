function P = set(P,varargin)
% p = set(p,'all',property,value,...) sets property/value pairs for all factors
% p = set(p,property,value,...) 'all' is implicit
% p = set(p,factorindex,property,value,...) sets properties for particular factors only.
% p = set(cgoppoint) shows fields

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:52:15 $

if nargin==1
    P = i_showfields;
elseif nargin<3
    error('set(P,property,value)');
else
    if ischar(varargin{1})
        if strcmp(varargin{1},'all')
            varargin(1) = [];
        end
        ind = 1:length(P.ptrlist);
    elseif isnumeric(varargin{1})
        ind = varargin{1};
        varargin(1) = [];
    else
        error('set(P,property,value...) or set(P,index,property,value...)');
    end
%     
%     if mod(nargin-varargsused,2)==0
%         error('set: need property/value pairs');
%         return
%     end
    
    for i = 1:2:length(varargin)-1
         property = varargin{i};
         if ~ischar(property)
             error('set: property must be string');
         end
         property = lower(property);
         value = varargin{i+1};
         P = i_setfactor(P,ind,property,value);
    end
end

%%%%%%%%%%%%%%%%%%%
function P = i_setfactor(P,ind,property,newvalue);


if any(~ismember(ind,1:length(P.ptrlist)))
    error('Bad index into factors');
    return
end

if strcmp(property,'data')
    P = i_setdata(P,ind,newvalue);
elseif strcmp(property, 'blocklen')
    P.blocklen = newvalue;
elseif strmatch(property,{'name','ptrlist','linkptrlist','rules'},'exact')
    if ~isempty(setdiff(1:length(P.ptrlist),ind))
        error(['set: ' property ' cannot be set for individual factors']); 
    elseif strcmp(property,'name')
        if ischar(newvalue)
            P.name = newvalue;
        else
            error('set: name must be string');
        end
    elseif strcmp(property,'rules')
            P.rules = newvalue;
    elseif strcmp(property,'linkptrlist') & length(newvalue)==length(P.ptrlist)
        if isa(newvalue,'xregpointer')
                P.linkptrlist = newvalue;
            else
                error('set: ptrlist must be a vector of xregpointers');
                return
            end
    elseif strcmp(property,'ptrlist') & length(newvalue)==length(P.ptrlist)
            if isa(newvalue,'xregpointer')
                P.ptrlist = newvalue;
            else
                error('set: ptrlist must be a vector of xregpointers');
                return
            end
    else
        error('set: ptrlist must match number of factors');
    end
else
 
for j = 1:length(ind)
    i = ind(j);
    if length(newvalue)==length(ind) & ~ischar(newvalue)
        if iscell(newvalue)
            value = newvalue{j};
        else
            value = newvalue(j);
        end
    elseif isempty(newvalue) | (length(newvalue)==1)
        value = newvalue;
    elseif ~isempty(strmatch(lower(property),{'range','units','factor_type'},'exact')) & ~iscell(newvalue)
        value = newvalue;
    else
        error('Length of value must match number of factors referenced');
    end
        
    switch lower(property)
    case 'orig_name'
        P.orig_name{i} = value;
    case 'factor_type'
        if ischar(value)
            switch lower(value)
            case 'ignore'
                P.factor_type(i) = 0;
            case 'input'
                P.factor_type(i) = 1;
            case 'output'
                P.factor_type(i) = 2;
            otherwise
                error('set: allowable factor types are input, output, ignore');
            end
        elseif isnumeric(value) & ismember(value,0:3)
            P.factor_type(i) = value;
        else
            error('set: factor_type must be in range 0:2');
        end
    case 'tolerance'
        P.tolerance(i) = value;
    case 'range'
  		P.range{i} = value;
    case 'constant'
        P.constant(i) = value;
    case 'do_range'
        warning('set: do_range');
    case 'grid_flag'
        P.grid_flag(i) = value;
        % Addition for blocklen
        if value == 7
            P.blocklen = size(P.data, 1);
        end
    case 'filter'
        P.filter(i) = value;
    case 'group'
        P.group(i) = value;
    case 'overwrite'
        P.overwrite(i) = value;
    case 'created_flag'
        P.created_flag(i) = value;
    case 'ptr'
        if isa(value,'xregpointer')
            P.ptrlist(i) = value;
        else
            error('set: ptr must be a xregpointer object');
            return
        end
    case 'linkptr'
        if isa(value,'xregpointer')
            P.linkptrlist(i) = value;
        else
            error('set: linkptr must be a xregpointer object');
            return
        end
    case 'units'
        if isa(value,'junit')
            P.units{i} = value;
        elseif ischar(value)
            try
                P.units{i} = junit(value);
            catch
                P.units{i} = junit;
            end
        end
        if ~isvalid(P.units{i})
            P.units{i} = junit;
        end
    otherwise
        error(['set: unknown property ' property]);
    end
end

end


%------------------------
function P = i_setdata(P,ind,newvalue)

if length(ind)~=size(newvalue,2)
    if length(ind)==size(newvalue,1)
        newvalue = newvalue';
    elseif ~isempty(newvalue)
        error('set: data size must match number of indices given');
    end
end

if ~all(ismember(ind,1:length(P.ptrlist)))
    error('set: bad index into factors');
end
if isempty(setdiff(1:length(P.ptrlist),ind))
    P.data = newvalue;
elseif size(newvalue,1)==size(P.data,1)
    if size(newvalue,2)==length(ind)
        P.data(:,ind) = newvalue(:,1:length(ind));
    elseif size(newvalue,2)==1
        P.data(:,ind) = repmat(newvalue,1,length(ind));
    elseif size(newvalue,2)==0
        P.data = [];
    else
        error('set: data size must match existing data');
    end
elseif size(newvalue,1)==1
    P.data(:,ind) = repmat(newvalue,size(P.data,1),1);
elseif isempty(newvalue)
    P.data(:,ind) = repmat(0,size(P.data,1),length(ind));
else
    error('set: data size must match existing data');
end


%-------------------------
function out = i_showfields
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
    %out.filter
    %out.outliers
