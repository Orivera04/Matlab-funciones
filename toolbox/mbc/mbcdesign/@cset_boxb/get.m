function out=get(obj,param)
% GET Get candidate set parameters
%
%   DATA=GET(OBJ,PARAM)
%
%   PARAM may be one of:
%
%       Limits
%       NumCenter

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:59:54 $



switch lower(param)
case 'limits'
   out=num2cell(limits(obj.candidateset),2);
case 'numcenter'
   out=obj.Nc;

end
return
