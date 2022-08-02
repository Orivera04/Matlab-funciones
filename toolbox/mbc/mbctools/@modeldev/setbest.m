function mdev= setBest(mdev,bm);
%SETBEST

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 08:10:55 $



mdev.BestModel= bm;
xregpointer(mdev);