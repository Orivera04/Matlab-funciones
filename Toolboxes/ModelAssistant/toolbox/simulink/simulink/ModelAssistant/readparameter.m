function value = readparameter(model, paramName)

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:16 $

[category, paramName] = strtok(paramName, '_');
paramName = paramName(2:end);
fp = get_param(model, 'ObjectParameters');
if isfield(fp, paramName)
    value = get_param(model, paramName);
else
   [category, paramName] = strtok(paramName, '_');
   paramName = paramName(2:end);
   if strcmpi(category, 'rtwoption')  % support for rtwoption sub category
       value = getrtwoption(model, paramName);
   elseif strcmpi(category, 'stateflow')
       value = stateflowsettings('get', getfullname(model), paramName);
       if isempty(value)
           value = 'We_Can_Not_Find_The_Value';
       end
   elseif strcmpi(category, 'makecmdption')
       value = getrtwmakecmd(model, paramName);
   else
       value = 'We_Can_Not_Find_The_Value';
   end
end