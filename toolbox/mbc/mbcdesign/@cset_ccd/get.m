function out=get(obj,param)
% GET Get candidate set parameters
%
%   DATA=GET(OBJ,PARAM)
%
%   PARAM may be one of:
%
%       Limits
%       NumCenter
%       Alpha
%       Inscribe
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:00:11 $

% Created 15/11/2000


switch lower(param)
case 'limits'
   out=num2cell(limits(obj.candidateset),2);
case 'numcenter'
   out=obj.Nc;
case 'alpha'
   out=obj.Alpha;
case 'inscribe'
   if obj.inscribe
      out='on';
   else
      out='off';
   end
end
return
