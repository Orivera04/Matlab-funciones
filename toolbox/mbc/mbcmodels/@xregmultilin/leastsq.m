function [mout,OK]= leastsq(m,varargin);
% xreglinear/LEASTSQ least squares estimate of model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:37 $


[mout,OK]= leastsq(get(m,'currentmodel'),varargin{:});
% change weights so 
n= get(m,'currentindex');
wts= zeros(1,get(m,'nmodels'));
wts(n)=1;
set(m,'weights',wts);
mout=set(m,'currentmodel',mout);