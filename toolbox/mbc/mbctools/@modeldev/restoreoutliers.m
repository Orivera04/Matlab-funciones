function p=restoreoutliers(mdev,level,varargin)
% This function will restore all of the
% outliers that have been selected through#
% the 'diagnostic plots gui' for a given
% global model. 
%
% The syntax is simply:
%
% p = RESTOREOUTLIERS(mdev,level)
%
% where mdev is a MODELDEV object
% level is the level that you want to undo, 
% it can be 'single'or 'recursive',
% and p is a pointer object.
%
% If one selects the level to be single, the previous
% outlier index should be passed in as an
% extra argument.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:10:51 $

switch lower(level)
case 'recursive'
   % remove all selected outliers
   mdev.Outliers=[];
case 'single'
   mdev.Outliers= setdiff(mdev.Outliers,varargin{1});
end

% Refit model
[OK,mdev]= fitmodel(mdev);
	
% update the pointer object
p=pointer(mdev);
