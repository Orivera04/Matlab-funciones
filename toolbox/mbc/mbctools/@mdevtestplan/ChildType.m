function [Type,ic]= ChildType(mdev,ind);
% TESTPLAN/CHILDTYPE node type of child

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:07:02 $



Type= 'Response Model';
if nargout>1
   ic=xregresload('newrf.bmp','bmp');
end
