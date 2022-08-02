function panels = getchildless( Tree )
%XREGFITTREE/GETCHILDLESS Gets list of panels that do not have children
%  GETCHILDLESS(T) is a list of panels in the tree T that do not have children.
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 


panels = find( all( Tree.Children == 0, 2 ) );

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
