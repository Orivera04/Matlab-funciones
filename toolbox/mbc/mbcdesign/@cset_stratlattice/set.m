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
%       Nlevels: Vector of number of stratified levels.
%                A zero => do not stratify dimension.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:01:38 $

% Created 12/3/2001


switch lower(param)
case 'limits'
   lims=cat(1,data{:});
   obj.candidateset=limits(obj.candidateset,lims);
case 'g'
   % just check the g values on non-stratified dimensions
   if all(isprime(data(~obj.Nlevels)))
      obj.g=data;
   end
   obj=doRealGCalc(obj);
case 'nlevels'
   strat= data~=0;
   if length(data(strat))==length(unique(data(strat)))
      obj.Nlevels=data;
   end
   obj=doRealGCalc(obj);
case 'n'
   obj.N=data;
   obj=doRealGCalc(obj);
end
return