function OK= InitModel(mdev)
%MODELDEV/INITMODEL initialise store for model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:09:35 $

[X,Y]= getdata(mdev);

doRinvCalc= isempty(var(mdev.Model));
[mdev.Model,OK]= InitModel(mdev.Model,X,Y,[],false,doRinvCalc);

pointer(mdev);
