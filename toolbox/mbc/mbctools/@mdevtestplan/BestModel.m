function bm=BestModel(mdev,p,Climb);
% TESTPLAN/BESTMODEL
%
% bm= BestModel(mdev); returns 
% mdev= BestModel(mdev,p); 
%           p is pointer to modeldev object
%           assigns bestmodel to the model 
%           this copies model, statistics and outliers from p to mdev

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.4 $  $Date: 2004/04/04 03:31:27 $

if nargin==1
	bm=model(mdev);
else
   bm=mdev;
end
