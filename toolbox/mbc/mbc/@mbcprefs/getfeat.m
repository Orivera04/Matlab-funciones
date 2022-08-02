function data=getfeat(p,feat)
% GETPREF  Get the data from preference field
%
%   DATA=GETPREF(P,FEAT) gets the data from the entry
%   FEAT in the current preference set.
%   If there is no such feature, an error is issued.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:44:54 $

% Created 16/6/2000

data = pr_datastore('getfeat',feat);