function h = mbcuser
%MBCUSER Create an object that contains user information
%  
%   OBJ=MBCUSER  creates an object that contains user information for MBC.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 06:45:44 $


S=struct('username','',...
   'company','',...
   'department','',...
   'contact','',...
   'version',1);

h=class(S,'mbcuser');