function varargout = set(varargin)
%cgnormaliser\set
%	out=set(N)	returns a list of properties and the required value type
%	N=set(N,'property',value,...) sets a property of N to the value given 
    %
%  T = set(T,'values',v);
%  T = set(T,'values',{v,Information});
%  Sets the "output" values of the normaliser.  Information, if given, is a
%  string which appears as the comment in the normaliser's history view.
%  Values must be increasing integers, although there may be two or more the
%  same at either end.
%
%  T = set(T,'breakpoints',v);
%  T = set(T,'breakpoints',{v,Information});
%  Sets the breakpoints of the normaliser.  Information, if given, is a
%  string which appears as the comment in the normaliser's history view.
%  Breakpoints must be increasing real numbers.
% 
%  T = set(T,'matrix',M);
%  T = set(T,'matrix',{M,Information});
%  M is an n*2 matrix.  The first column gives new breakpoints.  The second,
%  new values.  Use this to change the size of the normaliser. All locks are
%  lost.
%
%  T = set(T,'v_element',[j,x]);
%  T = set(T,'v_element',{[j,x],Information});
%  Sets the Value at index j to (integer) value x.
% 
%  T = set(T,'bp_element',[j,x]);
%  T = set(T,'bp_element',{[j,x],Information});
%  Sets the Breakpoint at index j to new value x.
% 
%  T = set(T,'vlocks',L);
%  L is a vector of the same length as the normaliser.  Locks all Values for
%  which the corresponding element in L is 1, and unlocks those for which the
%  corresponding element is 0.
%
%  T = set(T,'bplocks',L);
%  L is a vector of the same length as the normaliser.  Locks all Breakpoints
%  for which the corresponding element in L is 1, and unlocks those for which
%  the corresponding element is 0.
%
%  Other properties:
%  weights, description, input, precision, range, memory, extrapolate, flist

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.4 $  $Date: 2004/04/04 03:27:43 $



if nargin == 1
    varargout{1} = i_ShowFields(varargin{1});
    return;
