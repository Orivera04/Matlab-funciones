function p= evaluateModel(mdev,mbH);
%EVALUATEMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:31:51 $

chH= [];

hFig= double(mbH.Figure);
p= mbH.CurrentNode;

switch mdev.ViewIndex
case 'global'
   G = p.model;
   chH= Validate_Indpt('create',p,hFig,G);
   
case 'twostage'
   if p.hasBest %% there is a TS at the response node
      TS = p.model;
      chH= Validate_Indpt('create',p,hFig,TS);
   else %% should not get here if menu is disabled properly!!
      errordlg('You must choose a best twostage model first.',...
         'Evaluation Error','modal');
   end
   
end

%% register sub figure
if ishandle(chH)
   mbH.RegisterSubFigure(chH);
end

