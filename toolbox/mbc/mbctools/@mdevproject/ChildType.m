function [Type,ic]= ChildType(mdev,ind);
% TESTPLAN/CHILDTYPE node type of child

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:03:09 $



Type= 'Test Plan';
if nargout>1
   ic=xregresload('newtestplan.bmp','bmp');
end