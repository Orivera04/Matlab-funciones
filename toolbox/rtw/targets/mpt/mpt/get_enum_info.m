function enumInfo = get_enum_info(objectType,enumType)
%GET_ENUM_INFO Gets information of enumType defined in data objects 
%
%   ENUMINFO = GET_ENUM_INFO(OBJECTTYPE, ENUMTYPE) 
%   This function is used to get information of enumType defined in MPT 
%   data objects or MPT derived data objects. 
%   INPUTS:
%         objectType: type of object, which can be either 'Parameter' or 
%                     'Signal'.    
%         enumType:   type of enumerition defined in parameter or signal
%                     object. 
%                     Valid values for enumType (case insensitive) are: 
%                          'UserDataType', 'UserObjectType', 
%                          'MemorySection', 'CustomstorageClass'
%                     The values above are used to get the following defined 
%                     enum types in core MPT are:
%                       'UserDataTypesParam', 'UserDataTypesSignal',
%                       'ObjectTypeParam', 'ObjectTypeSignal',
%                       'MemTypesParam', 'MemTypesSignal',
%                       'CustomParamStorageClassList',
%                       'CustomSignalStorageClassList'.
%                     In addition, user can get information of enumType 
%                     defined in MPT derived data objects through a special
%                     custom function called get_user_enum_info.
%         enumInfo:   a struct array return containing the following fields:
%                     Name: name of the enumType. 
%                     Strings: all the elements (in a cell array) in the 
%                              enumType list. 
%                     Values:  index corresponding to each element in
%                              Strings fiels, starting from 0, 1, 2, ....

%   Linghui Zhang
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $   $Date: 2003/09/26 14:16:19 $

enumInfo = '';
type ='';
if strcmp(objectType,'Parameter')
    switch lower(enumType)
        case 'userdatatype'
            type = findtype('UserDataTypesParam');
        case 'userobjecttype'
            type = findtype('ObjectTypeParam');
        case 'memorysection'
            type = findtype('MemTypesParam');
        case 'customstorageclass'
            type = findtype('CustomParamStorageClassList');
        otherwise
%             warning(['A EnumType named "', enumType,'" does not exist.']);
%             enumInfo = '';            
    end
elseif strcmp(objectType,'Signal')
    switch lower(enumType)
        case 'userdatatype'
            type = findtype('UserDataTypesSignal');
        case 'userobjecttype'
            type = findtype('ObjectTypeSignal');
        case 'memorysection'
            type = findtype('MemTypesSignal');
        case 'customstorageclass'
            type = findtype('CustomSignalStorageClassList');
        otherwise
%             warning(['A EnumType named "', enumType,'" does not exist.']);
%             enumInfo = '';
    end   
end
if isempty(type) == 0
     enumInfo = type.get;
 else
     enumInfo = '';
end
if exist('get_user_enum_info','file') == 2
     userEnumInfo = get_user_enum_info(objectType,enumType);
     if isempty(userEnumInfo) == 0
         enumInfo = userEnumInfo;
     end
end
