function obj = updatenames(obj)
%UPDATENAMES Update the formula's variables
%
%  OBJ = UPDATENAMES(OBJ) updates the names of the variables in the formula
%  from the current names of the input value objects.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.2 $    $Date: 2004/02/09 07:16:04 $ 

if ~isempty(obj.EquationString)
    eqptrs = obj.EquationPointers;
    eqstr = obj.EquationString;
    sOldNames = obj.EquationInputs;
    sNewNames = cell(size(sOldNames));
    for n = 1:length(eqptrs)
        % get the alias this input has
        aliaslist = eqptrs(n).getaliaslist;
        % if the equation uses an alias, we'll keep the alias
        if ismember( sOldNames{n}, aliaslist )
            sNewNames{n} = sOldNames{n};
        else
            sNewNames{n} = eqptrs(n).getname;
        end
    end
    
    % convert from inline to sym
    sEq = sym(obj.EquationObject);
    % do the substitution(s)
    sEq = subs( sEq, sOldNames, sNewNames );
    % convert back to a string
    eqstr = char( sEq );

    % Create new equation objects
    eqobj = vectorize(inline(eqstr));
    inveqobj = createinverse(getname(obj), eqstr, sNewNames{obj.EquationVariableIndex});
    
    % Reorder pointers to match new argnames order
    [nul, idx] = sort(sNewNames);
    eqptrs = eqptrs(idx);
    
    [nul, idx] = sort(idx);
    obj.EquationVariableIndex = idx(obj.EquationVariableIndex);
    obj.EquationString = eqstr;
    obj.EquationInputs = argnames(eqobj);
    obj.EquationPointers = eqptrs;
    obj.EquationObject = eqobj;
    obj.InverseObject = inveqobj;
end