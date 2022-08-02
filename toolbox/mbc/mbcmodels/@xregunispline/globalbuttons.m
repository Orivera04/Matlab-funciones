function hands= globalbuttons(m,fH,View)
% xregUniSpline/GLOBALBUTTONS - returns handles to buttons on global view

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:58:28 $

if ishandle(fH)
   action='create';
else
   action=fH;
end
switch lower(action)
case 'id'
   hands='xregUniSpline';
   
case 'toolbar'
   hands=[];
%    xregTB = get(View.toolbarBtns(1),'parent');
%    [null, hands] = xregtoolbar(xregTB, {'uipush';'uipush'},...
%       {'imageFile'}, {'fitOptions.bmp';'buildModels.bmp'},...
%       {'Tooltipstring'}, {'Fit Options';'Build Models'},...
%       {'clickedcallback'}, {[View.mfile,'(''SubFigure'',''FitOptions'')'];[View.mfile,'(''SubFigure'',''BuildModel'')']},...
%       'transparentcolor', [0 255 0]);
   
case 'utilities'
   hands=[];
end
