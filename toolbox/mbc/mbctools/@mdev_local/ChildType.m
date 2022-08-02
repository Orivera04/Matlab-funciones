function [Type,ic]= ChildType(mdev,ind);
% MDEV_LOCAL/CHILDTYPE node type of child

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:03:58 $



if nargin>1 & ind==1 & RFstart(model(mdev))
   Type= 'Datum Model';
else
   Type= 'Response Feature';
end
if nargout>1
   ic=xregresload('newglobalmod.bmp','bmp');
end
