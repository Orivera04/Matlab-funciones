function output = mpt_get_user_object_type(objectType)
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
%   $Revision: 1.1.6.3 $  $Date: 2004/04/15 00:27:33 $

custom_user_object_type_reg;
userDTInfo = rtwprivate('rtwattic', 'AtticData', 'userDTInfo');
output = '';
if isempty(userDTInfo) == 0
    param = '';
    signal ='';
    for i = 1:length(userDTInfo)
        switch lower(userDTInfo{i}.type)
            case 'both'
                param{end+1} = userDTInfo{i}.name;
                signal{end+1} = userDTInfo{i}.name;
            case 'parameter'
                param{end+1} = userDTInfo{i}.name;
            case 'signal'
                signal{end+1} = userDTInfo{i}.name;
            otherwise
                disp([' *** Warning: "',userDTInfo{i}.name,'" is invalid user-defined object type.']);
        end
    end
    if strcmp(objectType,'Parameter')
        output = sort(param);
    elseif strcmp(objectType,'Signal')
        output = sort(signal);
    end
end
return
