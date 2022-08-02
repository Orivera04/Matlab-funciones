function unifysetparam(object, paramName, paramValue)
% Set parameter value of object

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:17 $

if isa(object, 'Stateflow.Data')
    if isprop(object, paramName)
        str = ['object.' paramName '=''' paramValue ''';'];
        eval(str);   % Stateflow object
    elseif strfind(paramName, '_')
        str = ['object.' strrep(paramName, '_', '.') '=''' paramValue ''';'];
        eval(str);
    else
    end
else
    set_param(object, paramName, paramValue); % Simulink object
end