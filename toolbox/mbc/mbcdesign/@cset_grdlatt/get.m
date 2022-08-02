function out=get(obj,param)
% GET Get candidate set parameters
%
%   DATA=GET(OBJ,PARAM)
%
%   PARAM may be one of:
%
%       Levels
%       Limits
%       g
%       N
%       griddims
%       latticedims

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:33 $

% Created 2/11/2000


switch lower(param)
case 'levels'
   out=get(obj.grid,'levels');
case 'g'
   out=get(obj.lattice,'g');
case 'n'
   out=get(obj.lattice,'N');
case 'limits'
   % lattice limits only
   out=get(obj.lattice,'limits');
case 'griddims'
   out=obj.griddims;
case 'latticedims'
   out=obj.lattdims;
end
return