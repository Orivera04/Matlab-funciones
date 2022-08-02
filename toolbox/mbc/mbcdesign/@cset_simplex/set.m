function obj=set(obj,param,data)
% SET Set candidate set parameters
%
%   OBJ=SET(OBJ,PARAM,DATA)
%
%   PARAM may be one of:
%
%       Limits   :  cell array of [min max] values
%       NumCenter:  number of center points

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:31 $


switch lower(param)
case 'limits'
   lims=cat(1,data{:});
   obj.candidateset=limits(obj.candidateset,lims);
case 'numcenter'
   if data>=0
      obj.Nc=data;
   end
end
return