else
    LT = varargin{1};
    if nargin < 3
        error('mbc:cgnormaliser:InvalidArgument','Insufficient arguments.');
    end
    for i = 2:2:nargin
        property = varargin{i};
        new_value = varargin{i+1};
        if ~isa(property , 'char')
            error('mbc:cgnormaliser:InvalidPropertyName','Non character array property name.');
        end

        switch lower(property)
        case 'breakpoints'
            LT = i_breakpoints(LT,new_value);
        case 'bp_element'
            LT = i_bp_element(LT,new_value);
        case 'v_element'
            LT = i_v_element(LT,new_value);
        case 'values'
            LT = i_values(LT,new_value)  ;       
        case 'vlocks'
            LT = i_vlocks(LT,new_value);
        case 'bplocks'
            LT = i_bplocks(LT,new_value);
        case 'matrix'
            LT = i_matrix(LT,new_value);
        case 'weights'
            if length(new_value) == length(LT.SFlist)
                LT.Weights = new_value;
            else
                error('mbc:cgnormaliser:InvalidPropertyValue','Weight vector is wrong length');
            end
        case 'description'
            LT.Description = new_value;
        case 'input'
            LT.Input = new_value;
        case 'precision'
            LT.Precision = new_value;
        case 'range'
            LT.Range = new_value;
        case 'memory'
            LT.Memory = new_value;
        case 'extrapolate'
            LT.Extrapolate = new_value;
        case 'flist'
            LT.Flist = new_value;
        otherwise
            warning('mbc:InvalidArgument',['Attempting to set '''...
                property ''' in cgnormaliser. Not a valid property.']);
        end
    end
end

if nargout > 0
    varargout{1} = LT;
elseif ~isempty(inputname(1))
    assignin('caller' , inputname(1) , LT);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = i_ShowFields(in)
out = struct(in);
out.Breakpoints = 'n by 1 vector';
out.BP_Element = '';
out.Values = 'n by 1 Array';
out.V_Element = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LT = i_bp_element(LT,new_value)

BP = LT.Breakpoints;
if isa(new_value,'double')
    j = new_value(1);
    x = new_value(2);
    BP(j) = x;
    LT = set(LT,'Breakpoints',BP);
else % Cell array: { [index,bp],information }
    V = new_value{1};
    j = V(1);
    x = V(2);
    info = new_value{2};
    BP(j) = x;
    LT = set(LT,'Breakpoints',{BP,info});
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LT = i_v_element(LT,new_value)

val = LT.Values;
if isa(new_value,'double')
    j = new_value(1);
    x = new_value(2);
    val(j) = x; 
    LT = set(LT,'values',val);
else % Cell array: { [index,value],information }
    V = new_value{1};
    j = V(1);
    x = V(2);
    info = new_value{2};
    val(j) = x; 
    LT = set(LT,'values',{val,info});
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function T = i_values(T,newvalue)

BP = T.Breakpoints;
val = T.Values;
vlocks = T.VLocks;

if ~isa(newvalue,'double')
    nval = newvalue{1};
    info = newvalue{2};
else
    nval = newvalue;
    info = [];
end

if isempty(nval)
    T.Values = [];
    T.VLocks = [];
else
    if ~isequal(size(BP),size(nval)) && ~isempty(BP)
        error('mbc:cgnormaliser:InvalidPropertyValue','New values vector not same size as breakpoints vector');
    end
    i_CheckValidValues(nval);
    if ~isempty(vlocks)
        vlocks = logical(vlocks);
        nval(vlocks) = val(vlocks);
    end
    T.Values = nval;
end

n = length(T.Memory);

T.Memory{n+1}.Values = T.Values;
T.Memory{n+1}.Breakpoints = BP;
T.Memory{n+1}.Information = info;
T.Memory{n+1}.Date = datestr(now,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_breakpoints               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function T = i_breakpoints(T,newvalue)

BP = T.Breakpoints;
val = T.Values;
bplocks = T.BPLocks;

if ~isa(newvalue,'double')
    nval = newvalue{1};
    info = newvalue{2};
else
    nval = newvalue;
    info = [];
end  

if isempty(nval)
    T.Breakpoints = [];
    T.BPLocks = [];
else
    if ~isequal(size(val(:)),size(nval(:))) && ~isempty(val)
        error('mbc:cgnormaliser:InvalidPropertyValue','New breakpoints vector not same size as values vector');
    end
    i_CheckValidBreakpoints(nval);
    if ~isempty(bplocks)
        bplocks = logical(bplocks);
        nval(bplocks) = BP(bplocks);
    end
    prec = T.Precision;
    T.Breakpoints = resolve(prec,nval);
end

n = length(T.Memory);

T.Memory{n+1}.Values = val;
T.Memory{n+1}.Breakpoints = T.Breakpoints;
T.Memory{n+1}.Information = info;
T.Memory{n+1}.Date = datestr(now,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_vlocks                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function T = i_vlocks(T,L)

if isempty(L)
    T.VLocks  = [];
elseif ~isequal(length(L(:)),length(T.Values(:)))
    error('mbc:cgnormaliser:InvalidPropertyValue','New vlock vector not right size');
elseif ~isequal(L, L.^2)
    error('mbc:cgnormaliser:InvalidPropertyValue','Locks vectors are to conist of 0''s and 1''s');
else
    T.VLocks = L;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_bplocks                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function T = i_bplocks(T,L)

if isempty(L)
    T.BPLocks  = [];
elseif ~isequal(size(L),size(T.Breakpoints))
    error('mbc:cgnormaliser:InvalidPropertyValue','New bplock vector not right size');
elseif ~isequal(L, L.^2)
    error('mbc:cgnormaliser:InvalidPropertyValue','Locks vectors are to conist of 0''s and 1''s');
else
    T.BPLocks = L;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LT = i_matrix(LT,new_value)

if isa(new_value,'double')
    M = {new_value,[]};
else
    M = new_value;
end
LT = set(LT,'vlocks',[]);
LT = set(LT,'bplocks',[]);

if isempty(M{1})
    LT.Values = [];
    LT.Breakpoints = [];
    LT.VLocks = [];
    LT.BPLocks = [];
    return
else
    i_CheckValidBreakpoints(M{1}(:,1));
    i_CheckValidValues(M{1}(:,2));
    LT.VLocks = [];
    LT.BPLocks = [];
    LT.Values = M{1}(:,2);
    prec = LT.Precision;
    LT.Breakpoints = resolve(prec,M{1}(:,1));
    LT.VLocks = zeros(length(M{1}),1);
    LT.BPLocks = zeros(length(M{1}),1);
end
n = length(LT.Memory);
LT.Memory{n+1}.Values = M{1}(:,2);
LT.Memory{n+1}.Breakpoints = M{1}(:,1);
LT.Memory{n+1}.Information = M{2};
LT.Memory{n+1}.Date = datestr(now,0);


%--------------------------------------
function i_CheckValidBreakpoints(bp)

diffs = diff(bp);
if any(diffs < 0)
    % no breakpoint is allowed to be lower than the previous one
    error('mbc:cgnormaliser:InvalidPropertyValue','Breakpoints vector must be non-decreasing');
end


%--------------------------------------
function i_CheckValidValues(v)

rv = round(v);
if any(rv~=v)
    error('mbc:cgnormaliser:InvalidPropertyValue','Values must be integers');
end
diffs = diff(v);
if any(diffs < 0)
    % no value is allowed to be lower than the previous one
    error('mbc:cgnormaliser:InvalidPropertyValue','Values vector must be increasing');
end
if any(diffs==0)
    % only values at the ends may be equal
    ind = find(diffs==0);
    ind = ind + 1;
    if any( v(ind)~=v(1) & v(ind)~=v(end) )
        error('mbc:cgnormaliser:InvalidPropertyValue','Only values at the ends may be equal');
    end
end

