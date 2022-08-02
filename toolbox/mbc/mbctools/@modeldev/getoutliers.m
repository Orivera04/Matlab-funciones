function [bdX,bdY,tn,bdind]= getoutliers(md)
% MODELDEV/GETOUTLIERS -  get back information about outliers.
% 
% [bdX,bdY,tn,dI]= getoutliers(md)
% 
% bdX   -  bad x data
% bdY   -  bad Y data
% tn    -  bad testnumbers
% bdind -  bad data index

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:21 $

% get all the data
[Xs,Y] = getdata(md,'X',0);
X= double(Xs);
Y= double(Y);
%get the bad data
bdind= outliers(md);
bdY= Y(bdind);
bdX= X(bdind,:);

% get the testnumbers
if size(Xs,1)==size(Xs,3)
   tn= testnum(Xs);
else
   tn= 1:size(Xs,1);
end
tn= tn(bdind)';

