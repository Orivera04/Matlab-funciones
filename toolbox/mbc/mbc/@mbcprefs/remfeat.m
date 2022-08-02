function flg=remfeat(p,feat)
%REMFEAT  Remove a feature
%   
%   REMFEAT(P,FEAT) removes the feature FEAT from the
%   preferences object.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:45:16 $

% Created 16/6/2000

pr_datastore('remfeat',feat);
return
