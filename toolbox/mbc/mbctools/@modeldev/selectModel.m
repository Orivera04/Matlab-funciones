function p= selectModel(mdev,mbH);
%SELECTMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:10:54 $



chH= [];

hFig= double(mbH.Figure);
p= mbH.CurrentNode;


pbest= children(mdev,'bestmdev');
for i=1:length(pbest)
   pbest{i}= double(pbest{i});
end
pbest=[pbest{:}];
if any(pbest==0)
	unvalmdev=children(mdev,find(pbest==0),'name');
	errordlg(str2mat('You must select a best model for all sub-models ',...
		'before selecting a best model. ',...
		'The following sub-models do not have a best model:',...
		unvalmdev{:}),...
		'Model Selection','modal');
	return
end


switch mdev.ViewIndex
case 'global'

	chH= Validate_OneStage('create',p,hFig);
case 'twostage'
	chH=Validate_TwoStage('create',p,hFig);
end
	
if ishandle(chH)
	mbH.RegisterSubFigure(chH);
end

	