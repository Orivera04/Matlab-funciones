function obj=set(obj,param,data)
% SET Set candidate set parameters
%
%   OBJ=SET(OBJ,PARAM,DATA)
%
%   PARAM may be one of:
%
%       Data: N*nf matrix of data points.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:10 $

% Created 2/11/2000


switch lower(param)
case 'data'
  obj.data=data;
end
return
