function obj=doRealGCalc(obj)
% DOREALGCALC   Recalculate internal data
%
%  obj=doRealGCalc(obj)
%
%  This is an internal function for recalculating data
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:01:36 $

% Created 12/3/2001

RealG= obj.g;
stratL= obj.Nlevels~=0;
RealG(stratL)= obj.N./obj.Nlevels(stratL);
obj.RealG= RealG;
obj.ScaleFudge= ones(size(obj.g));
obj.ScaleFudge(stratL)= obj.RealG(stratL);