function varargout=valdata(mdev,varargin);
% MODELDEV/VALDATA independent validation data

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:11:04 $

if nargin>1
   mdev.Validation= varargin;
   pointer(mdev);
   varargout{1}= mdev;
else
   varargout= mdev.Validation;
end