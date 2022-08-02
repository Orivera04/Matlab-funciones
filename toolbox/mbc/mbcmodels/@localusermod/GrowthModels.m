function [varargout]= GrowthModels(L);
% LOCALUSERMOD/GROWTHMODELS list of growth models
% 
% GList= GrowthModels(L);
% [GList,DisplayList]= GrowthModels(L);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:35 $



[varargout{1:nargout}]= GrowthModels(L.userdefined);