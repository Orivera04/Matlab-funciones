function ec_create_type_obj
%EC_CREATE_TYPE_OBJ is used to create alias type objects from mpt config.
%
% EC_CREATE_TYPE_OBJ prepares alias type objects for each of the mpt
% configuration user data type settings.

%   Steve Toeppe
%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  
%   $Date: 2004/04/01 16:13:21 $

try
    custom_user_type_registration;
catch
   errMsg = 'Error occurs in custom_user_type_registration.m'; 
   error([errMsg, sprintf('\n'),'    ',lasterr]);
end
userTypes = rtwprivate('rtwattic', 'AtticData', 'userTypes');
if isempty(userTypes) == 0
    for i=1:length(userTypes)
        try %handle (ignore) invalid user entry
            userTypeDepends{i} = userTypes{i}.userTypeDepend;
            aliasType = Simulink.AliasType;
            aliasType.HeaderFile = userTypes{i}.userTypeDepend;
            aliasType.BaseType  = base_to_sf_type(userTypes{i}.tmwName);
            assignin('base',userTypes{i}.userName,aliasType);
        catch
        end
    end
end

