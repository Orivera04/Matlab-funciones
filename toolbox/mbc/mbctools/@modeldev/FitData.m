function [X,Y,DataOK]= FitData(mdev);
% MODELDEV/

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:09:34 $

% get data with outliers 
[X,Y]= getdata(mdev,'X',1);

% find good data
[Xc,Yc,DataOK]=checkdata(model(mdev),X,Y);

% get with no outliers
[X,Y]= getdata(mdev,'X',0);
