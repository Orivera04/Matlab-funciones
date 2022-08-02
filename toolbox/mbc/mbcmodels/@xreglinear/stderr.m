function err=stderr(m)
%xreglinear/STDERR   Standard error calculation
%   e=STDERR(m) calculates the standard error of the jth coefficient
%   relative to RMSE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:50:14 $


x=eye(size(m.Store.R))/m.Store.R;

err=(sum(x.^2,2)).^0.5;


