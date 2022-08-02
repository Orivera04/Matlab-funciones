function lyt=printcopy(ctrl,p)
%  XREGLISTCTRL/PRINTCOPY   copies current view of xreglistctrl object to a layout, 
%                           ready for printing or whatever
%
%   lyt = copyobj(ctrl,parent)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:08 $

% Bail if we've not been given a xreglistctrl object
if ~isa(ctrl,'xreglistctrl')
   error('Cannot set properties: not an xreglistctrl object!')
end

el = get(ctrl,'elements');

start = get(ctrl,'top');
numVis = get(ctrl,'numvis');
finish = min(start+numVis-1,length(el));

%% axesinput - obj.grid is what we need to copy
%% copy all visible controls into a gridlayout and return this
lyt = xreggridlayout(p,...
   'dimension',[numVis,1],...
   'rowsizes',get(ctrl,'cellheight'));

new = {};
for i = start:finish
   try
      new = {new{:},copyobj(el{i},p)};
   catch
      new = {new{:},[]};
   end   
end

% % clear callbacks
% builtin('set',new.axes,'userdata',new);

% set position
newpos = get(ctrl,'position'); 
newpos([1 2]) = [10 10];
set(lyt,'visible','on','position',newpos,...
    'backgroundcolor',get(p,'color'),...
    'elements',new);
