function L=exportmodel(mdev,View,allFlag);
%% L=exportmodel(mdev,View,allFlag)
%% allFlag = 'all' returns cell array of all local models 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:04:30 $



if nargin<3 |~strcmp(allFlag,'all')
    SNo= View.SweepPos;
    L= LocalModel(mdev,SNo);
    Xf= getdata(mdev);
    tn= testnum(Xf);
    L= varname(L,sprintf('%s_%d',varname(L),tn(SNo)));
elseif strcmp(allFlag,'all')
    L= AllLocalModels(mdev,0);
 end
