function strMatch = ac_get_type(typeName, referenceType, desiredType, option)
%AC_GET_TYPE returns a specific type name based upon requested information.
%
%   STRMATCH = AC_GET_TYPE(TYPENAME, REFERENCETYPE, DESIREDTYPE, OPTION)
%         Returns a specific data type name based upon the requested
%         information. The request can be made relative to either the user data
%         type name or MathWorks data type name.
%
%   INPUT:
%         typeName:      Type name that is under investigation
%         referenceType: Category of type name('userName','tmwName')
%                        that is of interest.
%         desiredType:   Category of type name('userName','tmwName')
%                        that is disired to be returned.
%         option:        Match categories ('All'...all or 'Primary'...only the
%                        primary usage of the user type).
%
%   OUTPUT:
%         strMatch:      Type name corresponding to selection criteria. Empty
%                        indicates no match.


%   Steve Toeppe
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.8.4.4 $  
%   $Date: 2004/04/15 00:26:35 $



userTypes = rtwprivate('rtwattic', 'AtticData', 'userTypes');

strMatch = '';

switch(referenceType)
case {'userName','tmwName'}
otherwise
    disp('ac_get_type invalid referenceType name');
    return;
end

switch(desiredType)
case {'userName','tmwName'}
otherwise
    disp('ac_get_type invalid desiredType name');
    return;
end

switch(option)
case 'all'
    for i=1:length(userTypes)
    name = getfield(userTypes{i},referenceType);
    if strcmp(name,typeName) == 1
       strMatch{end+1} = getfield(userTypes{i},desiredType);
    end
end
case 'primary'
    for i=1:length(userTypes)
    name = getfield(userTypes{i},referenceType);
    if strcmp(name,typeName) == 1
        if strcmp(userTypes{i}.primaryUserName,'primary') == 1
            strMatch = getfield(userTypes{i},desiredType);
            break;
        end
    end
end
case 'depend'
    for i=1:length(userTypes)
        name = getfield(userTypes{i},referenceType);
        if strcmp(name,typeName) == 1
            strMatch = getfield(userTypes{i},'userTypeDepend');
            break;
        end
    end
otherwise 
end