function out=get(obj,param)
% GET Get candidate set parameters
%
%   DATA=GET(OBJ,PARAM)
%
%   PARAM may be one of:
%
%       Limits
%       CostMethod
%       OptimMethod
%       N
%       doRecalc
%       showgui
%       stratifyLevels
%       symmetric
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:00:43 $

% Created 1/11/2000


switch lower(param)
case 'limits'
   out=num2cell(limits(obj.candidateset),2)';
case 'costmethod'
   out=obj.alg;
case 'optimmethod'
   out=obj.optimalg;
case 'n'
   out=obj.N;
case 'dorecalc'
   out=obj.doRecalc;
case 'showgui'
   out=obj.guiflag;
case 'stratifylevels'
   out=obj.stratify;
case 'symmetric'
   out=obj.symmetry;
case 'exactlevels'
   out=obj.stratify_levels;
end
return