function [w,bnds]= mixed(c,yhat,varargin);
% COVMODEL/MIXED

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:46:24 $



if nargin==1
   w= [1 .5];
   bnds= [0 Inf;0 Inf];
else
   w= c.wparam(1) + abs(yhat).^(2*c.wparam(2));
end
