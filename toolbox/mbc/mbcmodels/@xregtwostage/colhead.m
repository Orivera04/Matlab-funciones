function  [head,width]= colhead(m);
% TWOSTAGE/COLHEAD column headings for listview summary stats

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:59:26 $


if islinear(m)
	head= {'Local RMSE','Two-Stage RMSE','PRESS RMSE','Two-Stage T^2','-log L'};
	width=   [25,35,25,40,40];
else
	head= {'Local RMSE','Two-Stage RMSE','Two-Stage T^2','-log L'};
	width=   [25,35,35,40,40];
end

