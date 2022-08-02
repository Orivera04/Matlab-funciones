function L= covmodel(L,newCov);
% LOCALMOD/COVMODEL extract and store covariance model for local model
%
% c= covmodel(L)        to get covmodel
% L= covmodel(L,newCov) to set covmodel

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:52 $

if nargin==1
   L= L.covmodel;
else
   L.covmodel= newCov;
end