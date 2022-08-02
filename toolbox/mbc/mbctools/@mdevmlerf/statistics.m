function s= statistics(mdev);
%STATISTICS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.4 $  $Date: 2004/02/09 08:05:51 $





s= statistics(mdev.modeldev);
p= Parent(mdev);
TS= p.BestModel;
D= cov(TS);
ind= rfindex(mdev);



s= [s(1:3) sqrt(D(ind,ind))]; 
