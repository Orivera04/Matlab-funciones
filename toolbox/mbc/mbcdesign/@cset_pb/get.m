function out=get(obj,param)
% GET Get candidate set parameters
%
%   DATA=GET(OBJ,PARAM)
%
%   PARAM may be one of:
%
%       Runs

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:55 $



switch lower(param)
case 'runs'
   out=obj.Nr;
case 'limits'
   out=num2cell(limits(obj.candidateset),2);
end
return
