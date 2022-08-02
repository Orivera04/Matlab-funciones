function mdev= upgradeGuids(mdev)
%MDEV_LOCAL/UPGRADETESTPLAN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.2.6.2 $  $Date: 2004/02/09 08:05:20 $

% get good fit data
[X,Y]= getdata(mdev);
[Xc,Yc,OK,BadData]=checkdata(model(mdev),X,Y);
Y(~BadData)= NaN;

% set response feature guids based on sweep guids of response
dguids= getSweepGuids(Y,'goodonly');
mdev.RFData.info= setGuids(mdev.RFData.info,dguids);


