function obj = initfromprefs( obj )
%INITFROMPREFS  Initialise object with information from preferences
%
%  OBJ = INITFROMPREFS(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 06:45:43 $


S=getpref(mbcprefs('mbc'),'UserInfo');

obj.username   = S.Name;
obj.company    = S.Company;
obj.department = S.Department;
obj.contact    = S.ContactInfo;