function  custom_user_object_type_reg
%CUSTOM_USER_OBJECT_TYPE_REG Registers user-defined object types
% 
%   INPUT:
%             none
%   OUTPUT: 
%             none
%

%   Linghui Zhang
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $
%   $Date: 2003/07/22 21:13:08 $

init_user_objecttype_info; % Do not delete this function call.

%Regist user object types
if  exist('custom_user_object_type_info','file') == 2
    objectType = custom_user_object_type_info;
    for i = 1:length(objectType)
        set_user_objecttype_info(objectType{i});
    end                 
end

                   
