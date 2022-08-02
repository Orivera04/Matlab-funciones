function mdev= ADDOUTLIERS(mdev,SNo,r);
% MDEV_LOCAL/ADDOUTLIERS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:04:20 $

if islogical(r)
   r= find(r);
end

L= model(mdev);
[X,Y]= getdata(mdev);
[Xs,Ys,ok,badIndex]= checkdata(L,X(:,:,SNo),Y(:,:,SNo));
% data already not flagged bad for Y
f= find(~badIndex); 

% only 'good' data is displayed in RegPlots
% so index to outliers from RegPlot (ud.index) needs to be
% refenced to good data index,
r= f(r);

% calculates the index wrt all sweeps
Spos   = tstart(Y);
RecInd = Spos(SNo) + r-1;

RecInd= [outliers(mdev);RecInd(:)];

mdev= ApplyOutliers(mdev,SNo,RecInd);

% Update Heap copy of mdev
p=pointer(mdev);
