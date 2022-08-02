function  [head,width]= colhead(m);
% NNMODEL/COLHEAD column headings for listview summary stats

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:56:16 $

%head  = {'MSE','R^2','F'};
head= {'Observations','Parameters', 'Box-Cox','RMSE', 'R^2'};
width = [35,35,25,40,40];
