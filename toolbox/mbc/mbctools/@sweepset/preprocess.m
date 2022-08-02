function [x,y]=preprocess(x,y)
% this function takes in data i nthe form of SweepSets
% and will do the following:
%
% shift x, so that we have no -ve values 
% shift y, so that we have no -ve values
% sort the data.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:06:44 $

% Check to see if X and Y are the same length
if size(x,3)~=size(y,3)
   error('Sweeps must be the same length');
   return
end

% Positive values only
x(y<0)=NaN;
y(y<0)=NaN;
y(x<0)=NaN;
x(x<0)=NaN;

% remove bad sweeps
x=x(~isbad(y));
y=y(~isbad(y));

% choose sweeps with > 4 data points
tstartx=tstart(x);
index=diff(tstartx)<5;
index(end+1)=(size(x,1)-tstartx(end))<5;
x(:,:,index)=NaN;
y(:,:,index)=NaN;

% remove bad sweeps
x=x(~isbad(y));
y=y(~isbad(y));
