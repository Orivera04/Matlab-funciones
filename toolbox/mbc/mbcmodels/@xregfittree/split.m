function varargout = split( Tree, panel, splitDim, splitPoint, PanelSize )
%XREGFITTREE/SPLIT  Build a regression tree for RBF fitting
%  TREE = SPLIT(TREE,PANEL,DIM,POINT,SIZE) splits the PANEL along the given 
%  dimension, DIM, at the given POINT or at the center of the panel if 
%  POINT == 'Center'. The half-widhts of the child panels are determined 
%  according to SIZE. This is the same as the 'PanelSize' option for BUILD.
%
%  See also XREGFITTREE, XREGFITTREE\PRESPLIT, XREGFITTREE\POSTSPLIT.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

data = presplit( Tree, panel, splitDim, splitPoint, PanelSize );
Tree = postsplit( Tree, data );

if nargout == 1
    varargout{1} = Tree;
elseif isvarname( inputname(1) ),
    assignin( 'caller', inputname(1), Tree );
end

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

