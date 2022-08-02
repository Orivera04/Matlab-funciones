function dim = getsplitdim( Tree, panel )
%XREGFITTREE/GETSPLITDIM Get the split dimension for a panel. 
%  GETSPLITDIM(T,PANEL) returns the index of the dimension that PANEL was split 
%  along. 
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

dim = Tree.SplitDim(panel);

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
