function center = getcenter( Tree, panel )
%XREGFITTREE/GETCENTER Get the coordinates of the center of a given panel
%  GETCENTER(T,PANEL) returns the coordinates of the center of the given PANEL. 
%  GETCENTER(T) returns a list of all the centera of the tree T. 
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 


if nargin == 1,
    center = Tree.Center;
else,
    center = Tree.Center(panel,:);
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

