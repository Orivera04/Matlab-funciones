function hands= globalbuttons(m,fH,View)
%GLOBALBUTTONS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:48:09 $

if ishandle(fH)
   action='create';
else
   action=fH;
end
switch lower(action)
case 'id'
   hands='hybridrbf';
   
case 'toolbar'
   xregTB = get(View.toolbarBtns(1),'parent');
   [null, hands] = xregtoolbar(xregTB, {'uipush'},...
      {'imageFile'}, {'refresh.bmp'},...
      {'clickedcallback'}, {@i_refit},...
      {'Tooltipstring'},{'Update Model Fit'},...
      'transparentcolor', [0 255 0]);
   
   hands2=globalbuttons(m.xreglinear,'toolbar',View);
   hands= [hands(:);hands2(:)];
case 'utilities'
   uMenu = findobj(View.menus.model,'label','&Utilities');

   Labels = {'&Update Model Fit'};
   CallBacks = {@i_refit};

   
   hands= zeros(size(Labels));
   for i=1:length(Labels)
      hands(i)= uimenu(uMenu,...
         'label',Labels{i},...
         'Callback',CallBacks{i});
   end
   hands2=globalbuttons(m.xreglinear,'utilities',View);
   hands= [hands(:);hands2(:)];
end


function i_refit(h,evt);

mbh= MBrowser;
p= get(mbh,'CurrentNode');
set(mbh.Figure,'pointer','watch');
p.refit;
mbh.ViewNode;
set(mbh.Figure,'pointer',get(0,'DefaultFigurePointer'));
