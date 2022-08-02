function sendtoprefs( obj )
%SENDTOPREFS  Set user information preferences from object
%
%  SENDTOPREFS(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 06:45:45 $



S=getpref(mbcprefs('mbc'),'UserInfo');

S.Name = obj.username;
S.Company = obj.company;
S.Department = obj.department;
S.ContactInfo = obj.contact;

setpref(mbcprefs('mbc'),'UserInfo',S);