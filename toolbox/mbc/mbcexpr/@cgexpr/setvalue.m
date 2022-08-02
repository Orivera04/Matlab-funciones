function [ptr,OK, msg] = setvalue(E,val,ptr);
%SETVALUE Attempt to set input value 
%
%  [ptr,OK, msg] = setvalue(E,val)
%  [ptr,OK, msg] = setvalue(E,val,ptr)
%  Set the output value of the expression E to be val, by adjusting the values in ptr. 
%  ptr must point to a value expression, and must be in getptrs of E.
%
%  If ptr is not supplied, then the first vector input to expression will be used (and returned in ptr).  
%
%  The inversion of the expression is performed by solve. 
%
%  OK is 0 or 1
%  msg is '' if OK is 1 and an error message otherwise

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:09:50 $

if nargin<2
    error('setvalue: not enough input arguments');
end
if nargin<3
    ptr = [];
end

if ~isnumeric(val) 
    OK = 0;
    msg = 'setvalue: val must be numeric';
    return
end

if ~isempty(ptr)
    %given ptr - check it's okay
    e_ptrs = getptrs(E);
    if ~isa(ptr,'xregpointer') | length(ptr)>1 | ~isvalid(ptr) | ~isinport(ptr.info)
        OK = 0;
        msg = 'setvalue: ptr must be valid xregpointer to a value expression.';
        return
    end
    if ~ismember(double(e_ptrs),double(ptr))
        OK = 0;
        msg = 'setvalue: cgexpr must be dependent on ptr';
        return
    end
else % find a good pointer to use
    [ptr,OK, msg] = FindVector(E);
    if ~OK 
        if isempty(ptr)
            msg = ['Problem in setvalue. ' msg]; 
            return
        else % have a pointer, but just to a constant value
            if length(val) == 1 % can still continue 
                OK = 1;
            else
                msg = ['Problem in setvalue. ' msg]; 
                return
            end   
        end
    end
end


% make a value expression from val 
cgval = cgvalue('tmpval',val); 

% rearrange E = val to make ptr the subject of the equation 
[pexpr, rhsexpr, problem, PtrCreated] = solve(E,cgval,ptr);

if ~problem % set the values of ptr
    OK = 1;
    msg = '';
    ptr.info = ptr.set('value',rhsexpr.eval);
    
elseif ~isempty(pexpr) % if we have returned a partial solve
    oldval = get(ptr.info,'value');
    %set the value by a direct search (a bit dodgy)
    tol = 1e-4;
    range = ptr.get('range');
    newvals = []; 
    IndValSet = [];% list of indices of values set   
    current = eval(E);
    exitflag = ones(size(current));
    for i = 1:length(current)
        % are any of the current values close enough to any elements in v
        f = find(abs(val - current(i)) < tol);  
        newvals(f) = oldval(i);
        if ~isempty(range) & (oldval(i)<range(1) | oldval(i)>range(2))
            exitflag(f) = -1;
        end
        IndValSet = [IndValSet f];
    end
    
    options = optimset('display','off');
    do_i = setdiff(1:length(val),IndValSet);  %only do those values we don't have
    for i = do_i
        if ~isempty(range)
            x0 = range;%pass range
        else
            x0 = val(i);%dummy initial value
        end
        try
            [newvals(i),f,exitflag(i)] = fzero(@i_search,x0,options,E,ptr,val(i));
        catch
            newvals(i) = 0;  
            exitflag(i) = -1;
        end
    end
    
    if any(exitflag<0)
        OK = 0;
        msg = ['Problem setting value of ' getname(E) '.'];
    else
        OK =1;
        msg = '';
        % set the value of ptr.info
        ptr.info = set(ptr.info,'value',newvals);
    end
else 
    OK = 0;
    msg = ['Problem setting value of ' getname(E) '. ' problem];
end

freeptr([cgval PtrCreated]);	


% ----------------------------- %
% Function for using with fzero %
% ----------------------------- %
function d = i_search(x,cgexpr,ptr,val)
ptr.info = set(ptr.info,'value',x);
result = eval(cgexpr);
d = result - val;
if length(d)>1
    d = sum(abs(d));
end