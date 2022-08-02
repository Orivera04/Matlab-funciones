function obj = initfromguiobject(obj,H)
%INITFROMGUIOBJECT  Take new settings from a user information GUI
%
%  OBJ = INITFROMGUIOBJECT(OBJ,HGUI)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 06:45:42 $


S=H.userinfo;

obj.username   = S.nm;
obj.company    = S.company;
obj.department = S.dept;
obj.contact    = S.contact;