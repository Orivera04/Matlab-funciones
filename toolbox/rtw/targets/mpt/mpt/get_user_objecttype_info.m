function DTInfo = get_user_objecttype_info(userObjectType);
%GET_USER_OBJECTTYPE_INFO  Returns the user object type info
%
%    [DTINFO] = GET_USER_OBJECTTYPE_INFO(USEROBJECTTYPE)
%    This function returns a structure containing the information about
%    inquiring user object type.
%    Input:
%              userObjectType: Name of the user-defined object type
%    Output:
%              DTInfo:       A structure containing the information about
%                            inquiring object type.
%

%   Linghui Zhang
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/15 00:27:11 $
%


DTInfo = '';

userDTInfo = rtwprivate('rtwattic', 'AtticData', 'userDTInfo');
for i = 1:length(userDTInfo)
    if isequal(lower(userObjectType),lower(userDTInfo{i}.name)) == 1
        DTInfo = userDTInfo{i};
        break;
    end
end
return

           
           
