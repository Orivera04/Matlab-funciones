function out=get(obj,param)
% GET Get candidate set parameters
%
%   DATA=GET(OBJ,PARAM)
%
%   PARAM may be one of:
%
%       Limits
%       NumCenter
%       NLevels
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:22 $

% Created 30/12/2000


switch lower(param)
case 'limits'
   out=num2cell(limits(obj.candidateset),2);
case 'numcenter'
   out=obj.Nc;
case 'nlevels'
   out=cellfun('length',get(obj.grid,'levels'));
end
return
