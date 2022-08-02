function varargout = compact( Tree, panel )
%XREGFITTREE/COMPACT Removes data from a tree object not required outide a build
%  COMPACT(T) Removes from the tree T all fileds and data not required for 
%  evaluation or driving the construction of other models. Spefically, this 
%  command removes the XData, YData, First, Last and Splitable fields. This is 
%  designed to be used after internal or external building. It can be useful 
%  when the regression tree is based on a large number of data points.
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $ 

Tree.XData     = [];
Tree.YData     = [];
Tree.First     = [];
Tree.Last      = [];
Tree.Splitable = [];

if nargout == 1
    varargout{1} = Tree;
elseif isvarname( inputname(1) ),
    assignin( 'caller', inputname(1), Tree );
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

