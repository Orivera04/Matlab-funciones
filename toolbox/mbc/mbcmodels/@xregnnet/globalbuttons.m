function hands= globalbuttons(m,fH,View)
% Place holder for NN global buttons

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:56:21 $

if ishandle(fH)
	action='create';
else
	action=fH;
end
switch lower(action)
case 'id'
	hands='xregnnet';
    
case 'toolbar'
    xregTB = get(View.toolbarBtns(1),'parent');
    [null, hands] = xregtoolbar(xregTB, {'uipush'},...
        {'imageFile'}, {'Refresh.bmp'},...
        {'Tooltipstring'}, {'Re-fit Current Neural Net Model'},...
        {'clickedcallback'}, {[View.mfile,'(''Subfigure'',''fitmodel'')']},...
        'transparentcolor', [0 255 0]);
    
case 'utilities'
   uMenu = findobj(View.menus.model,'label','&Utilities');

   Labels = {'&Re-fit Current Neural Net Model'};
   CallBacks = {[View.mfile,'(''Subfigure'',''fitmodel'')']};

   hands= zeros(size(Labels));
   for i=1:length(Labels)
      hands(i)= uimenu(uMenu,...
         'label',Labels{i},...
         'Callback',CallBacks{i});
   end

end
