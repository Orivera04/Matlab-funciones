function hands= globalbuttons(m,fH,View)
%GLOBALBUTTONS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.7.4.5 $  $Date: 2004/04/04 03:30:06 $




if ishandle(fH)
   action='create';
else
   action=fH;
end
switch lower(action)
case 'id'
   hands='xreglinear';
   
case 'toolbar'
    xregTB = get(View.toolbarBtns(1),'parent');
    [null, hands] = xregtoolbar(xregTB, {'uipushtool';'uipushtool';'uipushtool'},...
        {'imageFile'}, {'stepwise.bmp';'doeeval.bmp';'smallpev.bmp'},...
        {'Tooltipstring'}, {'Stepwise';'Design Evaluation';'Prediction Error Surface'},...
        {'clickedcallback'}, {@i_Stepwise;@i_doeEval;@i_PEview},...
        'transparentcolor', [0 255 0]);
    
case 'utilities'
   uMenu = findobj(View.menus.model,'label','&Utilities');

   Labels = {'&Stepwise';'&Design Evaluation';'&Prediction Error Surface'};
   CallBacks = {@i_Stepwise;@i_doeEval;@i_PEview};

   hands= zeros(size(Labels));
   for i=1:length(Labels)
      hands(i)= uimenu(uMenu,...
         'label',Labels{i},...
         'Callback',CallBacks{i});
   end
end



function i_Stepwise(h,evt);

mbH= MBrowser;
p= mbH.CurrentNode;
set(mbH.Figure,'pointer','watch');
drawnow
chH= mv_stepwise('create',p,0.3);
mbH.RegisterSubFigure(chH);
set(mbH.Figure,'pointer',get(0,'DefaultFigurePointer'));



function i_doeEval(h,evt);

mbH= MBrowser;
p= mbH.CurrentNode;
set(mbH.Figure,'pointer','watch');
drawnow
des= des_linearmod(p.model,Design(p.mdevtestplan));

chH= mv_doeanalysis('create',des);
mbH.RegisterSubFigure(chH);
set(mbH.Figure,'pointer',get(0,'DefaultFigurePointer'));

function i_PEview(h,evt);

mbH= MBrowser;
p= mbH.CurrentNode;
set(mbH.Figure,'pointer','watch');
drawnow

m= p.model;
des= des_linearmod(m,Design(p.mdevtestplan));

% Get boundary model from test plan
bdryModel = BoundaryModel( p.mdevtestplan, m );

fH= mv_PEVView( 'create', des, [], bdryModel );
mbH.RegisterSubFigure(fH);
set(mbH.Figure,'pointer',get(0,'DefaultFigurePointer'));
