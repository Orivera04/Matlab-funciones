function ind= rfindex(mdev);
%RFINDEX

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 08:05:48 $



p= Parent(mdev);
ind= p.ResponseFeatures+RFstart(p.model);
ind= find(ind(1,:)==childindex(mdev));
