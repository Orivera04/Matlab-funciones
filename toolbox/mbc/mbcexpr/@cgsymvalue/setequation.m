function [obj, flags, msg, newptrs] = setequation(obj, eqstr, pDD)
%SETEQUATION Set an equation string
%
%  [OBJ, FLAGS, MSG, NEWPTRS] = SETEQUATION(OBJ, EQUATION, PDD)
%
%  EQUATION is a string, e.g. 'x+k'.  PDD is a pointer to a Variable
%  Dictionary that will provide the values for the equation
%
%  FLAGS and MSG are the return arguments from running CHECKEQUATION on the
%  object.  See CHECKEQUATION for more details of their meaning.  If any of
%  FLAGS are false, the equation is not set in the object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.2 $    $Date: 2004/02/09 07:15:59 $ 

newptrs = assign(xregpointer, []);
[flags, msg] = checkequation(obj, eqstr, pDD);
if ~all(flags)
    return
end

% Create an inline function for evaluating the formula
eqobj = vectorize(inline(eqstr));
sInputs = argnames(eqobj);
nInputs = length(sInputs);
eqptrs = assign(xregpointer, zeros(1, nInputs));

% look for the inputs in the variable dictionary
ptr_cell = pDD.find(sInputs);
if ~iscell(ptr_cell)
    ptr_cell = {ptr_cell};
end
VAR_FOUND = false;
eqvarindex = 0;
nToCreate = 0;
for n = 1:nInputs
    if ~isempty(ptr_cell{n})
        eqptrs(n) = ptr_cell{n};
        valobj = eqptrs(n).info;
        if ~isconstant(valobj)
            VAR_FOUND = true;
            eqvarindex = n;
        end
    else
        nToCreate = nToCreate + 1;
    end
end

% Create new variables
if nToCreate
    for n = find(eqptrs==0)
        if ~VAR_FOUND
            % Make a variable
            VAR_FOUND = true;
            eqvarindex = n;
            eqptrs(n) = cgvalue(sInputs{n});
            newptrs = [newptrs eqptrs(n)];
        else
            % Make a constant
            const = cgconstvalue;
            const = setname(const, sInputs{n});
            eqptrs(n) = xregpointer(const);
            newptrs = [newptrs eqptrs(n)];
        end
        pDD.add(eqptrs(n));
    end
end

inveqobj = createinverse(getname(obj), eqstr, sInputs{eqvarindex});

obj.EquationString = eqstr;
obj.EquationInputs = sInputs(:)';
obj.EquationPointers = eqptrs;
obj.EquationVariableIndex = eqvarindex;
obj.EquationObject = eqobj;
obj.InverseObject = inveqobj;