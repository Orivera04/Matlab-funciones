function userdata = getuserdata( Tree, panel )
%XREGFITTREE/GETUSERDATA Get a panel's user data
%  GETUSERDATA(T,PANEL) returns the user data for the given PANEL.
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

if isempty( Tree.UserData ),
    userdata = [];
else,
    userdata = Tree.UserData{panel};
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

