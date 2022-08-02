function out=get(obj,param)
% GET Get candidate set parameters
%
%   DATA=GET(OBJ,PARAM)
%
%   PARAM may be one of:
%
%       Limits
%       g
%       N
%       Nlevels
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:17 $

% Created 12/3/2001


switch lower(param)
case 'limits'
   out=num2cell(limits(obj.candidateset),2)';
case 'g'
   out=obj.g;
case 'n'
   out=obj.N;
case 'nlevels'
   out=obj.Nlevels;
end
return