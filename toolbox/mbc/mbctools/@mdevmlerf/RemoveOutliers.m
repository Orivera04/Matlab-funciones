function mdev= RemoveOutliers(mdev,SelectionCriteria);
%RemoveOutliers refit models after removing outliers 
%
%mdev= RemoveOutliers(mdev,SelectionCriteria);
% Inputs
%   SelectionCriteria  outlier selection rule or indices of points to 
%                      remove
% 
% Indices= func(model, data, factorName); 
%   The factors are the same as appear in the scatter plot in the model
%   browser. 
%   'data' contains the factors as columns of a matrix
%   'factorNames' is a cell array of the names for each factor

% Note it is also possible to use a specical array to do standard types of
% outlier removal (available from popmenus in model browser dialog). This
% option is not documented because of its complexity

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:05:30 $


error('mbc:mdevmlerf:InvalidState','Outliers cannot be removed from MLE Response Features')

    
    
    