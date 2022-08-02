function  [head,width]= colhead(m);
% MODEL/COLHEAD column headings for listview summary stats

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:58:18 $

head  = {'Observations','Parameters','Box-Cox','RMSE','Knots','log10(GCV)'};
width = [30,25,20,25,20,25];
