function [head,width]= colhead(mdev);
%COLHEAD

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.3 $  $Date: 2004/02/09 08:05:34 $



head= colhead(mdev.modeldev);
head= [head(1:3) {'RMSE'}];
width=   [35,30,25,35];
width= width/sum(width);
