function hands= globalbuttons(m,fH,View)
% GLOBALBUTTONS   xreginterprbf global buttons

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:48:45 $ 


if ishandle(fH)
	action='create';
else
   action=fH;
end

switch lower(action)
case 'id'
   hands='dace';
   
case 'toolbar'
  % xregTB = [];
%    xregTB = get(View.toolbarBtns(1),'parent');
%    [null, hands] = xregtoolbar(xregTB,...
%       {'uipush'},...
%       {'imageFile'}, {...
%          'fitOptions.bmp'},...
%       {'Tooltipstring'}, {...
%          'Fit Options...'},...
%       {'clickedcallback'}, {...
%          [View.mfile,'(''Subfigure'',''fitopts'')']},...
%       'transparentcolor', [0 255 0]);
   hands=[];
case 'utilities'
%    uMenu = findobj(View.menus.model,'label','&Utilities');
%    
%    Labels = {...
%          'Fit &Options...'};
%    CallBacks = {...
%          [View.mfile,'(''Subfigure'',''fitopts'')']};
%    
%    hands= zeros(size(Labels));
%    for i=1:length(Labels)
%       hands(i)= uimenu(uMenu,...
%          'label',Labels{i},...
%          'Callback',CallBacks{i});
%    end
   hands=[];
end

% EOF
