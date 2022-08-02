function output = mpt_get_user_object_type_info(objectTypeName)
%MPT_GET_USER_OBJECT_TYPE  Returns user-defined object types
%
%   [OUTPUT] = MPT_GET_USER_OBJECT_TYPE(OBJECTTYPE)
%   This fucntion takes in the type of MPT object ('Signal', or 'Parameter') 
%   and returns the enumerated list user-defined object types for that MPT 
%   object type.  
%   INPUT:
%            objectType : Indicates the MPT object type ('Signal', or 'Parameter')
%   OUTPUT: 
%            output : The list of user-defined object typed
%

%   Linghui Zhang
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/15 00:27:34 $

custom_user_object_type_reg;
userDTInfo = rtwprivate('rtwattic', 'AtticData', 'userDTInfo');
output = '';
if isempty(userDTInfo) == 0
    param = '';
    signal ='';
    for i = 1:length(userDTInfo)
        if strcmp(userDTInfo{i}.name,objectTypeName)
            output = userDTInfo{i};
        end
    end

end
return
