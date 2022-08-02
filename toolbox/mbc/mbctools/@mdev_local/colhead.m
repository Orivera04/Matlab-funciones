function  [head,width]= colhead(mdev);
%COLHEAD

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:04:23 $



m= children(mdev,'BestModel');
isL= 1;
for i=1:length(m)
	isL= isL & islinear(m{i});
end

if isL
   head= {'Local RMSE','Two-Stage RMSE','PRESS RMSE','Two-Stage T^2','-log L'};
   width= [25,35,30,35,25];
else
   head= {'Local RMSE','Two-Stage RMSE','Two-Stage T^2','-log L'};
   width= [20,25,30,20];
end
width= width/sum(width);
