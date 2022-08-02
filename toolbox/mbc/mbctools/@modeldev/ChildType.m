function [Type,ic]= ChildType(mdev,ind);
% MODELDEV/CHILDTYPE node type of child

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:09:25 $



if isa(mdev.Model,'xregtwostage')
   Type= 'Local Model';
   if nargout>1
      ic=xregresload('newlocalmod.bmp','bmp');
   end
else
   Type= 'Model';
   if nargout>1
      ic=xregresload('newglobalmod.bmp','bmp');
   end
end