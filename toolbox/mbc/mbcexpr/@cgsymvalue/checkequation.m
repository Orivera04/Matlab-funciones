function  [flags, msg] = checkequation(obj, eqstr, pDD)
%CHECKEQUATION Check an equation string
%
%  [FLAGS, MSG] = CHECKEQUATION(OBJ, EQUATION, PDD) performs a series of
%  tests on the given equation string and returns a vector of flags to
%  indicate the return status of each one.  MSG is a cell array of message
%  strings describing the problems encountered.  Where possible, the
%  checking will still continue to other tests if an earlier one fails.
%
%  The FLAGS output is a boolean vector where a false entry means that the
%  equation string failed that test.  The entries correspond to the
%  following tests:
%
%  1. Must contain exactly one variable input
%  2. Must not contain any inputs that are not variable/constants
%  3. Must not contain a reference to this formula object
%  4. Must be a valid formula that can be evaluated
%  5. Must be soluble

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:15:23 $ 

msg = {};
flags = true(1,5);

% get input names in string
sInputs = symvar(eqstr);

[nVar, nConst, nOther, nToMake] = i_CountVarTypes(sInputs, pDD);

flags(1) = (nVar == 1) || ((nVar == 0) && (nToMake > 0));
flags(2) = (nOther == 0);
flags(3) = ~any(strcmp(sInputs, getname(obj)));

% Create an inline function for evaluating the formula

try
    eqobj = vectorize(inline(eqstr));
    nargs = nargin(eqobj);
    x = repmat({12345}, 1, nargs);
    eqobj(x{:});
catch
    flags(4) = false;
end

try
    sInputs = argnames(eqobj);
    % invert the equation now ready for later usage
    syminv = solve([getname(obj) ' = ', eqstr], sInputs{1});
catch
    flags(5) = false;
end


if ~flags(1)
    msg = [msg; {'A formula must have one variable as an input'}];
end
if ~flags(2)
    msg = [msg; {'A formula must only have a variable and constants as inputs'}];
end
if ~flags(3)
    msg = [msg; {'A formula must not have itself as an input'}];
end
if ~flags(4)
    msg = [msg; {'Unable to evaluate formula'}];
end
if ~flags(5)
    msg = [msg; {'Unable to solve inverse of formula'}];
end


function [nVar, nConst, nOther, nToMake] = i_CountVarTypes(str, pDD)

nVar = 0;
nConst = 0;
nOther = 0;
nToMake = 0;

% Loop over each input name and look for it as a variable/constant, or as
% some other object in this variable dictionary's project
nItems = length(str);
pItems = assign(xregpointer, zeros(1, nItems));
ptrs = pDD.find(str);
if iscell(ptrs)
    found = ~cellfun('isempty', ptrs);
    pItems(found) = [ptrs{found}];
else
    if ~isempty(ptrs)
        pItems = ptrs;
    end
end
pProj = address(pDD.project);
for n =1:nItems
    if pItems(n)==0
        if ~pProj.isuniquename(str{n})
            nOther = nOther + 1;
        else
            nToMake = nToMake + 1;
        end
    elseif ~ismember(pItems(n), pItems(1:n-1))
        % Only look at the pointer if it is not a duplicate (alias)
        if pItems(n).isconstant
            nConst = nConst + 1;
        elseif pItems(n).issymvalue
            nOther = nOther + 1;
        else
            nVar = nVar+ + 1;
        end
    end
end