function width = getwidth( Tree, panel )
%XREGFITTREE/GETWIDTH Get the half-width of a given panel
%  GETWIDTH(T,PANEL) returns the half-width of the given PANEL. 
%  GETWIDTH(T) returns a list of all the half-widths of the tree T. 
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

if nargin == 1,
    width = Tree.HalfWidth;
else,
    width = Tree.HalfWidth(panel,:);
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

