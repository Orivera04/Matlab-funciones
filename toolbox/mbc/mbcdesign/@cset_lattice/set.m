function obj=set(obj,param,data)
% SET Set candidate set parameters
%
%   OBJ=SET(OBJ,PARAM,DATA)
%
%   PARAM may be one of:
%
%       Limits: Cell array of [Min Max] values
%       g     : Vector of prime generator numbers
%       N     : Number of points
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:07 $

% Created 1/11/2000


switch lower(param)
case 'limits'
   lims=cat(1,data{:});
   obj.candidateset=limits(obj.candidateset,lims);
case 'g'
   if all(isprime(data))
      obj.g=data;
   end
case 'n'
   obj.N=data;
end
return
