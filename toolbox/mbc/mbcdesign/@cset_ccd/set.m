function obj=set(obj,param,data)
% SET Set candidate set parameters
%
%   OBJ=SET(OBJ,PARAM,DATA)
%
%   PARAM may be one of:
%
%       Limits   :  cell array of [min max] values
%       NumCenter:  number of center points
%       Alpha    :  vector of alpha values for each dim
%       Inscribe :  on/off

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:00:17 $

% Created 15/11/2000


switch lower(param)
case 'limits'
   lims=cat(1,data{:});
   obj.candidateset=limits(obj.candidateset,lims);
case 'numcenter'
   if data>=0
      obj.Nc=data;
   end
case 'alpha'
   nf=nfactors(obj.candidateset);
   if all(data>=1) & length(data)==nf
      obj.Alpha=data;
   end
case 'inscribe'
   if strcmp(data,'on');
      obj.inscribe=1;
   else
      obj.inscribe=0;
   end
end
return
