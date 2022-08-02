function paramValue = unifygetparam(object, paramName)
% Get parameter value of object

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:17 $

paramValue = '';
if isa(object, 'Stateflow.Data')
    if isprop(object, paramName)
        paramValue = getfield(object, paramName);   % Stateflow object
    elseif strcmpi(paramName, 'Type')
        paramValue = object.class;
    elseif strfind(paramName, '_')
        str = ['paramValue = object.' strrep(paramName, '_', '.') ';'];
        %paramValue = object.FixptType.BaseType;
        eval(str);
    end
else
    paramValue = get_param(object, paramName); % Simulink object
end