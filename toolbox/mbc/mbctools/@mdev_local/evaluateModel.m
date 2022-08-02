function p= evaluateModel(mdev,mbH);
%EVALUATEMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:31:14 $

chH= [];

hFig= double(mbH.Figure);
p= mbH.CurrentNode;

if p.hasBest
    %% have a twostage model so show this
    TS = p.BestModel;
    chH= Validate_Indpt('create',p,hFig,TS);

else %% don't have a twostage so do local model
    d = mbH.GetViewData;
    L = p.LocalModel(d.SweepPos);
    chH= Validate_Indpt('create',p,hFig,L);

end

%% register sub figure
if ishandle(chH)
    mbH.RegisterSubFigure(chH);
end

