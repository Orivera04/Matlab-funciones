function f=cgsymvalue(name)
% CGSYMVALUE/CGSYMVALUE Constructor for the cgsymvalue class
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:15:22 $


if nargin > 0
    if isstruct(name)
        f = name;
        v = name.cgvalue;
        f = mv_rmfield(f, 'cgvalue');
    else
        [f,v] = i_defaultobject;
        v = setname(v, name);
    end
else
    [f,v] = i_defaultobject;
end
f = class(f , 'cgsymvalue', v);





function[f, v] = i_defaultobject

f = struct('EquationString','', ...
    'EquationPointers', assign(xregpointer, []),...
    'EquationInputs', {{}}, ...
    'EquationVariableIndex', 0, ...
    'EquationObject', [], ...
    'InverseObject', [], ...
    'version', 2);
v = cgvalue;