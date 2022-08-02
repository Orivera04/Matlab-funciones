function varargout = setuserdata( Tree, panel, userdata )
%XREGFITTREE/SETUSERDATA Set a panel's user data
%  SETUSERDATA(T,PANEL) sets the user data for the given PANEL.
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

if isempty( Tree.UserData ),
    Tree.UserData = cell( size( Tree.Parent ) );
end
Tree.UserData{panel} = userdata;


if nargout == 1
    varargout{1} = Tree;
elseif isvarname( inputname(1) ),
    assignin( 'caller', inputname(1), Tree );
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

