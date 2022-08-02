function obj = initfromapp(obj)
%INITFROMAPP  Initialise object with information about application
%
%  OBJ = INITFROMAPP(OBJ) sets the object fields with information that is
%  appropriate for the "application" user, i.e. username = 'mbc', etc
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 06:45:41 $

obj.username   = 'MBC Toolbox';
obj.company    = '';
obj.department = '';
obj.contact    = '';